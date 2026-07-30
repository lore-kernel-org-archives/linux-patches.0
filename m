Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F14384CDD;
	Thu, 30 Jul 2026 16:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427686; cv=none; b=PQ9X8q9WX7hC5FY6V6ECKrRqN1cKAKRJnQ73PitM2+bFGviGzQZhS/79JDBb8w/c7fXUE/fll08B4Qe3/JdM8P9futSmvlyJeoml6GQQH6FQ4/eV/kkU000vogrTwTsfyfZba+xLC1TUuitcEF/Fr0HZKzEN7jUMeKghlGoHUOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427686; c=relaxed/simple;
	bh=87PKYX2gPUpcKqSyyMXhg5h9sumVRLvFEohjmHQuK8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaicQwDcP38rL3+58yenGBLaFOeA+OPSSor9jXgmHiFRyiYzhlkEPgfpRQM3Ktf+QMDiQOBtiBGsgj0ZkNDkhFh6JgYauNHWAwSSYIVui9AWh34i9DEKKm6yGuEVAFYKJdZbgW035/n76pUdPqg/gA73VmMcZd7nSFvYJlMexhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/7yv3FU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/7yv3FU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3851F00A3D;
	Thu, 30 Jul 2026 16:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427684;
	bh=QfEcy1Y9RKPFz2ipjGZC7iJgKmX/uvtpD7jdFFDSWfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/7yv3FUrfwv+ZZe6ynLXfYyfrywscWNg/puUTzKeIuw3t9yKB/0cV9JlZu9CfzDj
	 0az/TgV2bwULrwInmXP4cfPXYJ5rgBXT4k2fsXeBs8I+v/GcqO8tMiRAHn43w1Ltuq
	 rxpWkvfY3ai/YCaKDD2tw3dEg+PbA7TK6ngxLmDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 256/484] media: saa7134: Fix a possible memory leak in saa7134_video_init1
Date: Thu, 30 Jul 2026 16:12:33 +0200
Message-ID: <20260730141429.050336472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit f86ed548386e3050e5f8f25b450d09dc009d9a88 upstream.

In saa7134_video_init1(), the return value of the first
saa7134_pgtable_alloc() is not checked. If it fails, the function
continues as if successful, leaving the driver with an invalid page
table. Additionally, if vb2_queue_init() for the VBI queue fails after
the video queue page table has been allocated, the allocated memory is
not freed before returning. The second saa7134_pgtable_alloc() also
lacks a return value check. Errors occur during device probing before
the device is fully registered, the normal cleanup path in
saa7134_finidev() is not executed, leading to memory leaks and
potential use of uninitialized DMA resources.

Check the return value of both saa7134_pgtable_alloc() calls and
propagate errors. On failure of any later step, free allocated page
tables to avoid memory leaks. Ensure control handlers are also
released on error to prevent further resource leakage.

Found by code review.

Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Cc: stable@vger.kernel.org
Fixes: a00e68888d5d ("[media] saa7134: move saa7134_pgtable to saa7134_dmaqueue")
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/saa7134/saa7134-video.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1716,8 +1716,10 @@ int saa7134_video_init1(struct saa7134_d
 	q->dev = &dev->pci->dev;
 	ret = vb2_queue_init(q);
 	if (ret)
-		return ret;
-	saa7134_pgtable_alloc(dev->pci, &dev->video_q.pt);
+		goto err_free_ctrl;
+	ret = saa7134_pgtable_alloc(dev->pci, &dev->video_q.pt);
+	if (ret)
+		goto err_free_ctrl;
 
 	q = &dev->vbi_vbq;
 	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
@@ -1734,11 +1736,24 @@ int saa7134_video_init1(struct saa7134_d
 	q->lock = &dev->lock;
 	q->dev = &dev->pci->dev;
 	ret = vb2_queue_init(q);
-	if (ret)
-		return ret;
-	saa7134_pgtable_alloc(dev->pci, &dev->vbi_q.pt);
+	if (ret) {
+		saa7134_pgtable_free(dev->pci, &dev->video_q.pt);
+		goto err_free_ctrl;
+	}
+
+	ret = saa7134_pgtable_alloc(dev->pci, &dev->vbi_q.pt);
+	if (ret) {
+		saa7134_pgtable_free(dev->pci, &dev->video_q.pt);
+		goto err_free_ctrl;
+	}
 
 	return 0;
+
+err_free_ctrl:
+	v4l2_ctrl_handler_free(&dev->ctrl_handler);
+	if (card_has_radio(dev))
+		v4l2_ctrl_handler_free(&dev->radio_ctrl_handler);
+	return ret;
 }
 
 void saa7134_video_fini(struct saa7134_dev *dev)


