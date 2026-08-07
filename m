Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262D63AD506;
	Fri,  7 Aug 2026 14:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114136; cv=none; b=VOR6azXlmbQF0exAPaIA36bXFLZFXGLjj300z24loJzF+EBtDFhqaPbK1XZiXihpnT5swPaznUCdoFXTQMS54vVfpwUIechWDYrwI8qf8N34X3BPAuJIXiKcXxqH3Mz6PtVy6WQNCwTIXuzDHdUz9usgWFqsiZydTD+Yob0Zi1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114136; c=relaxed/simple;
	bh=4Qwbank8X+xGwPhAI0SgDrLOeJU5eoWEHExwa9cCZSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPnXYiJHmzfWsdSkZUDO8JZelZ5qYM8vVwgfWxnM5cb47V3SuRv2JJ3caJuU13AyVwBe6mn5gPGNukuMQaixOXIAilTE8B+VBt5i2ynauYM38AcZahDSn30B9pmu3kSKoUROyGHakGdrNuYft4I9F3dWLyyl926M7TfhvYUoFzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxulxcOZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxulxcOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06FB1F000E9;
	Fri,  7 Aug 2026 14:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114133;
	bh=0lHeeRIgl7hxnaRma4DePXq86X3YOpSXr6D2tYFYgRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HxulxcOZYsp7jButxZF44gWP+4WSzxv13/iVst2DfFSnTv9QUiKX/+P63jF0IiRZU
	 zE8ALAXkdoouSYBQVX0iykKe0SgkfzAgAL35+ggstT8RnBS2Kt9G76TbirPJUiYVgA
	 bWAZ2vEnDhlud7F/cuQ2XIgjaIIxWORZRKEMRb2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 6.12 155/337] ALSA: 6fire: Fix UAF at error handling during probe
Date: Fri,  7 Aug 2026 16:35:58 +0200
Message-ID: <20260807143421.911473589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


