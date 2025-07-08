Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7370A264F9C;
	Tue,  8 Jul 2025 16:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993056; cv=none; b=eNG25BAl8hoiJ5RvfuypdAt1XwRFhC5RE1dLVHeeqM7jFhOk+PNTV3dVSYXYe0GmDDsmEFpe6pu+aWvm6lQs9WIInH3ckfvvy0A6aPSpPoHZthspAdPMNAzNqyR4aZYVG2VTv6E0ccpIZIMOqxZ7OIFf844RS9z3tdbeQFczkp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993056; c=relaxed/simple;
	bh=CYTyjNrFuwol8+JBs7jqnvN+kANCkeKe3FHc2ruLGjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpylgKJElbkc1gEGyNlInJIBxINSJ/4uCZbTRTLa+FVAO8EzbW/ZZexI74EWryTx8FA47rUMrAkw8jhM5wzst0YF8Q7WRanOXSJrBMb3sG2uNcZn7lZaOYSYbv1c/1T/U/f0HOsxTyuas4fL1HEmjt2DH7l8Xk0QwYI1LyLJM6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9N03xD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9N03xD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F387CC4CEED;
	Tue,  8 Jul 2025 16:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993056;
	bh=CYTyjNrFuwol8+JBs7jqnvN+kANCkeKe3FHc2ruLGjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9N03xD8WZNObuBwjm9Aow23fXdl/ND+CyBHzd9noNiVqL6jlazE12jUtQq3mzU5e
	 ZNXIpiUCQKTWjdtuNC7u/wGkf6VyI6+z1DiKFjZpsRmnLJiluMG9A8ZP8LMtSeP19f
	 REFbF+ZDnlk+/1KpU9L3j/3AhCDZJ4VwKM9p6Sc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 173/232] ALSA: sb: Dont allow changing the DMA mode during operations
Date: Tue,  8 Jul 2025 18:22:49 +0200
Message-ID: <20250708162245.967305663@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 74db115250030..c4930efd44e3a 100644
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



