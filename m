Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598D237C923;
	Thu, 20 Aug 2026 15:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238051; cv=none; b=YgW55hJDXhMrEkF0z4fs0j9MULqzwwipft7XwmREDBMTdNAX/BwPVNfwhzjmFKJH30XcTJXJA3TXt7oc5LbwkI7dyPNPPZlL5SonYQvKEbybloqvPiqPjJD4kp58Qx5t+P+qNHJ8suNeIfp4UDiyndqmsSOmu+vqTS1AaGqrsp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238051; c=relaxed/simple;
	bh=/H3mfHh+qovx4TUZOi1lBjZW+lqFQuFFBijmCRn534c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQDD6s6WYq0dlbE8nLyVHWkifzmlMqr4sDSNHHR1Sm4EEalrQmPRh/4IV0r+zG2Dd/SQJAQo7WxdJu5A8kGzImbD2SykGMLcbNP3beRlI/Kz7H4Hi1Lply6QAEtXCNFeVFbWyxaJfdZG8HzF+0n/pNgS3AA5Vg8fnf9j5c7WLo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QAhQAAny; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QAhQAAny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BEB1F000E9;
	Thu, 20 Aug 2026 15:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238049;
	bh=plNLJkHlMmtk6HtUgy23p36zjiOQ5s5/KBPeP2iIrgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QAhQAAnyQON9ENcXWNGedKh6BZXS4xvZr6okP6ciIvgdlVkxeTXe3DH+svp1c9ye/
	 arzT9FXRHUEjyN9qlGXm2wjEeRqIIL1p8R+c+4GBhjsEbI7aXNqi2UqvNou7D9ozFn
	 C89vkBMaD94w+0AEh4FgrPzZIR/pMVc7rsxV6Hvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.1 003/228] selinux: reject a class permission count below its inherited common
Date: Thu, 20 Aug 2026 16:52:25 +0200
Message-ID: <20260820145244.570347681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 9a82dcd98b6e6e11cfd162410967951f12152528 upstream.

security_get_permissions() maps an inherited common's permissions into
an array sized by the class's own permissions.nprim, but class_read()
takes that nprim verbatim from the policy image and never checks that it
covers the common.  A class that inherits a common of N permissions while
declaring a smaller nprim is accepted, and on load the common's
permissions are written past the class-sized array -- an out-of-bounds
heap write.

Reject a class whose permission count is below its inherited common's.
Well-formed policies, where the class count already includes the
inherited permissions, are unaffected.

Cc: stable@vger.kernel.org
Fixes: 55fcf09b3fe4 ("selinux: add support for querying object classes and permissions from the running policy")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/policydb.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -1382,6 +1382,18 @@ static int class_read(struct policydb *p
 			       cladatum->comkey);
 			goto bad;
 		}
+
+		/*
+		 * security_get_permissions() maps the common's permissions
+		 * into an array sized by this class's nprim, so a class must
+		 * declare at least as many as the common it inherits.
+		 */
+		if (cladatum->permissions.nprim <
+		    cladatum->comdatum->permissions.nprim) {
+			pr_err("SELinux:  class %s has fewer permissions than common %s\n",
+			       key, cladatum->comkey);
+			goto bad;
+		}
 	}
 	for (i = 0; i < nel; i++) {
 		rc = perm_read(p, &cladatum->permissions, fp);


