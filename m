Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2143E3F54B6;
	Thu, 16 Jul 2026 14:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210688; cv=none; b=UFO2TlxUJATuQF0/zgDvoqGHgkhZHjOEvFa7oYDs9L/5uQ5526y5zdbas1vEghKqng1ICXF6AGieMmScF92xlNCHSYglM3XVA56iTTQcpIOdBYOOjRSMUMwlHFzeq0ECoP74qbe6vwxsUoptL5pZ4AH59EjzCvYdk4R6IuPDKfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210688; c=relaxed/simple;
	bh=aAXtgNiDxxeXbOOerS/IYMqyiwlSxUHCO84B+V7ecQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZTYB/SEGbIFc0wMcnoTbc08fAYhkGyPmcG5TFLIfGOwI1S8B8egbPnER8pgDbTVvpbOP1BPLnjF0fb2PNdk573z+AZkRxDrR+6nJyI5Wgwy4AOkKmUeVpyL4dkq98OKjFtittT4a4G3zsInwFkyzM2XQ/yif+nhdLYmvc8A5S38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXBTDifQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXBTDifQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876921F000E9;
	Thu, 16 Jul 2026 14:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210687;
	bh=FpFUW1xVbeH+BoSWjvUKeIskRmeHZLcLJQ74IA9zFyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXBTDifQVUoNQ4gDayWHlKSa7+JiR84YYsL2JeIgCCUdEgq0BOhCbF0dgJwS2MLc0
	 ORQU8AQ4BAbIhMEk2CScMtD4tYI9grh27wH8Astg6EUO2YfIUv353koUg3FrqW4Ahy
	 wYNk8Itow/AKnUdQ2U/C9wCqfqna+OSszpDz4N28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 098/480] ALSA: compress: Fix task creation error unwind
Date: Thu, 16 Jul 2026 15:27:25 +0200
Message-ID: <20260716133046.832420212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -1070,15 +1070,18 @@ static int snd_compr_task_new(struct snd
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
@@ -1090,6 +1093,8 @@ static int snd_compr_task_new(struct snd
 	list_add_tail(&task->list, &stream->runtime->tasks);
 	stream->runtime->total_tasks++;
 	return 0;
+free_driver_task:
+	stream->ops->task_free(stream, task);
 cleanup:
 	snd_compr_task_free(task);
 	return retval;


