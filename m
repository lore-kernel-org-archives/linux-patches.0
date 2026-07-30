Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9715D43B6D1;
	Thu, 30 Jul 2026 14:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422663; cv=none; b=tvt9+DrsGsyFmhIk4MWhu4VE3FSWUFmyL8um39zuTuzdtgSLiHCXKvlnHIaJpZKSFhSk/jZUa1BXfBGR6o+qgBxBzsETv5LDWyuqQVQODxh8nv+pdfAKps1QRXMBIwB+wXHfjipKhqhBs1sGqrCQhlSqfemIXrJZFCGaiDLii4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422663; c=relaxed/simple;
	bh=aPtAvRlUTaLSu4JZY3MhZ6B4PZdRtzxOICUTRZb+tTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zp3L0MY24FbPaPKbOzGKsi0uvl0CXjJthfSNO/jNBRGujUU+tXmKPdu6N7qh2RzPqbXZgBKeXQ2ZRLDlnZCUP8+AnIeL3QG4rXmHkNIyJQETbQl4U/8Zt3m9O97zxAyrS/C4+YB8MgWINQhcDBWXYUZ8hod9n7PlI3FNJii8eAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpSXfXM9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpSXfXM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CE21F00A3A;
	Thu, 30 Jul 2026 14:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422662;
	bh=eLA3NWwHa5Tof4oi3kqYoUDLJFxkX7pLW1RBXm2XdWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gpSXfXM9k/5Ml6yTwLx1giS1319MzsEYPwwIIQdHsxTYWi8u+2XaR+VM3P94q9K1P
	 rYJNUP+d00HFs4FAdVRInig/C93UqF5wmaAjNMze1PupjHBQmBvSsDlpeZ7I+ciByh
	 QaBUC9gwJTrYGAcBQS/0Yrj9VgkO0edfHy0dHzY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 516/744] media: stm32-dcmipp: Return queued buffers on start_streaming() failure
Date: Thu, 30 Jul 2026 16:13:09 +0200
Message-ID: <20260730141455.244875482@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -401,8 +401,10 @@ static int dcmipp_bytecap_start_streamin
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


