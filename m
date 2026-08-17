Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C4D3F1ABB;
	Mon, 17 Aug 2026 15:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979935; cv=none; b=USw6IQVnZNnPmxD9JXdIBWdDchigGk5ZZ6IHRR13W2DidEEF+5PW1R5pdIMVFwqdTNCmTWkyNABta2oODGijdvqVVwHYX4LmJjuX7Jh/EyUzl6+YgTskxDYRpUQ8jsPDQN8zEkse3c7kr+uBueHhMTJfZLgk5Gaa2b0gKJiKqss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979935; c=relaxed/simple;
	bh=dYf084edICvJvarZNlWHKxvJ80zldAkbDYsYmpOHYvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIZKRRGxinfFivL1EFJjNOxcUbaD8RlPlwyj0GA6IHzTtLs7Vlp2zL6h/hsQ+aJhIc7CiZ2DdEX0eSEh0TeLQTmNYP1pujUjn3sk+923HtKTmqc1EJyUJOHtTGyCUIAouM8qxzOh3c5m9gm8mA16wAOQruHOa8PubdGYhbGl3l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gng2Ei+6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gng2Ei+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5A41F000E9;
	Mon, 17 Aug 2026 15:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979933;
	bh=3X8nC6kO5feXrMm5FvogwrG6A930ZJiXRx0Dch4XRXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gng2Ei+6BV6TLnwzm8TDPAuxg/Kv0sECbv9qo8DEv39zdXtyyvJuDUr6Ekmxs95Aa
	 bE9zMued94S1AnJSZWxBugW9rtVsoAxCCBwc69fb/b/07cJq3TvL0sbpcxx4604PHU
	 i0nRAwSYlD03t1erE6IQO0jtIJxhVs4KpuLyKSAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 6.1 397/609] ALSA: 6fire: Fix UAF at error handling during probe
Date: Mon, 17 Aug 2026 15:31:33 +0200
Message-ID: <20260817132557.503694380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -158,6 +158,10 @@ static int usb6fire_chip_probe(struct us
 	return 0;
 
 destroy_chip:
+	chip->shutdown = true;
+	if (card)
+		snd_card_disconnect(card);
+	usb6fire_chip_abort(chip);
 	snd_card_free(card);
 	return ret;
 }


