Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE644F68CB;
	Thu, 17 Sep 2026 17:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667635; cv=none; b=p6AI+ftytGvxCCjorOoHTs4O0e/IssBU6EaGuoYJGhuMT2WALo703LLkdwQdTQpmixNx9xrM23To/wIBKE0J00hvDAKkjerPLb2OfxdKjcmydW900V0aI26IZoYrlCl44vXJekmDok3Lor+Z36ZXqK99kuneTl0U3PKJcMrLoAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667635; c=relaxed/simple;
	bh=3RPFg5ilwkziM4c4q79op3J1EUPw7m0xa61u28W/LFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRpLt2QDEC/vEdzDGGboJ7La/uOi8orUNpma/kqhYzDpamKsz/b/P6wEfqHKyDpQyuD8b4wUB0JZOZ1rueiyQr8PBV2S/z3sSzcv6buji55ZsInmjgnPt2Y+A52JoCPd+muGoaKCA6NmcuOwQBFUgBePd3aYp1MNAYEgqwZzNNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExrUykd4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExrUykd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95E61F000FF;
	Thu, 17 Sep 2026 17:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667634;
	bh=pBlI9pRzFJhfIqF+kOGgLI/qtcISjUC4K4H10eOyuQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ExrUykd412tX3KQmZ4kKb5uaPJ78BSCxvlVAn78suJVxvCMsUgGmCGKjPETiZ/z1L
	 J7Vuo6P/BUhjGX2ocUDsEkBk+DDXGLV1UaOIHNig1vSC16Sf0kqrLJw3Ntpn/9Npjm
	 Z+T78Ek3fjAee3bgktN8QjjpCWEphFu7mG6Dnn+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0157/1102] net: thunderx: fix PTP device ref leak in nicvf_probe()
Date: Thu, 17 Sep 2026 16:01:40 +0100
Message-ID: <20260917151543.476136439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 2bcf59eefb9f00a2b1d426b639ee49c305a80695 ]

cavium_ptp_get() acquires a reference to the PTP PCI device
through pci_get_device(). If any initialization step fails
after cavium_ptp_get(), the PTP PCI device reference is leaked.
Add a common error path to release the PTP reference before
returning from probe failures.

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20260525082611.61817-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index aebb9fef3f6eb..5730ce711b249 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2110,8 +2110,10 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	err = pci_enable_device(pdev);
-	if (err)
-		return dev_err_probe(dev, err, "Failed to enable PCI device\n");
+	if (err) {
+		err = dev_err_probe(dev, err, "Failed to enable PCI device\n");
+		goto err_put_ptp;
+	}
 
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err) {
@@ -2265,6 +2267,8 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_release_regions(pdev);
 err_disable_device:
 	pci_disable_device(pdev);
+err_put_ptp:
+	cavium_ptp_put(ptp_clock);
 	return err;
 }
 
-- 
2.53.0



