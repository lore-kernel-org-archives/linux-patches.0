Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4ED383983;
	Thu, 30 Jul 2026 15:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426722; cv=none; b=kYWOxrKWcENIfX/DYXkAOLYC6hsGehgjan5n8W3OzXJ/oOs6XfWOry0di6xgPu/VkJ0E4FQRNf3KklpijNEiwtzR51WsAPT+RD0s+7fCQi5aH6zLzOvGG9toll28h4zQSacJOTVlEGDlLrJal3VPUc4YEBCW8uqRh5I2bByK2hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426722; c=relaxed/simple;
	bh=5WN07/uK3nJjTlhDHSfYPJlBW7tIZsZvQ3Czj7NLIXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwM7aIZeislvgR6xnbuS5w8whtPErLul8hTjrqucnuO73P7itO8xPBTS3m5UNKT+TiHZZPGwREliDb+vsDAYJDN8LfbTjATPZkBpj8D+8DAauOR/A8/8peqGlDPGOXbViUTz9QuU+sZRgbwy7UNPxbah+Elva2GdBmGU9nbD2bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0JniCfP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0JniCfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131B01F000E9;
	Thu, 30 Jul 2026 15:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426721;
	bh=slDGq+hWqNAeNChvPV9joSC32o6GkQpCOQBbh4ysfiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K0JniCfPONzkXZ19W7aVRPD5i/32CIbz+i3DV1DX468mKR+YFRh0E22EeW+eetthr
	 NucFwVMShUBzhCzbbCipPJvdnkdISjSrwbHAxmNgHPMdT23BotzokyziJCkkc3QAYV
	 M3Zx7ShodDdYH/Utw55C1FQjYbmLNaERio0M/wsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 475/602] ALSA: hda: conexant: Remove mic bias threshold override
Date: Thu, 30 Jul 2026 16:14:27 +0200
Message-ID: <20260730141445.945963421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit f52524da7084c1a54683ae9fbc73e93fff19dd64 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -168,9 +168,6 @@ static void cx_fixup_headset_recog(struc
 {
 	unsigned int mic_present;
 
-	/* fix some headset type recognize fail issue, such as EDIFIER headset */
-	/* set micbias output current comparator threshold from 66% to 55%. */
-	snd_hda_codec_write(codec, 0x1c, 0, 0x320, 0x010);
 	/* set OFF voltage for DFET from -1.2V to -0.8V, set headset micbias register
 	 * value adjustment trim from 2.2K ohms to 2.0K ohms.
 	 */


