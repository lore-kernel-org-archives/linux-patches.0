Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09D92E5B07;
	Tue,  8 Jul 2025 16:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992507; cv=none; b=BSP6Qbp9+UtzUKEKgVvo0/AMMVgkFIz8/UdLaQe7EExxmWWg7BBmfUxVFBg43oj+mzpa8WERhDV5N5FEuwzk47/6XBFttcKlxnpUzW/wbZZltLo7B+JtXOHAl80KCdDjvcPNaNgu/N9Wl6v0fVSneVEapg5dmv9jYTRbCZLnC68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992507; c=relaxed/simple;
	bh=BAXOkVnoPMw9nrgOfZEoSV9CRSdZyl487TyE6mxu7NA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEeYnVTGuj29XAjT7CxgSyY6q7Xrj2OH/LmdLF3QyCJXsw/2l7x5tOiv5493h7w34MZ/eMwV2Fn0YMen8EBxMwtn+YMTOmlWSxwnKziZ77B7AeO/yeJ8HE3KWOM8v59P2gB+VmmwmXHc0qALr5bmr6k9oQVOPgl/pI8PjKEqcuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BVhLnp/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVhLnp/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199DCC4CEED;
	Tue,  8 Jul 2025 16:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992506;
	bh=BAXOkVnoPMw9nrgOfZEoSV9CRSdZyl487TyE6mxu7NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVhLnp/I0tNkRN4cwfKtKdXmMlez3JuQFMAfi7YQeUVDyjkHDesKQWU8mo7Y0CLzG
	 Xrx6O7Cou3QTgtlG6PnaqhOL25sQCuuoLpXGDEf8HkfdL3RkNfUnXVglZJtx0VWs+w
	 bk7u0+eWcO4QS4ntn4ruk94rg+mfFmVGI8xlut3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/132] ALSA: sb: Dont allow changing the DMA mode during operations
Date: Tue,  8 Jul 2025 18:23:15 +0200
Message-ID: <20250708162233.091337706@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



