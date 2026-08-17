Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27933911DC;
	Mon, 17 Aug 2026 14:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978112; cv=none; b=nGGSsfQ79bibvfqTd29K8WCmoN8FeN62abNR+yKcW/7AZdMV9NY6wTpgLbBL8CtS54lTDh4lxIYLb4CgaqfDR4MvCWuHSp7MBfJlatVCQcqiTDxQMhFc2S3ahUR5U/WeLaAm6D+O3sb2dO3kzH7AjexOUtjv7hmDBfcXmCC7kEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978112; c=relaxed/simple;
	bh=+cTIURHY79Dn5ZplOr5tgR8LDuYy+9FqgDWelFTCvwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlX/zu7o/CqWg6Ir2HQGExLXSqFHEyJkwxq9S6CYHH9gNJGVngc/0UZFb2sBo4BKsj8ddsypb/DWmCT2A6pUPWTd0i80WJa2QreaJDQgoolXoqWuImQ7eoU9LX+UCVXTo058zncgeiY274z+QQk5MqLGJfTZ4GPsWG2B7cJSMfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c05o+d43; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c05o+d43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C361F000E9;
	Mon, 17 Aug 2026 14:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978110;
	bh=GESkTX1QKNGy/uJwqtsCKcM6jDoLuugl+cRTFt66Z8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c05o+d43+55TCrgmhRPBsHNIXNhq8xhmAMdKElrAxTGx161HwRdvNtvWXIu+2u5XQ
	 p+cwn+mhqguOhBTs+sNQHD6PO5sG9aO4oC3Too8lJPTB5UyIxL9B110JcdwpfbMnyo
	 HWZI5x3G3eQ3ps+Dkwl9jevK3VM4oVPGVz4jbmws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/181] KVM: s390: pci: Fix aisb calculation
Date: Mon, 17 Aug 2026 15:33:19 +0200
Message-ID: <20260817132539.622137888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 61489016e4252..d9fcbf41025e0 100644
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



