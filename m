Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDC12DC765;
	Fri,  7 Aug 2026 15:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115221; cv=none; b=jm6hfe6QeGSZxBgZpi9ImqAAko2oCAssfBBElAmg4GSkECSs0wYmu4PTYJ42SInoVnHIRYAum/lLpKU94l7sQRsLmd8cmvhwUDBnlURWJfbUxY0UlxwoN8pKdS2gGE7WxOBk9ZqPaVD4nY530gcEm6VV2Bh8HuZHbo0Ax5raQpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115221; c=relaxed/simple;
	bh=GrD0bPq/2V0UpgsZUDilYcgEsV/dUvQcyy4tsk05u+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNiT02mbimkwihwoyRV1+3m8gPfiW7fGkJIsobyHMFyB/xoZ2D+sgqi7ugZCE0HU/6GMsAzlAfbXbHtQajzZHQ4CpldSvFkyoF9Wva3vpMO+WIUGd9nM2VzTTm1xZeviUUePb1GFYM4w6cYoAa19RZdN4TbPeMOpJLBNcyay6ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbbxI1w4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbbxI1w4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B877B1F00A3A;
	Fri,  7 Aug 2026 15:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115220;
	bh=QEgMuK2AA74dWE5lZ4B4ynSGtGIhKIvp2SfbsvUv+gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dbbxI1w4LzhKxfQBvt8yWV0U9ZDgEFWoLzvpEvYmPjLo54XAAYZ+NyHst+0iYRdcQ
	 n8lpKBtqk18MM7PPvvT3ZTWGBiQCt008dDd+mw/nuy+OleFvkalCo9RePLQpda6GQc
	 8tZ0+flQ2+VS90IvYpRJI0AsNKeFO1pZvVSt07X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 6.18 201/396] ALSA: 6fire: Fix UAF at error handling during probe
Date: Fri,  7 Aug 2026 16:36:01 +0200
Message-ID: <20260807143428.617341599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -156,6 +156,10 @@ static int usb6fire_chip_probe(struct us
 	return 0;
 
 destroy_chip:
+	chip->shutdown = true;
+	if (card)
+		snd_card_disconnect(card);
+	usb6fire_chip_abort(chip);
 	snd_card_free(card);
 	return ret;
 }


