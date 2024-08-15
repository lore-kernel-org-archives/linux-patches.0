Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B861AC8AE;
	Thu, 15 Aug 2024 13:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729685; cv=none; b=Hy3m67caCgp3ZBgNB30XOlMq+zUPhasjjcFIzolfPbGtIGDdd+GozQ5Jn6GJijtkbEHWh9KoY6+BmGPEqBPxVlaV8CLDENq7Aritjl/yGp9uzY/TtEETMOb6lqg+3jt9w6hvxWljkDOQCRnVc4SmaA2MDMBi5lDTu0PZsxLZL4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729685; c=relaxed/simple;
	bh=25RQ23hGR5bDB3A30ASL5OjinDhaSY3UtIbf2I9feZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTubXjF4jzSoP51HjVxE0UVJHEcgOP/PkRby/vOer7aqFSNEFCpYhW1cBL9p6SJkqAaOSis5ROceBe/ccT3dEhzBWfzs4il33m2ynjyeKoBp6nXgXLiAynlBD9I7g8Rpgqy+ECWsiDvMWYJjLoiI53fpq5znAMQ9Dj3FJveYUj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqKvKaXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqKvKaXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DEEC32786;
	Thu, 15 Aug 2024 13:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729685;
	bh=25RQ23hGR5bDB3A30ASL5OjinDhaSY3UtIbf2I9feZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqKvKaXPJH76h/ciQctDoO2kcCXj6Th8SBNYL939tONFaHUOVh3haKblvGdduMFRb
	 Q/BIkGnqN7I/9XkxZvQElTpc5sqANg6ep23uEDJUihrg7nfv4XwoMlJ/v39tHECSwO
	 2ayaJWtvAESIHH4byEHQbAT2ZlXbtTpsu1HW+P5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 5.15 176/484] fuse: verify {g,u}id mount options correctly
Date: Thu, 15 Aug 2024 15:20:34 +0200
Message-ID: <20240815131948.213588295@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -686,6 +686,8 @@ static int fuse_parse_param(struct fs_co
 	struct fs_parse_result result;
 	struct fuse_fs_context *ctx = fsc->fs_private;
 	int opt;
+	kuid_t kuid;
+	kgid_t kgid;
 
 	if (fsc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
 		/*
@@ -730,16 +732,30 @@ static int fuse_parse_param(struct fs_co
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
 


