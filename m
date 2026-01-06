Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91101DF965;
	Tue,  6 Jan 2026 17:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722194; cv=none; b=UvkwUAUdUUaRBpv8rSQyG8JkvnkhTjOEQI6+BIG0lsKV6Vj+0DkNvmrXdQ8Pu+4SJP6KpbdyikXLDdfqqIRyqP1KF3k+jdgCHyb4IaBElOk6QadAdxARYUWlmPqGOsjgUWLjdXe/45gnEHzj4CeC7wjFcpFG3TrivaLnKWebrJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722194; c=relaxed/simple;
	bh=WnCM7KXuk/QYHYIUuRwSlpc8r37qGUHObVm4rwMr9AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZ61ATpJMa/fNrNmZ7YXeByclTtnjQPmyHWho0F0du5ZUtg402R0syvnen5C/avZvVrmbGBdYjeJFarsn4uusAclxIiTsZYzonZux4WgVyLhyfjhwK7uSotbsKxsTuSmcpZDlZDbQO1hUVi/Y/PTQEcYt3/Aq8e4LTUjDhJsjUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxVUXpGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxVUXpGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37219C116C6;
	Tue,  6 Jan 2026 17:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722194;
	bh=WnCM7KXuk/QYHYIUuRwSlpc8r37qGUHObVm4rwMr9AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxVUXpGbz6hjHxuQ/FQEKuUm1+YF7306lBw/ExcIea4vq9Up/Tt0n7czRctt06snH
	 MYgo40xt9H6clq+dnmZt2c5Vo/UqqTDYJxRzKnHyzHDu/hfxeFunr/2ExpHhgs8NpU
	 tULJT/YKGserZezovb/CXEcI8oXJwPcifIs3DU7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 191/312] media: mediatek: vcodec: Fix a reference leak in mtk_vcodec_fw_vpu_init()
Date: Tue,  6 Jan 2026 18:04:25 +0100
Message-ID: <20260106170554.738360579@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -119,8 +119,10 @@ struct mtk_vcodec_fw *mtk_vcodec_fw_vpu_
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


