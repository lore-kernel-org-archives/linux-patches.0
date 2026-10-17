Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E73324B32;
	Sat, 17 Oct 2026 17:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259599; cv=none; b=SEMf1M975Np0dYKVmgmGLLPUxlp7lH/xQaX4E/NR+/EOt8M+fDvjOYTkfbpV2V2VDzACmN/HaiADaQ0C5SF1eyxGV2PqXJTFvz4TENM5BGjJfABt3mz84WXEzyVM7OiBTIuFouoiVfAzVEjhzR87zPTtUBM+BP8m1HGpn9XOzjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259599; c=relaxed/simple;
	bh=unAmuw9O8IXzTDcGJi38OXswCVejXaClD7horoeq3y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oqH2EtHhqt6LraulWEbRhwnGXODzyCyWAEQ62teBI59deGtxIr6t5NpBUC7dM3kbTz9h8a+sWFWe/T6CQ+97joitYHOg32Sd/UJuUO8Furr0HwueIcYFPlNx5fL/4z+iWBcwAkwzIqXBxyC1JzBB+wqX9XoY5yiTbV447rp41Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4SaOo1M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4SaOo1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAD61F000C4;
	Sat, 17 Oct 2026 17:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259598;
	bh=1ADB6RiomjQ353/ep83NuD0GEG4s0CtyP7GF4jmEWgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y4SaOo1MIyPm7u9FV/57dO/Xoo0XZqYhBAKs3j5EGNXrk/JxVdtJ6pOwqeBpCKOa+
	 wgEw2/h1loIW+QFKSFUdUFYWE7NTYlc6T/E6lMzXxC9zQPIeOljk9pwroOgON1jRb1
	 qahb35E3oP4/eZJjK23BJk+HkLLdI8o419mCUX8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francis De Brabandere <francisdb@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1266/1674] platform/x86/amd/pmc: Propagate SMU errors and validate S2D address
Date: Sat, 17 Oct 2026 17:58:58 +0200
Message-ID: <20261017160503.637338267@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 0225c1d637687b03726f00ac65b6def843d2c464 ]

amd_stb_s2d_init() discards the return value of several S2D SMU commands.
When the SMU refuses a command (e.g. "SMU cmd failed. err: 0xff") the
failure is only noticed indirectly - if at all - and reported as -EIO,
masking the real error.

More seriously, the S2D_PHYS_ADDR_LOW/HIGH return values are ignored, so
on failure phys_addr_low/hi are left uninitialised and the assembled
address is passed straight to devm_ioremap().  When the SMU leaves them at
zero this maps physical address 0 and trips the ioremap-on-RAM warning:

  amd_pmc AMDI000B:00: SMU cmd failed. err: 0xff
  ioremap on RAM at 0x0000000000000000 - 0x0000000000ffffff
  WARNING: CPU: 13 PID: 4592 at arch/x86/mm/ioremap.c:...

Check the return value of each SMU command and propagate it, and reject a
zero physical address before calling devm_ioremap().

Reported-by: Francis De Brabandere <francisdb@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221759
Tested-by: Francis De Brabandere <francisdb@gmail.com>
Fixes: 3d7d407dfb05 ("platform/x86: amd-pmc: Add support for AMD Spill to DRAM STB feature")
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260721181756.143084-4-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc.c | 40 +++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/platform/x86/amd/pmc/pmc.c b/drivers/platform/x86/amd/pmc/pmc.c
index bf6c7ca247e24..6b67f8517d90d 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -1005,34 +1005,46 @@ static int amd_pmc_s2d_init(struct amd_pmc_dev *dev)
 	/* Get num of IP blocks within the SoC */
 	amd_pmc_get_ip_info(dev);
 
-	amd_pmc_send_cmd(dev, S2D_TELEMETRY_SIZE, &size, dev->s2d_msg_id, true);
-	if (size != S2D_TELEMETRY_BYTES_MAX)
-		return -EIO;
+	ret = amd_pmc_send_cmd(dev, S2D_TELEMETRY_SIZE, &size, dev->s2d_msg_id, true);
+	if (ret)
+		goto out;
+	if (size != S2D_TELEMETRY_BYTES_MAX) {
+		ret = -EIO;
+		goto out;
+	}
 
-	/* Get DRAM size */
-	ret = amd_pmc_send_cmd(dev, S2D_DRAM_SIZE, &dev->dram_size, dev->s2d_msg_id, true);
-	if (ret || !dev->dram_size)
+	/* Get DRAM size; fall back to the default if the query fails */
+	if (amd_pmc_send_cmd(dev, S2D_DRAM_SIZE, &dev->dram_size, dev->s2d_msg_id, true) ||
+	    !dev->dram_size)
 		dev->dram_size = S2D_TELEMETRY_DRAMBYTES_MAX;
 
 	/* Get STB DRAM address */
-	amd_pmc_send_cmd(dev, S2D_PHYS_ADDR_LOW, &phys_addr_low, dev->s2d_msg_id, true);
-	amd_pmc_send_cmd(dev, S2D_PHYS_ADDR_HIGH, &phys_addr_hi, dev->s2d_msg_id, true);
+	ret = amd_pmc_send_cmd(dev, S2D_PHYS_ADDR_LOW, &phys_addr_low,
+			       dev->s2d_msg_id, true);
+	if (ret)
+		goto out;
+	ret = amd_pmc_send_cmd(dev, S2D_PHYS_ADDR_HIGH, &phys_addr_hi,
+			       dev->s2d_msg_id, true);
+	if (ret)
+		goto out;
 
 	if (!phys_addr_hi && !phys_addr_low) {
 		dev_err(dev->dev, "STB is not enabled on the system; disable enable_stb or contact system vendor\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	stb_phys_addr = ((u64)phys_addr_hi << 32 | phys_addr_low);
 
-	/* Clear msg_port for other SMU operation */
-	dev->msg_port = 0;
-
 	dev->stb_virt_addr = devm_ioremap(dev->dev, stb_phys_addr, dev->dram_size);
 	if (!dev->stb_virt_addr)
-		return -ENOMEM;
+		ret = -ENOMEM;
 
-	return 0;
+out:
+	/* Clear msg_port for other SMU operation */
+	dev->msg_port = 0;
+
+	return ret;
 }
 
 static int amd_pmc_write_stb(struct amd_pmc_dev *dev, u32 data)
-- 
2.53.0



