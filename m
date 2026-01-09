Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93F232AAB5;
	Fri,  9 Jan 2026 12:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960991; cv=none; b=X8NyuV8VlI1+IGytCMAsYvi+k6iziI/NZvcwyRv9ecIuSImYTX0PuSGcEPd3nVBfneSKzBWDQW90fRp4lMXn+QUMkmA2UmQNv8qdQ4UyLoBo1Y5ZxxNCCt65hDIwSn1cpfdY9wqbANwVg9SubbQMN6RoIfXpqu7iFJyfCK4ZQF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960991; c=relaxed/simple;
	bh=GmZDOhSgMUThpuLItwcQHDyXPLHC0rRIV2DJVVntydM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBH9rHJvs9xMpBLzUbt44fcqNJjHH9hP68cXDIeYMhkKOeXFD9Mz49a7jc4B+SMauczNPBITxh+7C4hnMCScPauKjIgNaUxUedKdQBf1EuX38s13AiZ695hWiAGyaRjWqj0911UEMBVqJKsVkAgCb0j5u33RFlaVYun6+uPSx+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GanpXK4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GanpXK4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76698C4CEF1;
	Fri,  9 Jan 2026 12:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960990;
	bh=GmZDOhSgMUThpuLItwcQHDyXPLHC0rRIV2DJVVntydM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GanpXK4L2p2rNakAc02LLYsgBTVYCXSOqlXmZnkCLtePwfyrxn1y9G1+e8415lCQ7
	 BUt6p+Qos2rkdGNA1umv+kWw0CaIobuXdP57gOOBYjiPEBXpG+nZnBOyPSlStbISKC
	 pjWwAK9KVdjaLaaIdP8wzv1NMBLLiTgGh+vMvudw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 595/737] media: mediatek: vcodec: Fix a reference leak in mtk_vcodec_fw_vpu_init()
Date: Fri,  9 Jan 2026 12:42:14 +0100
Message-ID: <20260109112156.384135601@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit cdd0f118ef87db8a664fb5ea366fd1766d2df1cd upstream.

vpu_get_plat_device() increases the reference count of the returned
platform device. However, when devm_kzalloc() fails, the reference
is not released, causing a reference leak.

Fix this by calling put_device() on fw_pdev->dev before returning
on the error path.

Fixes: e25a89f743b1 ("media: mtk-vcodec: potential dereference of null pointer")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_vpu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_vpu.c
+++ b/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_vpu.c
@@ -117,8 +117,10 @@ struct mtk_vcodec_fw *mtk_vcodec_fw_vpu_
 		vpu_wdt_reg_handler(fw_pdev, mtk_vcodec_vpu_reset_enc_handler, priv, rst_id);
 
 	fw = devm_kzalloc(&plat_dev->dev, sizeof(*fw), GFP_KERNEL);
-	if (!fw)
+	if (!fw) {
+		put_device(&fw_pdev->dev);
 		return ERR_PTR(-ENOMEM);
+	}
 	fw->type = VPU;
 	fw->ops = &mtk_vcodec_vpu_msg;
 	fw->pdev = fw_pdev;


