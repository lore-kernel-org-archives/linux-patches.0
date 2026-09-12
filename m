Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA31C38D6A2;
	Sat, 12 Sep 2026 08:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201175; cv=none; b=lYgK//XHIqhO2q6Elu7XkaVOri3tY0xnI0QgHeP2qSi4eTGDrCyzwU7jNs58rR32zC/O2mzgaF/9a7p5yAt64GTIwu4/ryONLuIB0yZMsNZxIxDapwiQ+9evj6wunOIamY/YGVRIUJxWItLA3HP334gg8dhVFMuQYC3x6T/lYzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201175; c=relaxed/simple;
	bh=Gu17pEThdiaNuC3bw2IYHF9fqY9KeHoUAGSCOqald/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIxO5wy69n+Ttg5xXX7bOXCLE+n4f7DYxdVCG0B8Pff8a2yIZHem8FfP2djQgz+XVoYRMw/AuVhR2YoLkipK9Cx6D2SyglNCvNZLsSQhNe1GbA/djLqq3FO+JyjSSh7qLJmAKJEbYafa1pZorTUFvuT2BTiuvGNl06A5MM0t+Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvuzPMbl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvuzPMbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CF61F000FF;
	Sat, 12 Sep 2026 08:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201173;
	bh=cmj245mI2Anw5o4NeJeex/+QxqUnSDSvL6Sh62o0C6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvuzPMblj3hOJlok/lVZ9yxnkzmKxyqHRQFrsDAE7R3ArJ7gO5T3250n1y9GZmj9q
	 DwLNxe+KjJYM1UMevGJ3IdQmIwxcR3osVQ3stmq6cIZFIiM9S1cdxy+g8Ti4KL5pYl
	 Pul76ag1tBkhI8IxiHlTiPXI5QUG0QmPCgEnD7jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0941/1815] wifi: mt76: mt7915: fix double hif2 init on the non-WED path
Date: Sat, 12 Sep 2026 08:44:51 +0200
Message-ID: <20260912065711.048251955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 3ae8ad277e2819a281b0e36b55633c8515c16ce7 ]

mt7915_pci_init_hif2() was called unconditionally and again inside the
WED-inactive branch. The helper increments the global hif_idx, writes the
PCIe RECOG_ID register and takes a get_device() reference via
mt7915_pci_get_hif2(), while removal only drops one reference. On non-WED
dual-hif hardware this double-incremented hif_idx, wrote RECOG_ID twice and
leaked a device reference. Only the call inside the WED-inactive branch is
correct; drop the unconditional one. hif2 is already initialised to NULL.

Fixes: cacdd67812c6 ("mt76: mt7915: add mt7915_mmio_probe() as a common probing function")
Link: https://patch.msgid.link/20260727150434.1778520-2-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
index f6b03211a879b..12b3e2dd530ae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
@@ -135,7 +135,6 @@ static int mt7915_pci_probe(struct pci_dev *pdev,
 
 	mdev = &dev->mt76;
 	mt7915_wfsys_reset(dev);
-	hif2 = mt7915_pci_init_hif2(pdev);
 
 	ret = mt7915_mmio_wed_init(dev, pdev, true, &irq);
 	if (ret < 0)
-- 
2.53.0



