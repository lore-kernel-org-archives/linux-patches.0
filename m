Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C842264AB;
	Sat, 12 Sep 2026 16:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230562; cv=none; b=clDtTNzaj0dIQr/UHwVUmPgK0VNYx6P5jesruOYLLz4CiYh9jBBE1B+QU0p3KrUNM79Uw5jMwokHaO2dyCTr0YWgObUikuY/TFKqWKlr+gPu3cfk1mSv9VhOuDcxFkR1Cxfgj4zk/3qmhAHIU1feQ9tFOY4pi0uaIGkXIHWnhfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230562; c=relaxed/simple;
	bh=Zz+VECm1rKI5XTUoyDErE/ktWBHGymjHKht3T3xuzio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyxq1+Fo6WxWV13C6Pu87JiHe3m8kNXWv4+e8ysCZ8C/2t7kxLQRBRNoeuzZyEAWF3BwoMA+onCx85KIpW9d+KxxNlGC2Vsw9MLBhd8QCodyHmcN437zuBT/ENjGq2/ZYJwS6HvxXV7PhmEbFnrMKMg6pRePVFJOtKRmDNyLzvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCCsr4cK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCCsr4cK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D54D1F000FF;
	Sat, 12 Sep 2026 16:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230561;
	bh=A29nKjXiqhF3712iI4Wo/L3DlbEeb4gR7vIRYd5D6RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xCCsr4cKk6XSD91e5lO+dJ9ONLQagGBt7nz8eJSOJEqNxxcnRrZTPTilrrPNbqlcp
	 kVvPTsoirFC3fFo8cFrtbu8LbZRqXboM8JQceT6Sq7XfzsNgNwhrG1na14ieqSsKAQ
	 rezJ27wBLOqrKFYND9Vd45TsbsESiwkZ+W061GqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0818/1191] wifi: mt76: mt7915: fix double hif2 init on the non-WED path
Date: Sat, 12 Sep 2026 08:59:06 +0200
Message-ID: <20260912065606.642533878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 39132894e8ea2..8e125daa90747 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
@@ -134,7 +134,6 @@ static int mt7915_pci_probe(struct pci_dev *pdev,
 
 	mdev = &dev->mt76;
 	mt7915_wfsys_reset(dev);
-	hif2 = mt7915_pci_init_hif2(pdev);
 
 	ret = mt7915_mmio_wed_init(dev, pdev, true, &irq);
 	if (ret < 0)
-- 
2.53.0



