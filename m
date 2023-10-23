Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450A015EA5
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VA9arPdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A10C433C8;
	Mon, 23 Oct 2023 11:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061394;
	bh=ZxYwFJpUI5OmNZV1HOeoXi85qJf3oD8Jg+oQpGOUTsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VA9arPdMODSyEgdMpJTj2OO4CG6D/cgJzMcCD1JIRtkJymJiifq8ZUhnpkL2ZkJGR
	 k1Rbna+bVCTL8bprZ2hMoTDcyfZ5K+oYFMTBz0GMD3iQPQ5zPnLXDFAbL+IoheF8GU
	 Jkq5jn0tXptM4+genAVUz6cFRVf2LC/qPx7eTFmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.10 032/202] media: mtk-jpeg: Fix use after free bug due to uncanceled work
Date: Mon, 23 Oct 2023 12:55:39 +0200
Message-ID: <20231023104827.537514156@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Wang <zyytlz.wz@163.com>

commit c677d7ae83141d390d1253abebafa49c962afb52 upstream.

In mtk_jpeg_probe, &jpeg->job_timeout_work is bound with
mtk_jpeg_job_timeout_work. Then mtk_jpeg_dec_device_run
and mtk_jpeg_enc_device_run may be called to start the
work.
If we remove the module which will call mtk_jpeg_remove
to make cleanup, there may be a unfinished work. The
possible sequence is as follows, which will cause a
typical UAF bug.

Fix it by canceling the work before cleanup in the mtk_jpeg_remove

CPU0                  CPU1

                    |mtk_jpeg_job_timeout_work
mtk_jpeg_remove     |
  v4l2_m2m_release  |
    kfree(m2m_dev); |
                    |
                    | v4l2_m2m_get_curr_priv
                    |   m2m_dev->curr_ctx //use
Fixes: b2f0d2724ba4 ("[media] vcodec: mediatek: Add Mediatek JPEG Decoder Driver")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
@@ -1455,6 +1455,7 @@ static int mtk_jpeg_remove(struct platfo
 {
 	struct mtk_jpeg_dev *jpeg = platform_get_drvdata(pdev);
 
+	cancel_delayed_work_sync(&jpeg->job_timeout_work);
 	pm_runtime_disable(&pdev->dev);
 	video_unregister_device(jpeg->vdev);
 	video_device_release(jpeg->vdev);


