Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159A941F7D5;
	Thu, 16 Jul 2026 13:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209175; cv=none; b=uzPJgMocvsiwSuSeJX7VRdTruxbQflEC1QIss6XakuLQTLoKAF7aq+C470nM8+RDGlq9d0P0RTRbFJR3ONJCJ+QIctFiDsxqpS7oD0wyOp9k0v3zvJ4GFE1a3XFbYN2MHw9x8LDH5SuVGVLcK9mhhkPyfN41BPqaq1+UKFeGXaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209175; c=relaxed/simple;
	bh=p1V84cG+Ghb6T4uG6Cnwn6r33074Tq7hHT+xchalx0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VueY1iQcNBJLdClb0J/gEHs7fKGsvbuWG3Qs7pVN0F7ZDsUeB8gXBdYhLEwPMElc1KiCMmjyi8ManLu/lGEyRWlWWNkWBXepEyfONZpufLTum2Kd52W2341932U778RMojQdA3PEBUoYCzUIpY98ZkRDt/7ho6KxBYF1TjWYgm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kB3gjMPK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kB3gjMPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4F01F000E9;
	Thu, 16 Jul 2026 13:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209174;
	bh=1k/8DhvmS4VvJgiYOgS16TYkHSctbnsOVnciFFT+Bkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kB3gjMPKp/HRkyZRZ4UV1qHcVnNDKvHasr4aXs7tiZQMDp5jqwl9w8HlZLtNCNVXM
	 AcNqo96KwhlaXhjUwPQnGlMxSUXpwjJ6HzSkrkXMYZMODgaCykZkZNcEIDOGcBCxWC
	 dZzJhkbn4LYvqoXhQ2ufsLN2HxXD3l14lQ7bAVv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 086/518] ALSA: compress: Fix task creation error unwind
Date: Thu, 16 Jul 2026 15:25:54 +0200
Message-ID: <20260716133049.747421930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit 4a60127debb9e370d6c0e22a307326b624a141f3 upstream.

snd_compr_task_new() allocates the driver task before validating the
returned DMA buffers and reserving file descriptors. When either of
those later steps fails, the core frees its task wrapper and DMA-buffer
references without calling the driver's task_free() callback. Any
driver resources allocated by task_create() are therefore leaked.

The dual-fd allocation path also jumps to cleanup without storing the
negative get_unused_fd_flags() result in retval. Since retval still
contains the successful task_create() return value, TASK_CREATE can
incorrectly report success although the task was discarded.

Preserve the fd allocation errors and call task_free() when failure
occurs after a successful task_create() callback.

Fixes: 04177158cf98 ("ALSA: compress_offload: introduce accel operation mode")
Fixes: 3d3f43fab4cf ("ALSA: compress_offload: improve file descriptors installation for dma-buf")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260615-alsa-compress-task-unwind-v1-1-39e8ad3ddb27@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/compress_offload.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -1083,15 +1083,18 @@ static int snd_compr_task_new(struct snd
 	   file descriptors are allocated before fd_install() */
 	if (!task->input || !task->input->file || !task->output || !task->output->file) {
 		retval = -EINVAL;
-		goto cleanup;
+		goto free_driver_task;
 	}
 	fd_i = get_unused_fd_flags(O_WRONLY|O_CLOEXEC);
-	if (fd_i < 0)
-		goto cleanup;
+	if (fd_i < 0) {
+		retval = fd_i;
+		goto free_driver_task;
+	}
 	fd_o = get_unused_fd_flags(O_RDONLY|O_CLOEXEC);
 	if (fd_o < 0) {
+		retval = fd_o;
 		put_unused_fd(fd_i);
-		goto cleanup;
+		goto free_driver_task;
 	}
 	/* keep dmabuf reference until freed with task free ioctl */
 	get_dma_buf(task->input);
@@ -1103,6 +1106,8 @@ static int snd_compr_task_new(struct snd
 	list_add_tail(&task->list, &stream->runtime->tasks);
 	stream->runtime->total_tasks++;
 	return 0;
+free_driver_task:
+	stream->ops->task_free(stream, task);
 cleanup:
 	snd_compr_task_free(task);
 	return retval;


