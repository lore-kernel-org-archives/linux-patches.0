Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3DB468C16;
	Thu, 20 Aug 2026 17:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247404; cv=none; b=dJpx4feBSvZ25nNOxdn7CWZNmy4KupnlX0yQtmBEzFgL0+Poi1tIkNH5viiFzPET3EenaDoMBHge7Lqoh3qMqpXPOKqAcffdCT/0+NXz4NmZMcq+s7XnlxOgwtJR4kYqkHJz9xv0b+bDOLUEIlgX/MB+bR4b+xJTByo7sv7mooc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247404; c=relaxed/simple;
	bh=etqR3TzibbKjmiSAeMYSk0hlGwqASip852YAcNkpW1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJQmCy14xJ/00LXnf6703elBjzany4RM9YRxCkXNe6aZhdaCoqCPCrVnQ+FFWyJiW7gS8tos1ayZDsixfAkU81aZBzG6WvYQ6woRdlFRv/ijuJ5FSZyTK10gFc58wN4Aaor/46uAK6AZs4zKat3z1n0eZawqp1tfBolkGBJWmz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSnZnFW3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSnZnFW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78871F000E9;
	Thu, 20 Aug 2026 17:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247403;
	bh=bdl1O96CFJhcfxT3A7Z2Z84W45u8gJtQZLyxkLHLwdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSnZnFW3b8iYwZSGyx6SlQp89mbO4Kten/GFQlphm/hRGJgIHYddS/YaWw00MDyAd
	 g0/Pyw7Vwod8cS8tSv8xBvG7xXEWf9/LMU/Xg0Cvs+ZmS/r4unGFIdFeCYyEHjjH3/
	 4wVgIgepsVJQRo+rHf5IdQofK7CPWBFe8Er1c4YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 006/166] selinux: reject a class permission count below its inherited common
Date: Thu, 20 Aug 2026 16:54:25 +0200
Message-ID: <20260820145211.387524977@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1351,6 +1351,18 @@ static int class_read(struct policydb *p
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


