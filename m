Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAA835CB63;
	Wed,  3 Dec 2025 16:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779169; cv=none; b=Ng9rmdk51TxbMUsySpKPNquMsXLtf0ME6TfOoNTcUOI9+FRWtct6fx6in4cFoBer0Y5ABMbaBj8xt0s9XsD33yMK334gHX/tOSp/wNGqA3A6M9mm19izZsV53EJ3qrOI6j+kK0ppenGm6nl4V3IRyWiBHoQBHBRaf5X00TXeLe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779169; c=relaxed/simple;
	bh=2DBbDSQnajByARDAaItzYcilNmsP4/VSqYo2kD9ejV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLh8Y7VoRAWpjZtXwOELhvmUZbEkupNKhkqWsb5Hm61zjHVq3b7i5OZKmfPhZMu1pI5VKELnKghb3EjQbtUvJtjhcrmO8AiNLAiJ+yBFlyP76O0SNsyFiVRKqVJ6dJj7k6cxlYjs9WxFVyqVUsgj54z8OhigtuCU6nknUD+520k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eevW7fhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eevW7fhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F02DC4CEF5;
	Wed,  3 Dec 2025 16:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779169;
	bh=2DBbDSQnajByARDAaItzYcilNmsP4/VSqYo2kD9ejV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eevW7fhWul7K38nxTLcutxJzGm98vk0AE5UZTtxVXtm7njnehjYGD9vbL7fhtZCdj
	 CXekQF1xhPeG2uLyJ2PgakDUOWm6vUypa4wRGX5vKYg5dlewyvxC2WkUkhmpXWWVLg
	 S1IZgMZcbsJkCU7QWMUxLqY/UkkSk1MUSKgwZ7Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Ming Qian <ming.qian@oss.nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/568] media: amphion: Delete v4l2_fh synchronously in .release()
Date: Wed,  3 Dec 2025 16:22:25 +0100
Message-ID: <20251203152445.965967117@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 19189d7449dc8..30aebefddc9c9 100644
--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -608,8 +608,6 @@ static int vpu_v4l2_release(struct vpu_inst *inst)
 
 	v4l2_ctrl_handler_free(&inst->ctrl_handler);
 	mutex_destroy(&inst->lock);
-	v4l2_fh_del(&inst->fh);
-	v4l2_fh_exit(&inst->fh);
 
 	call_void_vop(inst, cleanup);
 
@@ -678,6 +676,8 @@ int vpu_v4l2_open(struct file *file, struct vpu_inst *inst)
 
 	return 0;
 error:
+	v4l2_fh_del(&inst->fh);
+	v4l2_fh_exit(&inst->fh);
 	vpu_inst_put(inst);
 	return ret;
 }
@@ -697,6 +697,9 @@ int vpu_v4l2_close(struct file *file)
 	call_void_vop(inst, release);
 	vpu_inst_unlock(inst);
 
+	v4l2_fh_del(&inst->fh);
+	v4l2_fh_exit(&inst->fh);
+
 	vpu_inst_unregister(inst);
 	vpu_inst_put(inst);
 
-- 
2.51.0



