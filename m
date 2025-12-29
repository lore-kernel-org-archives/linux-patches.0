Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76A3331A45;
	Mon, 29 Dec 2025 16:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026058; cv=none; b=dJlu795Ec2eMbvv6ENlAnHFDKIUMIPRlmCPUHbdFSfe709N/96IKMv9Xr4RyaRAnb+P8vnYLYFqTos0sssWl9+WegINICt+hDitZCLcdCVL3K1BJR37oSeKvcJygk6bsDEkC0gkhRfbQdvzjY6AEc56SdoEyEVlKaXROd9SEt5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026058; c=relaxed/simple;
	bh=13CNCEVIgQrZweOlNSyim53maH6R3HMeyR4UEw51ObM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekqSZ4Yrw1lAcq24Fabo9pDf3R9EM/nhnPkM337cccDLYUiMZ4wLzOVYGYXzlV5vgjaVU4+h2+PllcAoxvIToCR5utV+QmutBvlQ9e7bsSPEXqSpX5MkN+EDUAd9jHdwJQbpUvJfRR8VEKA2JYq0VLYH3k0zH56W0rvRBXOFF40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXEjk7eW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXEjk7eW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CE7C4CEF7;
	Mon, 29 Dec 2025 16:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767026055;
	bh=13CNCEVIgQrZweOlNSyim53maH6R3HMeyR4UEw51ObM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXEjk7eWcZGaLLuvoCaA+d6LCrzMGDt/ViU/dM8Jv4gr4sNUCeUd+mmOiY3VRaeJR
	 fBD54tTHgbUksyptrrNl6FIvVdlLZwasvmYbSCQxK2u9rv1jYcwot5ddUSpSykwPtg
	 wCcX1vM24K1PJkV9Cv1zK6PBO3XbCH5MxN/RiwmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 416/430] i2c: amd-mp2: fix reference leak in MP2 PCI device
Date: Mon, 29 Dec 2025 17:13:38 +0100
Message-ID: <20251229160739.622058774@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit a6ee6aac66fb394b7f6e6187c73bdcd873f2d139 upstream.

In i2c_amd_probe(), amd_mp2_find_device() utilizes
driver_find_next_device() which internally calls driver_find_device()
to locate the matching device. driver_find_device() increments the
reference count of the found device by calling get_device(), but
amd_mp2_find_device() fails to call put_device() to decrement the
reference count before returning. This results in a reference count
leak of the PCI device each time i2c_amd_probe() is executed, which
may prevent the device from being properly released and cause a memory
leak.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 529766e0a011 ("i2c: Add drivers for the AMD PCIe MP2 I2C controller")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20251022095402.8846-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-amd-mp2-pci.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-amd-mp2-pci.c
+++ b/drivers/i2c/busses/i2c-amd-mp2-pci.c
@@ -458,13 +458,16 @@ struct amd_mp2_dev *amd_mp2_find_device(
 {
 	struct device *dev;
 	struct pci_dev *pci_dev;
+	struct amd_mp2_dev *mp2_dev;
 
 	dev = driver_find_next_device(&amd_mp2_pci_driver.driver, NULL);
 	if (!dev)
 		return NULL;
 
 	pci_dev = to_pci_dev(dev);
-	return (struct amd_mp2_dev *)pci_get_drvdata(pci_dev);
+	mp2_dev = (struct amd_mp2_dev *)pci_get_drvdata(pci_dev);
+	put_device(dev);
+	return mp2_dev;
 }
 EXPORT_SYMBOL_GPL(amd_mp2_find_device);
 


