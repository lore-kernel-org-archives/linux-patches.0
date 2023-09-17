Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656D36FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474BEC433CC;
	Sun, 17 Sep 2023 19:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978475;
	bh=ea/0UCvcploLzz5WivdqGnb2k3Fkc4CU4ayxUcjzYUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WycBV6OPssI4fu++r9s8W28e6w8KkBQ4JBcapUElf76Ga9mUsE5xLzd7cm5+5c0GO
	 6e80ZzouznM7kjct5ZhoydYC1TorYUT5wzGBrgLNmsjzoAAdOVAzBhUTXK5lRwdFja
	 R85DxLtDhXNyIe3jfPqAsVnCweoMSBJBh8CAv8dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Seth Forshee (DigitalOcean)" <sforshee@kernel.org>,
	Seth Jenkins <sethjenkins@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/406] tmpfs: verify {g,u}id mount options correctly
Date: Sun, 17 Sep 2023 21:08:43 +0200
Message-ID: <20230917191102.959155568@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 0200679fc7953177941e41c2a4241d0b6c2c5de8 ]

A while ago we received the following report:

"The other outstanding issue I noticed comes from the fact that
fsconfig syscalls may occur in a different userns than that which
called fsopen. That means that resolving the uid/gid via
current_user_ns() can save a kuid that isn't mapped in the associated
namespace when the filesystem is finally mounted. This means that it
is possible for an unprivileged user to create files owned by any
group in a tmpfs mount (since we can set the SUID bit on the tmpfs
directory), or a tmpfs that is owned by any user, including the root
group/user."

The contract for {g,u}id mount options and {g,u}id values in general set
from userspace has always been that they are translated according to the
caller's idmapping. In so far, tmpfs has been doing the correct thing.
But since tmpfs is mountable in unprivileged contexts it is also
necessary to verify that the resulting {k,g}uid is representable in the
namespace of the superblock to avoid such bugs as above.

The new mount api's cross-namespace delegation abilities are already
widely used. After having talked to a bunch of userspace this is the
most faithful solution with minimal regression risks. I know of one
users - systemd - that makes use of the new mount api in this way and
they don't set unresolable {g,u}ids. So the regression risk is minimal.

Link: https://lore.kernel.org/lkml/CALxfFW4BXhEwxR0Q5LSkg-8Vb4r2MONKCcUCVioehXQKr35eHg@mail.gmail.com
Fixes: f32356261d44 ("vfs: Convert ramfs, shmem, tmpfs, devtmpfs, rootfs to use the new mount API")
Reviewed-by: "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>
Reported-by: Seth Jenkins <sethjenkins@google.com>
Message-Id: <20230801-vfs-fs_context-uidgid-v1-1-daf46a050bbf@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index cfa8f43cb3a62..e173d83b44481 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3455,6 +3455,8 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
 	unsigned long long size;
 	char *rest;
 	int opt;
+	kuid_t kuid;
+	kgid_t kgid;
 
 	opt = fs_parse(fc, shmem_fs_parameters, param, &result);
 	if (opt < 0)
@@ -3490,14 +3492,32 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
 		ctx->mode = result.uint_32 & 07777;
 		break;
 	case Opt_uid:
-		ctx->uid = make_kuid(current_user_ns(), result.uint_32);
-		if (!uid_valid(ctx->uid))
+		kuid = make_kuid(current_user_ns(), result.uint_32);
+		if (!uid_valid(kuid))
 			goto bad_value;
+
+		/*
+		 * The requested uid must be representable in the
+		 * filesystem's idmapping.
+		 */
+		if (!kuid_has_mapping(fc->user_ns, kuid))
+			goto bad_value;
+
+		ctx->uid = kuid;
 		break;
 	case Opt_gid:
-		ctx->gid = make_kgid(current_user_ns(), result.uint_32);
-		if (!gid_valid(ctx->gid))
+		kgid = make_kgid(current_user_ns(), result.uint_32);
+		if (!gid_valid(kgid))
 			goto bad_value;
+
+		/*
+		 * The requested gid must be representable in the
+		 * filesystem's idmapping.
+		 */
+		if (!kgid_has_mapping(fc->user_ns, kgid))
+			goto bad_value;
+
+		ctx->gid = kgid;
 		break;
 	case Opt_huge:
 		ctx->huge = result.uint_32;
-- 
2.40.1



