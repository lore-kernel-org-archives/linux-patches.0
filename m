Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5696C30C618;
	Thu, 30 Jul 2026 15:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424593; cv=none; b=pFqK7R8rsa/ivJDmNawImHXY8vPQ+ATOB87pEiwISLUwvdHOBIrmlnmDCBvmxU7UpO1J5MQu1F2S0VQ+rUzELdsdb0KiAAf/WmWLZxUeVuWnEDG8xd1jRlL9aetpx5vZBgtbtLGhRUvSPZbRWadGVv1/zWWYVnkc+f/b2TgS/ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424593; c=relaxed/simple;
	bh=ZTIIO6277006gcp6jOiaa3x+fhMV7cm6AaELScC8B7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9hJ8eF/7uw5v0wgLGpqENapFQHdw1SDianoCfiwDgKP1ZsbjQ6Cwi8axFL7aZJChOxLoR0BS5fzKsqCbL716Q2BjPuNYT2eKsBsYp7FIQ8hwgLhGOw3/0eMxg13cmVLlJKje1srw2nWsqK+A3mWTno7oM9iHs2NKnYNBk52E58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0NnVVgk2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0NnVVgk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC031F000E9;
	Thu, 30 Jul 2026 15:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424592;
	bh=8JbZQsUe1ydQbhC2pdL/uG5CuXUFeaEpSgQ/dcYC5e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0NnVVgk25jzXRBmeJUVO1OQ83vkxo3188+RnnypheHr1mJfLecnpsaRI1jIwSAMmq
	 V6TJVvtLza4pIImSOaLpKxoZ5X4HT9X7PLo1/15uyg8gpwZghZm8FzKhD4ExX7+wzi
	 xoJSujofzvM/RiyyID9zdtGoaNny8isoVVkrEb20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 411/675] media: nuvoton: npcm-video: fix error handling in npcm_video_init()
Date: Thu, 30 Jul 2026 16:12:21 +0200
Message-ID: <20260730141453.868268437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

commit 60ca00792bce46ec170c7ed101f376186d4cf8a9 upstream.

npcm_video_init() has two error handling issues after
of_reserved_mem_device_init() is called:

When dma_set_mask_and_coherent() fails, the function releases the
reserved memory but does not return, allowing execution to fall through
into npcm_video_ece_init() with a failed DMA configuration.

When npcm_video_ece_init() fails, the function returns an error without
calling of_reserved_mem_device_release(), leaking the reserved memory
association.

Fix both by adding the missing return after the DMA mask failure and
adding the missing of_reserved_mem_device_release() call on the ECE init
error path.

Fixes: 46c15a4ff1f4 ("media: nuvoton: Add driver for NPCM video capture and encoding engine")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nuvoton/npcm-video.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/platform/nuvoton/npcm-video.c
+++ b/drivers/media/platform/nuvoton/npcm-video.c
@@ -1720,10 +1720,12 @@ static int npcm_video_init(struct npcm_v
 	if (rc) {
 		dev_err(dev, "Failed to set DMA mask\n");
 		of_reserved_mem_device_release(dev);
+		return rc;
 	}
 
 	rc = npcm_video_ece_init(video);
 	if (rc) {
+		of_reserved_mem_device_release(dev);
 		dev_err(dev, "Failed to initialize ECE\n");
 		return rc;
 	}


