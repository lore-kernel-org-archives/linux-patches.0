Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A261B314D34;
	Tue, 21 Jul 2026 17:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653489; cv=none; b=C3ivX4u0GAfIt1A5fZHTBVuPT8XMfCrf9lGIBvW2BX6QBpi3r+EJKqQowakNy8f7rW//ODYJw2pltBxnImS7FNqn0a9cuIJDCixPSlGDIYo4ZD3AbdGwHvAwEJy8qpKKqIRLPqn/hY3BVceXzgK9DiUs4LoSd7W4MHHjziaFz4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653489; c=relaxed/simple;
	bh=SsyHP29m5yUI7EzMvEZoJlBvK9wyYXTVYc92l9S9M0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTS799wj72tGDGLpRQ2nU7X8gfWR0xxa3KJiFJ0lahj+bJNkiXMVcqC/vbq1+s0nrbvQ6/utMNSvzNebEiMxTXGO+k+Gsrj0VCB7T4qG58HLPX9lxLBuPOg0wyUiO45rGrdfrteEj6/Qlc5mpVuXm2c45Wpm7e8U0abMoYhZvOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eVgMH5Q9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eVgMH5Q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065971F000E9;
	Tue, 21 Jul 2026 17:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653488;
	bh=PEiSuEuFxPcYhpAN4eHpjNf+jeVFFWocgsVZm+r3m8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eVgMH5Q9my0HGF7/3iMMsWN3cfakF3pTXIvbNN7yPAoSYfsMWt6Iuu6LlV9wmMKXk
	 lenPdvEPXu/RPbhHQBRX3K9z/fmtxuCtEg50zSggrWY8guGfnxbGj/+R0QNrG3IRnc
	 m+P3ZR6XwwukbIQv/kwznayjTKmAAHMyF3jo85E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1347/2077] drm/panthor: Interrupt group start/resumption if group_bind_locked() fails
Date: Tue, 21 Jul 2026 17:17:00 +0200
Message-ID: <20260721152624.587675414@linuxfoundation.org>
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

[ Upstream commit 1f27cef1f41dac0bd254d8741766f189936c9880 ]

group_bind_locked() can fail if the MMU block is stuck. This is normally
a reset situation, but by the time we reset the GPU, we might have
tried to resume a group that's not resident, which will probably trip
out the FW. So let's avoid that by bailing out when group_bind_locked()
returns an error. We don't even try to start more groups because the
GPU will be reset anyway.

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260623-panthor-signal-from-irq-v3-0-2ece396f8ee0@collabora.com?part=7
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260625-panthor-misc-fixes-v1-10-b67ed973fea6@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index b15c15617b70de..b09953ac0bd632 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -2367,7 +2367,13 @@ tick_ctx_apply(struct panthor_scheduler *sched, struct panthor_sched_tick_ctx *c
 
 			csg_iface = panthor_fw_get_csg_iface(ptdev, csg_id);
 			csg_slot = &sched->csg_slots[csg_id];
-			group_bind_locked(group, csg_id);
+			ret = group_bind_locked(group, csg_id);
+			if (ret) {
+				panthor_device_schedule_reset(ptdev);
+				ctx->csg_upd_failed_mask |= BIT(csg_id);
+				return;
+			}
+
 			csg_slot_prog_locked(ptdev, csg_id, new_csg_prio--);
 			csgs_upd_ctx_queue_reqs(ptdev, &upd_ctx, csg_id,
 						group->state == PANTHOR_CS_GROUP_SUSPENDED ?
-- 
2.53.0



