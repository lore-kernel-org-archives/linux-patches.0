Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472CF375AC3;
	Tue, 21 Jul 2026 17:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653487; cv=none; b=Ip4qOedt6umuryDobQg67lJQV2Sb1nh59QkWxIUM/pJfq0UZpQH2mKC/O6/FD1F0e6H6Hnbc7ZQNYaBXLtzbyIIu/QSuklVWGyx6JpexsxS6bYZKomzsoQSRCI+aolFb5OFtIWILYcIZL3HRrTFmh+xvASgLnyDkZgaZgot7LaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653487; c=relaxed/simple;
	bh=uzEx9BDxr44VtxEDBKEaXFmvpV9EdNcX3JmFqjdkm7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqXGIMb3r/SE529hz2WBCoNSoo0Thgd6JTdTR5Xfv9ukTeiQL9F2o4lK9Et4O7bETnU1W3YFxZRZDMFDCfqa7rcajjnqV4mucWNqDcgtP2ItdZjb/35j7mJy9iUErbdnGtL5kkTVOj0qCZgr42nwSMiQJWx35wCEN0T52gMgCPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1iXVPE5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1iXVPE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8337C1F000E9;
	Tue, 21 Jul 2026 17:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653485;
	bh=9C79XrPLyvxCpwybutdtHyLJQnS9teexuHtCj/kVywE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i1iXVPE5/XvcIwnKfyfXlGRuKG/8pbRqnP9/3Y89X0Ha4o1kuRj+7wwJS3B1BxW05
	 e8NgaBo6mgsGhm1vbMr4hRqYCjy3Zb60SmYMzP2zmzEkY2Lru0KXMYu5LD3/YtL7NU
	 b9VTmnFl9c90y/ZnuZNR/IkpXGvRuGTYMuKFyOnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1346/2077] drm/panthor: Fix a leak when a group is evicted before the tiler OOM is serviced
Date: Tue, 21 Jul 2026 17:16:59 +0200
Message-ID: <20260721152624.564254283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index e347e15349db59..b15c15617b70de 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -1058,7 +1058,8 @@ group_unbind_locked(struct panthor_group *group)
 
 	/* Tiler OOM events will be re-issued next time the group is scheduled. */
 	atomic_set(&group->tiler_oom, 0);
-	cancel_work(&group->tiler_oom_work);
+	if (cancel_work(&group->tiler_oom_work))
+		group_put(group);
 
 	for (u32 i = 0; i < group->queue_count; i++)
 		group->queues[i]->doorbell_id = -1;
-- 
2.53.0



