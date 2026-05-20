Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E53318EC7;
	Wed, 20 May 2026 16:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295906; cv=none; b=re0JmqlmU6fgE4uE+aFXwHLQv79HkH9TenwCwrEHd1nH+mx4FDTBLbe6KSW0rLcsScz4+uS4hiFSH0PAiG1yzeECVk5W76gFezzVqjQtV94eps0LhSrDvQFcYQU/mngxV6Fx/vp8vpFIPV9HgOFnDaoFU11EepthCaD+XststZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295906; c=relaxed/simple;
	bh=KGoXQ5AeUOV5exb0cr+tMuLTb1cTWbjzPOMQoy4KJqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/LogoKKiefJw97MWIw87/mBoBdffQu/upgQ09APzuLkx8Nd7LKzcd3rcDBTBMQepy3F6bodfGTppuu40u0NQYhAWxJ88wplT/NO5uIiceIXkiyPNFqfQisz5iyW2r6yecTPKsG5qgpkb8HBVjTz0ivx0nh9lmSuZ7n++LKXNIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F4C+N1K3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4C+N1K3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93ACE1F000E9;
	Wed, 20 May 2026 16:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295905;
	bh=mIrtKPOB8lHnmfZEeAHSo3FdzR/8lx3dmV5cUZPtgk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F4C+N1K3dA7rHQWBXZ2BC6D4L1dQj2qEHSYtEPK6HyYzBUR7Dr2L2tlsp+mHmXRHp
	 YlHlkU92PkJP2Ofm/3Lj4IPG1vNyazjWPzrAEguA9SPljEfFGPJyfoTOB8l47/oEGx
	 WyDd8xAFHwk1KTmcM4PLDWZF3raT4fE4R0nQq+fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <pratyush@kernel.org>,
	Haibo Chen <haibo.chen@nxp.com>,
	Michael Walle <mwalle@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0596/1146] mtd: spi-nor: micron-st: add SNOR_CMD_PP_8_8_8_DTR sfdp fixup for mt35xu512aba
Date: Wed, 20 May 2026 18:14:06 +0200
Message-ID: <20260520162201.666084030@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 6d660fba6a32a34ad7d746d7f65317831daaf033 ]

Find two batches mt35xu512aba has different SFDP but with same
jedec ID. The batch which use the new version of SFDP contain
all the necessary information to support OCT DTR mode. The batch
with old version do not contain the OCT DTR command information,
but in fact it did support OCT DTR mode.

Current mt35xu512aba_post_sfdp_fixup() add some setting including
SNOR_CMD_READ_8_8_8_DTR, but still lack SNOR_CMD_PP_8_8_8_DTR. Meet
issue on the batch mt35xu512aba with old SFDP version. Because no
SNOR_CMD_PP_8_8_8_DTR, micron_st_nor_octal_dtr_en() will not be
called, then use SNOR_CMD_READ_8_8_8_DTR will meet issue.

Fixes: 44dd635cd632 ("mtd: spi-nor: micron-st: use SFDP of mt35xu512aba")
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
[pratyush@kernel.org: touch up the comment a bit]
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/micron-st.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mtd/spi-nor/micron-st.c b/drivers/mtd/spi-nor/micron-st.c
index 88033384a71e5..b2b473501d023 100644
--- a/drivers/mtd/spi-nor/micron-st.c
+++ b/drivers/mtd/spi-nor/micron-st.c
@@ -167,6 +167,16 @@ static int mt35xu512aba_post_sfdp_fixup(struct spi_nor *nor)
 				  0, 20, SPINOR_OP_MT_DTR_RD,
 				  SNOR_PROTO_8_8_8_DTR);
 
+	/*
+	 * Some batches of mt35xu512aba do not contain the OCT DTR command
+	 * information, but do support OCT DTR mode. Add the settings for
+	 * SNOR_CMD_PP_8_8_8_DTR here. This also makes sure the flash can switch
+	 * to OCT DTR mode.
+	 */
+	nor->params->hwcaps.mask |= SNOR_HWCAPS_PP_8_8_8_DTR;
+	spi_nor_set_pp_settings(&nor->params->page_programs[SNOR_CMD_PP_8_8_8_DTR],
+				SPINOR_OP_PP_4B, SNOR_PROTO_8_8_8_DTR);
+
 	nor->cmd_ext_type = SPI_NOR_EXT_REPEAT;
 	nor->params->rdsr_dummy = 8;
 	nor->params->rdsr_addr_nbytes = 0;
-- 
2.53.0



