Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25A4335BCD;
	Fri,  9 Jan 2026 12:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962541; cv=none; b=XXdhxD7RLNoxxpNLea6Sc7HBFWIFkZNUhGsw3Yu744erVbWdFxfiFB8KBfn0A6hOIHtQ47u6LS5OmsisYQy2z/EFdAdYHgP9kb7MPpt4FILrbCKWPP7ib9JPJXqaTZHq+AxcfK9OcGtpFxwmHZBG86wHYvDct52GYTBMay6Ti0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962541; c=relaxed/simple;
	bh=9anle2/v1JjC/zvzCMeDmKkNh6aLzGSsq3fYnaHqbl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpCUslISXl+UKmSVtPTHeVgR8+PZN7Hy52JRLrZj5HFkpjNtTHKo95YMGeDSPSeHHHMhKO25k3yka5rXtCYrGw4kst1e8pWj9dWQerEG40hV0i9s87CbogerWP3CDDCxOxhCDp6YinZHdl/Pn77ocWrQYJKZhS23t+2RjcnSbsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jt1pXuVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jt1pXuVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B404C4CEF1;
	Fri,  9 Jan 2026 12:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962541;
	bh=9anle2/v1JjC/zvzCMeDmKkNh6aLzGSsq3fYnaHqbl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jt1pXuVXxyKv8nqHpPVOg13g9rgAx5G60EY6XE+d8AIdVuruV4ra93v9zZD/p7Ozs
	 g5pChTnKLXbTv/2jYnbltMpkvIeT6sN8gRrjxgYgBn7WGMqUfdPfNPdNf/zGHiacIp
	 xhPV+fJflqFzjJiW510glZuiwDC47z9Qej9RHX+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 384/634] i2c: amd-mp2: fix reference leak in MP2 PCI device
Date: Fri,  9 Jan 2026 12:41:02 +0100
Message-ID: <20260109112131.981008891@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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
@@ -449,13 +449,16 @@ struct amd_mp2_dev *amd_mp2_find_device(
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
 


