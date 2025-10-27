Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646142C3745;
	Mon, 27 Oct 2025 19:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593046; cv=none; b=uUNd6KaHOoE67J8grWx/8k8WBc10msqke8OOpqPhw6OQwDvueVpzgzkrHgOPdjpiJftIb77C54Dg1uGS+SVbBYdqXqWTe7lQDlj7HzGUZXyHamfWaI3d4fvAiKzlwj1dkcQlFe3y5vncZ3ZCdnSpXSNfp+s7l0pI3y+haNDST28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593046; c=relaxed/simple;
	bh=xxug9ayMhVrSxtbF64iNXZvFyMho6P2bw/5D/RutrCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqPa5kZMdV9NSnndHzjQRMp72ratmEzwBIKY2fWoSwduGXSImF3ndCP1QGmjvY6phMuVJabVOCq+y3gnMn5VCkT09UX3Dnn0GOEyS7u8xsR4SXFJctju+QD4BiHQ7fHYCXFCWVRUdrubSpY19TBNc26ovzIDnHWh8EQCR1fkXVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pk84sbrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pk84sbrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB48EC4CEF1;
	Mon, 27 Oct 2025 19:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593046;
	bh=xxug9ayMhVrSxtbF64iNXZvFyMho6P2bw/5D/RutrCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pk84sbrftLb/CorPNfHSThb882GtNPAfgUGvweGaw8I3AW2dLqRUmYBPYH5UHvtzs
	 mmumHn7gsATK55zq/FVN+SiczunxRI4GEa43aDrSXIupMeZ6Cb/br3/p2esMo0B7Jx
	 MRmBcn34x4QTJR4dM1tYiafU7FmcsD2ohVTQMPhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/117] spi: airoha: return an error for continuous mode dirmap creation cases
Date: Mon, 27 Oct 2025 19:36:40 +0100
Message-ID: <20251027183456.030048403@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit 4314ffce4eb81a6c18700af1b6e29b6e0c6b9e37 ]

This driver can accelerate single page operations only, thus
continuous reading mode should not be used.

Continuous reading will use sizes up to the size of one erase block.
This size is much larger than the size of single flash page. Use this
difference to identify continuous reading and return an error.

Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Fixes: a403997c12019 ("spi: airoha: add SPI-NAND Flash controller driver")
Link: https://patch.msgid.link/20251012121707.2296160-2-mikhail.kshevetskiy@iopsys.eu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-airoha-snfi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/spi/spi-airoha-snfi.c b/drivers/spi/spi-airoha-snfi.c
index 1369691a997bf..6930dea48f330 100644
--- a/drivers/spi/spi-airoha-snfi.c
+++ b/drivers/spi/spi-airoha-snfi.c
@@ -625,6 +625,10 @@ static int airoha_snand_dirmap_create(struct spi_mem_dirmap_desc *desc)
 	if (desc->info.offset + desc->info.length > U32_MAX)
 		return -EINVAL;
 
+	/* continuous reading is not supported */
+	if (desc->info.length > SPI_NAND_CACHE_SIZE)
+		return -E2BIG;
+
 	if (!airoha_snand_supports_op(desc->mem, &desc->info.op_tmpl))
 		return -EOPNOTSUPP;
 
-- 
2.51.0



