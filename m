Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069A72BB1B;
	Fri, 15 Nov 2024 06:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653737; cv=none; b=dfIWROBWEtprYr83kxv4acP3rdLS3rgODNbLLrvYaqq0QPUQi64lBFDnIj3pIBpTGs+GPN/ut/eD5nAKTClDihNC0ca4wbgCJ65Tmu8l5VPfO+bzBR3XQFEdPlXwz8QhdUZgYvIXJtmQTZLrH3/o7666MKhDxauNUC+gEGuD5DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653737; c=relaxed/simple;
	bh=+u8+vwWh3zTal6U3C67+2hyCpyFbxOY44amFte/4iJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QHFQzN2bo6cZhsxW39hYg5HXNmjzR3Ib+ZusbQPw9HUeUmuM0yKFbw51J27x9lyJUnXGPMOCX3OvJvjl9N9Hnl7RyxJIb/ePyQf+LZq263oXp6M06pTMQCbPwi1vdqTlCfHDpPu6JXwqIyRH2KyWT+9e7ZScNJppe3wrEK2ufYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9/cSzZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9/cSzZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEFAC4CECF;
	Fri, 15 Nov 2024 06:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653736;
	bh=+u8+vwWh3zTal6U3C67+2hyCpyFbxOY44amFte/4iJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9/cSzZDwY6Z9qrCG4vYkXUwMA8LM3jeZPFg8JFYIafas84AcT1/Dm0b9j+Vax2qo
	 A7uYFKU+pYcmnrDCcFXoA/iiwrBfTzZbnTTbhgkco46lCKfJoO2wuyvZaVfpa4qdn/
	 +zgMHfYvlRhSbHSkHuLCsOY55PRcLJ039usmFOCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jaros=C5=82aw=20Janik?= <jaroslaw.janik@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 21/82] Revert "ALSA: hda/conexant: Mute speakers at suspend / shutdown"
Date: Fri, 15 Nov 2024 07:37:58 +0100
Message-ID: <20241115063726.329882268@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarosław Janik <jaroslaw.janik@gmail.com>

commit c9363bbb0f68dd1ddb8be7bbfe958cdfcd38d851 upstream.

Commit 4f61c8fe3520 ("ALSA: hda/conexant: Mute speakers at suspend /
shutdown") mutes speakers on system shutdown or whenever HDA controller
is suspended by PM; this however interacts badly with Thinkpad's ACPI
firmware behavior which uses beeps to signal various events (enter/leave
suspend or hibernation, AC power connect/disconnect, low battery, etc.);
now those beeps are either muted altogether (for suspend/hibernate/
shutdown related events) or work more or less randomly (eg. AC
plug/unplug is only audible when you are playing music at the moment,
because HDA device is likely in suspend mode otherwise).

Since the original bug report mentioned in 4f61c8fe3520 complained about
Lenovo's Thinkpad laptop - revert this commit altogether.

Fixes: 4f61c8fe3520 ("ALSA: hda/conexant: Mute speakers at suspend / shutdown")
Signed-off-by: Jarosław Janik <jaroslaw.janik@gmail.com>
Link: https://patch.msgid.link/20241030171813.18941-2-jaroslaw.janik@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |    2 --
 1 file changed, 2 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -181,8 +181,6 @@ static void cx_auto_reboot_notify(struct
 {
 	struct conexant_spec *spec = codec->spec;
 
-	snd_hda_gen_shutup_speakers(codec);
-
 	/* Turn the problematic codec into D3 to avoid spurious noises
 	   from the internal speaker during (and after) reboot */
 	cx_auto_turn_eapd(codec, spec->num_eapds, spec->eapds, false);


