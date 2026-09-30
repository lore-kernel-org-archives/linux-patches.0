Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA6B50B43C;
	Wed, 30 Sep 2026 16:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784285; cv=none; b=LhUGV8L5QXLFPbyrqgjDG1TRlsjW4BXrU9SRC9jrAx0ZUK10Sj0w7BmUFYkupzqqRA7hjLUfOA3abh+P4MBwiW4k4Q/6aEn9lNEmDzvpp4yLKSlsotkpWLnVqhQcuKqDGNdcgTiJUforKwLN22y405cKLRNW/mTaNQaIKgPBtws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784285; c=relaxed/simple;
	bh=a+2TBCIiyqsP01M7/Nr9yZMzr02XJvo9WdtyRQqFWV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntYu22pBxxWntriPSXeozJAq2c0CsloCcUP3oBN/W+PftBdKJDfNR7D7t34C+X81lOi8HxVDHX8qZOrbkGvnhnfa37PXNRnj0QPkZXochM7LWol3c1g3XPZvHs3YobQTzc5oOgGzKvv+9zzxbmcQi1Ad3/vJSUAhwk9EOjdKCAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQ/zigYi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQ/zigYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94551F00893;
	Wed, 30 Sep 2026 16:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784278;
	bh=xCFQ9i62KoS1oA1l3XRD4Ujtxj4ChwqGBzgimXxAE/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pQ/zigYiVPUPsO81EtN3bQFJMFWxvmBwJucel1RxAcoAEKcv0udQ+1E6vrShAR2FM
	 QxUFL3naOpe+KUFzLSJRbOGk5YEHbCNN++WCURHzALfWWsUCNf+A/Pl6TW5VLmoQP3
	 aWYKG9FlrqnQ6eCKW2pXyHegmSkNIpUTh75IcJ9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/982] net: thunderx: fix PTP device ref leak in nicvf_probe()
Date: Wed, 30 Sep 2026 17:13:54 +0200
Message-ID: <20260930152418.915694790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index f2f95493ec89a..1c04ebaa705c0 100644
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
@@ -2261,6 +2263,8 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_release_regions(pdev);
 err_disable_device:
 	pci_disable_device(pdev);
+err_put_ptp:
+	cavium_ptp_put(ptp_clock);
 	return err;
 }
 
-- 
2.53.0



