Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0133803D7;
	Thu, 20 Aug 2026 17:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247838; cv=none; b=KHD/TZdFcGIs9KWhxkFKMLw1ijxqzsiLqvh1fbOfm8KmslJxSufT9cYhNMDaJSEOLh0Tns1VBrFl4QEDWfiA1/LboQteN2/r7ZlDqABb/BxF40rsnVNdrHDa8Ut95meI2fQUCcUwhocp3phE5hWBPW1o49L8zXo7PWoLhAZprSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247838; c=relaxed/simple;
	bh=xvXY02pHIlH5dd8bYwpnEZDEJNRJ93+xZ3lKcXNTkzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxseOPCzlGcQzPYk5ufGpKDBY9g/Q8P4fT34FOV4q5ps2dznCZpRmGoMcnKPn4pG+zAAqAg9l9Dm0ETQEN7ZS2E/kcoTxRVeciwtpBB8+y839SVnp/WdOwSuLbZXj8P+K+MD+ahbLSsQpsXIG7Ph6WewkZD5uhjZEzOD2sXN59Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JH0ndEt6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JH0ndEt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084021F000E9;
	Thu, 20 Aug 2026 17:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247837;
	bh=6HjHiTTyouKfynsQdWs4Omv8IHVN10JWEMjVwrmiYWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JH0ndEt6XgCz7zejuL85UacHiTz7uWByP+SLvqVRdL3F+/3vPYhkiOzFHpTKTzn1M
	 mc8HJnuheE+GCh+TNAbwvVJccLFwN8HJ1BEMngb1U0EWgFlibBRtwd6js4VCN13dhr
	 mgjgk4mL9S+lAjgLGesdw7H6wf0xSKMlsPA11n6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/303] KVM: s390: pci: Fix resource leak on IRQ registration failure
Date: Thu, 20 Aug 2026 16:52:21 +0200
Message-ID: <20260820145253.357625315@linuxfoundation.org>
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

From: Farhan Ali <alifm@linux.ibm.com>

[ Upstream commit 5580c9858f1e00f60191eb09c3add359836d60b6 ]

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
[alifm@linux.ibm.com: Resolved merge conflict]
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/pci.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index a6f6d5ddb0e3..8b91f289226b 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -359,19 +359,32 @@ static int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
 	aift->kzdev[zdev->aisb] = zdev->kzdev;
 	spin_unlock_irq(&aift->gait_lock);
 
-	/* Update guest FIB for re-issue */
-	fib->fmt0.aisbo = zdev->aisb & 63;
-	fib->fmt0.aisb = virt_to_phys(aift->sbv->vector + (zdev->aisb / 64) * 8);
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
 
 free_aisb:
 	airq_iv_free_bit(aift->sbv, zdev->aisb);
-- 
2.53.0



