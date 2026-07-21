Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D15746D0A1;
	Tue, 21 Jul 2026 17:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655471; cv=none; b=HYgcBELuqtcvxt7m4VbwZ533L7IJz/5D8tYh9P3DBMJO+74YQZSB6uVpE7VIDoOneoBnsb2B2G8Mt81zq4f/otVss0vKwGTHY+vhsxOizbdCTZe9idUFfnu+L/+ZN8BKv4eRxID7cZAAk+oGPX1rsM8QvsHXtv5cCkkNFKBRI0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655471; c=relaxed/simple;
	bh=ePaurNtlTx3o85tZK3cxgnMYo6J8NifZhJGOW29xU1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfihJQu7aJthW1YlyPNAHq8ijXsPdgE3Yr86BKEK0NjXA2oYEhHiqUFo3Wd2f+tiWSRTLXJZVgoBSS6Ati4aj/4UrXLLDp2xZWbf7rADUPrLY5V+x7UOGNb0rBLQ1e1wv3GNJlAF5zuBxX9JGge67+dm+OuWaA3mmu/UFpdiIRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGH8EQZW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGH8EQZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2C21F000E9;
	Tue, 21 Jul 2026 17:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655470;
	bh=za+SZzklFTCOcW/ooLymU1+/tX7ImGduAZ7KjsMc3yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGH8EQZWTe0VzBV+0spcK3vNOxUtosrOUq38FD5KBKSvOiaR5gBQv4q9gmIrR0Mi5
	 0gUmMpG3b4ysw2e6Rj2sPZYC4+uQZxZBjgDyxa1rL77a3DjqdxT9CiHYEFsIL44x4e
	 vjHRIeNmctdx8y3JyKzuDfQNM1yzFLR2o+gGeXKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 0022/1611] ALSA: hda: conexant: Remove mic bias threshold override
Date: Tue, 21 Jul 2026 17:02:18 +0200
Message-ID: <20260721152515.299402533@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

commit f52524da7084c1a54683ae9fbc73e93fff19dd64 upstream.

Remove the mic bias current comparator threshold override (NID 0x1c,
verb 0x320, value 0x010) from Conexant codec driver.

This override was originally intended to support volume up/down controls on
headsets with inline remote controls, but it causes microphone detection
failures on some headsets with impedance less than 1k ohm.

After consulting with the vendor's engineers, it was confirmed that this
setting is board-specific and should be handled by BIOS/firmware rather
than the generic codec driver, especially since inline remote support
is not currently implemented.

Fixes: 7aeb25908648 ("ALSA: hda/conexant: Fix headset auto detect fail in cx8070 and SN6140")
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260713100329.306892-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/conexant.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/sound/hda/codecs/conexant.c
+++ b/sound/hda/codecs/conexant.c
@@ -168,9 +168,6 @@ static void cx_fixup_headset_recog(struc
 {
 	unsigned int mic_present;
 
-	/* fix some headset type recognize fail issue, such as EDIFIER headset */
-	/* set micbias output current comparator threshold from 66% to 55%. */
-	snd_hda_codec_write(codec, 0x1c, 0, 0x320, 0x010);
 	/* set OFF voltage for DFET from -1.2V to -0.8V, set headset micbias register
 	 * value adjustment trim from 2.2K ohms to 2.0K ohms.
 	 */


