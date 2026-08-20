Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4A7469843;
	Thu, 20 Aug 2026 17:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247813; cv=none; b=j+X0coc/ImDh5/+4RDvMcdMkNitaCOO8nxqhl5aQ6nWXevMxJSqO14ihMOYnuRtMGDN4C77rTd4Pnhou8wOhonBch1gX4rGiid4BmOicyoYw0GhUjC9tUfv/Q2KRB2iHy7DdkJpOhQ5wOmDs92Mrs8zIuCL3XH1H8fmOWsOClDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247813; c=relaxed/simple;
	bh=IVv+SjLmYzyQFgHYA9AEqTs3bAa8JR+ZspoSu4I3sZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5kE7+hWOrRmcJuhFNCTNKTumAOdmz8YbiM436YaZWu3crqO6MVbw/x9FKb3o5M9yrdhLNWlJTG0+Qqc9C0hVaDLgoeaDpIsBco/R6Ri3f57ASyq/HQ37AGHrStOtN7HWn0cQSx72JUKC/A+nlo3UZhThpL2z8n008Vxo9dZ2/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1nalyov; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1nalyov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8607F1F00A3A;
	Thu, 20 Aug 2026 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247812;
	bh=vYsvnt9WiDBP7Vxo7K+5gqIemGwbNzere5ALJD9L7jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M1nalyovujWkOA2ZoeI8EA023JYyEYvCP7FFUZImWUF7OSPJw3Qr+wLKBV1OOWklD
	 10PnqW9Ug0JDmmT2ZHn1v7so0NiU1QhLL1h7kHNvBbSTR+Ty6vlptxYGXpAmXC0FV3
	 gaR5+bJB2BUMRtif9BzxT/CDe4ySyfqFM7nVAUj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.1 011/303] selinux: reject a class permission count below its inherited common
Date: Thu, 20 Aug 2026 16:52:27 +0200
Message-ID: <20260820145253.531509172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1350,6 +1350,18 @@ static int class_read(struct policydb *p
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


