Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30AC6EB61;
	Tue, 23 Jan 2024 02:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975420; cv=none; b=MAF/Y0QeS7XgUz+CuPWZ1MrYb4pX+0bvQ4Esp40y2mLZWh6MC3NrI2RABLbNLlEUooPDG9t5/ObpxkfeDcDGGf2brpHD+/WCb4fZqHBWdXWVh6U5l/hfNqWmBl3VPF3RNzYQq/dd9I0MWoDTdVQ6t/indy5kvl1KFVfZbE6uGxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975420; c=relaxed/simple;
	bh=cJ/JM91PdubmAT4Hs4oZEAmOPBY37Du5kkh6M8Rxiys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nfl8HWiW56R6h6h+rmS4dPMSb/3YCLhflO+TuG9CTPHVyXoB0qfUB7aLfF4KLRpI41HPeLfuVtU2xVnUCUJ+FkYWQgvTdhnoWwXbBK6S0rlqNsHr037JpLqVKSqErRBfoUuM3KharCJ9KEO93doDAcAo+Y0179+zBXz5haDCpWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1H3Az8uF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1H3Az8uF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A13C43390;
	Tue, 23 Jan 2024 02:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975420;
	bh=cJ/JM91PdubmAT4Hs4oZEAmOPBY37Du5kkh6M8Rxiys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1H3Az8uF9s0/YyOZPg9HkC0QZuasLuli+FBAz84yBqz3h/4TsRW8kbEvrzE39qwYS
	 IU8tJMl3DpZoZ1C4Pnon3G5aXmTfumfoQ3GtBHvpFJNS8rxkE20XvHa43SDoLIhWX/
	 0VfOo+18h5/KvaNV/h+ZN+3VYvslar7UDayrU2gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 379/583] ALSA: oxygen: Fix right channel of capture volume mixer
Date: Mon, 22 Jan 2024 15:57:10 -0800
Message-ID: <20240122235823.602983763@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit a03cfad512ac24a35184d7d87ec0d5489e1cb763 upstream.

There was a typo in oxygen mixer code that didn't update the right
channel value properly for the capture volume.  Let's fix it.

This trivial fix was originally reported on Bugzilla.

Fixes: a3601560496d ("[ALSA] oxygen: add front panel controls")
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=156561
Link: https://lore.kernel.org/r/20240112111023.6208-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/oxygen/oxygen_mixer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/oxygen/oxygen_mixer.c
+++ b/sound/pci/oxygen/oxygen_mixer.c
@@ -718,7 +718,7 @@ static int ac97_fp_rec_volume_put(struct
 	oldreg = oxygen_read_ac97(chip, 1, AC97_REC_GAIN);
 	newreg = oldreg & ~0x0707;
 	newreg = newreg | (value->value.integer.value[0] & 7);
-	newreg = newreg | ((value->value.integer.value[0] & 7) << 8);
+	newreg = newreg | ((value->value.integer.value[1] & 7) << 8);
 	change = newreg != oldreg;
 	if (change)
 		oxygen_write_ac97(chip, 1, AC97_REC_GAIN, newreg);


