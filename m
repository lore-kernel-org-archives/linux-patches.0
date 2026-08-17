Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35CA44781B;
	Mon, 17 Aug 2026 15:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979912; cv=none; b=bl2r9bv7Hdh2piO3TDE7vcFoNU2hgn5feQsz4JcmhcZtIa7Tjv9QqV4/Sn/y8S11vJmOSrU5M4aruJw2TcJz0J8iUb8jXPt7FXzniUYy6vZNko3YquHKxJU4OxngaBs/ZDS5H+3G2vUX4kofT0iPvtP4MbfDG/eQGbhNQWNtkuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979912; c=relaxed/simple;
	bh=mK6aVOzJO83ru4/rziPbSWJPSEihEODhb7cnav/W8Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTtLxJRDra6Tw74Vu+uilJ4iOP5wJA2G2ANIM67MhkjsPcM37XpqFo5MvMxvswf4LTbqsgUh5jGAHXKH3T9dJGp7LpSxW/YHsS6AJ57klrDZztSrIxNXiY9pOS5FVnGQZ5rLZBrbxfQXzFB8x8cotW2tb4AUtcIjmpVrBDACrKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JU211fqu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JU211fqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E761F000E9;
	Mon, 17 Aug 2026 15:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979910;
	bh=Z8QR66jSLaaAxjZX2SwYhab3daqR+LUZ3U+GXoZURvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JU211fquICj0a8nvJzOJFJdFLGPSccgxWQ8WEyohP+dfqBUHdt7ehlbpUXLMMFR2G
	 JWB8K5P7xSpMe02Bbz4y8dotc2dKEDpTgRvGg9+0xw70NDXNHYSlIsmKEILddSoUVH
	 qHUDp454WqBtco6VYOrXxEVqUF4cuiijhZv475W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>
Subject: [PATCH 6.1 389/609] KVM: s390: pci: Fix NULL dereference on AIBV allocation failure
Date: Mon, 17 Aug 2026 15:31:25 +0200
Message-ID: <20260817132557.262400573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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


