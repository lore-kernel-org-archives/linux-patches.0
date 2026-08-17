Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741F241F34C;
	Mon, 17 Aug 2026 14:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976978; cv=none; b=kYtK1eMKFbR+yyu2XfMfOLmlTPNcFh2jMY4dgin2Ys5r5p7RdhgzWOS/UF0RpqXrDCyO8egf5kbticMy37pc5PSrBAm/9ASp9ro1sMF6lc4wdKMJoPSIYIfit7k6fxZSg3/0I7zuS6lSa0OFgr1SFKm1sRFLF0fAiYC55xw3v1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976978; c=relaxed/simple;
	bh=UVyPe00UgbqjPzMwa3Yp/NEEF4MmJ2EsJ03xUZSGCXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nyq+bdRHcmDTR6KS+jiIhIXXzKWqAvMLuChNL6KEDjVO/rcvfusBHkQ+zpA/j0HKKMhlPGo1eM0gbAcxB1b6yIfvcvHz4DQp1q/4TULiA9Hvdbwme95XgxlblZ7uUWI7zR+zZd5ATYEMFPVuw1jeeF+/mwLSDqVPXFT0I3fSBFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCP633Wq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCP633Wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6541F00A3D;
	Mon, 17 Aug 2026 14:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976977;
	bh=9P+8ZyszIBecUeMZsCvfziMWv9CjkW0hRwWOZXNXX/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gCP633Wqtk+OYuaOswf+1DjHSF4bk7sUBURc7jLLq8IUgMcFDSqhrlCQ4S9AZT6lj
	 B4LQynueFzr+3pKJ5fXDADzzrD0DIdh62WmCiz7Z4GaWr9rpl0MiE4rk7q5u/j5zZl
	 89HIxZ9crEhcIhmJsuY4Z+EOlLB8V+uiPJRm/IuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 170/456] media: saa7134: Fix a possible memory leak in saa7134_video_init1
Date: Mon, 17 Aug 2026 15:29:20 +0200
Message-ID: <20260817132546.755869578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2126,8 +2126,10 @@ int saa7134_video_init1(struct saa7134_d
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
@@ -2144,11 +2146,24 @@ int saa7134_video_init1(struct saa7134_d
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


