Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31925384CED;
	Sat, 17 Oct 2026 16:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254287; cv=none; b=Gx5PJHPa05WEmBs0p56ZcF0xPdtYUz3VI/lpUBWb57evvKTjOiFItDGWeGaY9WFyADpSE2ucaQFvrMJUqdaktN2YRwle9o8DiiaFlyfuYy8MkrW/6uyHZzaq1Y/y6a0CaU7eUr2Tzpk6Ed6xf+xyqGrKrKn+bZelM5Akk1XFz5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254287; c=relaxed/simple;
	bh=BE9Z1g2QSCRQTZDi6oAvfKOSgTIDv6PfRkqfaL2bY3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2yovblQQ3hlitLk0K2wZRkn1siE8MEHNYkxC1f+Z0v+9bAReSzVbhCPd+gVix31LSMCECfgkEqGinlr7O3p7JMSSVGrfmRkHH3XM7CUQ90T69s9BoK9EgiAEU0oh0d2R2jZz/xipxgMy0BIifagXQA2+49FVFV2fNjk6thGrr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7GxHSoc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7GxHSoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755751F000C4;
	Sat, 17 Oct 2026 16:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254286;
	bh=xETWutDLSas0L7syuvd3o1r9xBEtWNt35CB4G+bqSX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7GxHSocJVZDqgGAXPk1BLIl1qPyIGQ1c6Bd1Kz5iVD+ZFwAfH3BAlZKlmJvBasah
	 X7dcmHcmY2/s2mbPQCrS5I7BF8oOFwcT8NC8LXffxhhrdwkZMA6XGzrfQnlIh6ATbL
	 1V130zZqppWlq2gsnD3tZc3MoSXHazni22rEbLQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 380/869] media: stm32-dcmipp: Return queued buffers on start_streaming() failure
Date: Sat, 17 Oct 2026 17:53:41 +0200
Message-ID: <20261017160046.857641047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valery Borovsky <vebohr@gmail.com>

[ Upstream commit ffc8eec06378a340d708c889184ab3e14b57d540 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c   | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c b/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c
index 2b323dd6cf6bf..b1e35df41a9c0 100644
--- a/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c
+++ b/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-bytecap.c
@@ -381,8 +381,10 @@ static int dcmipp_bytecap_start_streaming(struct vb2_queue *vq,
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
-- 
2.53.0



