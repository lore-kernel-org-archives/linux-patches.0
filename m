Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AC7443AAB;
	Thu, 30 Jul 2026 16:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427691; cv=none; b=XLlHuzXXC+fhcFc98nO8Z3+mN+LrWryBmczushsvrrNoD12HlYkR0jgmOC/W26vwI/NqS2UFbmbk8Vz/7KoNuG8YieDBYPauq4pjgEi5xYHHsy7043Kn8IC1SOhX/0bScpOqzixkIIWukbk0lmIxQC2LFQAJ97b6MBBioCbjLZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427691; c=relaxed/simple;
	bh=8BLJx7KbXFCAndBhG2VrfiMUxNRL/Eq1vszZkbe3gZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIm2iHBvUrVOWP5pV8skBsMXt5FbmCq2p83RnBzeBWf/J/HCFh4261+dHyqDdXYEh4nLkffOjkPZqXLyOwceISbGaLJpeCoDgjyHpHFGAjMycitcB+VLXq5H4FlCXBhc398BM49+J5I59wFqg1FrYyPwxoq4FWXLJheE9kNXtTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrafFlpF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrafFlpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7FA1F000E9;
	Thu, 30 Jul 2026 16:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427690;
	bh=Sh8ES0gR0YaVVckIYlhDv0WtlXIS1Xa1vtoyp6q+DDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QrafFlpFlqpm6NrKFQdVBIZnmLalPoynJC2lmbdpjqtkW0ISxRD/dOK1balFLnhWm
	 eFPEo8pbF6Pksa2K4C1KtHHANWSBTKXbecwBnBXeISG44liWQoIhLDOmpDHNcbRs1W
	 QYDAY1LgXOWMx/GInRNMcorADohgt29yd8XBgL+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 258/484] media: sun4i-csi: Return queued buffers on start_streaming() failure
Date: Thu, 30 Jul 2026 16:12:35 +0200
Message-ID: <20260730141429.092905855@linuxfoundation.org>
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

From: Valery Borovsky <vebohr@gmail.com>

commit bbba3e260a62810a717b4442a3bb96d0ec0f6309 upstream.

The vb2 framework hands buffers to the driver via buf_queue() before
calling start_streaming().  If start_streaming() returns an error
without first returning those buffers via vb2_buffer_done(),
vb2_start_streaming() fires WARN_ON(owned_by_drv_count) and the queued
buffers leak.

sun4i_csi_start_streaming() returned -EINVAL when no matching CSI
format could be found, before any setup (scratch buffer allocation,
pipeline start) had been performed.  The remaining error paths already
converge on the err_clear_dma_queue label, which calls
return_all_buffers(..., VB2_BUF_STATE_QUEUED) under csi->qlock.  Jump
to that label directly: the intermediate err_disable_device /
err_disable_pipeline / err_free_scratch_buffer labels are skipped,
which is correct because nothing they would undo has happened yet.

This mirrors the uvcvideo fix in commit 4cf3b6fd54eb ("media: uvcvideo:
Return queued buffers on start_streaming() failure").

Fixes: 577bbf23b758 ("media: sunxi: Add A10 CSI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Valery Borovsky <vebohr@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c
+++ b/drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c
@@ -234,8 +234,10 @@ static int sun4i_csi_start_streaming(str
 	int ret;
 
 	csi_fmt = sun4i_csi_find_format(&csi->fmt.pixelformat, NULL);
-	if (!csi_fmt)
-		return -EINVAL;
+	if (!csi_fmt) {
+		ret = -EINVAL;
+		goto err_clear_dma_queue;
+	}
 
 	dev_dbg(csi->dev, "Starting capture\n");
 


