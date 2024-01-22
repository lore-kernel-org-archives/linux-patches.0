Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80705604B5;
	Tue, 23 Jan 2024 01:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974702; cv=none; b=euhL6dwiVjmz8uJrB0TnkSNaJY9aT/XGZgnLOA48qioNXQl5CoaIYdDn2RLh723N8JDpuecH3fjmZ3bxZI44+BHuD2NLbxz/lTbvLYfoAuvctpOOivU5ka8yJRztgNUiJ/feJpXlPZsWMEvFBSD+lFoS+KQEl+i252ZMjP2NeXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974702; c=relaxed/simple;
	bh=lAcsMrMCSxrj53vyZcPD/yRyfNkcbkn2vJ6C7j1EAkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DL6+n5Z1a0PaowiEqbcmfFrSukIYY/ZaJrNsqJa2Bh0uc2VuSefvO1TStma99MTt+40/4YfVNVnPGYEThhpuvu9DNxGJfwte5nCEAJjkPrXvSFEh+pVb0VvViostpPHMdirP2FACDaQuDQoQM1J6unE1aeedSaRV6GnaYtXngvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klvMId6l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klvMId6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B28C43390;
	Tue, 23 Jan 2024 01:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974702;
	bh=lAcsMrMCSxrj53vyZcPD/yRyfNkcbkn2vJ6C7j1EAkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klvMId6l2duA0L3/2xlgZs6deT1L6KnhsODF/3S7H1KalhwaE6tvdDCP2OtQZ4RCB
	 0cxaCynhT04+UYEZo5k2EOLZO/vK91lqGpjtKtI3RX4pCyXvpx4nNmpIicreMC1BuZ
	 c/qm+ul15Stv/u2pvyyEefsNWjBH2qN6mNy5eMYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/374] ALSA: scarlett2: Add missing error check to scarlett2_usb_set_config()
Date: Mon, 22 Jan 2024 15:58:08 -0800
Message-ID: <20240122235752.788428038@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit ca459dfa7d4ed9098fcf13e410963be6ae9b6bf3 ]

scarlett2_usb_set_config() calls scarlett2_usb_get() but was not
checking the result. Return the error if it fails rather than
continuing with an invalid value.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Fixes: 9e15fae6c51a ("ALSA: usb-audio: scarlett2: Allow bit-level access to config")
Link: https://lore.kernel.org/r/def110c5c31dbdf0a7414d258838a0a31c0fab67.1703001053.git.g@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett_gen2.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/usb/mixer_scarlett_gen2.c b/sound/usb/mixer_scarlett_gen2.c
index 6e79872e68c4..f8787a4b1e13 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -1266,7 +1266,10 @@ static int scarlett2_usb_set_config(
 		size = 1;
 		offset = config_item->offset;
 
-		scarlett2_usb_get(mixer, offset, &tmp, 1);
+		err = scarlett2_usb_get(mixer, offset, &tmp, 1);
+		if (err < 0)
+			return err;
+
 		if (value)
 			tmp |= (1 << index);
 		else
-- 
2.43.0



