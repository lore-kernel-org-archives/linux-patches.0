Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FFF30675C;
	Wed, 20 May 2026 17:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299866; cv=none; b=I/CzTC9mTj8plX7Xpap2HVDUlhe/mlYLl3zAs4Vlbc53yo+juwe5Qs2Ks9sKqkCs4E4RO7bVFcJgE1MeB442SKo0za3D+wM8ubx5+yqpF3eWxqbvFFVDV1FSeg3/HUclB4jpUT/+gK/n9Nl7YTeDNIxoxaY8zXFDjxc710n+nBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299866; c=relaxed/simple;
	bh=O39okzC32fyFq+6miS6LmQgYHDBiqK6lpIjUVEhkgUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lvBwYfRSPHS3EetY4hCvL6cyyhA++e55yHlrZn17XM6OmWx4LZ6AQCPsHgzFW4mpsHrt3PTnzMpgk6R9yZTrUDDRsnNlNx5KJQavRtIlKgQx+3sJ99nsgxu0ci6VbFZD2+U+Q9OIT+wCxV+iLUVNsNmnVC6++JZUGMZeXGVy78M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOSmPUhC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOSmPUhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9281F000E9;
	Wed, 20 May 2026 17:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299865;
	bh=QhFQXw7fRWTlDb0Q2CX23SAF0xxSnDBf5qigTmK0ohk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jOSmPUhCFsWC+GHA/X8fMcx2+fiLVvHdq7k6pyfCAWg9fIWl7SoJ5bipMVwwgNsAB
	 bOTwymtuSHZ6P0lh9dU8o9bQhDeA6u9gDd+cv2/qHaRfCAPNuHM4iZVlp4IWy/iDbQ
	 yg8pg42MXjGN5sJ7MwLm7/xX6dK0zJCg9br9Hci4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 915/957] ALSA: usb-audio: qcom: Check offload mapping failures
Date: Wed, 20 May 2026 18:23:18 +0200
Message-ID: <20260520162154.421150237@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit 814b2c9b30e56074e11fc0a6e5419b3fee0639bc upstream.

uaudio_transfer_buffer_setup() calls dma_get_sgtable() and then passes
the sg_table to uaudio_iommu_map_xfer_buf() without checking whether sg
table construction succeeded. If dma_get_sgtable() fails, the sg_table
contents are not valid.

uaudio_iommu_map_pa() also ignores iommu_map() failures for the event and
transfer rings and still returns the allocated IOVA to the QMI response.
That can expose an unmapped IOVA to the audio DSP. For transfer rings,
the failed mapping also leaves the IOVA allocator state marked in use.

Check both operations. Free the coherent transfer buffer when sg table
construction fails, free the sg table when transfer-buffer IOMMU mapping
fails, and release the transfer-ring IOVA if iommu_map() fails. Also
return the existing event-ring IOVA when the event ring is already mapped,
matching the pre-split helper behavior.

Fixes: 326bbc348298 ("ALSA: usb-audio: qcom: Introduce QC USB SND offloading support")
Fixes: 44499ecb4f28 ("ALSA: usb: qcom: Fix false-positive address space check")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260511-alsa-usb-qcom-offload-map-errors-v1-1-6502695e58bc@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/qcom/qc_audio_offload.c |   31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

--- a/sound/usb/qcom/qc_audio_offload.c
+++ b/sound/usb/qcom/qc_audio_offload.c
@@ -565,6 +565,7 @@ static unsigned long uaudio_iommu_map_pa
 	unsigned long iova = 0;
 	bool map = true;
 	int prot = uaudio_iommu_map_prot(dma_coherent);
+	int ret;
 
 	switch (mtype) {
 	case MEM_EVENT_RING:
@@ -582,10 +583,24 @@ static unsigned long uaudio_iommu_map_pa
 		dev_err(uaudio_qdev->data->dev, "unknown mem type %d\n", mtype);
 	}
 
-	if (!iova || !map)
+	if (!iova)
 		return 0;
 
-	iommu_map(uaudio_qdev->data->domain, iova, pa, size, prot, GFP_KERNEL);
+	if (!map)
+		return iova;
+
+	ret = iommu_map(uaudio_qdev->data->domain, iova, pa, size, prot,
+			GFP_KERNEL);
+	if (ret) {
+		dev_err(uaudio_qdev->data->dev,
+			"failed to map %zu bytes at iova 0x%08lx: %d\n",
+			size, iova, ret);
+		if (mtype == MEM_XFER_RING)
+			uaudio_put_iova(iova, size,
+					&uaudio_qdev->xfer_ring_list,
+					&uaudio_qdev->xfer_ring_iova_size);
+		return 0;
+	}
 
 	return iova;
 }
@@ -1054,15 +1069,17 @@ static int uaudio_transfer_buffer_setup(
 	if (!xfer_buf)
 		return -ENOMEM;
 
-	dma_get_sgtable(subs->dev->bus->sysdev, &xfer_buf_sgt, xfer_buf,
-			xfer_buf_dma, len);
+	ret = dma_get_sgtable(subs->dev->bus->sysdev, &xfer_buf_sgt, xfer_buf,
+			      xfer_buf_dma, len);
+	if (ret)
+		goto free_xfer_buf;
 
 	/* map the physical buffer into sysdev as well */
 	xfer_buf_dma_sysdev = uaudio_iommu_map_xfer_buf(dma_coherent,
 							len, &xfer_buf_sgt);
 	if (!xfer_buf_dma_sysdev) {
 		ret = -ENOMEM;
-		goto unmap_sync;
+		goto free_sgt;
 	}
 
 	mem_info->dma = xfer_buf_dma;
@@ -1073,7 +1090,9 @@ static int uaudio_transfer_buffer_setup(
 
 	return 0;
 
-unmap_sync:
+free_sgt:
+	sg_free_table(&xfer_buf_sgt);
+free_xfer_buf:
 	usb_free_coherent(subs->dev, len, xfer_buf, xfer_buf_dma);
 
 	return ret;


