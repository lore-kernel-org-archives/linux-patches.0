Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B0B3B811F;
	Mon, 17 Aug 2026 14:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975752; cv=none; b=QJPaUewyJQPS/nERtS2yMwhX5HdQbpKa+MVyYnJ3EC9rUCFEtRaLDiStvd1/MbAZrGfpQ0v0xRt6tYMTkRED6KxerkDmUikn6KV5NAoKK+sgl9FJgwe4JRjCqezJkyEfy6Vi1Wi/hrUPij0KWoB5K0EpGmb4tJmqWpx6n0N28w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975752; c=relaxed/simple;
	bh=kCpg6wo9z01OWNGkqx14ezJUa4X2VCd20np98FY4ee8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBlzJw2vkwAB94fxQIeisAukTKyQ3/MuSzFf4etHyAixDb+9rzryLi1bshFO2r2xDRn/0bviV9uKwFzfnOj8p+BGrNXpsOe+iEKNzXV/dSO/zuksE+gx7nSp9fux8p4xGd/S5wplKbt6sSxHSS6MnSazZhYS1iEpPJSy2RJUxc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1pWn9FN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1pWn9FN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF8B1F000E9;
	Mon, 17 Aug 2026 14:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975751;
	bh=NpHRUX7amhvHeZNuL/n+KIFuZsDP6gQ4UEoaNVNMoVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1pWn9FNczSLNA+R2sx3VyA5VhY80A99AyDrfdHhgdZGFeoX/So8n7ytZrtKKcHLV
	 yZBnnu9B3P3ZGmOypT+U9PoMSp1fK/5q0IwoYBQEfaAm613Mq/jORU5sG29zyiLD1I
	 CfZdnmG8ASpkyStQ5AvQG33dh2EzBlw7j+THrKIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 136/389] media: sun4i-csi: Return queued buffers on start_streaming() failure
Date: Mon, 17 Aug 2026 15:29:35 +0200
Message-ID: <20260817132544.458955424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
 


