Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A05140926A;
	Tue, 21 Jul 2026 19:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663148; cv=none; b=rFlHCWelPqeVBbjivoi+3XymRPwdFhsRRzcbtWQpWymyWbHaM5jQCSn4orKlJB7FA5EnPLHZOvN7bZ81A8/fYOpFrDmQGgF9L0GtlIXoVHsFBzmLGJw5HU2/Bgxwi4UdK7kMVYkoUfPMyIjiueyD3Z3W6N7BBqTWvY3SCXckOBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663148; c=relaxed/simple;
	bh=zpsM2GWXY5KVf6uSMrKWM3TsXfQpM+fKA9RzzdskVP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7OFBc66DyIQC9Ob8ipJiu9/JKiPKg6erjdZPXsXGwLy5lcXMYrsBj4qHBNPzv+YOHsgn/TOyMtjoH0vlclATYarwsJJVsKfi3wKfeDWdTZoQMwZQUqo/RhGapB1xpRdN0GnbTZaz7XW+wjNE85o9C1Wem9gUbilVBh6yXqdbto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=InUg4dQN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InUg4dQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC161F000E9;
	Tue, 21 Jul 2026 19:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663147;
	bh=H7Q2rUVpV8YtNisThN8IDbdgFkZ6xc7mys0MUvAAmiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=InUg4dQNAqxGc/QCh1SCs0R4GOCzinwj++nKzjnbHyAetC7WcxSh4+ZoyKYZLNXLy
	 +6zfrBmrvA7BYB9wQB3qTi0MbCx4wPSMkFxZfPMwu7ljETOW9jjar0OgAcO4/7T1Zs
	 aD/VZzHWtgCllrYAHlIGzu9G8CR9HLXTzHKHcmqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0713/1276] drm/panthor: Interrupt group start/resumption if group_bind_locked() fails
Date: Tue, 21 Jul 2026 17:19:16 +0200
Message-ID: <20260721152502.050223302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 2a1a6a04901d28..cedcde0f10bdb0 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -2236,7 +2236,13 @@ tick_ctx_apply(struct panthor_scheduler *sched, struct panthor_sched_tick_ctx *c
 
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



