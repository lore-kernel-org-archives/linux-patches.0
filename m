Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105ED29DB64;
	Sat, 12 Sep 2026 10:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209297; cv=none; b=I+ThGQzDI2IvBeg2xgs1I32lDtT6Jn3nAxtT18CrFU52iMJUZD6aX8GgZmsfOkpHjVwwGqQVERlJTLTa0vms7aeLwiSsWFkk/a06A9eby33H05yt2svL7tqCT0qaHa16OGJuRbEPxwbGOtJdooHEhFIA6H7t/GuyLFbrg3yRhRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209297; c=relaxed/simple;
	bh=iQkKj7vZluy9LSaWdc/NLmhreWpOF16B+MF0CXNaY+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjWeZBmA7s7y7ROh6HvdKsmGo9VQ6SLbEPfDB91ZXFJm46ZIp39OAh0g2OeVPpsU0gBfveHRrgYfzTBJHFyN8VI5/24pEVpaDMMMZkkTBPLi+88cxdywZ6cxbZ5ZdNCBRDmL5UDf6D2rdmOGt5i4sdZnfkskJJEfNOtQ4VZ5OYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=puiQMcDW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="puiQMcDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD831F000FF;
	Sat, 12 Sep 2026 10:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209295;
	bh=LI+iB8roV1lPc5mZr0kHUvjD5UWgZHE63zlGc2G4PCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=puiQMcDW3gc+6Z1SffJXWRYXtM15AnubT1/AKJGqrfxP/NuOwrUNqGJP40l1mslF3
	 6OedceuiANIJskVRFTOMzOYmelmDF+gZ8I/ctnpMYV9gmy/j7S+B/MhKG72re8CEjt
	 prT4fENdz8X1x8acvAZDvVOE64jQEQ5AT9dbng+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0793/1518] wifi: mt76: mt7915: fix double hif2 init on the non-WED path
Date: Sat, 12 Sep 2026 08:49:22 +0200
Message-ID: <20260912065641.372567085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 07b0a5766eab7..5a0c9eeb2c4e2 100644
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



