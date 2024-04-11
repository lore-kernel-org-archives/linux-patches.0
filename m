Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E14A63A2;
	Thu, 11 Apr 2024 10:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832496; cv=none; b=ipTLIeimmQRxbUhkQNBhyKIY0GRl8MupWm3EDU8RQXae2OlkKyH2Zlvmc8p/frzwUkFFtR0Y4g1OFFvuiWrwRzvbEejYbkIEg5sH2jCkJENKPQ/EG1CYtbm1U2Jw0ivgSsCV/8gI6M1aY2Eol1rixzwGDZW0pWkmlRAbGhihWcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832496; c=relaxed/simple;
	bh=ThHWZ4OevIVpDZ8s0q+izCjOgEiBuAfsBdE07ANj6yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJ1qxRDszjTGSUfUYaZ3836ydVM+vOonNHv5L6bM+0r0LRXHa01i/uw2a9H8mt3lw3TrzNl3qLolDXpj312izuSVUuuHK98IH/T5AfiDbcdih7ZarJenaU33VDrhkuoBOc5z/y51ubC62nPwY6EGhijLf2NJ6tEZteNNMB8bb54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZU9aQ7qO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZU9aQ7qO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FABC433F1;
	Thu, 11 Apr 2024 10:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832496;
	bh=ThHWZ4OevIVpDZ8s0q+izCjOgEiBuAfsBdE07ANj6yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZU9aQ7qOWQP/8hCydQDfVT1qMx8MxMRpKX8EvvaTux3Ll82njq6sBbiqKZCHcLoHZ
	 Ahjyvy11u0PlCTbgQzmFvZ93N8LGAtpPx2MFPTntHLFmubEnywdaXsVviq6A6Z8F3B
	 UYN1SbSkA858PfoZHM13usk1WIdiUE9Ny2D8RXks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Fu <i@ibugone.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 67/83] drivers/nvme: Add quirks for device 126f:2262
Date: Thu, 11 Apr 2024 11:57:39 +0200
Message-ID: <20240411095414.700796458@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawei Fu (iBug) <i@ibugone.com>

[ Upstream commit e89086c43f0500bc7c4ce225495b73b8ce234c1f ]

This commit adds NVME_QUIRK_NO_DEEPEST_PS and NVME_QUIRK_BOGUS_NID for
device [126f:2262], which appears to be a generic VID:PID pair used for
many SSDs based on the Silicon Motion SM2262/SM2262EN controller.

Two of my SSDs with this VID:PID pair exhibit the same behavior:

  * They frequently have trouble exiting the deepest power state (5),
    resulting in the entire disk unresponsive.
    Verified by setting nvme_core.default_ps_max_latency_us=10000 and
    observing them behaving normally.
  * They produce all-zero nguid and eui64 with `nvme id-ns` command.

The offending products are:

  * HP SSD EX950 1TB
  * HIKVISION C2000Pro 2TB

Signed-off-by: Jiawei Fu <i@ibugone.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 3d01290994d89..5ff09f2cacab7 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3471,6 +3471,9 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_BOGUS_NID, },
 	{ PCI_VDEVICE(REDHAT, 0x0010),	/* Qemu emulated controller */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x126f, 0x2262),	/* Silicon Motion generic */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
+				NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x126f, 0x2263),	/* Silicon Motion unidentified */
 		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST |
 				NVME_QUIRK_BOGUS_NID, },
-- 
2.43.0



