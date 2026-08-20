Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6101642AF95;
	Thu, 20 Aug 2026 16:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243978; cv=none; b=batmvF9bEua56v9v93i5QiIk2QzzqeIXA4Mxr5uMFZaaeYJBmSpJVtoyKVRTTHcAKNoMO5Grden5EZcCb6DtuxsVZB41GaR/KtsIG3Kuo3T19HC1VdssevJo2Esc3qGF2Zs/hbvf/iPTkKa/57hPJ6Cz7CzdDHtn/XHKXuLIJ8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243978; c=relaxed/simple;
	bh=qe/Rxhw2s9eIqhPlH2ZCLl52C/YSPjIjCe3nZcm8jjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPGvNZfor9iFbJR7+gdFzo/xctwBetgKq0LZmcJmak0COyZrHLJACJOwpYeqfP7xk2dUbLdN2nb8YW/WIZg8D3U5KNRrpXV92AQop55FA8a2XnqddbfTXI5tuWqpLgRRRQz7xbRupIaue7JciNGmW4CD1Bq8VQWsOXJxLw5vb84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8fZVqHI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8fZVqHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD8F1F000E9;
	Thu, 20 Aug 2026 16:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243977;
	bh=EVZL0JmTP0LgPNGk+IFLhp1U8pLBYtofC2wbKwoTxQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8fZVqHIpzWlo57kXPogTPK6uspjs/XKr7TjX/jEcZCWToN/307rVTNuj4T6YNhkJ
	 GJhn2yOc1CiDNxi8Z/uPAx07KT8vQqzRsLIZfQdWTkjFxrE8PNNO5hSlMbfdsGvjwh
	 qbDKiYFbXXlWTJRlUuVlcDqzMIakGhMtmrvtRako=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrey Troshin <drtrosh@yandex-team.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/235] media: mediatek: vcodec: Fix a resource leak related to the scp device in FW initialization
Date: Thu, 20 Aug 2026 16:53:58 +0200
Message-ID: <20260820145216.506244835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 4936cd5817af35d23e4d283f48fa59a18ef481e4 ]

On Mediatek devices with a system companion processor (SCP) the mtk_scp
structure has to be removed explicitly to avoid a resource leak.
Free the structure in case the allocation of the firmware structure fails
during the firmware initialization.

Fixes: 53dbe0850444 ("media: mtk-vcodec: potential null pointer deference in SCP")
Cc: stable@vger.kernel.org
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[Andrey Troshin: backport fixs from
 drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c
 to drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c]
Signed-off-by: Andrey Troshin <drtrosh@yandex-team.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c
index 27f08b1d34d1..199a64c853bc 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_scp.c
@@ -65,8 +65,11 @@ struct mtk_vcodec_fw *mtk_vcodec_fw_scp_init(struct mtk_vcodec_dev *dev)
 	}
 
 	fw = devm_kzalloc(&dev->plat_dev->dev, sizeof(*fw), GFP_KERNEL);
-	if (!fw)
+	if (!fw) {
+		scp_put(scp);
 		return ERR_PTR(-ENOMEM);
+	}
+
 	fw->type = SCP;
 	fw->ops = &mtk_vcodec_rproc_msg;
 	fw->scp = scp;
-- 
2.53.0



