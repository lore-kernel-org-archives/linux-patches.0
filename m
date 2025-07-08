Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418FA217722;
	Tue,  8 Jul 2025 16:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992065; cv=none; b=jvBM9tANQppRtpXBcaIctVh/7XLfPK84jH07fZahIthQLvKeUrTT702+p8jKaf32RxZ935dOC71w42VffvUNF8yUCTrKLcfBhM/7ek1NnIKsz3Xjwyh3LFc6BACqv25v98a3WoXVMD/eVx47p8sa2rHtGoR5uc4HHth0hZUa6H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992065; c=relaxed/simple;
	bh=J6Ycl9taQaXipIe8Ow1V3YIS+EbQNHODf4oc+JxMylo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHmKPR5OHE2zn1bafiwBN6hT72hHb1UHnXoeS/Md3Gf9E+CZQ7VAlZOQjooo+Nyc76VsqwwiPPIq9lhGUYYxi3I0m0gkda4DtcVUs631rxHmJmcr65jwnXiuCSOgHpmTAqFxZaUvRlBbMsSyHs/8KRvSfIsO0YFQaYMI4RWbV2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdRXPWzB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdRXPWzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5E1C4CEED;
	Tue,  8 Jul 2025 16:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992065;
	bh=J6Ycl9taQaXipIe8Ow1V3YIS+EbQNHODf4oc+JxMylo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdRXPWzB2ytytgk7Mhm7y/d0BkZOKLwSTLfZCLfs3O9icq+eedq8Vt8MSVAnPUm1r
	 0WKDWD/0vlsw/PXQdOuKc2nQYDih+44zkXk8xW2FAPIV14VRq6hCX9xdETMUm1wq1z
	 XgRjiPEaR/7M6XqX+BEyUmu2q5A8bl3eqSDfN8YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 46/81] ALSA: sb: Dont allow changing the DMA mode during operations
Date: Tue,  8 Jul 2025 18:23:38 +0200
Message-ID: <20250708162226.488038113@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ed29e073ba93f2d52832804cabdd831d5d357d33 ]

When a PCM stream is already running, one shouldn't change the DMA
mode via kcontrol, which may screw up the hardware.  Return -EBUSY
instead.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218185
Link: https://patch.msgid.link/20250610064322.26787-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/sb/sb16_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/isa/sb/sb16_main.c b/sound/isa/sb/sb16_main.c
index a9b87e159b2d1..5efbd0a41312b 100644
--- a/sound/isa/sb/sb16_main.c
+++ b/sound/isa/sb/sb16_main.c
@@ -703,6 +703,9 @@ static int snd_sb16_dma_control_put(struct snd_kcontrol *kcontrol, struct snd_ct
 	unsigned char nval, oval;
 	int change;
 	
+	if (chip->mode & (SB_MODE_PLAYBACK | SB_MODE_CAPTURE))
+		return -EBUSY;
+
 	nval = ucontrol->value.enumerated.item[0];
 	if (nval > 2)
 		return -EINVAL;
-- 
2.39.5



