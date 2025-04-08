Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B694022257E;
	Tue,  8 Apr 2025 11:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113161; cv=none; b=Fh4I9xOdgSWADbKTjU4JhMyqR5oXGxDssfXEm7hIaqbxkKoeG0UFit2peLzCtDcqeMIJ0n2IKgRHX87wrYPvPCcIhMeMBJYdgZ1f/a8l6sxMugsCtq/dhTNQGfXA62im6c/HVmA8OFgiYdgPYk72Qf2FmYzCAdyGqNw+Or2v+CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113161; c=relaxed/simple;
	bh=p93Dh0KDFgk/n68NobLai/Rdjf7WwKsMPEphEdWa8R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knWqs3V1MUwOLYqMSRaR542zsLV3sYgrfobCVCaioXu+C97W4fEjB4M5sEQhRG9T3VcOwcg57izN+etjuxE+cDPh1vceHKx3KqMftFHrUUiEz/R80F/wxvl0R5t3uN1tnKnQ9ibNsm5CDSpBw7rMVFYvnphTq3HyWhR16FnWMbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ghAqamk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ghAqamk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445F9C4CEE5;
	Tue,  8 Apr 2025 11:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113161;
	bh=p93Dh0KDFgk/n68NobLai/Rdjf7WwKsMPEphEdWa8R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ghAqamktAj5k2RCUOy0ktAx8sCYNRBIMPWPdyS1LYlmy2slDtS+Akhh48NIf0lpw
	 OEc0veIvfGXJG0MHFxPYw9Q4Urn4b58kwSz9bnpzykpqYShYJM1W0A7Q2aLOVnxIY0
	 dGzAMCGhqTnnJc2Hpfg82Z8Eer8dLuFNDa/Dek8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mattijs Korpershoek <mkorpershoek@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/268] drm/mediatek: dsi: fix error codes in mtk_dsi_host_transfer()
Date: Tue,  8 Apr 2025 12:47:46 +0200
Message-ID: <20250408104829.983314490@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit dcb166ee43c3d594e7b73a24f6e8cf5663eeff2c ]

There is a type bug because the return statement:

        return ret < 0 ? ret : recv_cnt;

The issue is that ret is an int, recv_cnt is a u32 and the function
returns ssize_t, which is a signed long.  The way that the type promotion
works is that the negative error codes are first cast to u32 and then
to signed long.  The error codes end up being positive instead of
negative and the callers treat them as success.

Fixes: 81cc7e51c4f1 ("drm/mediatek: Allow commands to be sent during video mode")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202412210801.iADw0oIH-lkp@intel.com/
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/b754a408-4f39-4e37-b52d-7706c132e27f@stanley.mountain/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index 0d96264ec5c6d..f154b3a7c2c2d 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -1016,12 +1016,12 @@ static ssize_t mtk_dsi_host_transfer(struct mipi_dsi_host *host,
 				     const struct mipi_dsi_msg *msg)
 {
 	struct mtk_dsi *dsi = host_to_dsi(host);
-	u32 recv_cnt, i;
+	ssize_t recv_cnt;
 	u8 read_data[16];
 	void *src_addr;
 	u8 irq_flag = CMD_DONE_INT_FLAG;
 	u32 dsi_mode;
-	int ret;
+	int ret, i;
 
 	dsi_mode = readl(dsi->regs + DSI_MODE_CTRL);
 	if (dsi_mode & MODE) {
@@ -1070,7 +1070,7 @@ static ssize_t mtk_dsi_host_transfer(struct mipi_dsi_host *host,
 	if (recv_cnt)
 		memcpy(msg->rx_buf, src_addr, recv_cnt);
 
-	DRM_INFO("dsi get %d byte data from the panel address(0x%x)\n",
+	DRM_INFO("dsi get %zd byte data from the panel address(0x%x)\n",
 		 recv_cnt, *((u8 *)(msg->tx_buf)));
 
 restore_dsi_mode:
-- 
2.39.5



