Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B640183CA6;
	Wed, 17 Sep 2025 13:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114071; cv=none; b=FUclDwMqSSto9prgJ93aiQMgJEl5WbY/wvA/AbwVKP3w6MKf0wKbsueVYNn2lGttCGvD4eFhgu+fQWbXaFiAVUiTh8CilWx7S2cFVOTvSu9d7WnViXaizh5d8Z0iMeqqIi7gLSpwHfXOtIpFeGiZ3SApvzizhUTGHe3VU9fLxYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114071; c=relaxed/simple;
	bh=8eT2409VU5TQC5kKUTKAm/ADWK4L2SPbJP2nLuoAuo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccfnOsBkRDFa2fDZMDnnEtFB4HpgJfvMZoeV3KTGShv+A3sBUsNoafHL+UxzVz4SlkAgPE7KW2ppUYouxhhANRGBlt4v3Ig47kI2T6+JUPT22jcKaVrl0rfXnVEr9DpVSZPQ/gj0RLgqAYkI3/PnjcuiEhdzOdeI52Yr86RnJD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHH5++hb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHH5++hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA7CC4CEF0;
	Wed, 17 Sep 2025 13:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114071;
	bh=8eT2409VU5TQC5kKUTKAm/ADWK4L2SPbJP2nLuoAuo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHH5++hb97uQy5pfnW5sLU+wkt1+UrZrlej2rrvUaEMicWeNKDyOGCGP49kUxu9tF
	 lRpZ7OXhPc6r5NT0NwVF/H3Fi6I1pKy0EQnasZtuCib8BM1Cdr6hwbFRDaoIGXQBkH
	 E+wQwzRP1t7pZhn+PXauZJaidl5W2YhVbO39tA1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Alexander Dahl <ada@thorsis.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 38/78] mtd: nand: raw: atmel: Respect tAR, tCLR in read setup timing
Date: Wed, 17 Sep 2025 14:34:59 +0200
Message-ID: <20250917123330.489820577@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

[ Upstream commit fd779eac2d659668be4d3dbdac0710afd5d6db12 ]

Having setup time 0 violates tAR, tCLR of some chips, for instance
TOSHIBA TC58NVG2S3ETAI0 cannot be detected successfully (first ID byte
being read duplicated, i.e. 98 98 dc 90 15 76 14 03 instead of
98 dc 90 15 76 ...).

Atmel Application Notes postulated 1 cycle NRD_SETUP without explanation
[1], but it looks more appropriate to just calculate setup time properly.

[1] Link: https://ww1.microchip.com/downloads/aemDocuments/documents/MPU32/ApplicationNotes/ApplicationNotes/doc6255.pdf

Cc: stable@vger.kernel.org
Fixes: f9ce2eddf176 ("mtd: nand: atmel: Add ->setup_data_interface() hooks")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Tested-by: Alexander Dahl <ada@thorsis.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/atmel/nand-controller.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -1378,13 +1378,23 @@ static int atmel_smc_nand_prepare_smccon
 		return ret;
 
 	/*
+	 * Read setup timing depends on the operation done on the NAND:
+	 *
+	 * NRD_SETUP = max(tAR, tCLR)
+	 */
+	timeps = max(conf->timings.sdr.tAR_min, conf->timings.sdr.tCLR_min);
+	ncycles = DIV_ROUND_UP(timeps, mckperiodps);
+	totalcycles += ncycles;
+	ret = atmel_smc_cs_conf_set_setup(smcconf, ATMEL_SMC_NRD_SHIFT, ncycles);
+	if (ret)
+		return ret;
+
+	/*
 	 * The read cycle timing is directly matching tRC, but is also
 	 * dependent on the setup and hold timings we calculated earlier,
 	 * which gives:
 	 *
-	 * NRD_CYCLE = max(tRC, NRD_PULSE + NRD_HOLD)
-	 *
-	 * NRD_SETUP is always 0.
+	 * NRD_CYCLE = max(tRC, NRD_SETUP + NRD_PULSE + NRD_HOLD)
 	 */
 	ncycles = DIV_ROUND_UP(conf->timings.sdr.tRC_min, mckperiodps);
 	ncycles = max(totalcycles, ncycles);


