Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0848632B116;
	Thu, 30 Jul 2026 15:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424539; cv=none; b=WzQPOhdts/ei4jjTGMCGm9nmCjXhi9pZG25IlXdzFFuPMchcOQBzP0OVpzb78vwgW/fH9ZuO4AXvfKxrWhtNg1TFWXuA9hofyexrat5GoD1Rh4dJtMH1PeK7k+G0c8MZrpuawq7n4APXPiUQ+vJv5/X93+YfHX/TCeRBG30FlgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424539; c=relaxed/simple;
	bh=AyOq/ncZeG2usRSmSryQOGDUHX2iwjilTR4rqkWtefI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uY6L54PpaRVQltysiaM7xJX75MYaERN4scsHWZ44speplMspSnhowuVnTnxykfqIjzhj83t/MVKU2WTJ9SVUpY1GbsOKpVYIUGvqCxWSnZWynPUpS+aN4XhbKdNzuXilxJPN/6n/xgN/t6ZJGwMRuGSBk5pu7u4wCzyBfhTsS4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czKkJ4Ve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czKkJ4Ve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BF11F000E9;
	Thu, 30 Jul 2026 15:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424537;
	bh=dWYnNdjTP5pK577oRTZyxJFn9ZniZl3d82N483Z8zk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=czKkJ4VeGmRABDpIvZyQcSRobRr0b/A2kDNd3BkvNg3gPbZ4XxDONUhRPcISE7Kgs
	 RnD5JPcdEDD/VgaVelsrJvDXga+l9h//P7Vl3Nx+oEOZZVToSbV3+/38vE7JKXf0Uz
	 LuM845OJJTCNgWCGOhE/XXqQOwadxH/9RdlCdaRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 429/675] media: stm32-dcmipp: Return queued buffers on start_streaming() failure
Date: Thu, 30 Jul 2026 16:12:39 +0200
Message-ID: <20260730141454.254175838@linuxfoundation.org>
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

From: Valery Borovsky <vebohr@gmail.com>

commit ffc8eec06378a340d708c889184ab3e14b57d540 upstream.

The vb2 framework hands buffers to the driver via buf_queue() before
calling start_streaming().  If start_streaming() returns an error
without first returning those buffers via vb2_buffer_done(),
vb2_start_streaming() fires WARN_ON(owned_by_drv_count) and the queued
buffers leak.

dcmipp_bytecap_start_streaming() returned -EINVAL when the source
subdevice could not be resolved from the media graph, before
pm_runtime_resume_and_get() and media_pipeline_start() had been called.
The remaining error paths already converge on the err_buffer_done
label, which calls dcmipp_bytecap_all_buffers_done(...,
VB2_BUF_STATE_QUEUED).  Jump to that label directly: the intermediate
err_pm_put / err_media_pipeline_stop labels are skipped, which is
correct because nothing they would undo has happened yet.

This mirrors the uvcvideo fix in commit 4cf3b6fd54eb ("media: uvcvideo:
Return queued buffers on start_streaming() failure").

Fixes: 28e0f3772296 ("media: stm32-dcmipp: STM32 DCMIPP camera interface driver")
Cc: stable@vger.kernel.org
Signed-off-by: Valery Borovsky <vebohr@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c
+++ b/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c
@@ -398,8 +398,10 @@ static int dcmipp_bytecap_start_streamin
 	 */
 	if (!vcap->s_subdev) {
 		pad = media_pad_remote_pad_first(&vcap->vdev.entity.pads[0]);
-		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
-			return -EINVAL;
+		if (!pad || !is_media_entity_v4l2_subdev(pad->entity)) {
+			ret = -EINVAL;
+			goto err_buffer_done;
+		}
 		vcap->s_subdev = media_entity_to_v4l2_subdev(pad->entity);
 		vcap->s_subdev_pad_nb = pad->index;
 	}


