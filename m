Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99A326B0B7;
	Tue, 11 Nov 2025 01:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825042; cv=none; b=RxU0TLTIOcU/P5rH58zueAhHKo4NA5utPzGIQj5O4+c7JXtsPGuNz9Y4HjaadrbIpU/k8sQDLdDBLQGR6lntXA4v2mjHDcEVNoPTQ3M639yBzpSwimKMspKLohubnUyHYgKdYK4OO8GAjnx0qQNW9GxDo58cIV8U1If/alMhEOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825042; c=relaxed/simple;
	bh=eFmSObKhbqpxNowZgHgOUc1ZcibYvwGSjXLT7T9BbBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ss0Yd8PcUp1fzZhimqTtdruRlOJLqEYPYB8zM1daGAQyUcHeRnmwaJh9Bciu7h6LynFM3L2qBTYoNAp2sUMba4INEVePB+j8kgxJye9NTNTjM0eyS6JNnog0EjFO6GygU8mS8VrrthpdaFtRuGMhYNffVq98jg0RHo8WbQy994Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jN+UVrW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jN+UVrW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774A9C16AAE;
	Tue, 11 Nov 2025 01:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825042;
	bh=eFmSObKhbqpxNowZgHgOUc1ZcibYvwGSjXLT7T9BbBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jN+UVrW3uw5n4H9Nv4JQn9pT/PwkKtXE0V1HdmgHv1T3OzGGxM0SgfrURIflCgc4N
	 j6qtfzdyDWwrGVlt6vquRGXgxM77YMWLrdTDdtRTdA2uP9RT3YBAdbe+CSRHyZDAhL
	 3LgtsaMscXfCh81NdoXkEHHSDyCZZPIDV7wIgGco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 619/849] ALSA: usb-audio: dont apply interface quirk to Presonus S1824c
Date: Tue, 11 Nov 2025 09:43:09 +0900
Message-ID: <20251111004551.397470490@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>

[ Upstream commit d1d6ad7f6686e208aba06b7af3feef7a7cba61cf ]

Testing with a Presonus STUDIO 1824c together with
a Behringer ultragain digital ADAT device shows that
using all 3 altno settings works fine.

When selecting sample rate, the driver sets the interface
to the correct altno setting and the correct number of
channels is set.

Selecting the correct altno setting via Ardour, Reaper or
whatever other way to set the sample rate is more convenient
than re-loading the driver module with device_setup to
set altno.

Signed-off-by: Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 766db7d00cbc9..4a35f962527e9 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1599,9 +1599,6 @@ int snd_usb_apply_interface_quirk(struct snd_usb_audio *chip,
 	/* presonus studio 1810c: skip altsets incompatible with device_setup */
 	if (chip->usb_id == USB_ID(0x194f, 0x010c))
 		return s1810c_skip_setting_quirk(chip, iface, altno);
-	/* presonus studio 1824c: skip altsets incompatible with device_setup */
-	if (chip->usb_id == USB_ID(0x194f, 0x010d))
-		return s1810c_skip_setting_quirk(chip, iface, altno);
 
 	return 0;
 }
-- 
2.51.0



