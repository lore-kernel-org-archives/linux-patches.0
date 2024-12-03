Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BFA1F708A;
	Tue,  3 Dec 2024 14:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236558; cv=none; b=SfJDtVnJ2am/DFgk3ba+zTtOm8TEA8G4alpVXn9iegFP5zn4KvmQeYxb7b4E8sdjVfvUl86kpDMcqjIimoN8koFWAaj7l8Q7UUC4LakneTMLFRZ7b9/RiNdXqmWgzTOCDYQlM2WiTXvZ2dZaXVXaYckAWT0X56M2OPnv8Qtup6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236558; c=relaxed/simple;
	bh=Qdho3cMs8MRhGJB6X/coIjIN/ZrXXr0hdw41uGrP86g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RF9CJvymZ7aoG2M0xYXd/9IJoWt3J8KmW3SQ5y35lDmviqeO4uz6Sj1SyjuMqf61t1OEMAt1KE/2YB6ZtBY0Sp8uGefjiVZkIlKiAMEDV4VV13PalAI256aF7RRX2BPkTXYFqSQJduQv7Lxba96UTpcUDLEI6TKLRnoD7wtqWLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXkAVeb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXkAVeb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F31EC4CECF;
	Tue,  3 Dec 2024 14:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236557;
	bh=Qdho3cMs8MRhGJB6X/coIjIN/ZrXXr0hdw41uGrP86g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXkAVeb0jATGaZrEIf0pJvkxtF9b/sEwvu7KY1JLr3z0L4tBm6+N3nSBqcTh7ui9Y
	 FkXYxVHZS27epyqOrTnEI8MLPhJE5MtpqgkjCkzV344KvqwwBBoubmcA5AWEBSX7o9
	 uriBI4ncZCZ17H7yP0pmBl+NLJTiRzWfrPy93yZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 054/138] ALSA: us122l: Use snd_card_free_when_closed() at disconnection
Date: Tue,  3 Dec 2024 15:31:23 +0100
Message-ID: <20241203141925.628103386@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b7df09bb348016943f56b09dcaafe221e3f73947 ]

The USB disconnect callback is supposed to be short and not too-long
waiting.  OTOH, the current code uses snd_card_free() at
disconnection, but this waits for the close of all used fds, hence it
can take long.  It eventually blocks the upper layer USB ioctls, which
may trigger a soft lockup.

An easy workaround is to replace snd_card_free() with
snd_card_free_when_closed().  This variant returns immediately while
the release of resources is done asynchronously by the card device
release at the last close.

The loop of us122l->mmap_count check is dropped as well.  The check is
useless for the asynchronous operation with *_when_closed().

Fixes: 030a07e44129 ("ALSA: Add USB US122L driver")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241113111042.15058-3-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/us122l.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index 8082f7b077f18..eac2e4d0e7d94 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -649,10 +649,7 @@ static void snd_us122l_disconnect(struct usb_interface *intf)
 	usb_put_intf(usb_ifnum_to_if(us122l->dev, 1));
 	usb_put_dev(us122l->dev);
 
-	while (atomic_read(&us122l->mmap_count))
-		msleep(500);
-
-	snd_card_free(card);
+	snd_card_free_when_closed(card);
 }
 
 static int snd_us122l_suspend(struct usb_interface *intf, pm_message_t message)
-- 
2.43.0



