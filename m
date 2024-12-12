Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286462185A8;
	Thu, 12 Dec 2024 15:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017417; cv=none; b=CPn8/4yH7Oag48pM13t6+DM1Abry59VGq1cgjzmGCNHh5nClPLZxOMtg+Ip7B1KBCa2tFiTPQWfdjA7lsmwqUK8UWoT2WO9DKEToCdVh6nAw7VtSTjglN8TmWj7Pfnfu2ZSLBlM/yBzeM6CRfTAXF7X8bzWD5iHU02cwtPYphN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017417; c=relaxed/simple;
	bh=uu80/eVw7ntNB/mDz030rPKPke78rbmbYcybIk5ZhPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXnNKyZASJ1Pql94Q8ryDHlz85DbbRe/Zqri9iBBjFtr4dpYxq9FH/i11JtpvA7W3Gi+UUVEDpJpqc18SKLwxqulmxYM5rC8SYqWtWtJHvKccrC/FGHtO1EIifcb36GVVyE8ap3K1+myoy/t3ouKdJtPenvFZgtbiw0qLRElIgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekBzs0uF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekBzs0uF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3C2C4CED0;
	Thu, 12 Dec 2024 15:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017417;
	bh=uu80/eVw7ntNB/mDz030rPKPke78rbmbYcybIk5ZhPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekBzs0uF92a+SD8EuL0sUYze71rLD5FqFLgruqYX1tga4s0yzpbs1d5nQjjUcKqRX
	 2rD5NfbUYa3r0WPn5TRWFpbU5wTFD6z1Rep6dKe1RnX64Kvq8+lYa7QRNaokJ1DvDA
	 JsxDpNWVCg/pMKvjOnR68qtv+/VSI4mqTkOcAgkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 462/466] ALSA: hda: Fix build error without CONFIG_SND_DEBUG
Date: Thu, 12 Dec 2024 16:00:31 +0100
Message-ID: <20241212144325.122032320@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 0ddf2784d6c29e59409a62b8f32dc5abe56135a4 upstream.

The macro should have been defined without setting the non-existing
name field in the case of CONFIG_SND_DEBUG=n.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/20241011131046.5eb3905a@canb.auug.org.au
Fixes: 5b1913a79c3e ("ALSA: hda: Use own quirk lookup helper")
Link: https://patch.msgid.link/20241011072152.14657-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_local.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -308,9 +308,15 @@ struct hda_quirk {
 #endif
 };
 
+#ifdef CONFIG_SND_DEBUG_VERBOSE
 #define HDA_CODEC_QUIRK(vend, dev, xname, val) \
 	{ _SND_PCI_QUIRK_ID(vend, dev), .value = (val), .name = (xname),\
 			.match_codec_ssid = true }
+#else
+#define HDA_CODEC_QUIRK(vend, dev, xname, val) \
+	{ _SND_PCI_QUIRK_ID(vend, dev), .value = (val), \
+			.match_codec_ssid = true }
+#endif
 
 struct snd_hda_pin_quirk {
 	unsigned int codec;             /* Codec vendor/device ID */


