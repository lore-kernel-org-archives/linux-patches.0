Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1989D24A078;
	Tue, 21 Jul 2026 21:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668933; cv=none; b=JW/wvr1TBip/UB5hjemNAHur/Bi3lJ2FQzsGdxJ5KtcYcqfD4X3dZlHnF52p7P9dpd5ABsDHOHbA7eibb+ef9DxxnjdnUV37eMSpKTvkwcNInGARVJaRHsJiHSyQ1P0+5ufQJTbv2iULo/x4TfaiEX20GrrXp8AY3WUVDM5eqFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668933; c=relaxed/simple;
	bh=s1eyYYrJJmAuKBI84882HWCG80pbfFYORYzwg+6WQWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVl35pr7HOAVegNu+w40g13E0LqWGYztIG40hdwa5CQyATftcENCHeJ8/MEypsZpZcmdSgmsBqWnL2iWc0Y3WVpzcmtwoQgBxhxAyEVih1FvVDWehmg8hnnJy1Nw9zZC3x5r+7uhKPdHoWKfJQfsiIaRse6dLW/it8Tkgrie6bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUhaoHx9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUhaoHx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5A31F000E9;
	Tue, 21 Jul 2026 21:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668931;
	bh=/HXL1b+ei1Q9ScUs822NHRKmWPbO6zIxwyvFdWA9kds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xUhaoHx9RztULw7KHvp8AbXySqPiVmy0CfyWa/JMB09m58k3UHaS5MymTcXyvMPtc
	 6rZ5qih3IyzI+6B4x8aKufghU/9Bl5h5MN2EsWO1oLL72uZU7vq2PPyuyjTVoOjbR9
	 VXXeMijaMAxX31gaWO5wI7mgknp/bNps/rhDbvmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Xiao Ni <xiao@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0362/1067] md/raid10: reset read_slot when reusing r10bio for discard
Date: Tue, 21 Jul 2026 17:16:03 +0200
Message-ID: <20260721152432.714496651@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit 6b8a26af065ddc93de2aa5c9f0df98dce9723442 ]

put_all_bios() always drops devs[i].bio, but it only drops
devs[i].repl_bio when r10_bio->read_slot < 0. If discard reuses an
r10bio that was previously used for a read, read_slot can still be
non-negative, and discard cleanup can skip bio_put() on repl_bio.

Reset read_slot to -1 when preparing an r10bio for discard so the
replacement bio is always released correctly.

Fixes: d30588b2731f ("md/raid10: improve raid10 discard request")
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Reviewed-by: Xiao Ni <xiao@kernel.org>
Link: https://patch.msgid.link/20260515093019.3436882-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7dd7957454b589..508b461eabe88a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1767,6 +1767,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	r10_bio->mddev = mddev;
 	r10_bio->state = 0;
 	r10_bio->sectors = 0;
+	r10_bio->read_slot = -1;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
 	wait_blocked_dev(mddev, r10_bio);
 
-- 
2.53.0



