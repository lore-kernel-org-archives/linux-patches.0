Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04F3224F6;
	Tue,  8 Apr 2025 11:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111176; cv=none; b=MnHDhfqNyQLE18eXrr+3JS50NfGMDeEQIXLdk0+NbAK4OBXmFB3g1zJk4fTwBjUKsKo4ZTRI1PK1aqHLu/YnD7v3xWBVSXwsRe9KBLZVymVbbfraF99m0gdz9TMx0otXGv9q1cJmvOIrTcEHvj6lUotVXDig+qlEuIHWTy1kF+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111176; c=relaxed/simple;
	bh=5J8jigF0KBnfJDFwJP8DSWyEfN29SC/Qu4tJtnHHwco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVHs3/P4ADNwJKMPKpNbfwyOfdfaITvyqA/nSXSsMi6PiTveV6Xi4WgZGjF3eFZOhkbciFzgjdRo8KJTswrSfBN6oyqCtbb40NXQ2atITElhmVRdMKjTEJwx3rqwEJQTbFBaX+tBe+oYNkGSUpG4i0dNPghlWrONb5n9spwMOoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzhvdtve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzhvdtve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B85C4CEE5;
	Tue,  8 Apr 2025 11:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111175;
	bh=5J8jigF0KBnfJDFwJP8DSWyEfN29SC/Qu4tJtnHHwco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzhvdtve7w/i6aUv+jfucsITOxr/NxkDbBsvyH3JhQHsblMhPgWMeEzYWaKaChgCP
	 9CiHPrzKgyKwSStW5eXKect9YtARF0SzpzIejUrx4sn4uie9pYbpQLDWG9wFpj9asX
	 1pK/r1TjSzHptlvM/KNQMLlQvj0sF1BvOEbpv/0o=
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
Subject: [PATCH 6.14 334/731] drm/mediatek: dsi: fix error codes in mtk_dsi_host_transfer()
Date: Tue,  8 Apr 2025 12:43:51 +0200
Message-ID: <20250408104922.045060588@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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
index 40752f2320548..852aeef9f38dc 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -1116,12 +1116,12 @@ static ssize_t mtk_dsi_host_transfer(struct mipi_dsi_host *host,
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
@@ -1170,7 +1170,7 @@ static ssize_t mtk_dsi_host_transfer(struct mipi_dsi_host *host,
 	if (recv_cnt)
 		memcpy(msg->rx_buf, src_addr, recv_cnt);
 
-	DRM_INFO("dsi get %d byte data from the panel address(0x%x)\n",
+	DRM_INFO("dsi get %zd byte data from the panel address(0x%x)\n",
 		 recv_cnt, *((u8 *)(msg->tx_buf)));
 
 restore_dsi_mode:
-- 
2.39.5



