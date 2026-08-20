Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A17F37DE9B;
	Thu, 20 Aug 2026 17:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247841; cv=none; b=ru+Qyi06hmmvuSvI70DrIC/QJb7IaNG4imQ/Cp4rVE/H5C/2SGE5ap4vTcyq12TXrzT0zngqdbThQ0sWXDGNfwHkxssKz8gHn4FSoKPfN0Vbjltyl+RwtsSDbQZjW4pFkwO0ZOxcSiuWhS00xAIeR0ZhKJyhvfO2Ktmc5tnrd70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247841; c=relaxed/simple;
	bh=Qvq/FFYaXIcq7exPl4hemUwzy/FGFLyfkf6cT31Ages=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcYdDzcWaRI4S0rq17AAGf4LchSCfjQUVVqVBewErwmPyhleLCipLMCdMiJxpG33Bc2DkDo8SbXRFPisIGrqLq1hhLCMXUAyHPP1JJl2cGspnJLDsbhlGBAJKBghYjVboDhCZlMMzpVBdatyipOyCtjqYdHoX4NQ2CwxdBuOly8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iutNU9xz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iutNU9xz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C891F000E9;
	Thu, 20 Aug 2026 17:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247840;
	bh=y05ClFnlxyPwdmjjy+RFzOozdNoiNl7U+kxCA+vr0zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iutNU9xz8k7bnwplHOYSXR+58pp5W8XKTuYPbvL+Sm2vJMIc5Rye78/5+OkkzfVlD
	 u+JRzfRI7RkbSia8D06S6yjpsNBLgw+bdltkUc2V/tP6rJKov3R/fw1s/evBxZtzi3
	 CkOKmzb48XeEBWN0ZysvAWJWcUjnNmgxUYUn9WOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/303] KVM: s390: pci: Fix aisb calculation
Date: Thu, 20 Aug 2026 16:52:22 +0200
Message-ID: <20260820145253.385892270@linuxfoundation.org>
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

From: Matthew Rosato <mjrosato@linux.ibm.com>

[ Upstream commit 0cfe660559e857d7c00ab86c73e4510ce069086f ]

The current implementation of aisb calculation will erroneously index
via an unsigned long * as well as multiply by 8B for every 64-bits in
the offset; only one or the other is required.  This throws off aisb
calculations once the number of devices exceeds 64, and can result
in out-of-bounds access as well as failure to indicate summary bits
associated with those devices in guests.

Fix this by converting to a physical address before applying the
offset, as is already done in arch/s390/pci/pci_irq.c.

Fixes: 3c5a1b6f0a18 ("KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding")
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
[alifm@linux.ibm.com: Resolved merge conflict]
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 8b91f289226b..59e824a7eaaf 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -167,7 +167,7 @@ static int kvm_zpci_set_airq(struct zpci_dev *zdev)
 	fib.fmt0.noi = airq_iv_end(zdev->aibv);
 	fib.fmt0.aibv = virt_to_phys(zdev->aibv->vector);
 	fib.fmt0.aibvo = 0;
-	fib.fmt0.aisb = virt_to_phys(aift->sbv->vector + (zdev->aisb / 64) * 8);
+	fib.fmt0.aisb = virt_to_phys(aift->sbv->vector) + (zdev->aisb / 64) * 8;
 	fib.fmt0.aisbo = zdev->aisb & 63;
 	fib.gd = zdev->gisa;
 
-- 
2.53.0



