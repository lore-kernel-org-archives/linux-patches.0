Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A130618DB2A;
	Wed, 25 Feb 2026 01:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983097; cv=none; b=PS4dQq+3I6iMyAx7yJN3oW3hHfs3ndVfC2ZEB8z6GXpk9Ck7NQpp0C2xsW6x6XXfjPFY161/27OmrrGC1R7NhLn93S5T1ukBHcfiS7hJVRf3eo8GPIjFK3/8uuXAYao93wwd7aUEHuzqub/aVfANmnkT1sUSYq0OsXBG3Y82W0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983097; c=relaxed/simple;
	bh=0mrLMDwwUJ1ekiJsXvXstTxwOKAgchK3ZSEdzlhGRBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuodvWVq2OhogoxwmTthkN4AgzrAnZw0p9OigZw9XWx3YVjDag/FHdIhJ6futiOAAqJ0xIPhZ9yTAwcSBDMu2JDnSHHA2bseMIzSIgdvMflkbsMFZip71JHBPfH3vxSoPyxl414826CqbHZ7jwM+WJgRTgBR8wZBcUxhMteZSrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQdtUrqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQdtUrqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F986C116D0;
	Wed, 25 Feb 2026 01:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983097;
	bh=0mrLMDwwUJ1ekiJsXvXstTxwOKAgchK3ZSEdzlhGRBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQdtUrqecpPGWpx0An/IV8DrHpWxWvJmWxFSNQPGoZOd+/vZvaYn9oQ8B2Gg64rQP
	 ouVaL13e2o4ElUIWs9veAgV/BfZ1i5HIIojMvRwPL4+35NMWVre2SpUYXrBfLhT9wI
	 1DkfL5NEsuoA2Ix1hnaEIrTKX1EEgcVhNq7EgDlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 215/781] ALSA: pcm: Relax __free() variable declarations
Date: Tue, 24 Feb 2026 17:15:24 -0800
Message-ID: <20260225012404.989195256@linuxfoundation.org>
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

[ Upstream commit f3d233daf011abbad2f6ebd0e545b42d2f378a4f ]

We used to have a variable declaration with __free() initialized with
NULL.  This was to keep the old coding style rule, but recently it's
relaxed and rather recommends to follow the new rule to declare in
place of use for __free() -- which avoids potential deadlocks or UAFs
with nested cleanups.

Although the current code has no bug, per se, let's follow the new
standard and move the declaration to the place of assignment (or
directly assign the allocated result) instead of NULL initializations.

Fixes: ae9213984864 ("ALSA: pcm: Use automatic cleanup of kfree()")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251216140634.171890-4-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm.c        |  4 ++--
 sound/core/pcm_compat.c |  9 ++++----
 sound/core/pcm_native.c | 50 +++++++++++++++++++++--------------------
 3 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 283aac441fa0a..0b512085eb63f 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -328,13 +328,13 @@ static const char *snd_pcm_oss_format_name(int format)
 static void snd_pcm_proc_info_read(struct snd_pcm_substream *substream,
 				   struct snd_info_buffer *buffer)
 {
-	struct snd_pcm_info *info __free(kfree) = NULL;
 	int err;
 
 	if (! substream)
 		return;
 
-	info = kmalloc(sizeof(*info), GFP_KERNEL);
+	struct snd_pcm_info *info __free(kfree) =
+		kmalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return;
 
diff --git a/sound/core/pcm_compat.c b/sound/core/pcm_compat.c
index 54eb9bd8eb218..e86f68f1f23c1 100644
--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -235,7 +235,6 @@ static int snd_pcm_ioctl_hw_params_compat(struct snd_pcm_substream *substream,
 					  int refine, 
 					  struct snd_pcm_hw_params32 __user *data32)
 {
-	struct snd_pcm_hw_params *data __free(kfree) = NULL;
 	struct snd_pcm_runtime *runtime;
 	int err;
 
@@ -243,7 +242,8 @@ static int snd_pcm_ioctl_hw_params_compat(struct snd_pcm_substream *substream,
 	if (!runtime)
 		return -ENOTTY;
 
-	data = kmalloc(sizeof(*data), GFP_KERNEL);
+	struct snd_pcm_hw_params *data __free(kfree) =
+		kmalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -332,7 +332,6 @@ static int snd_pcm_ioctl_xfern_compat(struct snd_pcm_substream *substream,
 	compat_caddr_t buf;
 	compat_caddr_t __user *bufptr;
 	u32 frames;
-	void __user **bufs __free(kfree) = NULL;
 	int err, ch, i;
 
 	if (! substream->runtime)
@@ -349,7 +348,9 @@ static int snd_pcm_ioctl_xfern_compat(struct snd_pcm_substream *substream,
 	    get_user(frames, &data32->frames))
 		return -EFAULT;
 	bufptr = compat_ptr(buf);
-	bufs = kmalloc_array(ch, sizeof(void __user *), GFP_KERNEL);
+
+	void __user **bufs __free(kfree) =
+		kmalloc_array(ch, sizeof(void __user *), GFP_KERNEL);
 	if (bufs == NULL)
 		return -ENOMEM;
 	for (i = 0; i < ch; i++) {
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 932a9bf98cbc0..844ee1b4d286f 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -242,10 +242,10 @@ int snd_pcm_info(struct snd_pcm_substream *substream, struct snd_pcm_info *info)
 int snd_pcm_info_user(struct snd_pcm_substream *substream,
 		      struct snd_pcm_info __user * _info)
 {
-	struct snd_pcm_info *info __free(kfree) = NULL;
 	int err;
+	struct snd_pcm_info *info __free(kfree) =
+		kmalloc(sizeof(*info), GFP_KERNEL);
 
-	info = kmalloc(sizeof(*info), GFP_KERNEL);
 	if (! info)
 		return -ENOMEM;
 	err = snd_pcm_info(substream, info);
@@ -364,7 +364,6 @@ static int constrain_params_by_rules(struct snd_pcm_substream *substream,
 	struct snd_pcm_hw_constraints *constrs =
 					&substream->runtime->hw_constraints;
 	unsigned int k;
-	unsigned int *rstamps __free(kfree) = NULL;
 	unsigned int vstamps[SNDRV_PCM_HW_PARAM_LAST_INTERVAL + 1];
 	unsigned int stamp;
 	struct snd_pcm_hw_rule *r;
@@ -380,7 +379,8 @@ static int constrain_params_by_rules(struct snd_pcm_substream *substream,
 	 * Each member of 'rstamps' array represents the sequence number of
 	 * recent application of corresponding rule.
 	 */
-	rstamps = kcalloc(constrs->rules_num, sizeof(unsigned int), GFP_KERNEL);
+	unsigned int *rstamps __free(kfree) =
+		kcalloc(constrs->rules_num, sizeof(unsigned int), GFP_KERNEL);
 	if (!rstamps)
 		return -ENOMEM;
 
@@ -583,10 +583,10 @@ EXPORT_SYMBOL(snd_pcm_hw_refine);
 static int snd_pcm_hw_refine_user(struct snd_pcm_substream *substream,
 				  struct snd_pcm_hw_params __user * _params)
 {
-	struct snd_pcm_hw_params *params __free(kfree) = NULL;
 	int err;
+	struct snd_pcm_hw_params *params __free(kfree) =
+		memdup_user(_params, sizeof(*params));
 
-	params = memdup_user(_params, sizeof(*params));
 	if (IS_ERR(params))
 		return PTR_ERR(params);
 
@@ -889,10 +889,10 @@ static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 static int snd_pcm_hw_params_user(struct snd_pcm_substream *substream,
 				  struct snd_pcm_hw_params __user * _params)
 {
-	struct snd_pcm_hw_params *params __free(kfree) = NULL;
 	int err;
+	struct snd_pcm_hw_params *params __free(kfree) =
+		memdup_user(_params, sizeof(*params));
 
-	params = memdup_user(_params, sizeof(*params));
 	if (IS_ERR(params))
 		return PTR_ERR(params);
 
@@ -2267,7 +2267,6 @@ static int snd_pcm_link(struct snd_pcm_substream *substream, int fd)
 {
 	struct snd_pcm_file *pcm_file;
 	struct snd_pcm_substream *substream1;
-	struct snd_pcm_group *group __free(kfree) = NULL;
 	struct snd_pcm_group *target_group;
 	bool nonatomic = substream->pcm->nonatomic;
 	CLASS(fd, f)(fd);
@@ -2283,7 +2282,8 @@ static int snd_pcm_link(struct snd_pcm_substream *substream, int fd)
 	if (substream == substream1)
 		return -EINVAL;
 
-	group = kzalloc(sizeof(*group), GFP_KERNEL);
+	struct snd_pcm_group *group __free(kfree) =
+		kzalloc(sizeof(*group), GFP_KERNEL);
 	if (!group)
 		return -ENOMEM;
 	snd_pcm_group_init(group);
@@ -3291,7 +3291,6 @@ static int snd_pcm_xfern_frames_ioctl(struct snd_pcm_substream *substream,
 {
 	struct snd_xfern xfern;
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	void *bufs __free(kfree) = NULL;
 	snd_pcm_sframes_t result;
 
 	if (runtime->state == SNDRV_PCM_STATE_OPEN)
@@ -3303,7 +3302,8 @@ static int snd_pcm_xfern_frames_ioctl(struct snd_pcm_substream *substream,
 	if (copy_from_user(&xfern, _xfern, sizeof(xfern)))
 		return -EFAULT;
 
-	bufs = memdup_array_user(xfern.bufs, runtime->channels, sizeof(void *));
+	void *bufs __free(kfree) =
+		memdup_array_user(xfern.bufs, runtime->channels, sizeof(void *));
 	if (IS_ERR(bufs))
 		return PTR_ERR(bufs);
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
@@ -3577,7 +3577,6 @@ static ssize_t snd_pcm_readv(struct kiocb *iocb, struct iov_iter *to)
 	struct snd_pcm_runtime *runtime;
 	snd_pcm_sframes_t result;
 	unsigned long i;
-	void __user **bufs __free(kfree) = NULL;
 	snd_pcm_uframes_t frames;
 	const struct iovec *iov = iter_iov(to);
 
@@ -3596,7 +3595,9 @@ static ssize_t snd_pcm_readv(struct kiocb *iocb, struct iov_iter *to)
 	if (!frame_aligned(runtime, iov->iov_len))
 		return -EINVAL;
 	frames = bytes_to_samples(runtime, iov->iov_len);
-	bufs = kmalloc_array(to->nr_segs, sizeof(void *), GFP_KERNEL);
+
+	void __user **bufs __free(kfree) =
+		kmalloc_array(to->nr_segs, sizeof(void *), GFP_KERNEL);
 	if (bufs == NULL)
 		return -ENOMEM;
 	for (i = 0; i < to->nr_segs; ++i) {
@@ -3616,7 +3617,6 @@ static ssize_t snd_pcm_writev(struct kiocb *iocb, struct iov_iter *from)
 	struct snd_pcm_runtime *runtime;
 	snd_pcm_sframes_t result;
 	unsigned long i;
-	void __user **bufs __free(kfree) = NULL;
 	snd_pcm_uframes_t frames;
 	const struct iovec *iov = iter_iov(from);
 
@@ -3634,7 +3634,9 @@ static ssize_t snd_pcm_writev(struct kiocb *iocb, struct iov_iter *from)
 	    !frame_aligned(runtime, iov->iov_len))
 		return -EINVAL;
 	frames = bytes_to_samples(runtime, iov->iov_len);
-	bufs = kmalloc_array(from->nr_segs, sizeof(void *), GFP_KERNEL);
+
+	void __user **bufs __free(kfree) =
+		kmalloc_array(from->nr_segs, sizeof(void *), GFP_KERNEL);
 	if (bufs == NULL)
 		return -ENOMEM;
 	for (i = 0; i < from->nr_segs; ++i) {
@@ -4106,15 +4108,15 @@ static void snd_pcm_hw_convert_to_old_params(struct snd_pcm_hw_params_old *opara
 static int snd_pcm_hw_refine_old_user(struct snd_pcm_substream *substream,
 				      struct snd_pcm_hw_params_old __user * _oparams)
 {
-	struct snd_pcm_hw_params *params __free(kfree) = NULL;
-	struct snd_pcm_hw_params_old *oparams __free(kfree) = NULL;
 	int err;
 
-	params = kmalloc(sizeof(*params), GFP_KERNEL);
+	struct snd_pcm_hw_params *params __free(kfree) =
+		kmalloc(sizeof(*params), GFP_KERNEL);
 	if (!params)
 		return -ENOMEM;
 
-	oparams = memdup_user(_oparams, sizeof(*oparams));
+	struct snd_pcm_hw_params_old *oparams __free(kfree) =
+		memdup_user(_oparams, sizeof(*oparams));
 	if (IS_ERR(oparams))
 		return PTR_ERR(oparams);
 	snd_pcm_hw_convert_from_old_params(params, oparams);
@@ -4135,15 +4137,15 @@ static int snd_pcm_hw_refine_old_user(struct snd_pcm_substream *substream,
 static int snd_pcm_hw_params_old_user(struct snd_pcm_substream *substream,
 				      struct snd_pcm_hw_params_old __user * _oparams)
 {
-	struct snd_pcm_hw_params *params __free(kfree) = NULL;
-	struct snd_pcm_hw_params_old *oparams __free(kfree) = NULL;
 	int err;
 
-	params = kmalloc(sizeof(*params), GFP_KERNEL);
+	struct snd_pcm_hw_params *params __free(kfree) =
+		kmalloc(sizeof(*params), GFP_KERNEL);
 	if (!params)
 		return -ENOMEM;
 
-	oparams = memdup_user(_oparams, sizeof(*oparams));
+	struct snd_pcm_hw_params_old *oparams __free(kfree) =
+		memdup_user(_oparams, sizeof(*oparams));
 	if (IS_ERR(oparams))
 		return PTR_ERR(oparams);
 
-- 
2.51.0



