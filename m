Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B2430BB80;
	Tue, 12 May 2026 17:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608396; cv=none; b=ITzcqWNHNfxoCoZG56DIW6TMC7KuCuhsb9UV78ckzMy1xtllqya/cLUvQsczrPFJwBfklm0McW96JwkbF/4HNwBXxF7J0fBDdOLQ2l0yHJghdpZN6D5dIm5s4Jis7mH6AANk72z0Pf5IKX6KaV9thKeTd8pnU33JVJPy+Pjskqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608396; c=relaxed/simple;
	bh=U59UaCmmwF1Kf2+RVgntDlwobxIF8hqKskstU2TpUXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebLJrbn07kjP0y8szvy/hGuXIB7sypyl2QpH+Kp9MXwTiAl94X+IXG3hfInlfz5IA9LLxXQxKXlVwtvStDmB+EpgdSNh8Xb5DNsYxJKJKlGM51iwA6vASeoAfEXC49I1aKVcXJCW0g/fFMbsqrtDv97cGWQwQ7Cv7MpL7TUTHv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgQ3o6wm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgQ3o6wm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAE1C2BCB0;
	Tue, 12 May 2026 17:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608396;
	bh=U59UaCmmwF1Kf2+RVgntDlwobxIF8hqKskstU2TpUXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgQ3o6wmX2a0OAY/RURnrToQOdpmVFkqC1yCTlLSg8mycaDKL3SOQYkD4CvQwOgfP
	 NyTSt7NB9y4mwcfpVVkSvJDAp3F0O9gKm+GAiBa175JP2jZsmUTI5eo1W2Pg2xfsgc
	 2Ic5UPvsxWZq2HbJQNxEgJXQQ4NkjUdjvH2LkCKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Windsor <dwindsor@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.18 062/270] selinux: dont reserve xattr slot when we wont fill it
Date: Tue, 12 May 2026 19:37:43 +0200
Message-ID: <20260512173939.757852592@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2931,7 +2931,7 @@ static int selinux_inode_init_security(s
 {
 	const struct cred_security_struct *crsec = selinux_cred(current_cred());
 	struct superblock_security_struct *sbsec;
-	struct xattr *xattr = lsm_get_xattr_slot(xattrs, xattr_count);
+	struct xattr *xattr;
 	u32 newsid, clen;
 	u16 newsclass;
 	int rc;
@@ -2957,6 +2957,7 @@ static int selinux_inode_init_security(s
 	    !(sbsec->flags & SBLABEL_MNT))
 		return -EOPNOTSUPP;
 
+	xattr = lsm_get_xattr_slot(xattrs, xattr_count);
 	if (xattr) {
 		rc = security_sid_to_context_force(newsid,
 						   &context, &clen);


