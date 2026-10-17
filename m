Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EAB3A1A3F;
	Sat, 17 Oct 2026 17:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259962; cv=none; b=IbD/T9rf5Agq1uKylxwU+M0hZAVK4qPlcMS2mIRuCk0HRZvSsb5Of8wHVEVqLxVNrQM5TJOBudMIkiOy2if/iIoCIpVmEmJJ0lVbQdGycYFo6Ek4rHiI2dKcRAedf4zlRuzemV0Yn4Nh1+qIA21leNZKkMz4Y6FUCbQLXyaBHCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259962; c=relaxed/simple;
	bh=GqB0eygt0tLj6gNqHQjOuY1qpY9LgprOHAvxOXcByoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bF+SWfdq4H3DzaivtrSo3KOQZalvOz38UKJKTwBx1IioIfffrJLkZ5JJURGBwj4WecMQiLdZ8qPV+YgJ+IF3z7zhPKmssJFGuGN6gGEB7zHJ3omYTYMpRzk34om/86hOTdaBWyPVmIngYrSptr0EWHFEeLQmOA9jXpSmxGx7kk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkZbhZvI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkZbhZvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598871F000C4;
	Sat, 17 Oct 2026 17:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259961;
	bh=CdTCtmJCkF4R/USNVCUtWwUZ++bEK8QSuow9qz6JjhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tkZbhZvIBye0wm/EUR6UyXCw1gnoi7tYYlt78+KrtYzQsABlCMGcH0ki68SN1n+1T
	 Waa/UHte4TaKjSXBGiH2U8lRHZUnYZdWXBPHuK3Wc1RI6q8sXCasJ9uU9/vvRw/QqK
	 4y7LkC3UdvqwQWJRqpGJYBu/5H9qivjo1Pmx+V7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1387/1674] ALSA: mtpav: shut down output timer before card teardown
Date: Sat, 17 Oct 2026 18:00:59 +0200
Message-ID: <20261017160506.768052763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit c73cb5b7c159246dd572277c668851a56e516019 ]

snd_mtpav_output_timer() rearms chip->timer while holding
chip->spinlock and accesses the card-private mtpav state.

snd_mtpav_free() currently takes the same lock and calls
timer_delete() when the timer is active. This only removes a
pending timer; it does not wait for a callback that is already
running and does not prevent the callback from rearming the timer.

A callback running on another CPU can therefore continue after
snd_mtpav_free() releases the lock and access the card-private
state while the card is being torn down. It can also rearm the
timer after timer_delete() has returned.

Call timer_shutdown_sync() without holding chip->spinlock. This
waits for any running callback to finish and prevents further
rearming before the card-private mtpav state is released.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260820112749.9195-1-runyu.xiao@seu.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/mtpav.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/sound/drivers/mtpav.c b/sound/drivers/mtpav.c
index f212f233ea618..1fb6797fa45f8 100644
--- a/sound/drivers/mtpav.c
+++ b/sound/drivers/mtpav.c
@@ -663,12 +663,8 @@ static int snd_mtpav_get_RAWMIDI(struct mtpav *mcard)
 static void snd_mtpav_free(struct snd_card *card)
 {
 	struct mtpav *crd = card->private_data;
-	unsigned long flags;
 
-	spin_lock_irqsave(&crd->spinlock, flags);
-	if (crd->istimer > 0)
-		snd_mtpav_remove_output_timer(crd);
-	spin_unlock_irqrestore(&crd->spinlock, flags);
+	timer_shutdown_sync(&crd->timer);
 }
 
 /*
-- 
2.53.0



