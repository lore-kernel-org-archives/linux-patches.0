Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6575730AABF;
	Mon, 13 Oct 2025 15:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369478; cv=none; b=MBOHYSmOlzSYZ4osXX+VltOe/YgPWsqGlp10auT/X4LKNQtJ15SYeGOL/00DpKQjwPsVtUaqyzZcv+V1q1pk/XvGLlYigtsGuFJ6mPrahWGUKoZvmtlUN4jmtivLFoale7IGbEwJajznbuWlJCge/MS8h+qeKFFI0LveQH5NJII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369478; c=relaxed/simple;
	bh=gkOS/RGo4c9mFqQxep3kZF4DKT4Y1vBA+DfEDmzV1f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSdknIlPcINXxPJXb1N67WRuTicWake/In+kscSpE751MDugWk2BKGXwpkgpMtMeL6plinO91h1wTGdiRuyWZ7zZ2+EF84m5TVdmaGpA74hF8cx5FRXnp/mr1csJs0FMOMOfuH59olxNCB3IcyxP3FyxxKBEm+RlS4cTZEZH8FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kj2onO0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kj2onO0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD851C4CEE7;
	Mon, 13 Oct 2025 15:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369478;
	bh=gkOS/RGo4c9mFqQxep3kZF4DKT4Y1vBA+DfEDmzV1f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kj2onO0KIclTU3YiBcnBSrzCaKycmYHK1BAy8GOzyWNnxQfNNNU8JzNBo8P8wRKXx
	 fiNcXxe8bSwOKL7hwcKlTwdCTHxRqMWdp/Dw45ggZc1Oka4nlGaPMh2PkBHApR/s3O
	 5FdAj+ICmqjt9A4gn9JjSlEppKcVjYpjK5ujMqx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 260/563] media: staging/ipu7: convert to use pci_alloc_irq_vectors() API
Date: Mon, 13 Oct 2025 16:42:01 +0200
Message-ID: <20251013144420.696687668@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bingbu Cao <bingbu.cao@intel.com>

[ Upstream commit 283f7638c26c0f36e4ef5e147884e241b24fbebd ]

pci_enable_msi() is a deprecated API, thus switch to use modern
pci_alloc_irq_vectors().

Fixes: b7fe4c0019b1 ("media: staging/ipu7: add Intel IPU7 PCI device driver")
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu7/ipu7.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/ipu7/ipu7.c b/drivers/staging/media/ipu7/ipu7.c
index 1b4f01db13ca2..a8e8b0e231989 100644
--- a/drivers/staging/media/ipu7/ipu7.c
+++ b/drivers/staging/media/ipu7/ipu7.c
@@ -2248,20 +2248,13 @@ void ipu7_dump_fw_error_log(const struct ipu7_bus_device *adev)
 }
 EXPORT_SYMBOL_NS_GPL(ipu7_dump_fw_error_log, "INTEL_IPU7");
 
-static int ipu7_pci_config_setup(struct pci_dev *dev)
+static void ipu7_pci_config_setup(struct pci_dev *dev)
 {
 	u16 pci_command;
-	int ret;
 
 	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
 	pci_command |= PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER;
 	pci_write_config_word(dev, PCI_COMMAND, pci_command);
-
-	ret = pci_enable_msi(dev);
-	if (ret)
-		dev_err(&dev->dev, "Failed to enable msi (%d)\n", ret);
-
-	return ret;
 }
 
 static int ipu7_map_fw_code_region(struct ipu7_bus_device *sys,
@@ -2510,13 +2503,15 @@ static int ipu7_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	dma_set_max_seg_size(dev, UINT_MAX);
 
-	ret = ipu7_pci_config_setup(pdev);
-	if (ret)
-		return ret;
+	ipu7_pci_config_setup(pdev);
+
+	ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
+	if (ret < 0)
+		return dev_err_probe(dev, ret, "Failed to alloc irq vector\n");
 
 	ret = ipu_buttress_init(isp);
 	if (ret)
-		return ret;
+		goto pci_irq_free;
 
 	dev_info(dev, "firmware cpd file: %s\n", isp->cpd_fw_name);
 
@@ -2632,6 +2627,8 @@ static int ipu7_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	release_firmware(isp->cpd_fw);
 buttress_exit:
 	ipu_buttress_exit(isp);
+pci_irq_free:
+	pci_free_irq_vectors(pdev);
 
 	return ret;
 }
-- 
2.51.0



