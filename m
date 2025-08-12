Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3344121C187;
	Tue, 12 Aug 2025 19:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025221; cv=none; b=i05Y/Vc00+aiqzWNg/835xz8Tb7VM+1UU/cX03vAJSmQ1VPwKQ+isig2izJzD5yIxDNXz75ItUPku8DLzzl1KYcYqfwP9GAZ+TxDozFBcZgH/rdOqqXDYEkya4Og54/miUx5qooeHSPTSBCUsW/CC6mVUVf+OP9n/TKwLxHLnQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025221; c=relaxed/simple;
	bh=dI6MA/tw7w43nATN1LYg/ij72yT0VduBAjmDwgpWvpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7JtMoirKLPX+BlYpjS7HzdKQtiZYWcyzd4nBY65jJON3F++/Ups+BVF687jzVOr1n6i28JWayspyPkyFcHB7DMqLIa2ifKhDNklc+cdOr5KVXw3lpacZMsQ75glkj2LE5T+1Vh5opu2aiAAEQyAbhDYINKItWRu4+69AoOlOTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJzN3IQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJzN3IQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A08C4CEF0;
	Tue, 12 Aug 2025 19:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025221;
	bh=dI6MA/tw7w43nATN1LYg/ij72yT0VduBAjmDwgpWvpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJzN3IQvo252EbrIkDagRd7ZvYjf0FrepJl4hidzgK9Jm/ZHuRawbAebQcC+YJXu8
	 oFPp4LC2VAcmzCMfMK8ZEuwO/c+xnjYEm9up2vJs0alK1l9+xNXOLnZm8RZgAKZcTQ
	 ty238mOytbbKW/TehxR5LVrRNgn4/mA7pX8PWuOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.16 597/627] ALSA: intel_hdmi: Fix off-by-one error in __hdmi_lpe_audio_probe()
Date: Tue, 12 Aug 2025 19:34:52 +0200
Message-ID: <20250812173454.580897255@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 8cbe564974248ee980562be02f2b1912769562c7 upstream.

In __hdmi_lpe_audio_probe(), strscpy() is incorrectly called with the
length of the source string (excluding the NUL terminator) rather than
the size of the destination buffer. This results in one character less
being copied from 'card->shortname' to 'pcm->name'.

Use the destination buffer size instead to ensure the card name is
copied correctly.

Cc: stable@vger.kernel.org
Fixes: 75b1a8f9d62e ("ALSA: Convert strlcpy to strscpy when return value is unused")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20250805234156.60294-1-thorsten.blum@linux.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/x86/intel_hdmi_audio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/x86/intel_hdmi_audio.c
+++ b/sound/x86/intel_hdmi_audio.c
@@ -1768,7 +1768,7 @@ static int __hdmi_lpe_audio_probe(struct
 		/* setup private data which can be retrieved when required */
 		pcm->private_data = ctx;
 		pcm->info_flags = 0;
-		strscpy(pcm->name, card->shortname, strlen(card->shortname));
+		strscpy(pcm->name, card->shortname, sizeof(pcm->name));
 		/* setup the ops for playback */
 		snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &had_pcm_ops);
 


