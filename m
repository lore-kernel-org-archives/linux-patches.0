Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858731A76A9;
	Tue, 30 Jul 2024 17:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359974; cv=none; b=pcszcWCB0ZpJnh8UpF0FA/MLgPFLoSriNRwBqQgxKZ/qFboLlZ4M5bfby2JY5UUrY7ig324u0EZlKtrfFTWwlnI2jT7bsF2xh3CUeFbwXqchsupbDgX99bolPqeYGcxExLRHO2LapmiVadc1jbjx4jhNiuOS5MmMCgRbTQQreVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359974; c=relaxed/simple;
	bh=b7YbQ0+/Iw7nSJ+aNomQhcxDTz4b6ZXeoZzeIIgg2V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njVEvHXVvVdJXXuPQ6afNKquBMn95h8C1kkg6/DYV1TVMXQ1IDvrESt/wiIb2lputQDwCshco3fCHsggIbw99//b7Us45D+9iSfEWdxC+BZuq2XE3nEPYo8nXNk6XWvga8Y7l+SwGUZg7GNVsUyHDlHbC+0WL+MgA1vwWKdK5x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YI3/J1Qo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YI3/J1Qo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9027AC32782;
	Tue, 30 Jul 2024 17:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359974;
	bh=b7YbQ0+/Iw7nSJ+aNomQhcxDTz4b6ZXeoZzeIIgg2V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YI3/J1Qogvxf6KHO1R8BkOPFzzpRn5QdcQkCT0L7mwlS1y7ybk7Gn8PoNGJkOeEAU
	 EcVXB2fiLWnkQzpzrI4u7UTbiq+99qcMFFEZBkXClKUQS+aj8SlXE8minfSnMvU64u
	 LaN0uxMQQGXGQXjOVWerzYSjfJinGIMVGd4RqcOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.10 561/809] fuse: verify {g,u}id mount options correctly
Date: Tue, 30 Jul 2024 17:47:17 +0200
Message-ID: <20240730151746.920677237@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit 525bd65aa759ec320af1dc06e114ed69733e9e23 upstream.

As was done in
0200679fc795 ("tmpfs: verify {g,u}id mount options correctly")
we need to validate that the requested uid and/or gid is representable in
the filesystem's idmapping.

Cribbing from the above commit log,

The contract for {g,u}id mount options and {g,u}id values in general set
from userspace has always been that they are translated according to the
caller's idmapping. In so far, fuse has been doing the correct thing.
But since fuse is mountable in unprivileged contexts it is also
necessary to verify that the resulting {k,g}uid is representable in the
namespace of the superblock.

Fixes: c30da2e981a7 ("fuse: convert to use the new mount API")
Cc: stable@vger.kernel.org # 5.4+
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Link: https://lore.kernel.org/r/8f07d45d-c806-484d-a2e3-7a2199df1cd2@redhat.com
Reviewed-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/inode.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -755,6 +755,8 @@ static int fuse_parse_param(struct fs_co
 	struct fs_parse_result result;
 	struct fuse_fs_context *ctx = fsc->fs_private;
 	int opt;
+	kuid_t kuid;
+	kgid_t kgid;
 
 	if (fsc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
 		/*
@@ -799,16 +801,30 @@ static int fuse_parse_param(struct fs_co
 		break;
 
 	case OPT_USER_ID:
-		ctx->user_id = make_kuid(fsc->user_ns, result.uint_32);
-		if (!uid_valid(ctx->user_id))
+		kuid =  make_kuid(fsc->user_ns, result.uint_32);
+		if (!uid_valid(kuid))
 			return invalfc(fsc, "Invalid user_id");
+		/*
+		 * The requested uid must be representable in the
+		 * filesystem's idmapping.
+		 */
+		if (!kuid_has_mapping(fsc->user_ns, kuid))
+			return invalfc(fsc, "Invalid user_id");
+		ctx->user_id = kuid;
 		ctx->user_id_present = true;
 		break;
 
 	case OPT_GROUP_ID:
-		ctx->group_id = make_kgid(fsc->user_ns, result.uint_32);
-		if (!gid_valid(ctx->group_id))
+		kgid = make_kgid(fsc->user_ns, result.uint_32);;
+		if (!gid_valid(kgid))
+			return invalfc(fsc, "Invalid group_id");
+		/*
+		 * The requested gid must be representable in the
+		 * filesystem's idmapping.
+		 */
+		if (!kgid_has_mapping(fsc->user_ns, kgid))
 			return invalfc(fsc, "Invalid group_id");
+		ctx->group_id = kgid;
 		ctx->group_id_present = true;
 		break;
 


