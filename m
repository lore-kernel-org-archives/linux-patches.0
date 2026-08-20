Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A89337F00C;
	Thu, 20 Aug 2026 15:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239452; cv=none; b=nCByatHGmxtNXnftAyHeVWFhX0lBLiOrhrQNEHkXXiYwYv5U0CG1wZadULQvkA3A/Y+yBFjAS1LWXrS8if3BkITp/1SmNdwVxRiFmPDJxvG/tWNgT5oxpQsZjKQGNaB/s5dOhxp1i/MBF2x6Re31CRKQrUO1h8MMwu1Jb4u9uCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239452; c=relaxed/simple;
	bh=KRZmf3o9oygZCL6xtXcar3RSzZLT++nC08IXM0mB0C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ue9a8vE0NemYJiHB23TB//HFHp5ke17/2UMBViPaJiTLAD0eUUvGp5l5gZCouw7clPfQRUadh4MT0FvWkWQLv8Hnq4EVLMBaShTmdCxChTESehashSgjdFuffHc2V9gcTe7Xq6jq7YJWCIP8Pa4DF8qnusMBX6C2mP0Pf3jag2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNORMi5M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNORMi5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61E91F000E9;
	Thu, 20 Aug 2026 15:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239451;
	bh=RRp3aXcqE3ZlRdmiMADgKnlTCPtu6+xpRnR+DSvGTbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LNORMi5MWvj2D12ALCGfxd2eJGBMrsHUq7jX3belnTm2YDhP2NfuB3uiE3gAxQTcK
	 sZQ+/oSk09wisH+Np7L7xCiDKoe4LwNCX0Jv8X6/HSUqONm7mY5qdC6qICBY/MjEM0
	 2oK99eTqWDn2bDlUf4GP4xsi9hb+t4zgeyiv7hiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.12 017/220] selinux: reject a class permission count below its inherited common
Date: Thu, 20 Aug 2026 16:53:27 +0200
Message-ID: <20260820145224.020299217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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
@@ -1375,6 +1375,18 @@ static int class_read(struct policydb *p
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


