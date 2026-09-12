Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB1B3DC878;
	Sat, 12 Sep 2026 14:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224464; cv=none; b=iedTBX6UEE2KP1cyjYqLV0oZv97J+PGVjRgTW36cI7GB1jxPG/qz7+NlekVA6qzzh/Ixo0v6ho6DoXMweskhFDwofpPPIjzHOjDBOBsso/vo6qo74HUeYlJ7ZU4UxNMmDGa3nF7fkDL03o/zc1QynaMbPusBjHDImtzoHPaFZyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224464; c=relaxed/simple;
	bh=vWmEzGfEZvkCYwp3Oq3HuWi8Nt9B5mymW2sqOnEp0Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1BQ/PeK1WAJWf702k2S3H+3GUXBdtIE/5fk/rzQDLJKvA/u7m7AdIF3qZKv9lG7I7/dXZAlvu1UWi5gzcdT6ng45IDhzKpCbTsYp9Rrk0Qw6tKURaESHsN2/RXHnxkd+1OTxn8CFJYQfM8JO8Q47eUuklSmqHdzUoaGPVC46yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=akgLjNR9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="akgLjNR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012641F000FF;
	Sat, 12 Sep 2026 14:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224462;
	bh=NtqnZRoDIA6G+efaDCcQTp8EW1IDyBCzl/wYioAF3Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=akgLjNR9mipZUJym2GYluQ8C75++jgXDaYtfzuyfkj8TR7kCLaFafyHfhDe2gf89n
	 B7wSTPSbcN52PxN36iD0REGfsqzdVdSl41CYZVXSN5NtSWQP1LvjCbN+XYzvmgJtVT
	 nZRkaDKB+DGmavc5PGYqVxd63OJY3UV0ZPHgvnNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0996/1424] wifi: mt76: mt7915: fix double hif2 init on the non-WED path
Date: Sat, 12 Sep 2026 08:57:08 +0200
Message-ID: <20260912065629.622347903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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



