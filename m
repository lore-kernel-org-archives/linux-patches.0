Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875012DC792;
	Sat, 12 Sep 2026 11:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211875; cv=none; b=oxdWBKbMTKoLUbjRsZADBANK8lS1LahlnqWUEjgyFU2tglMuQYa0gqHfvRJg27vszzAFDIUeXZJ7s865RZKNjTtLz86yEORK72iCugalm46NUISIBAKIhFtgW0JtKFdqd2PDlYe+7V5Q/w7wLTCqnPL5OytC8SyLhUl1cbSPcFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211875; c=relaxed/simple;
	bh=RJgetkFDrur+gsGTaVEq6RQLM5bmpCMBpIloLawR07Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PL639bYv+LZBXEv4CUWx0TjE+epNPSod8RR+HOK1cgoqsI3aXodE2ksrA6YMW6rS0vAzOa34pfL2Ckf72kUDOY4mtbkSSW/AYqP6QqRqNln/5hIXrlBrMioNnzXP7/IhT2eRVQ8EJdewpP3Ap0K7mAP6IsE35KHQA/bS1r55Dfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlQDGODc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlQDGODc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E961F000FF;
	Sat, 12 Sep 2026 11:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211874;
	bh=VBcbYrYkt9w+ouaWHhd749Qyir7msHZdGGKo6LNadU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlQDGODc4hc4ayD7HeWs/WmjNNC+Z9y1V9rHnewr4Nh1BI+BeV9avSaWKy/6jn5kB
	 zyVEZDs+SuaY7R3nic7xN0pekHl2uYL7q1rHPNg/C1rqNxLQoMctZI1nMxDeJGnrSG
	 +pusGeoWYltCcjlRk+u4OqUnzYW7eAm3vHsx18Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1320/1518] ALSA: mtpav: shut down output timer before card teardown
Date: Sat, 12 Sep 2026 08:58:09 +0200
Message-ID: <20260912065653.390659433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
 sound/drivers/mtpav.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/drivers/mtpav.c b/sound/drivers/mtpav.c
index d31eadf4be5f8..1ed6d4f0cb625 100644
--- a/sound/drivers/mtpav.c
+++ b/sound/drivers/mtpav.c
@@ -642,9 +642,7 @@ static void snd_mtpav_free(struct snd_card *card)
 {
 	struct mtpav *crd = card->private_data;
 
-	guard(spinlock_irqsave)(&crd->spinlock);
-	if (crd->istimer > 0)
-		snd_mtpav_remove_output_timer(crd);
+	timer_shutdown_sync(&crd->timer);
 }
 
 /*
-- 
2.53.0



