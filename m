Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3F71A6192;
	Tue, 30 Jul 2024 16:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357351; cv=none; b=P27qntVWXzU3UtnDW1VblVo0O8MF5LS/JaYAFpREUmek5AMPGxSlc8tDNPiLaqpcr/CzqVuVtEyDLBcSuDwI0X5ea9mt8bm9p2QfKd3bOiovGfIaX8VWh6Ypw5kFKO0Ea54plYirKiNCWCP9uswRZPweDe963CxYmPD24l8ylEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357351; c=relaxed/simple;
	bh=1EZnVPwormY/oFqntPxkSWz/X+7Wpy7PvPLWOTuBO2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcUGPubnQJswmSCjyq6qNPykS35f+mh28TFYTwjlGxRK7pofBWTcf0QywgQuqEFIfAQuM/G7FWu39JisxmrrM1/KBA6aPQlTuVGa0GE89Mp14Zf86XI9gQpWtfysmWnflrRukG392zdKGoowWQGe9oQ7+uryyQmAoldXtpah+Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxHGqsHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxHGqsHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3476CC32782;
	Tue, 30 Jul 2024 16:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357350;
	bh=1EZnVPwormY/oFqntPxkSWz/X+7Wpy7PvPLWOTuBO2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxHGqsHu8vz4z8E5qHgqtiCCisbYuPiDvQQBG5lY0bieCvQXOpx3OS2/b37E7VgBD
	 eXB4wfQ5KxMlDuqTz9K31gvrmCLzFTqs+Hzmx/AERE0K59yt7lUbgeAb4K/N70dqGC
	 tnrbIP1Kkz0SujkMTbGqVFBgTObxK1EwcNeX8znE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.1 284/440] fuse: verify {g,u}id mount options correctly
Date: Tue, 30 Jul 2024 17:48:37 +0200
Message-ID: <20240730151626.922633787@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -724,6 +724,8 @@ static int fuse_parse_param(struct fs_co
 	struct fs_parse_result result;
 	struct fuse_fs_context *ctx = fsc->fs_private;
 	int opt;
+	kuid_t kuid;
+	kgid_t kgid;
 
 	if (fsc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
 		/*
@@ -768,16 +770,30 @@ static int fuse_parse_param(struct fs_co
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
 


