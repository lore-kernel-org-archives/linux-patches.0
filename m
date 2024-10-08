Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C011D1DE88F;
	Tue,  8 Oct 2024 13:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392893; cv=none; b=gXVUH15d2fI9j/gJFe8gJ5g/7TLhryGYd6v9U2xMTWyl/2knART5l63M91HIMVbC/hn/bscWSC37PxpBvD2h/j1/MHAYrtAbm68F/VVWXTpGrp9nkx0euEuzKJfhAhkf3UB7NEUd8xz7EpEZoi+BrJ+lnfgOf3her26jKzTZXlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392893; c=relaxed/simple;
	bh=pa/xgXjA+C706/AdFU6IWnv55KeiKSRUZKcDO4kb7EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jat/wbT7zx9k2BBn8bW6E/Hj6so0JCFDHkSEuLCUOATTETlD+Ovt86h/a4tEpowWNUySsKf3uRJmF36Ywt1ks32gqZ2mYczoeYbi5BLp0nRBQb/TiKmDVL0NEj8NdPvZ/9zlUXhwyQRhdV71GafPOgZEQiQpL7PWZ6JFgAfPcq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFsy0UWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFsy0UWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4609AC4CEC7;
	Tue,  8 Oct 2024 13:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392893;
	bh=pa/xgXjA+C706/AdFU6IWnv55KeiKSRUZKcDO4kb7EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFsy0UWXQix1TWM6wvtG7EwHK2g6tV3m2x7dAAAp2SSYgYuB0ysUk7fOt4BakBrb+
	 fMU0Fjxa9JY/5NDDSRLGE5/ssfbQH8hRQKq/JYWgLUxEOK8HkdD/QY9PcoGQhCf5JC
	 K7WLXKT9kY23LGYksCpEGxgKBb3iOodDVjaU1y5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>
Subject: [PATCH 6.11 519/558] drm/panthor: Dont declare a queue blocked if deferred operations are pending
Date: Tue,  8 Oct 2024 14:09:09 +0200
Message-ID: <20241008115722.651950567@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/panthor/panthor_sched.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -1103,7 +1103,13 @@ cs_slot_sync_queue_state_locked(struct p
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


