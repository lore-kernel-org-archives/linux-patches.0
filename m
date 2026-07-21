Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3AF46AA60;
	Tue, 21 Jul 2026 15:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647972; cv=none; b=fdYMUX6XuBlJFN7/yflSiQ06Bv4Zt3ewpixN9JxfowtObdndHXjxoXUW+cCc56z4IwN8o0X7yZ0/Czp0nPEp48YnZgFIh2BRQHH9+8KXQGvbsSZh0EAMVtJg/gYrT3DaoU/v6eGsjJreQCHx+Gm+7HHTBAMG8bJUPgeHgErEjrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647972; c=relaxed/simple;
	bh=dZhVrZpGxG394/Oq6huReONvRepYIGT3Ivj9eOCrLpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrTxOfydM7yhQLGPRy+82isRVUQj+6daGIlFs0bbSFrN5PebKQrHW7OSN9tRylqs0XF6XJ1xHy42LBbskKvJYr6DXvhtncqpdqnE98Pz3IAFVoji5wjbWzA5aELEkj+uSjZXXdxmpLwNUFC3nrfHYHTN2viIH+EcfnERVEdqJuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMGaHKLG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMGaHKLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578491F000E9;
	Tue, 21 Jul 2026 15:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647970;
	bh=X7YXiRTwezGfC85PApVQAVN2XJxCdeEl5ylBIpzKtTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EMGaHKLGQevemD1fDFnqt6OXT1SugDLicXiCVSyj1uwX86P2se9RRW14GcnyGF+ri
	 gT6Syb0kCYgLuNUfMykyi2xKKhF2fugKqWo7y6FyrI9xpE7akMFFht2b5CPvgzFdgn
	 F/69RYR2TtMtJTRrS5ri+bB86WuIDEZChq5FSqLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 0006/2077] ALSA: hda: conexant: Remove mic bias threshold override
Date: Tue, 21 Jul 2026 16:54:39 +0200
Message-ID: <20260721152552.811437849@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -162,9 +162,6 @@ static void cx_fixup_headset_recog(struc
 {
 	unsigned int mic_present;
 
-	/* fix some headset type recognize fail issue, such as EDIFIER headset */
-	/* set micbias output current comparator threshold from 66% to 55%. */
-	snd_hda_codec_write(codec, 0x1c, 0, 0x320, 0x010);
 	/* set OFF voltage for DFET from -1.2V to -0.8V, set headset micbias register
 	 * value adjustment trim from 2.2K ohms to 2.0K ohms.
 	 */


