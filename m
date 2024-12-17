Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705FC1F8AD2;
	Tue, 17 Dec 2024 17:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456415; cv=none; b=DR5t5//tabqFXWHsSllMb9njY0hRPzH79FUF6iywkHwreRhaRyGIAy+lHX8qkYm/gfIWaS/rtAHoUK3UieLYrczqXHguzL4QIWzGUXRpLSfQZjpqJX8DaqP3ADWfIKSL/skq8Rrx4pDypOixncb5bpANZqD9b89nivA5+8fh5tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456415; c=relaxed/simple;
	bh=PzSSTBFKJwhXq6/PgnA61TEJxI1BtPmgtm2lMSPyItg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dgk7h45XgqVu2ewDQGB8Rr2Y/2NTe2nPar1QA4qWzfiCsrwFt0ImYVY+x4sDmU4k66oJVMPDXsvFYEU9Sfc7nmSdAmHFq9RKLzHbT/v6A7Y7vyLWF212hKrFvOoHtPec3FiKwAzWjtCav1Bo0h8+ZJb4VzSbXbzH/12hAmWECWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9YILZZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9YILZZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB790C4CEDD;
	Tue, 17 Dec 2024 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456415;
	bh=PzSSTBFKJwhXq6/PgnA61TEJxI1BtPmgtm2lMSPyItg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9YILZZI5PqPJmCrmqDD76e2prbzIqZWjlJpquoVnXldRUdmUY3bk3SWWFJOfLDXV
	 S+VjAsoJqEjjUWfORpxzsDwRKhvBSpvfmoN83DpXlrd0BWSL6MD+fzZ9+Wc9IHxCBS
	 pYP31kNIQSlD82Ivt4f7ArLV1nJHOIdgYyErnkfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 045/172] usb: gadget: midi2: Fix interpretation of is_midi1 bits
Date: Tue, 17 Dec 2024 18:06:41 +0100
Message-ID: <20241217170548.133114509@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 82937056967da052cbc04b4435c13db84192dc52 upstream.

The UMP Function Block info m1.0 field (represented by is_midi1 sysfs
entry) is an enumeration from 0 to 2, while the midi2 gadget driver
incorrectly copies it to the corresponding snd_ump_block_info.flags
bits as-is.  This made the wrong bit flags set when m1.0 = 2.

This patch corrects the wrong interpretation of is_midi1 bits.

Fixes: 29ee7a4dddd5 ("usb: gadget: midi2: Add configfs support")
Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20241127070213.8232-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi2.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_midi2.c
+++ b/drivers/usb/gadget/function/f_midi2.c
@@ -1593,7 +1593,11 @@ static int f_midi2_create_card(struct f_
 			fb->info.midi_ci_version = b->midi_ci_version;
 			fb->info.ui_hint = reverse_dir(b->ui_hint);
 			fb->info.sysex8_streams = b->sysex8_streams;
-			fb->info.flags |= b->is_midi1;
+			if (b->is_midi1 < 2)
+				fb->info.flags |= b->is_midi1;
+			else
+				fb->info.flags |= SNDRV_UMP_BLOCK_IS_MIDI1 |
+					SNDRV_UMP_BLOCK_IS_LOWSPEED;
 			strscpy(fb->info.name, ump_fb_name(b),
 				sizeof(fb->info.name));
 		}


