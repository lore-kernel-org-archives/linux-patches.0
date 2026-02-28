Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3E7340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301049; cv=none; b=gw4lQud44wgEUdbEWVYsgxLMMtx9F1Rf0h7IwELlmzWEvAohkqIMTFh7FtrN/MTSTznN1FA0rUMfN1AgrviJG3VvIShG4Mih8b69CviIgdF7fuSkVkbFXFBuHay9UdPB4qPtm7V3X+1N6hBdRImnFS50vWR/vQxbFOmKrthHYmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301049; c=relaxed/simple;
	bh=X/24zNX9m2CflY3r9cZXGdaOzHCJRi1OEaMdW8UAAlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPZT1jc4CS1BVzhWZQZzZaWL9UzJ+zcRR0AIzSr37SKNbSTmX3BoUlrabFWM4IXbkvjZnMJwjvqY38PSFCvdv+O9exCfRf4XPsFWhSBDqk/I9ookGHGYXENZvM0Lbt+G8CnLEtxEB8XmmmRNqYPn2H7d7ieKL4UVNFU2v6aTnN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hO7LkxCw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hO7LkxCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E855EC19423;
	Sat, 28 Feb 2026 17:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301049;
	bh=X/24zNX9m2CflY3r9cZXGdaOzHCJRi1OEaMdW8UAAlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hO7LkxCwxeZCUp2YPZcnyMO4NTBYHws2AEwJuU+O6z2YO6f3/1Dn2SVuMhfSflV5s
	 YNWcsKWQe9bN7o+MWZGqO6IUfHYBiZmV9rRTAyAxSx+mPiq7UC+DokfPrCijR1yTw3
	 Y+WkD+LDqKhTVjgcERecSsbRVloEUa/X7U2wgKvhPGJS8X5QDLaHx++tZBtBYg3ev2
	 zmXaiAKt3nUrfzHkzNnWyrAoI9PB/8Lwi6mbldFYla0rMPxHW8c5eE7IttRzQX+Cp0
	 2Y4kzBthWPIbUlW6SpF3RDmYlW9FBAJd30hRjYmBbdEmMRUIIYXsUl0nIt2RjpRMsi
	 3SthSTkjyOwjQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chin-Ting Kuo <chin-ting_kuo@aspeedtech.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 189/752] spi: spi-mem: Protect dirmap_create() with spi_mem_access_start/end
Date: Sat, 28 Feb 2026 12:38:20 -0500
Message-ID: <20260228174750.1542406-189-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chin-Ting Kuo <chin-ting_kuo@aspeedtech.com>

[ Upstream commit 53f826ff5e0e3ecb279862ca7cce1491b94bb017 ]

spi_mem_dirmap_create() may reconfigure controller-wide settings,
which can interfere with concurrent transfers to other devices
sharing the same SPI controller but using different chip selects.

Wrap the ->dirmap_create() callback with spi_mem_access_start() and
spi_mem_access_end() to serialize access and prevent cross-CS
interference during dirmap creation.

This patch has been verified on a setup where a SPI TPM is connected
to CS0 of a SPI controller, while a SPI NOR flash is connected to CS1
of the same controller. Without this patch, spi_mem_dirmap_create()
for the SPI NOR flash interferes with ongoing SPI TPM data transfers,
resulting in failure to create the TPM device. This was tested on an
ASPEED AST2700 EVB.

Signed-off-by: Chin-Ting Kuo <chin-ting_kuo@aspeedtech.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Link: https://patch.msgid.link/20260120123005.1392071-2-chin-ting_kuo@aspeedtech.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mem.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mem.c b/drivers/spi/spi-mem.c
index 71e3eaf59df97..db9467535416d 100644
--- a/drivers/spi/spi-mem.c
+++ b/drivers/spi/spi-mem.c
@@ -714,9 +714,18 @@ spi_mem_dirmap_create(struct spi_mem *mem,
 
 	desc->mem = mem;
 	desc->info = *info;
-	if (ctlr->mem_ops && ctlr->mem_ops->dirmap_create)
+	if (ctlr->mem_ops && ctlr->mem_ops->dirmap_create) {
+		ret = spi_mem_access_start(mem);
+		if (ret) {
+			kfree(desc);
+			return ERR_PTR(ret);
+		}
+
 		ret = ctlr->mem_ops->dirmap_create(desc);
 
+		spi_mem_access_end(mem);
+	}
+
 	if (ret) {
 		desc->nodirmap = true;
 		if (!spi_mem_supports_op(desc->mem, &desc->info.op_tmpl))
-- 
2.51.0

