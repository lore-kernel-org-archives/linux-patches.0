Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2551427B;
	Tue, 23 Jan 2024 02:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975357; cv=none; b=sIJz3N2PsDnrVdoMwEgfC83JRbxCzDlWKBX0/JWDs6TXgzWoFhZ3aU7lJ5yALk0G4XHMqgbOlL3aqh16EVE4ukh/ID4wTWhfn29DOlCmEUIPMmUZ/dQ5KkZJbajpOLAgv4j1saao/ut8YHvrBzSs4j5RsJS1G6kNlxHo2vjR+28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975357; c=relaxed/simple;
	bh=YVkPGHX4Ji2RAgKd45qqXRo7lankmFTwKf0C4cWuVD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4b0XGJamGdlL+KjSmpazA1u289ChQ7ThweT2p1+ilD9Xa0LPiibn9VbL+jcO8AsS5rGvaqdo5kWEwIHYhhAMbJOna0h47F2xSLx/niIU1in2B1r8Ckp+ilg9CdWj/tHDvAFE6uyeR6+e53QNqrIrI8vRfPVp69kc+lLwL0iRT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgmVCuas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgmVCuas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943BDC43390;
	Tue, 23 Jan 2024 02:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975357;
	bh=YVkPGHX4Ji2RAgKd45qqXRo7lankmFTwKf0C4cWuVD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgmVCuasnI0afjcpM+xuSnMPsUDtkpMcvlrbvOJFgUcnj6y7fqykGN1hZozZMFVQi
	 cW1SWOiJWrJ5onDIzpVeFrDWvCeKds9p7Y7XF8NRwzVqcdQz8nXdw9DoFVCwBTKTSl
	 niB4/94+yZoz+wszYPq6Fqh/KSb+23uDpXANoTqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 320/583] ALSA: scarlett2: Add missing error check to scarlett2_usb_set_config()
Date: Mon, 22 Jan 2024 15:56:11 -0800
Message-ID: <20240122235821.843088144@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 64cfe2d6045e..834b936e7106 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -1390,7 +1390,10 @@ static int scarlett2_usb_set_config(
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



