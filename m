Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52D047427A;
	Fri,  7 Aug 2026 15:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117255; cv=none; b=a5yb/IpDb7nly/EGBNu6T4CLRZ9Utxm7klDODSP0WvH3jF6cYZf3GWDJYwticW4KNSi5/hUbkz46PwRIvTcvfX/q/GlUwjPXquemzQYozrMQRISsFNguOTn6vaLf/fiSjWNjIP0tWZaCXp8RlU6RrcVMMc39mwb+U5gaTuZMs6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117255; c=relaxed/simple;
	bh=O36Q+o8+S8Dmx5O5mG9KIAEVku+hfI/g9ldwAUwgOf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmMAOy6673fzGfHhPc/GjE+HRUnXDALVh8q9VZIfwarfrlUO7DrgmuiCrIyl9/ZPV4OG++pCG3WznogLqfGxpefIu6eLqYbb2MNfxR18cziZqWsndm+dprOEj9Vd1v+cD9d8Bb9hFlTIp6Iwl7Qv649kfdFgN98ICOa5twIMBlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjmtl4/m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjmtl4/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFA71F000E9;
	Fri,  7 Aug 2026 15:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117253;
	bh=OHzY2ZFMyNOLZ+2TD29S2pTWkjdm9pzwVqAdIHzjB2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jjmtl4/mg7NWV8D6lvzaDE0On6AFNCL4Aqjpq9KrAYDDwT4g3PHm3tv5lyISsdDjP
	 FkIaugGl1kjYEwd1QQZ5lewOAh76mhT0a7GM2Pkid44XJYgcguCgKpcG5WJ8VKgOPk
	 odi7IBmzLItRPipXqa4Gik8o7tK6cTtIOtzsi1zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 7.1 252/438] ALSA: 6fire: Fix UAF at error handling during probe
Date: Fri,  7 Aug 2026 16:37:28 +0200
Message-ID: <20260807143433.370783201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit a54bf16965f896415c3337bc4fbb40fb11941d99 upstream.

Although 6fire driver had a few fixes for dealing with the early error
handling during the probe phase, it forgot a pending URB before
freeing the resources, which may lead to a UAF.

This patch addresses it by doing the almost same cleanup procedure
like the normal disconnect phase at the error path.

Reported-and-tested-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Closes: https://lore.kernel.org/20260724030900.1984491-1-shuangpeng.kernel@gmail.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260726074821.2288158-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/6fire/chip.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/usb/6fire/chip.c
+++ b/sound/usb/6fire/chip.c
@@ -150,6 +150,10 @@ static int usb6fire_chip_probe(struct us
 	return 0;
 
 destroy_chip:
+	chip->shutdown = true;
+	if (card)
+		snd_card_disconnect(card);
+	usb6fire_chip_abort(chip);
 	snd_card_free(card);
 	return ret;
 }


