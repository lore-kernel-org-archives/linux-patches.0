Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E856A27466A;
	Fri,  7 Aug 2026 15:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116098; cv=none; b=ENBs6JMdRbm8U7HahdKMBZnJjQRLbw8QGgmyCxM5vwR1kYwLbujDtNpPn4BXnvFqXPaVva/SkAaxR2ciHWdawbh/WG6jhFItL/bxI7s78n4QmrWzPjC3VDJ57TRN9NLPKrzdTshtqyuwH5tYVQa9efsLI/K3Yk0aJQgI6NQRwsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116098; c=relaxed/simple;
	bh=UvJj+68/66L2otXi1cavobkpc6P+6F3iJTfGgmxiqJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXFcm8kd2ymHL6cdtAsuoSng3FoNUMzgGlW7ac9xS13l3eaH817qPCgmp6rZDbearTQEeAv1NyhifKvuKTl36Gt3tAYHxj0UoDNwfLwF2p551WMJuR1MpAMWZvPD084LAdAb0DuJtQiYVbP5HhqXqCMLbGukGwkal3ppC/OnAA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1PFYNSX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1PFYNSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FF31F000E9;
	Fri,  7 Aug 2026 15:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116096;
	bh=ObuQwohQ+F9ZOPRtHWFpYsZhe4y7C+dy4lp7X56f1yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u1PFYNSXAPPocYJiqpeCZ5kE0XGiWyei0idGgrOWitmbU4gX1ODWcCdt0aHoPwzyX
	 9nF/LyAW1Kw4wsO6oSwc7AKMV8bshBx8Jxrvi8cqrOHc12yc3vO1KfO8b4iZNdQw7A
	 +YGh6aDbbjnwnDY/8jtYCuH4Nd3iuCxdh8nFp7Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 6.6 109/261] ALSA: 6fire: Fix UAF at error handling during probe
Date: Fri,  7 Aug 2026 16:37:46 +0200
Message-ID: <20260807143417.732197691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


