Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C595695;
	Tue,  6 Jan 2026 17:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720706; cv=none; b=PRwTiky4QE+B24r1Fg/ABZk5906+LVoYB+IE8BtmwBvs3+z8TwCJ5PmCjXTmZrbFfvCm0C4yGyKDnBkJbLlnVLF0KaFTVJlhFHpUAWa+7UoR1gDr+Skuc2lNRShw7IpF1gp4W1IS57DAwO7+cTFSR33ThKVJY+8qfOsijhkccV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720706; c=relaxed/simple;
	bh=/Xt9PdgjELG6ROqyWbEq3eqTnq7akhuQ/7mtJkEABos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaugttocoYGY8YEUD8AIgmzC2UnqLrapvI1tmD7i+CnZ9pO4JacvqLMYPhY4djr0UTlazYlpts1h1lygtKD50Bec3Rn5cin3W+6lfAQaTzpfEzqpq8xbYT0yqCBCWe1lenfFIfwArg+BlSLDQguWeQfqaPpIsybZm6dH/qt+j5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rU6oBDZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rU6oBDZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62987C116C6;
	Tue,  6 Jan 2026 17:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720705;
	bh=/Xt9PdgjELG6ROqyWbEq3eqTnq7akhuQ/7mtJkEABos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rU6oBDZPgLxhXEDLX9EemGGkkhdkz8hpV6uVitFaX4VpuVkWLYs/50QTwY23qRKqH
	 /tN4vY4rwI2bLFzPn6llrF4hQmh+wkYtZbpvc5YBZrLaXdmlyKisz50dyJxXcEWn+q
	 lGkOpxnPdAxFo4Q/ZYdivKlaz5Y4RWT/aEpUIKVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 284/567] i2c: amd-mp2: fix reference leak in MP2 PCI device
Date: Tue,  6 Jan 2026 18:01:06 +0100
Message-ID: <20260106170501.837929200@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
@@ -461,13 +461,16 @@ struct amd_mp2_dev *amd_mp2_find_device(
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
 


