Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A8F214411;
	Tue, 12 Nov 2024 10:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408219; cv=none; b=WX+coJ5uq9+Fg35AYdx3ti48iOqqmg04t6mwrgjAE4m/EUo/xyyUSHTcuOF8ayiH0K/0EbvSj37BDWK4Fw+NhIrh8Ifdg+lncbyB0XSINVlFaXd+2A0m2+dhxnB/2PmBDVNZjkLqccp1+AZSBovvp5jtKa85pf9e6vPpIMx5DpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408219; c=relaxed/simple;
	bh=jhezMph3gOdpz+xS/Iz/POpEfYnjY6M9wQYKhcVrG0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g13/cRzQPROJjxv6MbvKi0xR9mdkZNRokTcqA92b9c3+cwmZ7izGBsTde4fF0oSWeHKHzgiF0fwshdChnfYEK4YM8K35TODXmrIArfnAekUS5LjPjvMwxEWwGzjJaQRl/ZzOjimkb1ap+hk7TLzZNPx0lHmevS0IPKXFnpPiKng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=in+H0txX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="in+H0txX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01DAC4CECD;
	Tue, 12 Nov 2024 10:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408219;
	bh=jhezMph3gOdpz+xS/Iz/POpEfYnjY6M9wQYKhcVrG0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=in+H0txX7vTpaWMD0d3PxAu/un7ROlN0iNRcYr8c2tlhcmV678eHp/llTybxcWyQ2
	 G5yGjtSA26hUMqf+8LQO4/Fh+01b2pFlClsbc7qVBMmyweesrU2gZDTpBOG8gMUmx3
	 7kUChjoCIy5P3Zv7RjWmSJOTGEEkM6YYPDn96ggU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jaros=C5=82aw=20Janik?= <jaroslaw.janik@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 064/184] Revert "ALSA: hda/conexant: Mute speakers at suspend / shutdown"
Date: Tue, 12 Nov 2024 11:20:22 +0100
Message-ID: <20241112101903.320628868@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -205,8 +205,6 @@ static void cx_auto_shutdown(struct hda_
 {
 	struct conexant_spec *spec = codec->spec;
 
-	snd_hda_gen_shutup_speakers(codec);
-
 	/* Turn the problematic codec into D3 to avoid spurious noises
 	   from the internal speaker during (and after) reboot */
 	cx_auto_turn_eapd(codec, spec->num_eapds, spec->eapds, false);


