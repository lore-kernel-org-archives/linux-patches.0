Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759E23A0E85;
	Sat, 17 Oct 2026 16:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254940; cv=none; b=YTVGobi3IdI7bY2949YNkVX06+cclt2M7WSuSmNLkh+D/TT6ug1oiZtFDpjmJbDiIIjK86Fx1dtqdxCIuCgGbMMailr2Xs2JhFWcrjJrIjInYKWKjQ33aI6LK6IRMpCRe9TRGiESfgIoiKBvXOfiFgqJST+QXAtWHplRq7r7efk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254940; c=relaxed/simple;
	bh=Jkr/aqBykvKEpBntwBipWjnQAZJk17LQUfHAeZmd3XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfZ6y9FcpzKzPL6xAJXZLCwzgbB0xlsQEbi2ZkJBdkRgtknv/5mjyD6AV0ajfsbAZ+nvnlGBDRs9g2/v0UJly4DXa4yRW9VNk5nJLqI7f3W3rM7IbH9wshOEJIM/E9Y9ZrGuZNtJ/PpmG0oUBTsuOBumg1FaBt8rgsaOOcNw5S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UggQEkgv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UggQEkgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1E71F000C4;
	Sat, 17 Oct 2026 16:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254939;
	bh=jAi/mba/PoyRgPsFZAsdjM2woNfOypXr79fJfjLdod4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UggQEkgvonQjtr8dv/lXI6myzWB3hqpT2aeSKqXD1mQvRFSGQuqDWX+rNFi0jUm9S
	 cYTSbJk6LL73LKti4+LCEDXm8bPkPbYjZqxErOqjB+RczoKCCr4y/xDh9Kq0Ivffwh
	 mc7mYjd+HeV0mSMgPuoirbp6RUG2pBBm/KMphnzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 613/869] ALSA: mtpav: shut down output timer before card teardown
Date: Sat, 17 Oct 2026 17:57:34 +0200
Message-ID: <20261017160052.751872754@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 946184a2a7589..dc67bb3d46397 100644
--- a/sound/drivers/mtpav.c
+++ b/sound/drivers/mtpav.c
@@ -657,12 +657,8 @@ static int snd_mtpav_get_RAWMIDI(struct mtpav *mcard)
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



