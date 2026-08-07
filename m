Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C04D46EC60;
	Fri,  7 Aug 2026 15:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117189; cv=none; b=Goly0gdkhaHpLUhAtVs6JbLWPpBBq2cviKhvCE+34HTNucRbX2N284hXOEmg/AIlAKnB0EI7us3+BSyI/90Vsi6C97GZ4HMe1bYv5bu67HlmR5P2HEhVEtPMJQeVixjcov4Zl9DAAciVb+mhasR4jLKaISHeTaiCPeUgBXS/xhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117189; c=relaxed/simple;
	bh=cn3e2JukgRfCdzulgt8+9WcqVFB3epIw1Gbgy4BQOAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDYXg8agM17+l89HmRsjhpLYRo0OiAnt90swaAlE8RamQEXQDt7ygvqY9NYMizQZADwqnBS3fk4eggWwRbgK7cL7rpbpOzGvJvPZADB8v0xeh2Q2XAIvdfhbWO1PFAQ5ge1TZ4U/rqJRtBZGoBYdnuKRJlQfM+ifz8BV0s+rtJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HySzjibM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HySzjibM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1BA1F000E9;
	Fri,  7 Aug 2026 15:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117188;
	bh=d/qPxoxXZMFNYT2TRZxxiseyi1iHnUdsRXcmPeEjc3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HySzjibMrcgJZhGWpw3EzQucKN9+vNaEWPcI6hROMLU3DO/sAPzA3mNSYHDHueV+N
	 c+8b1st4XDhxGIZmM1r8Sa044SaA3piwfzFj4pyLDzDTnXar7SLDUgv8M0PEUHiBJh
	 YaJsUBvEQP8TZ1vZ0PzF0nPUeznKy2jhdPnr4X+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>
Subject: [PATCH 7.1 231/438] KVM: s390: pci: Fix missing error codes and memory unaccounting
Date: Fri,  7 Aug 2026 16:37:07 +0200
Message-ID: <20260807143432.928991855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Farhan Ali <alifm@linux.ibm.com>

commit f86842e4d6c482300f4567f492d512c9ccf5bc4f upstream.

In kvm_s390_pci_aif_enable() two error paths failed to set an error code,
causing the function to return 0 on failure. It also failed to rollback
memory accounting on failure. Fix both by propagating an error code on
failure and calling unaccount_mem() in the cleanup path.

Fixes: 3c5a1b6f0a18 ("KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding")
Cc: stable@vger.kernel.org
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/pci.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -300,14 +300,17 @@ static int kvm_s390_pci_aif_enable(struc
 	}
 
 	/* Account for pinned pages, roll back on failure */
-	if (account_mem(zdev->kzdev, pcount))
+	rc = account_mem(zdev->kzdev, pcount);
+	if (rc)
 		goto unpin2;
 
 	/* AISB must be allocated before we can fill in GAITE */
 	mutex_lock(&aift->aift_lock);
 	bit = airq_iv_alloc_bit(aift->sbv);
-	if (bit == -1UL)
+	if (bit == -1UL) {
+		rc = -ENOMEM;
 		goto unlock;
+	}
 	zdev->aisb = bit; /* store the summary bit number */
 	zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA |
 				    AIRQ_IV_BITLOCK |
@@ -351,6 +354,8 @@ static int kvm_s390_pci_aif_enable(struc
 	return rc;
 
 unlock:
+	if (pcount > 0)
+		unaccount_mem(zdev->kzdev, pcount);
 	mutex_unlock(&aift->aift_lock);
 unpin2:
 	if (fib->fmt0.sum == 1)


