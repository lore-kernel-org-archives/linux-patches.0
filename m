Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5048543E9CB;
	Mon, 17 Aug 2026 14:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976075; cv=none; b=o796JhQhCjOmV8KOHZ5J/KBB552kzx1Dh0CLBoEJaYizwY6faNLyApTgaB+o/3QatBYUYgtd7fcjHTHQ66JWtH+o1+hafhl48yWBN/aR2vzYDSsWLuTQwf4dej8j7YBGxqlS+Gr6Lsa57daU/oDXwPVdjxC6lvlWi+Daya2u0E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976075; c=relaxed/simple;
	bh=+sLpmPBMt8uQMCUmkDM1t3QTcRjttbXgIbJxK5jWsAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tiqq4vt6I9lFB7Mx+TPU6iA0cXutsTLjG5mu2x5qzx8SjeGC+DGuBU4N8aaRonwdvYeIQBLKVGuB0dsbhCcSjDHgx0xCnYm4hFSINF1/IQI9nXLufQmJsa2JtGE/14n7ubQ1yvMc6sEW3jgddOv/xtES7ic1Ikc8ePlOeVhBQpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ph6Lh9dT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ph6Lh9dT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECAA1F000E9;
	Mon, 17 Aug 2026 14:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976074;
	bh=9NuHBABXzy0oxtLGaIaAalnOOzcvgfsUjtkpjdjdbrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ph6Lh9dTIVPbR5hfrPzNd/EcrrAv9gTOMwtNtjlKcXu5yDmA5mCw0jRH+MBR8vM7E
	 O7ZLxmtc15LpFQq0aNn3XrkbvUdMtgkWs3nd3kreqRVHTbMqujzY/SnyZb1a/SApcU
	 rGhMEw4sZtco1HsM5QnMqZK/h4A2ThchpXF21jgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 5.10 249/389] ALSA: 6fire: Fix UAF at error handling during probe
Date: Mon, 17 Aug 2026 15:31:28 +0200
Message-ID: <20260817132548.971388459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -159,6 +159,10 @@ static int usb6fire_chip_probe(struct us
 	return 0;
 
 destroy_chip:
+	chip->shutdown = true;
+	if (card)
+		snd_card_disconnect(card);
+	usb6fire_chip_abort(chip);
 	snd_card_free(card);
 	return ret;
 }


