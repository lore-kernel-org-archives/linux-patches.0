Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E5F46D567;
	Tue, 21 Jul 2026 15:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649211; cv=none; b=Wcolx2GoCUnYzimg5j5RS8scnIpmNWSJCsp7XVhTENg9m1RoMADoqqqOxiI6/jwcmZHM9sf9x+/bbK4MzCZlQ8om4XoOHNLJlMAEbv17rvS86vPWg7/u0BbDSMIbaTwJE+/oVeFd7i6zlpoApobazeu4L+cusKrviziDpOLdfWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649211; c=relaxed/simple;
	bh=2nI3QvBoU+p+D/K0gVLbzBCSQSbnt9gf4fmksHIOnG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=poQ+nD2DPNocjAnLu4iq1DBvNdAhrsNI9P5qhieWmNyZ55sAfwqIZWGkzj6fN/eycoyiL6Wf/waaAlnKF7jsuu7fkGuJ6HXFRIcO6OVrH7EW2V2BFvys3zLS4gqQ3SLfwp9A/rn6+D+3KOGjoBz0TTypuhsu6boZ1kEdnm69Ufs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJNRs3Dk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJNRs3Dk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8371F000E9;
	Tue, 21 Jul 2026 15:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649210;
	bh=uPG4b2bGEwj9H9NZi7ow3nv1yGf+Nl/yJNcJu+qC0H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJNRs3DkBZafXGvLAQLRkDLNjGwpuqeoqo2HI3Mc+aE24TpbEjUwfpxBjhHHyCXpQ
	 Iy56kpKRCzTXBBgIIXhTkT/JN+aX+nnVP28Tbq/IkYSy3U/HtXGpfTqJujBmQUlXOH
	 DOU41f0DEqzYrkmLIkQf2Ca8EAgtYdehNiY60Dr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0491/2077] ALSA: usb-audio: qcom: Initialize offload control return value
Date: Tue, 21 Jul 2026 17:02:44 +0200
Message-ID: <20260721152604.389655830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

[ Upstream commit 2b5632d72fca0841bea283da2e3a478d24118508 ]

snd_usb_offload_create_ctl() returns ret after walking the USB PCM list,
but ret is only assigned after a playback stream passes the endpoint and
PCM-index filters.

If all playback streams are skipped, for example because there is no
playback endpoint or because all PCM indexes exceed the 0xff control
range, the function returns an uninitialized stack value.

Initialize ret to 0 so the no-control-created path returns deterministic
success, while preserving the existing negative error return when
snd_ctl_add() fails.

Fixes: a67656f011d1 ("ALSA: usb-audio: qcom: Add USB offload route kcontrol")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260605-alsa-usb-qcom-offload-ret-init-v1-1-dc72fcc4bd3b@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/qcom/mixer_usb_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/qcom/mixer_usb_offload.c b/sound/usb/qcom/mixer_usb_offload.c
index 2adeb64f4d33f4..005138714f7249 100644
--- a/sound/usb/qcom/mixer_usb_offload.c
+++ b/sound/usb/qcom/mixer_usb_offload.c
@@ -113,7 +113,7 @@ int snd_usb_offload_create_ctl(struct snd_usb_audio *chip, struct device *bedev)
 	struct snd_usb_substream *subs;
 	struct snd_usb_stream *as;
 	char ctl_name[48];
-	int ret;
+	int ret = 0;
 
 	list_for_each_entry(as, &chip->pcm_list, list) {
 		subs = &as->substream[SNDRV_PCM_STREAM_PLAYBACK];
-- 
2.53.0



