Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F6B3DD870;
	Tue, 21 Jul 2026 18:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658096; cv=none; b=I2p/UZ0HLd7PPVWwVW04vCWaEEHKNKWI9CP7nKIIZ5ElwtsaMwEAbJj9n3e/Arp9uxD7yDmDy41Wx+pV8x56hrBrxh092qRXeO5inrFcKzR4zoXpToRNPSj1BOoROP9+p4fC2gXt4B0BkExMy3vmNDeaRrmipl67nPAq/f74HHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658096; c=relaxed/simple;
	bh=/NYuPC7l/KOp7ARceXlVt/gD5fRffdOJPAtZawMWXc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UufXMRJbBqLlOL9+TNaspvNE4OdCNefoBlDN48g+/7SNitK85ymIV59BTLOGJoCx7jEjfuOvurxM36eJRqBUW5jG2n8lEnl6hqZf3Ted9IlV+qwClyE6E7oNNV9q4KmvDnJlj6vbmpQuoLszWDR/muS/WsMN8z9rD1iTzMaB3VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ciIDSsP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ciIDSsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1AE1F00A3A;
	Tue, 21 Jul 2026 18:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658095;
	bh=AZaaRJsveEWdDjIVMDlQlxToTCwpJaeIWiFmVuooPnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ciIDSsPVmj/Ehi+LMR5Jnw8lK8+fqkt29SDh6dEWM2FoETU3tlpZcW0eOL620xIT
	 tqyonoEf/ypJVo2yaFEUUaADUsZ7c4A/BEf96fRHvbmganotFFAbF/+ip+yYZuiNVr
	 bMBauzJC7GaLHs20Xn0fisDZ7uyj+otQGsCQ6LiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0977/1611] drm/panthor: Fix a leak when a group is evicted before the tiler OOM is serviced
Date: Tue, 21 Jul 2026 17:18:13 +0200
Message-ID: <20260721152537.367568819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 6efeb9ddb4fbf5ac30aff03e8f09ffbdf966abd0 ]

A group ref is tied to the pending tiler_oom_work, so we need to release
it if the cancel was effective.

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260623-panthor-signal-from-irq-v3-0-2ece396f8ee0@collabora.com?part=7
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260625-panthor-misc-fixes-v1-9-b67ed973fea6@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index ff6fb8e6c38e96..e329e1a4fc0b98 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -1039,7 +1039,8 @@ group_unbind_locked(struct panthor_group *group)
 
 	/* Tiler OOM events will be re-issued next time the group is scheduled. */
 	atomic_set(&group->tiler_oom, 0);
-	cancel_work(&group->tiler_oom_work);
+	if (cancel_work(&group->tiler_oom_work))
+		group_put(group);
 
 	for (u32 i = 0; i < group->queue_count; i++)
 		group->queues[i]->doorbell_id = -1;
-- 
2.53.0



