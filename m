Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3B1330B37;
	Fri, 17 Oct 2025 15:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715579; cv=none; b=JmA7BcYdHEBCFwHEGSZLMv9mmehbX/3rRp4GTy6NpXez0hSsdHasxtfOzS4tgFPxFzSCmQqy53Uq/nou55PNGO711dsZYZQmA1DJSZLa1xWAn6JZYTYCAiw6c4vt+Rpoiun6oltTfVdx8Jjn1gX+GIPAjZqiRBss+47AeRUiFHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715579; c=relaxed/simple;
	bh=A657CWYDtRFjcy83JSclA4/6YUaJdnxjgElR3epVspA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIPzSG5jnrObbCN6cfiDjKV7EH6/D4QW9Gg2DXKkRPD/w3uVo92SDAjrXvUPRhTvGL6dx/3zP2i6UDeAfD2yinMXc8kiAJfFuY6YrTc3LtASnoFBzchzPXYxcucZyGvpoela2Oi3VTQvPaoYICNpCtcyL1u3S5VTC18CKxHouN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2g69Kv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2g69Kv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F076C4CEE7;
	Fri, 17 Oct 2025 15:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715579;
	bh=A657CWYDtRFjcy83JSclA4/6YUaJdnxjgElR3epVspA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2g69Kv9/ilHgx416mKgVLnO4YSw2BTzGm7ifV3KxmlOhtTRFYUXSJIoVaVNYlfOl
	 4gNUTiSjlYZcdJCPqWq8NOBJQ9wAKt7ml5Me3XRswb2d1gmaJEm7LJJOjpIPz80Wzk
	 o983UCDO/6qDfZzqmGO2BQz5rPpqC4f+POIdDVvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.17 264/371] mtd: rawnand: fsmc: Default to autodetect buswidth
Date: Fri, 17 Oct 2025 16:53:59 +0200
Message-ID: <20251017145211.631333918@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

commit b8df622cf7f6808c85764e681847150ed6d85f3d upstream.

If you don't specify buswidth 2 (16 bits) in the device
tree, FSMC doesn't even probe anymore:

fsmc-nand 10100000.flash: FSMC device partno 090,
  manufacturer 80, revision 00, config 00
nand: device found, Manufacturer ID: 0x20, Chip ID: 0xb1
nand: ST Micro 10100000.flash
nand: bus width 8 instead of 16 bits
nand: No NAND device found
fsmc-nand 10100000.flash: probe with driver fsmc-nand failed
  with error -22

With this patch to use autodetection unless buswidth is
specified, the device is properly detected again:

fsmc-nand 10100000.flash: FSMC device partno 090,
  manufacturer 80, revision 00, config 00
nand: device found, Manufacturer ID: 0x20, Chip ID: 0xb1
nand: ST Micro NAND 128MiB 1,8V 16-bit
nand: 128 MiB, SLC, erase size: 128 KiB, page size: 2048, OOB size: 64
fsmc-nand 10100000.flash: Using 1-bit HW ECC scheme
Scanning device for bad blocks

I don't know where or how this happened, I think some change
in the nand core.

Cc: stable@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/fsmc_nand.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/fsmc_nand.c
+++ b/drivers/mtd/nand/raw/fsmc_nand.c
@@ -876,10 +876,14 @@ static int fsmc_nand_probe_config_dt(str
 	if (!of_property_read_u32(np, "bank-width", &val)) {
 		if (val == 2) {
 			nand->options |= NAND_BUSWIDTH_16;
-		} else if (val != 1) {
+		} else if (val == 1) {
+			nand->options |= NAND_BUSWIDTH_AUTO;
+		} else {
 			dev_err(&pdev->dev, "invalid bank-width %u\n", val);
 			return -EINVAL;
 		}
+	} else {
+		nand->options |= NAND_BUSWIDTH_AUTO;
 	}
 
 	if (of_property_read_bool(np, "nand-skip-bbtscan"))


