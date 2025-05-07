Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617EC1FF5EC;
	Wed,  7 May 2025 18:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643965; cv=none; b=mailcpxcyNGSAQSPhFSVejK1KeP7R57OHybalFg6SW+T3ZNkkbZ7yZgaQGs4emOn73/c4GIlC9Jxgsi3Pej3D/B1vCHZD4NEV7aG7R2KyPu/oJOGCimXjwhL2dz3Va0Y5YazzIngDzhWMq6ta47UZNl4i81zJhxJngHE98n6vGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643965; c=relaxed/simple;
	bh=ImsVPsMY2BUe4Wy3plp/RrI6Fk7oeSZ1kOD8xrUsoFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2mBJwpfWiZH0CRsPv2M0hpl05gZg53Wq/5m7CRTjehyGvGI8oKBIGy0Z6ERMGmm/60iDkGDBSZui3uz+agKh08fxYqVVa+J5WLYFEhb6Bp8t4a0HiI4wUR3Zp0Jz/bEHudMc/kSgo4/Ki8vUsLbsn7QoZMfLKdfdy/3/SEXqPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAyzYBF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAyzYBF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4470C4CEE2;
	Wed,  7 May 2025 18:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643965;
	bh=ImsVPsMY2BUe4Wy3plp/RrI6Fk7oeSZ1kOD8xrUsoFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bAyzYBF4WlfsUWrAIho/Av1neZy+No3tHRLYNneh4/0d2qVEG9q9+yiVpNjaUl4l9
	 u+WfKhORTPtZLIo8goipVRj4+V5rL1QDR7XhcbP/MlnSv6usreO2jhLUpbnOjR2/tC
	 N3KCXTQd2rUElzOOy/fRh/enTUk17Mp92oNdsgw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishnamoorthi M <krishnamoorthi.m@amd.com>,
	Akshata MukundShetty <akshata.mukundshetty@amd.com>,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 075/183] spi: spi-mem: Add fix to avoid divide error
Date: Wed,  7 May 2025 20:38:40 +0200
Message-ID: <20250507183827.728743318@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit 8e4d3d8a5e51e07bd0d6cdd81b5e4af79f796927 ]

For some SPI flash memory operations, dummy bytes are not mandatory. For
example, in Winbond SPINAND flash memory devices, the `write_cache` and
`update_cache` operation variants have zero dummy bytes. Calculating the
duration for SPI memory operations with zero dummy bytes causes
a divide error when `ncycles` is calculated in the
spi_mem_calc_op_duration().

Add changes to skip the 'ncylcles' calculation for zero dummy bytes.

Following divide error is fixed by this change:

 Oops: divide error: 0000 [#1] PREEMPT SMP NOPTI
...

  ? do_trap+0xdb/0x100
  ? do_error_trap+0x75/0xb0
  ? spi_mem_calc_op_duration+0x56/0xb0
  ? exc_divide_error+0x3b/0x70
  ? spi_mem_calc_op_duration+0x56/0xb0
  ? asm_exc_divide_error+0x1b/0x20
  ? spi_mem_calc_op_duration+0x56/0xb0
  ? spinand_select_op_variant+0xee/0x190 [spinand]
  spinand_match_and_init+0x13e/0x1a0 [spinand]
  spinand_manufacturer_match+0x6e/0xa0 [spinand]
  spinand_probe+0x357/0x7f0 [spinand]
  ? kernfs_activate+0x87/0xd0
  spi_mem_probe+0x7a/0xb0
  spi_probe+0x7d/0x130

Fixes: 226d6cb3cb79 ("spi: spi-mem: Estimate the time taken by operations")
Suggested-by: Krishnamoorthi M <krishnamoorthi.m@amd.com>
Co-developed-by: Akshata MukundShetty <akshata.mukundshetty@amd.com>
Signed-off-by: Akshata MukundShetty <akshata.mukundshetty@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Link: https://patch.msgid.link/20250424121333.417372-1-Raju.Rangoju@amd.com
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mem.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mem.c b/drivers/spi/spi-mem.c
index a9f0f47f4759b..74b013c41601d 100644
--- a/drivers/spi/spi-mem.c
+++ b/drivers/spi/spi-mem.c
@@ -585,7 +585,11 @@ u64 spi_mem_calc_op_duration(struct spi_mem_op *op)
 	ns_per_cycles = 1000000000 / op->max_freq;
 	ncycles += ((op->cmd.nbytes * 8) / op->cmd.buswidth) / (op->cmd.dtr ? 2 : 1);
 	ncycles += ((op->addr.nbytes * 8) / op->addr.buswidth) / (op->addr.dtr ? 2 : 1);
-	ncycles += ((op->dummy.nbytes * 8) / op->dummy.buswidth) / (op->dummy.dtr ? 2 : 1);
+
+	/* Dummy bytes are optional for some SPI flash memory operations */
+	if (op->dummy.nbytes)
+		ncycles += ((op->dummy.nbytes * 8) / op->dummy.buswidth) / (op->dummy.dtr ? 2 : 1);
+
 	ncycles += ((op->data.nbytes * 8) / op->data.buswidth) / (op->data.dtr ? 2 : 1);
 
 	return ncycles * ns_per_cycles;
-- 
2.39.5



