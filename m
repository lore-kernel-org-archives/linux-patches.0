Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FBF1C84D0;
	Fri,  7 Aug 2026 15:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116207; cv=none; b=dnto8r+rtmd+sCdKNYeIjf5lE77lyeWGDaHF5oO5Ik1CathI00BALHJduzegonfGJ5yigrtL4VpICXuqK96KbGNi26+s+NMwm2lL6JdU5N6tc3xGtWREaYDW1Ba3/894eG80b8UvZ1scUleX84ESwNLpZPxrVJ5wEFMcoyM2FaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116207; c=relaxed/simple;
	bh=smaVEe4e8/2//N66cM+apj2B8ncTqFrihKxLeJ5+CG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDg2HCyj2BLRrw+9nA0dMKXINI6ijt2FWj0AbAO4xX3qOIWAEeoPDv6XlqPve2s02Q+nxraW4sg2gtmXc3j4V9DVBhGUORz4b6ycAdaVfnx72PABFI8g/5QgBj03KEl5lI2bSvmOxxcqA2oHEt7ZNa0uKmjEh53p+rUdzpGYDrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFLp6GfP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFLp6GfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA301F000E9;
	Fri,  7 Aug 2026 15:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116206;
	bh=3aKSjaWITQg+EZN8eT7n8wfZktWDF5HaGYzbxpcxocA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFLp6GfPc/C6FhU44R2yaiDktsRbwCL60GO2K6AQ+gJH45/5eoFAaS+KopmXrttx+
	 /Dsn2Pa97qibMl4wcbY/E4wkq5VY09FS9BF2S/m6SCvjXlrTT6CbP4CUg1JYlYHGke
	 XQzgxvrElcM8YauGzQF4snIJGk1K6NWr/UnazusE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 149/261] i2c: amd-mp2: Unregister callback on adapter add failure
Date: Fri,  7 Aug 2026 16:38:26 +0200
Message-ID: <20260807143418.579088726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 82048795242f04275a3f49ffc66ad851b6120954 upstream.

amd_mp2_register_cb() stores the platform I2C context in the MP2 PCI
driver's callback table before the adapter is registered. If
i2c_add_adapter() fails, probe returns and devres frees the context,
but the PCI driver can still dereference the stale pointer from its IRQ
and system-sleep callbacks.

Unregister the callback before returning the adapter registration error.

Fixes: 529766e0a011 ("i2c: Add drivers for the AMD PCIe MP2 I2C controller")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260721144147.31150-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-amd-mp2-plat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-amd-mp2-plat.c
+++ b/drivers/i2c/busses/i2c-amd-mp2-plat.c
@@ -316,8 +316,10 @@ static int i2c_amd_probe(struct platform
 
 	amd_mp2_pm_runtime_put(mp2_dev);
 
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&pdev->dev, "i2c add adapter failed = %d\n", ret);
+		amd_mp2_unregister_cb(&i2c_dev->common);
+	}
 
 	return ret;
 }


