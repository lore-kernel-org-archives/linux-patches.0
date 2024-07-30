Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB14B1A76AC;
	Tue, 30 Jul 2024 17:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359930; cv=none; b=qyjp5K+v8PP2PkmnpiMBbP47fHCAcJAICkRg/9TIv8yBB0HVcrmmKyKwojyEDZxTiOwZ6Zm2ogUXa6NiMp5fBW4nt0gWVYHys2hNNGpQZm9SeQniP7cPx0+ewQCaW1cmvipY74UoXJiFnyN8gLtYxP+aO/ULxU7JsWzjMcY6/zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359930; c=relaxed/simple;
	bh=UAdiLRXMEGbqOhgW8ZOPU/KcpAq0FYbvI8eEWF+g+PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxfNFHZQhV9O++HMHxRviQgubdmFMe/qpIrojVxHIYf/K8/9XCfhmuZM579iE7uPL/AYQpvxh+0AHTNAT8xbUO49kFsUnRFjskzCKHiUJqjQR0coRvdkSV1VB70KR7hceWFs5GhYuB3K3Y0t50Ub2N4X2TBk+QEupToyEfYkPdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWoP5lAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWoP5lAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD714C4AF0E;
	Tue, 30 Jul 2024 17:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359930;
	bh=UAdiLRXMEGbqOhgW8ZOPU/KcpAq0FYbvI8eEWF+g+PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWoP5lAukac54tpU21i9wFk+tYLIFMNNw2OxLgUnJCD8YiY7mOmTHAWqw3jJqk5KA
	 n9zDi0xZ4qhVKtuPQngFSp2VgidgvxFfEM0gZdDVUAK5CutPFvxIhdlGs/GvG+Yvy3
	 xjq1WYiIKiPXmDg2A6CuMAY3JdsGO+te1RrR6Bow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 557/568] ASoC: sof: amd: fix for firmware reload failure in Vangogh platform
Date: Tue, 30 Jul 2024 17:51:04 +0200
Message-ID: <20240730151701.928830339@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit f2038c12e8133bf4c6bd4d1127a23310d55d9e21 ]

Setting ACP ACLK as clock source when ACP enters D0 state causing
firmware load failure, as per design clock source should be internal
clock.

Remove acp_clkmux_sel field so that ACP will use internal clock
source when ACP enters into D0 state.

Fixes: d0dab6b76a9f ("ASoC: SOF: amd: Add sof support for vangogh platform")

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Link: https://patch.msgid.link/20240718062004.581685-1-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/pci-vangogh.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/sof/amd/pci-vangogh.c b/sound/soc/sof/amd/pci-vangogh.c
index d8be42fbcb6dd..b035e31fadaba 100644
--- a/sound/soc/sof/amd/pci-vangogh.c
+++ b/sound/soc/sof/amd/pci-vangogh.c
@@ -34,7 +34,6 @@ static const struct sof_amd_acp_desc vangogh_chip_info = {
 	.dsp_intr_base	= ACP5X_DSP_SW_INTR_BASE,
 	.sram_pte_offset = ACP5X_SRAM_PTE_OFFSET,
 	.hw_semaphore_offset = ACP5X_AXI2DAGB_SEM_0,
-	.acp_clkmux_sel = ACP5X_CLKMUX_SEL,
 	.probe_reg_offset = ACP5X_FUTURE_REG_ACLK_0,
 };
 
-- 
2.43.0



