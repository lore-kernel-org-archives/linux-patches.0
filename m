Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6443208;
	Fri, 17 Oct 2025 15:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713254; cv=none; b=eD8JZPEaQwUtCv0IyOX1L/05afPIRapxgSyZ/s783Mn6cux/ZoO9qrGgJVyVMPH/QwWkcj6/rpz6fp54WrECn60f8b4KtdIGjTiSJd2BZ1E2bRvnEFnUpJuRrM2GAoEURx4D/DUXjuqI5GTBD0YaF+DrQOv+Hj0KKq5l4zMg9GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713254; c=relaxed/simple;
	bh=bXFEJrj7rmBkJtipbwAPysAKbqQl6dr5/CE9QKvy8jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBzPAjAoVxtdyVNbAFH90PywptoFONo1RV+3qErDoZaZg8OmfWEhKjiBFP4FerdXxRtqlILqGUkCf9tArtzykR1B4H+MbOBTvRKFYA70vc2d6GxhkilEMXxK7RpEYB5YC6Lu7lwgYmiPuZUsTn5b9VYK3sbc35Vna9OmQL8JdB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9lLSabu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9lLSabu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A170C4CEE7;
	Fri, 17 Oct 2025 15:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713254;
	bh=bXFEJrj7rmBkJtipbwAPysAKbqQl6dr5/CE9QKvy8jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9lLSabubPU7HAUZBxosva7HV0Y0N8Y0d5Ig1boVr6GB/S9mJeyCZkPGrX3d3LB3g
	 thH8nUdJeixtqDHja9iwNWW0VE7gTB635AgJXhlBRX14zQ9uugeU7gfy6QwkIvr/E2
	 Ltpfmj4ZXye7MJ9n1LXo8JXQdViR0sEy2t8o6Mt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 102/168] mtd: rawnand: fsmc: Default to autodetect buswidth
Date: Fri, 17 Oct 2025 16:53:01 +0200
Message-ID: <20251017145132.784784949@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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
 
 	if (of_get_property(np, "nand-skip-bbtscan", NULL))


