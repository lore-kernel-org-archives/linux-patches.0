Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162061779B1;
	Tue,  8 Oct 2024 12:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390931; cv=none; b=CmcU+VRHvuHlUAdxHU5kH3TwjgdZlDPj9laT5PKwDuPxtkv0Jd4socHBHvKbMdQ931Xn0L0/wPKnQPz+NUTmmI+1QHIOQyaTiB5RYLjjyNh5kngfnsZhsU8lrlB1gcXd9vhuDN28EkRqno6Q1bajDY0HAu9pBjeeym3GwwhcXOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390931; c=relaxed/simple;
	bh=CXwiQnk/SwQPzbvhnmyxA3XwE/1F9Um1TaYpNk6EDCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipfXXOGW+TDb4v1lWEKYxn6snj3Fxpdh9TrYldi2h+ScRUkvWI78ZhgjPlziPl47tpfnFHnKLQtv+l2Vr2WxrNBGSnizyTC7ebWZ8yM+vdmytUhJcJ0kQsOHGnTOMxbKFo3CQYoN/ISKMot0htxxuT41SmgTbSqHUUY61+gpKeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DzKGpAk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DzKGpAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B697C4CECC;
	Tue,  8 Oct 2024 12:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390930;
	bh=CXwiQnk/SwQPzbvhnmyxA3XwE/1F9Um1TaYpNk6EDCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1DzKGpAkRUI/un6yHgYDEcRCVQhFvUEgGn3FsICqtHqRKCbtgt7NAmvtcbdRMwgj7
	 AdMZkKIxSGzo3Yw3M4wCEHlSw2OKSTeE07qmRRE/B4dayqy3vkgzhpCRn+1H1uXXGp
	 p95chHXM6bEyka/eVrwZRK23bd6WX84FMkIUPjo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>
Subject: [PATCH 6.10 438/482] drm/panthor: Dont declare a queue blocked if deferred operations are pending
Date: Tue,  8 Oct 2024 14:08:21 +0200
Message-ID: <20241008115705.761038691@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

commit 7a1f30afe97294281a2ba05977688385744f9844 upstream.

If deferred operations are pending, we want to wait for those to
land before declaring the queue blocked on a SYNC_WAIT. We need
this to deal with the case where the sync object is signalled through
a deferred SYNC_{ADD,SET} from the same queue. If we don't do that
and the group gets scheduled out before the deferred SYNC_{SET,ADD}
is executed, we'll end up with a timeout, because no external
SYNC_{SET,ADD} will make the scheduler reconsider the group for
execution.

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240905071914.3278599-1-boris.brezillon@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 145d983bb129..2aff02ba6949 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -1103,7 +1103,13 @@ cs_slot_sync_queue_state_locked(struct panthor_device *ptdev, u32 csg_id, u32 cs
 			list_move_tail(&group->wait_node,
 				       &group->ptdev->scheduler->groups.waiting);
 		}
-		group->blocked_queues |= BIT(cs_id);
+
+		/* The queue is only blocked if there's no deferred operation
+		 * pending, which can be checked through the scoreboard status.
+		 */
+		if (!cs_iface->output->status_scoreboards)
+			group->blocked_queues |= BIT(cs_id);
+
 		queue->syncwait.gpu_va = cs_iface->output->status_wait_sync_ptr;
 		queue->syncwait.ref = cs_iface->output->status_wait_sync_value;
 		status_wait_cond = cs_iface->output->status_wait & CS_STATUS_WAIT_SYNC_COND_MASK;
-- 
2.46.2



