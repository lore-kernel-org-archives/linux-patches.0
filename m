Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F43347ECF2;
	Thu, 20 Aug 2026 17:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247981; cv=none; b=KEUNPh2ffU2+qc8UZq4Dam9M/j82jdf74urdbltKdKOZSTJjJP4UMpVIG9WQxjWbRcxfB6UPWGifAUlu2szIcDNyq7seFmGVBV+4wBNOHqyO3DL+kD67SdJPv19z410zUHR26mnjJ4nbITLxlryNgBrIRrsej4AkeW3zKlS57RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247981; c=relaxed/simple;
	bh=ihsJtOXIQSSVIktoSN2uiAvq9iy2CHcnB5EhEqcWhAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwWLOYSUCptgEfGhMXLEwjE9Ren1wgDTJa2DKh8xkPur8+P1VYjrVqemy7fxjCmNaLFMqZSnvaxwFjL+pdm8JVUWeBWzi374oDSYjYbc92hATpPtFxvcCASSSDfXXD+Dg208xq0tx+8cShVIEf3leNtmPIdfp9+mAivDYogIWWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqNLihim; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqNLihim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9651F00A3A;
	Thu, 20 Aug 2026 17:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247980;
	bh=Ed6gU4qjbnSTXoNXviwWaBR8JIoo1nrxRDYMso1UFdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XqNLihimfESmITnSHA9+j8wcC7M2uBf6JPplTxMJ7Zd2QL8hpi7BFSz+5KANO8bkg
	 fkgKdbFIADkN7e8exrSueM4IjzsD+4+TzwLz07wjboJ09ZIBcwllXmcbvMX9FuEkT0
	 fIX6mGWIRNM3dusUNzUG1Rl9noUjM/oGt14kzNFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/303] ALSA: hda: conexant: Remove mic bias threshold override
Date: Thu, 20 Aug 2026 16:53:26 +0200
Message-ID: <20260820145255.269211680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


