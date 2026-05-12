Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795DB2EBB84;
	Tue, 12 May 2026 17:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607980; cv=none; b=NEPVlclN3zFpFx01SG6yOHoRNg1AaCw0fMUDdoUd+bfuFaylohOknKWpD4mJM6kunBMzQNLAS0IvQ91aYdnHK4Lgs4pT9rSwFCtnAyuTIKmln1+wa3BhAo5UxuYN3tUWXJzi7LeQ+c549mR5AOJwkuSGmMMdv9Cf0Is1FLTCaio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607980; c=relaxed/simple;
	bh=vrANMr+i7S8PbgJXsGzOPQAPTkV16j/BDOXQ9axX3bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bA368ReujHAN0ECuhnHPmwE4lP9KDTwqRB87P76DGmth5/9cA/7FNzO1x3AM020sH98mw1LLIwXFjo0jJzKkY4ELOGl9gazS6VrPfx3AmJOFE2ZSXtwTgrxlqMZ6TULQhxLBkUFGbglcmK1e+BSRjJOGHhM1L34feR1YZrEkR7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17FJeHbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17FJeHbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A03C2BCB0;
	Tue, 12 May 2026 17:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607980;
	bh=vrANMr+i7S8PbgJXsGzOPQAPTkV16j/BDOXQ9axX3bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17FJeHbxEk+SeqrghsvgqWKUFBTmCCCC0lYSEgX2qAS5nMMsjXVqwpNJNxg2IE3Bf
	 6KYSuz57lBJioV9PiJiwSfVgRyOj0ya+ihnGx7Jq3wzRY6ubPQ3mLM2pF8FjHjce92
	 tLClX2yelB20j2I454nsBht39xQz8OFanWzv6WOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Windsor <dwindsor@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.12 057/206] selinux: dont reserve xattr slot when we wont fill it
Date: Tue, 12 May 2026 19:38:29 +0200
Message-ID: <20260512173934.048345006@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2916,7 +2916,7 @@ static int selinux_inode_init_security(s
 {
 	const struct task_security_struct *tsec = selinux_cred(current_cred());
 	struct superblock_security_struct *sbsec;
-	struct xattr *xattr = lsm_get_xattr_slot(xattrs, xattr_count);
+	struct xattr *xattr;
 	u32 newsid, clen;
 	u16 newsclass;
 	int rc;
@@ -2942,6 +2942,7 @@ static int selinux_inode_init_security(s
 	    !(sbsec->flags & SBLABEL_MNT))
 		return -EOPNOTSUPP;
 
+	xattr = lsm_get_xattr_slot(xattrs, xattr_count);
 	if (xattr) {
 		rc = security_sid_to_context_force(newsid,
 						   &context, &clen);


