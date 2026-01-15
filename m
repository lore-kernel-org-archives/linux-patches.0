Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6742868B0;
	Thu, 15 Jan 2026 17:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499895; cv=none; b=l1VjiwGlT99c7tWWIiT1CmKpyEZPGKneQgLJtnoTMoSxnd4nPjCje8sLNEdM3+tOVh/aRtIpy4zBtjE9GBUTpiOyFC9d+4vDqw79w5vAVsWatuj+zFZmnsVB+gN1G7S9cE7gj2p0AClM6XZ8KTrDz6c3CC12QyBZRWwPQ5howe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499895; c=relaxed/simple;
	bh=z6bxf/1kPSxAhIJYvl7XmGrkzsg2HX63y2UQFJ/Z01o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hoGPX/uDGFgltAfu0ZiQezwReqZ0TvOOiVhN5ZqnQBQWRkM2lJvrlXXCh3HAivefqFLU22kH7Ic2TRIR+QH6aCgEWHHckpjH6wGlWg6eV6QaeBPbY2ZQntBAzHtcOrxJ0gmwNDc3wrtrYHEpSDje2Tfwq3qHxkhze2S9YT0qElM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPbTZdAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPbTZdAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3CFC116D0;
	Thu, 15 Jan 2026 17:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499895;
	bh=z6bxf/1kPSxAhIJYvl7XmGrkzsg2HX63y2UQFJ/Z01o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPbTZdATw3zc5TGxd+FKB3dQsMg8F4eENKl6TI5u4VZcNlomUm0lvvzDco3JYKdz4
	 CfE1iZhYysbbC1tgF39ZBP0f3gMpiAs2qVWWaQxOhUA7j6GSaTr0lEQWwdLFXHObqU
	 xc+nb2rxNGi/F2pfEe8RyJCjB9rpiZu8BVWADe5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 387/451] media: mediatek: vcodec: Fix a reference leak in mtk_vcodec_fw_vpu_init()
Date: Thu, 15 Jan 2026 17:49:48 +0100
Message-ID: <20260115164244.928356828@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit cdd0f118ef87db8a664fb5ea366fd1766d2df1cd ]

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
[ adapted file path from common/ subdirectory and adjusted devm_kzalloc target from plat_dev->dev to dev->plat_dev->dev ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_vpu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_vpu.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_fw_vpu.c
@@ -94,8 +94,10 @@ struct mtk_vcodec_fw *mtk_vcodec_fw_vpu_
 	vpu_wdt_reg_handler(fw_pdev, mtk_vcodec_vpu_reset_handler, dev, rst_id);
 
 	fw = devm_kzalloc(&dev->plat_dev->dev, sizeof(*fw), GFP_KERNEL);
-	if (!fw)
+	if (!fw) {
+		put_device(&fw_pdev->dev);
 		return ERR_PTR(-ENOMEM);
+	}
 	fw->type = VPU;
 	fw->ops = &mtk_vcodec_vpu_msg;
 	fw->pdev = fw_pdev;


