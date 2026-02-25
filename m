Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2D11D5ABA;
	Wed, 25 Feb 2026 01:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983095; cv=none; b=QiRspa7aNxwfMSsvuX+obCt4WsiumR7cbBJhH7Ov2brY2XC4J9noPkd7QJiBi1vMVEiwQ0C2HtcN6HTJqLEEADjTxl/lRmIBpk5EG9ECcMtgewQ2iBpSm44CGR/q3gYLe77RQtdn4gRg7Z3wDrg8hhSUAilPJHx3b8xVKcFyKDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983095; c=relaxed/simple;
	bh=IMACFyz7ZyxFvdyOni/per+bIXk3a2Mm/yq30euMwBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLUZ8ngdO4tya+nvMAvO1uueLr1tfFUIxibbbnqTIpHYnwI6KbfVXc3voTrZ8Kd/PbuVcfhDFSqW6wlfQE9IMX+ncMzr/dJXtoIsm+ExIRyDwugQS9QgoGK6bdnp6UZyKp6bOc/makKIiqWAJxedtjzWpW3NJiyUp3sN2xXJ8fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjR49LBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjR49LBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0A8C116D0;
	Wed, 25 Feb 2026 01:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983095;
	bh=IMACFyz7ZyxFvdyOni/per+bIXk3a2Mm/yq30euMwBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjR49LBuAw3FVMAmchYiMJSue3Sxi8RVNFzTcXbmkiJPOjLdyQWf8JiVbEnDVuoc4
	 ek4lI94Gqc7wBS4ZhD7KKRjL2iPr6/tu6qWNp9E0JxBsdyQB1gvEUYyD+01mQ31g1Z
	 wU0FUYSaJMp7kMCqtX61Enh3CDuAZOCkEX6h9+UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 213/781] ALSA: compress_offload: Relax __free() variable declarations
Date: Tue, 24 Feb 2026 17:15:22 -0800
Message-ID: <20260225012404.937097604@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 14324b8f0760ca6f56202bb4ad356ec459ce165b ]

We used to have a variable declaration with __free() initialized with
NULL.  This was to keep the old coding style rule, but recently it's
relaxed and rather recommends to follow the new rule to declare in
place of use for __free() -- which avoids potential deadlocks or UAFs
with nested cleanups.

Although the current code has no bug, per se, let's follow the new
standard and move the declaration to the place of assignment.

Fixes: 9b02221422a5 ("ALSA: compress_offload: Use automatic cleanup of kfree()")
Fixes: 04177158cf98 ("ALSA: compress_offload: introduce accel operation mode")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251216140634.171890-2-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index da514fef45bca..ed2eeb914c6db 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -514,12 +514,12 @@ static int
 snd_compr_get_codec_caps(struct snd_compr_stream *stream, unsigned long arg)
 {
 	int retval;
-	struct snd_compr_codec_caps *caps __free(kfree) = NULL;
 
 	if (!stream->ops->get_codec_caps)
 		return -ENXIO;
 
-	caps = kzalloc(sizeof(*caps), GFP_KERNEL);
+	struct snd_compr_codec_caps *caps __free(kfree) =
+		kzalloc(sizeof(*caps), GFP_KERNEL);
 	if (!caps)
 		return -ENOMEM;
 
@@ -647,7 +647,6 @@ snd_compress_check_input(struct snd_compr_stream *stream, struct snd_compr_param
 static int
 snd_compr_set_params(struct snd_compr_stream *stream, unsigned long arg)
 {
-	struct snd_compr_params *params __free(kfree) = NULL;
 	int retval;
 
 	if (stream->runtime->state == SNDRV_PCM_STATE_OPEN || stream->next_track) {
@@ -655,7 +654,9 @@ snd_compr_set_params(struct snd_compr_stream *stream, unsigned long arg)
 		 * we should allow parameter change only when stream has been
 		 * opened not in other cases
 		 */
-		params = memdup_user((void __user *)arg, sizeof(*params));
+		struct snd_compr_params *params __free(kfree) =
+			memdup_user((void __user *)arg, sizeof(*params));
+
 		if (IS_ERR(params))
 			return PTR_ERR(params);
 
@@ -687,13 +688,13 @@ snd_compr_set_params(struct snd_compr_stream *stream, unsigned long arg)
 static int
 snd_compr_get_params(struct snd_compr_stream *stream, unsigned long arg)
 {
-	struct snd_codec *params __free(kfree) = NULL;
 	int retval;
 
 	if (!stream->ops->get_params)
 		return -EBADFD;
 
-	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	struct snd_codec *params __free(kfree) =
+		kzalloc(sizeof(*params), GFP_KERNEL);
 	if (!params)
 		return -ENOMEM;
 	retval = stream->ops->get_params(stream, params);
@@ -1104,12 +1105,13 @@ static int snd_compr_task_new(struct snd_compr_stream *stream, struct snd_compr_
 
 static int snd_compr_task_create(struct snd_compr_stream *stream, unsigned long arg)
 {
-	struct snd_compr_task *task __free(kfree) = NULL;
 	int retval;
 
 	if (stream->runtime->state != SNDRV_PCM_STATE_SETUP)
 		return -EPERM;
-	task = memdup_user((void __user *)arg, sizeof(*task));
+
+	struct snd_compr_task *task __free(kfree) =
+		memdup_user((void __user *)arg, sizeof(*task));
 	if (IS_ERR(task))
 		return PTR_ERR(task);
 	retval = snd_compr_task_new(stream, task);
@@ -1165,12 +1167,13 @@ static int snd_compr_task_start(struct snd_compr_stream *stream, struct snd_comp
 
 static int snd_compr_task_start_ioctl(struct snd_compr_stream *stream, unsigned long arg)
 {
-	struct snd_compr_task *task __free(kfree) = NULL;
 	int retval;
 
 	if (stream->runtime->state != SNDRV_PCM_STATE_SETUP)
 		return -EPERM;
-	task = memdup_user((void __user *)arg, sizeof(*task));
+
+	struct snd_compr_task *task __free(kfree) =
+		memdup_user((void __user *)arg, sizeof(*task));
 	if (IS_ERR(task))
 		return PTR_ERR(task);
 	retval = snd_compr_task_start(stream, task);
@@ -1256,12 +1259,13 @@ static int snd_compr_task_status(struct snd_compr_stream *stream,
 
 static int snd_compr_task_status_ioctl(struct snd_compr_stream *stream, unsigned long arg)
 {
-	struct snd_compr_task_status *status __free(kfree) = NULL;
 	int retval;
 
 	if (stream->runtime->state != SNDRV_PCM_STATE_SETUP)
 		return -EPERM;
-	status = memdup_user((void __user *)arg, sizeof(*status));
+
+	struct snd_compr_task_status *status __free(kfree) =
+		memdup_user((void __user *)arg, sizeof(*status));
 	if (IS_ERR(status))
 		return PTR_ERR(status);
 	retval = snd_compr_task_status(stream, status);
-- 
2.51.0



