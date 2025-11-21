Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945EB347BC9;
	Fri, 21 Nov 2025 13:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732464; cv=none; b=Qrg1m33JHmD5Bb8nV442g+qA3EKaIDMsmRXKhTyn+pEfwIiCfL/LcOZaO0vlCsfMoliRbD1Wca40KN7g3Qsy1+L+HDt9/SdVHiXumD4NIhopYsirV3HyjeQNz3+pow3Yf4Fuz4yB2tCyeODLI+iMaYqmroB2ZV4iV4lNq7OoAco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732464; c=relaxed/simple;
	bh=PWemDepiS95sy3BLwaWmBZMYzG3BweKtnkPBQlIpYuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sssryhEP2vR/nd4xqWBqtNyDbPPc3h8M9We6wI2DU3h9YnDgaNnbZUWCfyiJi8pnCgP1F8T39RB8equH/U2HoYf6FFNR0hMfZk4XJ2FCMLk8AtFBlC4bqEFrAo69amF3bcD0BV86IM5WYAOY4hCsRZpy3c++akWLWG2kCCdxXO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwpM7xXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwpM7xXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2048FC116C6;
	Fri, 21 Nov 2025 13:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732464;
	bh=PWemDepiS95sy3BLwaWmBZMYzG3BweKtnkPBQlIpYuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwpM7xXDwulE/3GSUkv+9LT7Udtr7MpTUD4uZvTvRCvQIFZBDFP32e9Td68HYyDJc
	 5xSLBWXQ9dkBPonsWrNi1cSnndz7ZvNG9HdPeRrmqRNA67nEpeJruhgJyO+FfJ+pxR
	 iS1mmL9Vg5/LUE0jvbRpSP0Vpg2cESNLD1z0SbMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Ming Qian <ming.qian@oss.nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/529] media: amphion: Delete v4l2_fh synchronously in .release()
Date: Fri, 21 Nov 2025 14:07:08 +0100
Message-ID: <20251121130235.611143992@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit 19fb9c5b815f70eb90d5b545f65b83bc9c490ecd ]

The v4l2_fh initialized and added in vpu_v4l2_open() is delete and
cleaned up when the last reference to the vpu_inst is released. This may
happen later than at vpu_v4l2_close() time.

Not deleting and cleaning up the v4l2_fh when closing the file handle to
the video device is not ideal, as the v4l2_fh will still be present in
the video device's fh_list, and will store a copy of events queued to
the video device. There may also be other side effects of keeping alive
an object that represents an open file handle after the file handle is
closed.

The v4l2_fh instance is embedded in the vpu_inst structure, and is
accessed in two different ways:

- in vpu_notify_eos() and vpu_notify_source_change(), to queue V4L2
  events to the file handle ; and

- through the driver to access the v4l2_fh.m2m_ctx pointer.

The v4l2_fh.m2m_ctx pointer is not touched by v4l2_fh_del() and
v4l2_fh_exit(). It is set to NULL by the driver when closing the file
handle, in vpu_v4l2_close().

The vpu_notify_eos() and vpu_notify_source_change() functions are called
in vpu_set_last_buffer_dequeued() and vdec_handle_resolution_change()
respectively, only if the v4l2_fh.m2m_ctx pointer is not NULL. There is
therefore a guarantee that no new event will be queued to the v4l2_fh
after vpu_v4l2_close() destroys the m2m_ctx.

The vpu_notify_eos() function is also called from vpu_vb2_buf_finish(),
which is guaranteed to be called for all queued buffers when
vpu_v4l2_close() calls v4l2_m2m_ctx_release(), and will not be called
later.

It is therefore safe to assume that the driver will not touch the
v4l2_fh, except to check the m2m_ctx pointer, after vpu_v4l2_close()
destroys the m2m_ctx. We can safely delete and cleanup the v4l2_fh
synchronously in vpu_v4l2_close().

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Ming Qian <ming.qian@oss.nxp.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_v4l2.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu_v4l2.c b/drivers/media/platform/amphion/vpu_v4l2.c
index 61d27b63b99d4..75084ba8f93b6 100644
--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -693,8 +693,6 @@ static int vpu_v4l2_release(struct vpu_inst *inst)
 
 	v4l2_ctrl_handler_free(&inst->ctrl_handler);
 	mutex_destroy(&inst->lock);
-	v4l2_fh_del(&inst->fh);
-	v4l2_fh_exit(&inst->fh);
 
 	call_void_vop(inst, cleanup);
 
@@ -763,6 +761,8 @@ int vpu_v4l2_open(struct file *file, struct vpu_inst *inst)
 
 	return 0;
 error:
+	v4l2_fh_del(&inst->fh);
+	v4l2_fh_exit(&inst->fh);
 	vpu_inst_put(inst);
 	return ret;
 }
@@ -782,6 +782,9 @@ int vpu_v4l2_close(struct file *file)
 	call_void_vop(inst, release);
 	vpu_inst_unlock(inst);
 
+	v4l2_fh_del(&inst->fh);
+	v4l2_fh_exit(&inst->fh);
+
 	vpu_inst_unregister(inst);
 	vpu_inst_put(inst);
 
-- 
2.51.0



