Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5900299920;
	Sat, 12 Sep 2026 09:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204664; cv=none; b=imvXqubrGHNhDDBIUZbV62JG8AXyCPLcQD62oLz2UHypMjl+MUFhEEG7c9hUT+T+HRVRLiBKXT6HCcHTsiqlzfftoRtg6hr0srrFeLR6yh7cjvc0sCVhtwpYs5Zb0HsbsQInkSaBBkHU/sRAGbHC9vDtL7ydDxK9Mt+22I9vdXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204664; c=relaxed/simple;
	bh=KQw4XH8XOUtBUEy017FppevyNyxXecWTZrL/5FRW9lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQCKBNatU2Y+9bNpb39mPXyQraiFe5t4h6vyKaqjb8eQSweotq8pPgR4z08vAbgrbhNHBQk49jqpfsdMAmG1FVj01qTMnQh8STu4eT7fUuTIAl499QndNGEIo/Uo2yb/lJorfQmZa3P3pAPsViIqvTkAgsEbD6cO4QRvqG7Bwd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHiHG0wW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHiHG0wW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5351F000FF;
	Sat, 12 Sep 2026 09:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204663;
	bh=NqC6BhOz2o9kDdvyVEBBgTL5Kas+d4QcKRfTFx3EZ60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHiHG0wWr7Dz+ad+qBJE2sMVPjusua3na35lfD+Y9WRKecUAzZwJbrgNLdzJJf1wu
	 vUMepy1qUhv623u9YuVZVkU0UqKvlGj8AVxdDm/wlsKjY92CFMfqvaoGXElJfVjsw9
	 F8Q6qj+ZERkiuNTBqNvAidCJdaOldr/afnPM8nik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1660/1815] ALSA: mtpav: shut down output timer before card teardown
Date: Sat, 12 Sep 2026 08:56:50 +0200
Message-ID: <20260912065727.960993354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



