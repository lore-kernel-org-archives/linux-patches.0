Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FC842AF95;
	Thu, 20 Aug 2026 16:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243987; cv=none; b=g67UgEhwjNOE+T4RpJ4OsH6Zg9NKA3aRLLejFsd+YxtNlS4BmQerrA7sn1RS5AnOsm/YF2o9x1xXzTzsq+59XsfQ3geYbEfM91ZLwBSN8ESL6iXVqPD7tbuP6vNaNj/sBOvxPpNP4t2jzYC0Tgn6hUgY0r/Y9rzBctvfw1phTNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243987; c=relaxed/simple;
	bh=dKkLoQDTH9+kCtdYEiWeCkSC59HXyamS8dnLdt2E3T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4N4JqqYgosvEqXDnYUSaDxlG4/3eIVwb5YWnPjRE+BSaZY/JUXm54MZ7WNdsKp152mfe9zwzGpVN1vpnMKlRSW5jr1VLBioWA10CgB+oy9T4OB0BqD7dfKt1cR591/5RSL700FRj+sTZiezm0LDwB5g34wbwIlMJIztghKeQ7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VwiJGyJa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VwiJGyJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477791F000E9;
	Thu, 20 Aug 2026 16:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243985;
	bh=c1n9KFKjT7LPCV17ww529ZyfvzMnMi9+UUg4uWZYIWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VwiJGyJai6koycxGHCd6J06KaSj3Miuo961h4hkPGUiTwhVsrti/3JhiHiOCrScsE
	 Se0UFjsqHJI/LZ6Sb1xYqfXQgRKgarcN2WeSS3Qbf6Wrv6mL6vFREt7QVhK0YM1Zus
	 bz75MPYG8+JEo+NdnyVk1PmI863lN/ALjSZT2LbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 005/235] selinux: reject a class permission count below its inherited common
Date: Thu, 20 Aug 2026 16:54:01 +0200
Message-ID: <20260820145216.602923928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1356,6 +1356,18 @@ static int class_read(struct policydb *p
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


