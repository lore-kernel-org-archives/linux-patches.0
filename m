Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1673AA4F8;
	Mon,  4 May 2026 14:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903784; cv=none; b=nuo+EH5+d35DGmkIO3UtXJIEhNgFQlx1ALNdUMD51QpE3ozswUbvRDSPziQQDKKQGm20oo8LZ0HEwhMvg6fHBGPiJfFzfUpU/QfC1w73QnsDXost+6msQ3Tk+tl/iaclDZDjkEo+EDFAU0d8yvpylHf+dhalRCNtRhDCSkSjYMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903784; c=relaxed/simple;
	bh=04JED3shfEKOGXZ2D7mmo6KsP7RNp56OsNASUpnS0gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZsStbgjzK6Ft09/2MZtAaFQ54HpW5Vvwih9XPsh+OF8zyCboyaDDSSu90cZpuRT/pgz0gRaXb60dc2mbihd9RZJH+5oAxaXmspDpnrMBbQF3hrOMjaMdtrdc7FE06SQn/VdGqLAVFw4ocYmRu89Xx1N+Xo0/CkQMqh4hzOFSrsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXJz189i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXJz189i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBB6C2BCB8;
	Mon,  4 May 2026 14:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903783;
	bh=04JED3shfEKOGXZ2D7mmo6KsP7RNp56OsNASUpnS0gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXJz189ifTOo35zJCqbaO7OAZ+ZwqJdmebP+i1CRNF3HMKxJ7fVIWdqCLRdfYy9j2
	 w8vtTPiIacKT9WGTDGzPM6QJIDG+rP+NdT2Wa36XNpcs9vT31GiCZH1FLNSlNLjmiK
	 lB0Lm0WJe21LOCIIZ0dbZPLN3Dt4MC5fen3Xeg8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 061/275] ALSA: aoa: i2sbus: clear stale prepared state
Date: Mon,  4 May 2026 15:50:01 +0200
Message-ID: <20260504135145.201503728@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

commit 5ed060d5491597490fb53ec69da3edc4b1e8c165 upstream.

The i2sbus PCM code uses pi->active to constrain the sibling stream to
an already prepared duplex format and rate in i2sbus_pcm_open().

That state is set from i2sbus_pcm_prepare(), but the current code only
clears it on close. As a result, the sibling stream can inherit stale
constraints after the prepared state has been torn down.

Clear pi->active when hw_params() or hw_free() tears down the prepared
state, and set it again only after prepare succeeds.

Replace the stale FIXME in the duplex constraint comment with a description
of the current driver behavior: i2sbus still programs a single shared
transport configuration for both directions, so mixed formats are not
supported in duplex mode.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202604010125.AvkWBYKI-lkp@intel.com/
Fixes: f3d9478b2ce4 ("[ALSA] snd-aoa: add snd-aoa")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260331-aoa-i2sbus-clear-stale-active-v2-1-3764ae2889a1@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/aoa/soundbus/i2sbus/pcm.c |   55 ++++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 11 deletions(-)

--- a/sound/aoa/soundbus/i2sbus/pcm.c
+++ b/sound/aoa/soundbus/i2sbus/pcm.c
@@ -165,17 +165,16 @@ static int i2sbus_pcm_open(struct i2sbus
 	 * currently in use (if any). */
 	hw->rate_min = 5512;
 	hw->rate_max = 192000;
-	/* if the other stream is active, then we can only
-	 * support what it is currently using.
-	 * FIXME: I lied. This comment is wrong. We can support
-	 * anything that works with the same serial format, ie.
-	 * when recording 24 bit sound we can well play 16 bit
-	 * sound at the same time iff using the same transfer mode.
+	/* If the other stream is already prepared, keep this stream
+	 * on the same duplex format and rate.
+	 *
+	 * i2sbus_pcm_prepare() still programs one shared transport
+	 * configuration for both directions, so mixed duplex formats
+	 * are not supported here.
 	 */
 	if (other->active) {
-		/* FIXME: is this guaranteed by the alsa api? */
 		hw->formats &= pcm_format_to_bits(i2sdev->format);
-		/* see above, restrict rates to the one we already have */
+		/* Restrict rates to the one already in use. */
 		hw->rate_min = i2sdev->rate;
 		hw->rate_max = i2sdev->rate;
 	}
@@ -283,6 +282,23 @@ void i2sbus_wait_for_stop_both(struct i2
 }
 #endif
 
+static void i2sbus_pcm_clear_active(struct i2sbus_dev *i2sdev, int in)
+{
+	struct pcm_info *pi;
+
+	guard(mutex)(&i2sdev->lock);
+
+	get_pcm_info(i2sdev, in, &pi, NULL);
+	pi->active = 0;
+}
+
+static inline int i2sbus_hw_params(struct snd_pcm_substream *substream,
+				   struct snd_pcm_hw_params *params, int in)
+{
+	i2sbus_pcm_clear_active(snd_pcm_substream_chip(substream), in);
+	return 0;
+}
+
 static inline int i2sbus_hw_free(struct snd_pcm_substream *substream, int in)
 {
 	struct i2sbus_dev *i2sdev = snd_pcm_substream_chip(substream);
@@ -291,14 +307,27 @@ static inline int i2sbus_hw_free(struct
 	get_pcm_info(i2sdev, in, &pi, NULL);
 	if (pi->dbdma_ring.stopping)
 		i2sbus_wait_for_stop(i2sdev, pi);
+	i2sbus_pcm_clear_active(i2sdev, in);
 	return 0;
 }
 
+static int i2sbus_playback_hw_params(struct snd_pcm_substream *substream,
+				     struct snd_pcm_hw_params *params)
+{
+	return i2sbus_hw_params(substream, params, 0);
+}
+
 static int i2sbus_playback_hw_free(struct snd_pcm_substream *substream)
 {
 	return i2sbus_hw_free(substream, 0);
 }
 
+static int i2sbus_record_hw_params(struct snd_pcm_substream *substream,
+				   struct snd_pcm_hw_params *params)
+{
+	return i2sbus_hw_params(substream, params, 1);
+}
+
 static int i2sbus_record_hw_free(struct snd_pcm_substream *substream)
 {
 	return i2sbus_hw_free(substream, 1);
@@ -335,7 +364,6 @@ static int i2sbus_pcm_prepare(struct i2s
 		return -EINVAL;
 
 	runtime = pi->substream->runtime;
-	pi->active = 1;
 	if (other->active &&
 	    ((i2sdev->format != runtime->format)
 	     || (i2sdev->rate != runtime->rate)))
@@ -450,9 +478,11 @@ static int i2sbus_pcm_prepare(struct i2s
 
 	/* early exit if already programmed correctly */
 	/* not locking these is fine since we touch them only in this function */
-	if (in_le32(&i2sdev->intfregs->serial_format) == sfr
-	 && in_le32(&i2sdev->intfregs->data_word_sizes) == dws)
+	if (in_le32(&i2sdev->intfregs->serial_format) == sfr &&
+	    in_le32(&i2sdev->intfregs->data_word_sizes) == dws) {
+		pi->active = 1;
 		return 0;
+	}
 
 	/* let's notify the codecs about clocks going away.
 	 * For now we only do mastering on the i2s cell... */
@@ -490,6 +520,7 @@ static int i2sbus_pcm_prepare(struct i2s
 		if (cii->codec->switch_clock)
 			cii->codec->switch_clock(cii, CLOCK_SWITCH_SLAVE);
 
+	pi->active = 1;
 	return 0;
 }
 
@@ -734,6 +765,7 @@ static snd_pcm_uframes_t i2sbus_playback
 static const struct snd_pcm_ops i2sbus_playback_ops = {
 	.open =		i2sbus_playback_open,
 	.close =	i2sbus_playback_close,
+	.hw_params =	i2sbus_playback_hw_params,
 	.hw_free =	i2sbus_playback_hw_free,
 	.prepare =	i2sbus_playback_prepare,
 	.trigger =	i2sbus_playback_trigger,
@@ -802,6 +834,7 @@ static snd_pcm_uframes_t i2sbus_record_p
 static const struct snd_pcm_ops i2sbus_record_ops = {
 	.open =		i2sbus_record_open,
 	.close =	i2sbus_record_close,
+	.hw_params =	i2sbus_record_hw_params,
 	.hw_free =	i2sbus_record_hw_free,
 	.prepare =	i2sbus_record_prepare,
 	.trigger =	i2sbus_record_trigger,


