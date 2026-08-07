Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AB43C81B4;
	Fri,  7 Aug 2026 15:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117192; cv=none; b=ZYj4xjLp5RKY3kg6abQIJ2mSsw18z9YufKs6XoDUYwyEsY8HLocqJBpZbdnhaSBoPMf8ZBfQuqVxUB4E8hfHypP5XXPjNCGMvaDg+t+7sceZyA+ezn1Y1k3vyEOB+a8vgayIA5hXy0Rnfc5zeso9zE4iSBzSI3ZI7D4+lyvMmio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117192; c=relaxed/simple;
	bh=eRgfNTk/KBiMOD2vTBpcr6TN3h304Qxd4BoikXv2mBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4KaEKm8swhHX7R1RsD4aqJjHZfWrUCrd9SpgKy484A3QS+XFlNNBfTDmn/Au3yFhQx6eaEpHoP7RwMtPoZLeStS7+tMiFWznfebVxE4s7BhS0oKYsc2Cr68l2slfOosMhBD4mh4qOQHO2BKqhPn5uS4aPZnehD6Fs7T5g0k8T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CoH2l2XI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoH2l2XI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9075D1F000E9;
	Fri,  7 Aug 2026 15:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117191;
	bh=iPzQQLlOyX6Vt2js8i2YLTOUVpru4NBpXGnXkjzHyR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CoH2l2XIwgIp50aCEjN0CSKpMaOU8MOdOs15yv1EDsfIz8N1DM9B8qECmJ1B8tGtz
	 8kv3+D6h1v7ZdcsYbYhQCnIF8UOVMbKgvkk71Gwpx573/Hb7eSMBn3NYgZ20gV1XtD
	 uEtHULPxmUyou/1PFTmfvEZdARaSjGEaJ+Mf1PLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>
Subject: [PATCH 7.1 232/438] KVM: s390: pci: Fix resource leak on IRQ registration failure
Date: Fri,  7 Aug 2026 16:37:08 +0200
Message-ID: <20260807143432.951553617@linuxfoundation.org>
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

commit 5580c9858f1e00f60191eb09c3add359836d60b6 upstream.

Currently if kvm_zpci_set_airq() fails, kvm_s390_pci_aif_enable() returns
the error code but doesn't do any resource cleanup thus leaking resources.
Fix this by cleaning up all the resources such as the GAITE, AIBV, AISB and
unpinning any pinned pages. While at it, remove dead code that stored FIB
values that were never referenced.

As part of the cleanup, we are also holding the aift_lock a bit longer, as
we hold the lock while executing the MPCIFC instruction. Though this is not
strictly necessary, it means we don't have to drop and re-acquire in the
error case.

Fixes: 3c5a1b6f0a18 ("KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/pci.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -339,19 +339,32 @@ static int kvm_s390_pci_aif_enable(struc
 	aift->kzdev[zdev->aisb] = zdev->kzdev;
 	spin_unlock_irq(&aift->gait_lock);
 
-	/* Update guest FIB for re-issue */
-	fib->fmt0.aisbo = zdev->aisb & 63;
-	fib->fmt0.aisb = virt_to_phys(aift->sbv->vector) + (zdev->aisb / 64) * 8;
-	fib->fmt0.isc = gisc;
-
 	/* Save some guest fib values in the host for later use */
-	zdev->kzdev->fib.fmt0.isc = fib->fmt0.isc;
+	zdev->kzdev->fib.fmt0.isc = gisc;
 	zdev->kzdev->fib.fmt0.aibv = fib->fmt0.aibv;
-	mutex_unlock(&aift->aift_lock);
 
 	/* Issue the clp to setup the irq now */
 	rc = kvm_zpci_set_airq(zdev);
-	return rc;
+	if (!rc) {
+		mutex_unlock(&aift->aift_lock);
+		return rc;
+	}
+
+	/* Start cleanup */
+	zdev->kzdev->fib.fmt0.isc = 0;
+	zdev->kzdev->fib.fmt0.aibv = 0;
+
+	spin_lock_irq(&aift->gait_lock);
+	gaite->count--;
+	gaite->aisb = 0;
+	gaite->gisc = 0;
+	gaite->aisbo = 0;
+	gaite->gisa = 0;
+	aift->kzdev[zdev->aisb] = NULL;
+	spin_unlock_irq(&aift->gait_lock);
+
+	airq_iv_release(zdev->aibv);
+	zdev->aibv = NULL;
 
 unlock:
 	if (pcount > 0)


