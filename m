Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9392035B631;
	Fri,  7 Aug 2026 15:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116063; cv=none; b=O4P+X0szZ3qfy9RW8EJ56Ip2aAXQ/cfVCZwgNXUQIzGc+Q93lOu+d13h9HmdovdaWuWPnNqnQxsVqK5gAfuHGVlJeIa4BKaIBxfxdhe7kax5pENfKs8b0MxwQKuVWRdijlxkW4/DhU0UT/wtmD/aur9KuLVuV+kqqWCI6LXq2f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116063; c=relaxed/simple;
	bh=+XSVcC4wPgsNKGn18Mg+04kfJ2R93X10Bo9qc3y84LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPEIV2FijrsUR/qW2fYtROTQN4ETv+vUDGlm7yDWaLMinqWS21rNROxTfzIhbTLLf60iB964bGfpORGHoB/IxFHXf5M6qaQAAzBs9qv8mc72V5W/dxDITe15xBiPzBw2BhsLKqXl1us2HtNaHbukTCZIll3fNHanynd7QvClrFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdXDf/DP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdXDf/DP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5301F00A3E;
	Fri,  7 Aug 2026 15:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116062;
	bh=288BLTeFqqXIHKDVtDIbFasyGV9Pbox0WTIqzRjqJTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FdXDf/DPlzizihN81NaL45gcd6jpF5qqU7ORuPvvN4+f4voX0L6Be4uscJ9jan1nL
	 KTUkrQGH1afqJmjqFjM3rdzeRTPFR6+BBWAod7E5kb81k1c1vGGF1Ew4PDAmTeml69
	 BYgMZWGAN3/wFrtGvYfIfqUufZhBdqsr00iZWBDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>
Subject: [PATCH 6.6 098/261] KVM: s390: pci: Fix NULL dereference on AIBV allocation failure
Date: Fri,  7 Aug 2026 16:37:35 +0200
Message-ID: <20260807143417.496694733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Farhan Ali <alifm@linux.ibm.com>

commit 8bf09b9b7d3232806df95f409581f8a9fd99a3fa upstream.

The airq_iv_create() can return NULL on failure, but the return value was
never checked. If it fails, zdev->aibv will be NULL and fail when
dereferenced in kvm_zpci_set_airq(). Add a NULL check and free the
previously allocated AISB bit and zdev->aisb on failure.

Fixes: 3c5a1b6f0a18 ("KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding")
Cc: stable@vger.kernel.org
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/pci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -295,6 +295,11 @@ static int kvm_s390_pci_aif_enable(struc
 				    AIRQ_IV_GUESTVEC,
 				    phys_to_virt(fib->fmt0.aibv));
 
+	if (!zdev->aibv) {
+		rc = -ENOMEM;
+		goto free_aisb;
+	}
+
 	spin_lock_irq(&aift->gait_lock);
 	gaite = aift->gait + zdev->aisb;
 
@@ -331,6 +336,9 @@ static int kvm_s390_pci_aif_enable(struc
 	rc = kvm_zpci_set_airq(zdev);
 	return rc;
 
+free_aisb:
+	airq_iv_free_bit(aift->sbv, zdev->aisb);
+	zdev->aisb = 0;
 unlock:
 	mutex_unlock(&aift->aift_lock);
 unpin2:


