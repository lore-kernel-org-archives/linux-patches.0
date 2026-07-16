Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E6528505E;
	Thu, 16 Jul 2026 14:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211807; cv=none; b=ke+1HPkJgDDfuoo5sMrXDLVMslgpkeLHyZo/sPC7k7GXzZjuqwOZ5Y/hY4N3q3mjdoAv1tidSzR+/kWerLR0ifZs4azZ+IQVQVFyH6pr73mY3jlfBs7fZdqcGUzVA3qDKkhIfBbTI/OULp+cFMT37hdaSBaafNFvuJg1k6FPlGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211807; c=relaxed/simple;
	bh=5cUia11MesdAwNvAaN4JDqwRpcXbf0UD/RbeOuJ2nrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sNxxlSzicLz57i35noW3Tv3mEawD5IVBHCsZkA5gbcOs1nCOl/eSjFRBbR03ReFaO24v0vxfBVXswSx1fx/NdikIoX6Wy3YdWq9ClGO7FsWBmkBGqrBWXRT3ErfqHVRVJKJJDEwgWTMRoNjtowtL9bQ+hKcbXOfeDRanUal+Kw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qK0Tl2tt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qK0Tl2tt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CD31F000E9;
	Thu, 16 Jul 2026 14:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211805;
	bh=A3ema9bId7+b4jhGNo+oAddpep8XSWD2IEPH7do7Nj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qK0Tl2ttgkT82wNc4KLwyBTv870faaXMAyc7AwxfApmv9UhV9bpg144KdDx/ECV2p
	 WuUzjOQeqW9Fl5QmRtF3sFm+9bh45Tgd8PZU+k2MR8F/9yOeZG5ITRvIjlj9ncRykg
	 uvJGbGWrbTg2FDXN+1ncIkFPs5h7C1VPpB6V/fuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 086/349] ALSA: usb-audio: Update US-16x08 EQ/comp shadow state after successful writes
Date: Thu, 16 Jul 2026 15:30:20 +0200
Message-ID: <20260716133035.237588069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit a440c17869ecd71da0f295b62868fc742d09a8ba upstream.

snd_us16x08_comp_put() and snd_us16x08_eq_put() update their
software stores before sending the USB write. If the transfer
fails, later get callbacks report a value the hardware never
accepted.

Build the outgoing message from the current store plus the
pending value, then commit the store only after a successful
write.

Fixes: d2bb390a2081 ("ALSA: usb-audio: Tascam US-16x08 DSP mixer quirk")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260419-usb-write-error-propagation-v1-4-5a3bd4a673ae@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_us16x08.c |   78 ++++++++++++++++++++++++++++++----------------
 1 file changed, 52 insertions(+), 26 deletions(-)

--- a/sound/usb/mixer_us16x08.c
+++ b/sound/usb/mixer_us16x08.c
@@ -436,6 +436,7 @@ static int snd_us16x08_comp_put(struct s
 	int index = ucontrol->id.index;
 	char buf[sizeof(comp_msg)];
 	int val_idx, val;
+	int threshold, ratio, attack, release, gain, switch_on;
 	int err;
 
 	val = ucontrol->value.integer.value[0];
@@ -448,36 +449,61 @@ static int snd_us16x08_comp_put(struct s
 	/* new control value incl. bias*/
 	val_idx = elem->head.id - SND_US16X08_ID_COMP_BASE;
 
-	store->val[val_idx][index] = ucontrol->value.integer.value[0];
+	threshold = store->val[COMP_STORE_IDX(SND_US16X08_ID_COMP_THRESHOLD)]
+		[index];
+	ratio = store->val[COMP_STORE_IDX(SND_US16X08_ID_COMP_RATIO)][index];
+	attack = store->val[COMP_STORE_IDX(SND_US16X08_ID_COMP_ATTACK)][index];
+	release = store->val[COMP_STORE_IDX(SND_US16X08_ID_COMP_RELEASE)]
+		[index];
+	gain = store->val[COMP_STORE_IDX(SND_US16X08_ID_COMP_GAIN)][index];
+	switch_on = store->val[COMP_STORE_IDX(SND_US16X08_ID_COMP_SWITCH)]
+		[index];
+
+	switch (val_idx) {
+	case COMP_STORE_IDX(SND_US16X08_ID_COMP_THRESHOLD):
+		threshold = val;
+		break;
+	case COMP_STORE_IDX(SND_US16X08_ID_COMP_RATIO):
+		ratio = val;
+		break;
+	case COMP_STORE_IDX(SND_US16X08_ID_COMP_ATTACK):
+		attack = val;
+		break;
+	case COMP_STORE_IDX(SND_US16X08_ID_COMP_RELEASE):
+		release = val;
+		break;
+	case COMP_STORE_IDX(SND_US16X08_ID_COMP_GAIN):
+		gain = val;
+		break;
+	case COMP_STORE_IDX(SND_US16X08_ID_COMP_SWITCH):
+		switch_on = val;
+		break;
+	}
 
 	/* prepare compressor URB message from template  */
 	memcpy(buf, comp_msg, sizeof(comp_msg));
 
 	/* place comp values in message buffer watch bias! */
-	buf[8] = store->val[
-		COMP_STORE_IDX(SND_US16X08_ID_COMP_THRESHOLD)][index]
-		- SND_US16X08_COMP_THRESHOLD_BIAS;
-	buf[11] = ratio_map[store->val[
-		COMP_STORE_IDX(SND_US16X08_ID_COMP_RATIO)][index]];
-	buf[14] = store->val[COMP_STORE_IDX(SND_US16X08_ID_COMP_ATTACK)][index]
-		+ SND_US16X08_COMP_ATTACK_BIAS;
-	buf[17] = store->val[COMP_STORE_IDX(SND_US16X08_ID_COMP_RELEASE)][index]
-		+ SND_US16X08_COMP_RELEASE_BIAS;
-	buf[20] = store->val[COMP_STORE_IDX(SND_US16X08_ID_COMP_GAIN)][index];
-	buf[26] = store->val[COMP_STORE_IDX(SND_US16X08_ID_COMP_SWITCH)][index];
+	buf[8] = threshold - SND_US16X08_COMP_THRESHOLD_BIAS;
+	buf[11] = ratio_map[ratio];
+	buf[14] = attack + SND_US16X08_COMP_ATTACK_BIAS;
+	buf[17] = release + SND_US16X08_COMP_RELEASE_BIAS;
+	buf[20] = gain;
+	buf[26] = switch_on;
 
 	/* place channel selector in message buffer */
 	buf[5] = index + 1;
 
 	err = snd_us16x08_send_urb(chip, buf, sizeof(comp_msg));
 
-	if (err > 0) {
-		elem->cached |= 1 << index;
-		elem->cache_val[index] = val;
-	} else {
+	if (err < 0) {
 		usb_audio_dbg(chip, "Failed to set compressor, err:%d\n", err);
+		return err;
 	}
 
+	store->val[val_idx][index] = val;
+	elem->cached |= 1 << index;
+	elem->cache_val[index] = val;
 	return 1;
 }
 
@@ -579,11 +605,10 @@ static int snd_us16x08_eq_put(struct snd
 	/* copy URB buffer from EQ template */
 	memcpy(buf, eqs_msq, sizeof(eqs_msq));
 
-	store->val[b_idx][p_idx][index] = val;
-	buf[20] = store->val[b_idx][3][index];
-	buf[17] = store->val[b_idx][2][index];
-	buf[14] = store->val[b_idx][1][index];
-	buf[11] = store->val[b_idx][0][index];
+	buf[20] = p_idx == 3 ? val : store->val[b_idx][3][index];
+	buf[17] = p_idx == 2 ? val : store->val[b_idx][2][index];
+	buf[14] = p_idx == 1 ? val : store->val[b_idx][1][index];
+	buf[11] = p_idx == 0 ? val : store->val[b_idx][0][index];
 
 	/* place channel index in URB buffer */
 	buf[5] = index + 1;
@@ -593,14 +618,15 @@ static int snd_us16x08_eq_put(struct snd
 
 	err = snd_us16x08_send_urb(chip, buf, sizeof(eqs_msq));
 
-	if (err > 0) {
-		/* store new value in EQ band cache */
-		elem->cached |= 1 << index;
-		elem->cache_val[index] = val;
-	} else {
+	if (err < 0) {
 		usb_audio_dbg(chip, "Failed to set eq param, err:%d\n", err);
+		return err;
 	}
 
+	store->val[b_idx][p_idx][index] = val;
+	/* store new value in EQ band cache */
+	elem->cached |= 1 << index;
+	elem->cache_val[index] = val;
 	return 1;
 }
 


