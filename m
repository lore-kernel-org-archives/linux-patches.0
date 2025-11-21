Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4150D29B78F;
	Fri, 21 Nov 2025 13:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732456; cv=none; b=adA+Xf9GTx70WU1+crg28ad4K1KQzptXaXXwPO3nCVz0DuNcFIsYQ25XY0V6vYfBTv64M5Y6qkQmSU9q7EjQ12e33t6FaP+ot4x0oePhwSkWG4rfQBLy4WZ/DhtJymBAgSx0IVM8WDm9q5IqxoBN8vBmVkn7U7Gl3haGPkwclmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732456; c=relaxed/simple;
	bh=IboGGDiHDKgOyHSRs1gA0qM6QREsNSlOjawlESnB+qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkAl046gQZmkS57wgpm5GAKBPlDhEx4jRFbSQX5PCkCvzds97flZ9+8j3R128kOHLeMWl8jnVvaPqhpgwXeM4+JHpc3vUZ5rNFy8ZU7VwDeJDXN2HbqivsJVrOWTJfr1FjJLlMRg9Mg172Ajqi/Wl8My0kwRdT7JZPwNE1D0Xfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2e6USDe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2e6USDe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CC4C4CEF1;
	Fri, 21 Nov 2025 13:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732456;
	bh=IboGGDiHDKgOyHSRs1gA0qM6QREsNSlOjawlESnB+qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2e6USDe9e2LclLoMetqseGblKyg96fVhtCwem0q+d3SHOiWeyQ/GoMdD2LfA2g7QU
	 VaPsUtoKglJRDN+LXSV7PWRIoazjHT+Rm4sT3hls6XnDjZOrPBrQuRwdfx23aXDtV/
	 qOMlhdOzaDrhm1m6+J++WNy6sskaV8P6e3oh4PXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Oniszczuk <piotr.oniszczuk@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/529] wifi: rtw88: sdio: use indirect IO for device registers before power-on
Date: Fri, 21 Nov 2025 14:07:05 +0100
Message-ID: <20251121130235.504902295@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 58de1f91e033b1fface8d8948984583125f93736 ]

The register REG_SYS_CFG1 is used to determine chip basic information
as arguments of following flows, such as download firmware and load PHY
parameters, so driver read the value early (before power-on).

However, the direct IO is disallowed before power-on, or it causes wrong
values, which driver recognizes a chip as a wrong type RF_1T1R, but
actually RF_2T2R, causing driver warns:

  rtw88_8822cs mmc1:0001:1: unsupported rf path (1)

Fix it by using indirect IO before power-on.

Reported-by: Piotr Oniszczuk <piotr.oniszczuk@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/699C22B4-A3E3-4206-97D0-22AB3348EBF6@gmail.com/T/#t
Suggested-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Tested-by: Piotr Oniszczuk <piotr.oniszczuk@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250724004815.7043-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 832a427279b40..df4248744d87a 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -143,6 +143,10 @@ static u32 rtw_sdio_to_io_address(struct rtw_dev *rtwdev, u32 addr,
 
 static bool rtw_sdio_use_direct_io(struct rtw_dev *rtwdev, u32 addr)
 {
+	if (!test_bit(RTW_FLAG_POWERON, rtwdev->flags) &&
+	    !rtw_sdio_is_bus_addr(addr))
+		return false;
+
 	return !rtw_sdio_is_sdio30_supported(rtwdev) ||
 		rtw_sdio_is_bus_addr(addr);
 }
-- 
2.51.0



