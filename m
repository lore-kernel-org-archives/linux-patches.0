Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C7C37F8C2;
	Fri,  7 Aug 2026 15:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115180; cv=none; b=IsHhKTZfmTshKsSvVltlZ7k69yz+PNOK/sLEW5Ioo6Be8Mf7EVWFZRjEVjkUJkivD7KIq6eJO7/yMOLFAFUI5iijn3K8NMWG5265NEk3QG5n2pMsdywVx28hpW5+jUM1yBCKw0Q3aqkMstALlRvBF3XsD0hzvFw9IkinQ1cZphg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115180; c=relaxed/simple;
	bh=KVT8r5sak2RTPMdvro670f5m/E+Pr5RowUYtSIx/Skw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KS73PnYtgrMnKvmMVY1Qj1/Q6TWr/92++GGlrl+5ndxcGDUSE4dxme9NZSHmZgwnEmi9F1+Jpv62gsFBkSrIjqx9uDSrY4FaMOmQjufdR356ra58Q2NqvBHXgKcayp39/9Uxp8P0viA3DtYtkmRcFv4uskoMKZG9qhwWr1dthGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pjjUOJTc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjjUOJTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2911F00ADB;
	Fri,  7 Aug 2026 15:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115175;
	bh=kD3LglLZWhTMEi5fCXzC9NHHlovAoCg+IzTEVas785A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pjjUOJTcyAroCe/3Dbvyph5SI1rTxCd0Gyx58HWih8sN4y6GB2o80FUoERzJNCwR2
	 YqZHreXMnG7Ra69KrekI5SSJwAPbkwjAn9V5ruIbELfoj6f+ncLzjHHvubKINOU76f
	 /bmBeH1ezh9e9JI6P5VTLsER9Yv5SLelZ4Fp0pVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>
Subject: [PATCH 6.18 182/396] KVM: s390: pci: Fix missing error codes and memory unaccounting
Date: Fri,  7 Aug 2026 16:35:42 +0200
Message-ID: <20260807143428.218225335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -301,14 +301,17 @@ static int kvm_s390_pci_aif_enable(struc
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
@@ -352,6 +355,8 @@ static int kvm_s390_pci_aif_enable(struc
 	return rc;
 
 unlock:
+	if (pcount > 0)
+		unaccount_mem(zdev->kzdev, pcount);
 	mutex_unlock(&aift->aift_lock);
 unpin2:
 	if (fib->fmt0.sum == 1)


