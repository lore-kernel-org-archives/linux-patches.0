Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B1512BF00;
	Tue, 23 Jan 2024 00:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971388; cv=none; b=VoEgZdrP7nTJdCCaDkmXPywbQxqhi5AG1XvEODH0muWQtct05ifPmY8wZSZwo6BFip7fQ2XdEkb9HF0N/Ivie2h+SjaTVE58meOOjWLiqXoK/bMUzV94j9jKA7VZ4ST+0D6+vrSShryhMYwFENlO9pxfdmpchEaTDvtwWLI2/nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971388; c=relaxed/simple;
	bh=bfh4EteW1RJGLJXJBV7OFKmRE+OUtqbCTSL5zdk1kR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGSlIeua2g7PVmCcPv7+3RCIHZqYDgZzCODbHxl8VzbAvTSE2w6L4Rkrn4kKzM6cx1ulKcLduzjbgsYjT7yUokYMlpRvXcUM5ovo1Yb5tt3K7CdB0aZcX5xLxEvmsab/4xDg0qGvFCAuIdUmuc7H8jmRh0giQ6wzvEqeymDd0Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3uQ75e4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3uQ75e4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475C0C433C7;
	Tue, 23 Jan 2024 00:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971388;
	bh=bfh4EteW1RJGLJXJBV7OFKmRE+OUtqbCTSL5zdk1kR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3uQ75e4GXGafHC2ZLdeEidOburFvq39XPHcnLGD5BuQkI22dJdGd72lPxz+K82Ne
	 ElPd5afKpz8FKkVkVArqdACwW4SRyjBWaBkI/DwiUXb0rmkrCwmCESnhRA/gm8fbnU
	 y+TkkomoNSs0QYTzx4FWjpCEXJcmjiAJ/AjHY7To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 233/417] ALSA: scarlett2: Add missing error check to scarlett2_usb_set_config()
Date: Mon, 22 Jan 2024 15:56:41 -0800
Message-ID: <20240122235759.963324793@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3da0d3167ebf..94704581865b 100644
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



