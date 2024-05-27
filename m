Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CD517E90E;
	Mon, 27 May 2024 19:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837237; cv=none; b=aV9a4AVZ3JKHXbe6DFhgq+tBD9YzRX7vPGoCFjDJGOejY14s7gWTckRNijGuvIcX1H3UxoCka6o3VAUAHZBzViPu4gJf8cDn+nzL2/ml5UXrsdGaV7gpJCwhxLFODmb7AMMy0tYhcstMe/mZOH/s2AfsMKEZ+qjLW3Fu9DrXD88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837237; c=relaxed/simple;
	bh=8pUmjX5tJBpLxxR9EzK3nQpdm/v9kpMuPbfrm7DY3zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7vmwjbdXvMDbg3PdcTdV2qNMqp8N2MWR6Qn/nBMIx6yF9Yg7EAquFzewiUwFTYEKzGL/xu8m6FGviTuvCU4TgPVjsTs8NTyMeLix2tWxsLQkATsKE7heNt0RRdM4UhXWzNYqfgfNgYT7JXVe/9re0xOfvKKUwhbQ9n2EbkuJ/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0tv63fU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0tv63fU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC57C2BBFC;
	Mon, 27 May 2024 19:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837237;
	bh=8pUmjX5tJBpLxxR9EzK3nQpdm/v9kpMuPbfrm7DY3zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0tv63fU53ZUR0s3klNghfkyz8RcHEdxWwsi/S/4TftxJuMZp6l/DumTKZwGYwHvZ
	 lyfNRlV/p5fvvuJxPxkw22HoaOR0Fs9u2fpQTbQEfMl7UaRzp4hXDsF3P+WbAIFPgA
	 3YQqwqNEm0L5Vp2uQ2I+t+X4vHV8rUHHIx7l8PzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 321/427] media: ipu3-cio2: Request IRQ earlier
Date: Mon, 27 May 2024 20:56:08 +0200
Message-ID: <20240527185631.612757611@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit a069f79bfa6ec1ea0744981ea8425c8a25322579 ]

Call devm_request_irq() before registering the async notifier, as otherwise
it would be possible to use the device before the interrupts could be
delivered to the driver.

Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index c42adc5a408db..00090e7f5f9da 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1752,11 +1752,6 @@ static int cio2_pci_probe(struct pci_dev *pci_dev,
 
 	v4l2_async_nf_init(&cio2->notifier, &cio2->v4l2_dev);
 
-	/* Register notifier for subdevices we care */
-	r = cio2_parse_firmware(cio2);
-	if (r)
-		goto fail_clean_notifier;
-
 	r = devm_request_irq(dev, pci_dev->irq, cio2_irq, IRQF_SHARED,
 			     CIO2_NAME, cio2);
 	if (r) {
@@ -1764,6 +1759,11 @@ static int cio2_pci_probe(struct pci_dev *pci_dev,
 		goto fail_clean_notifier;
 	}
 
+	/* Register notifier for subdevices we care */
+	r = cio2_parse_firmware(cio2);
+	if (r)
+		goto fail_clean_notifier;
+
 	pm_runtime_put_noidle(dev);
 	pm_runtime_allow(dev);
 
-- 
2.43.0



