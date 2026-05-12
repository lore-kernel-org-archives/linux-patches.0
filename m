Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBEB3EDE67;
	Tue, 12 May 2026 18:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609089; cv=none; b=nt+JZIrOQumf2ZPf/UZr2/LBbBM2aDHIPiAPLByk7rPWf3Wmo7hpZMeozYC9o8p4B3t215KCG4oR/J99DqICSeP8Mx3IDBUkCKmKqLb6f7Aci7pd23i3GlZEn+uOQ4X9rXWfagAzVKQU1XMUCmDxaLps9EzkhIE/BVeLvjPpxCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609089; c=relaxed/simple;
	bh=17znin8c8+ritrrVBoLRPt9QBKhTjJzcxE2PqWjkroU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBV+K12LiM1bwsjMbRo6qa8bTj9LWcdbhXnpeymIP7ANpJQILLxK/elxhKulhnCNilv0hLOVniScQBZP8XKF7dUQMN4uDDQflj+uZJ/5m/jWEJ/g7mzlDJfOO8y14e7rHuOF6A3cX3/8sl3zu4fFAsFZ3CqJ+YE6m+DKQeOrRAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciC6gGpM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciC6gGpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EB0C2BCB0;
	Tue, 12 May 2026 18:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609089;
	bh=17znin8c8+ritrrVBoLRPt9QBKhTjJzcxE2PqWjkroU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciC6gGpMe46ByBvjTXWzmh8CaieILf+WrOCxvcrxjrzL4sH4p8v41bmAIJv0RfnJT
	 kysyev+J+hiKR64+MBj9uMlc5c3cTsmoZeeLIrpkUEJ1FSGnTw/+LDQ9nLEx1h19r6
	 /h2LJa9iNtr/KhIGQvNB4wZ6sBWFZz+IK/Zji/Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Windsor <dwindsor@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.0 060/307] selinux: dont reserve xattr slot when we wont fill it
Date: Tue, 12 May 2026 19:37:35 +0200
Message-ID: <20260512173941.389935720@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Windsor <dwindsor@gmail.com>

commit 1e5a8eed7821e7a43a31b4c1b3675a91be6bc6f6 upstream.

Move lsm_get_xattr_slot() below the SBLABEL_MNT check so we don't leave
a NULL-named slot in the array when returning -EOPNOTSUPP; filesystem
initxattrs() callbacks stop iterating at the first NULL ->name, silently
dropping xattrs installed by later LSMs.

Cc: stable@vger.kernel.org
Signed-off-by: David Windsor <dwindsor@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2965,7 +2965,7 @@ static int selinux_inode_init_security(s
 {
 	const struct cred_security_struct *crsec = selinux_cred(current_cred());
 	struct superblock_security_struct *sbsec;
-	struct xattr *xattr = lsm_get_xattr_slot(xattrs, xattr_count);
+	struct xattr *xattr;
 	u32 newsid, clen;
 	u16 newsclass;
 	int rc;
@@ -2991,6 +2991,7 @@ static int selinux_inode_init_security(s
 	    !(sbsec->flags & SBLABEL_MNT))
 		return -EOPNOTSUPP;
 
+	xattr = lsm_get_xattr_slot(xattrs, xattr_count);
 	if (xattr) {
 		rc = security_sid_to_context_force(newsid,
 						   &context, &clen);


