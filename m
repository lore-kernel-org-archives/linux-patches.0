Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AD833C1AD;
	Fri,  7 Aug 2026 15:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115361; cv=none; b=Qe6Qe2UAWs3KN9dfzuCzFi41bceIw9u2FEIQJqvFqM+VKEezpIyaPKp6grqbXrPvQd/80pLS2rY8fPIuXXbgzy+WzHwWjDJV8hEP8qCYDPZjpyh8R147eO+aop6iZHlvRnqcldr+AybrBKNXJ/xmC9lyEc7NAyrlFkbE1IWhvTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115361; c=relaxed/simple;
	bh=VYcWWsOYpploumxkko9Da1rQu6B/Kl0vh0JWWWScey0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhsqD+2APpxxpiglKO5CZ2AQdPc7C25XN8hJnbg6cHETn3RtmK5Ny46oSTLrs4vDzRSeDO2tqLrhZsHG++EFC+HldJuETcDlLUHdD/844EOKDxVixkx6y4NMOqsAMNfxUQiXvGlNSwPwu1ZTQX7T1l2i6LaOVGZGq9D94ek/xLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYiEsZpN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYiEsZpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF111F000E9;
	Fri,  7 Aug 2026 15:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115360;
	bh=/mwOb7S/tpj7ETJQYdQlP/9RE+3HBEv7G0575CFfKJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fYiEsZpNkqiKHlvULBqV4meozfm8dYEvx1DWmEOa9Q2cRveBMgy7eE5KRgF9XBl/d
	 B4fMdpMJNt//1FzW4d+kO//T0TwUcQI802PG+kOz835qdZJouN1SIotGzYFTMzWZIJ
	 TUYAOAE7d0Z0Y9RA+3wVbjhWLNwytfyYN1UFxXwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <tom.leiming@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 250/396] ublk: reset kernel-owned dev_info fields in ublk_ctrl_add_dev()
Date: Fri,  7 Aug 2026 16:36:50 +0200
Message-ID: <20260807143429.642819921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Ming Lei <tom.leiming@gmail.com>

commit e65848e4ce352bac9e3465099354c8b8f845391f upstream.

ublk_ctrl_add_dev() memcpy()s the userspace ublksrv_ctrl_dev_info into
ub->dev_info and then fixes up the fields the driver owns, but misses
->state and ->ublksrv_pid.

A device added with ->state = UBLK_S_DEV_LIVE passes the
"->state != UBLK_S_DEV_DEAD" test that ublk_stop_dev_unlocked() uses as its
proxy for "a disk is attached", while ->ub_disk is still NULL, so DEL_DEV
right after ADD_DEV oopses in del_gendisk().  UBLK_S_DEV_QUIESCED plus
UBLK_F_USER_RECOVERY dies one step earlier, in ublk_force_abort_dev().  A
poisoned ->state also gets START_USER_RECOVERY and the char device
read/write path onto a device that was never started, and wedges START_DEV
at -EEXIST.  A poisoned ->ublksrv_pid just makes GET_DEV_INFO report an
unrelated task as the ublk server.

Reset both after the memcpy(), as ublk_detach_disk() does.  Userspace only
ever reads these back, so correcting them silently breaks nothing.

ADD_DEV has copied ->state in unsanitized since ublk was merged, but back
then it was harmless: the gendisk was allocated during ADD_DEV, and both
teardown and the START_DEV -EEXIST check keyed off disk_live() rather than
->state.  The oops became reachable once the disk allocation moved to
START_DEV and those checks switched to ->state.

Fixes: 6d9e6dfdf3b2 ("ublk: defer disk allocation")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Link: https://patch.msgid.link/20260726145025.1507383-1-tom.leiming@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -3288,6 +3288,15 @@ static int ublk_ctrl_add_dev(const struc
 	ub->dev_info.dev_id = ub->ub_number;
 
 	/*
+	 * ->state and ->ublksrv_pid are owned by the driver and only read back
+	 * by userspace, but they come from the copied-in dev_info, so reset
+	 * them. Otherwise a device added with ->state != DEAD looks live while
+	 * ->ub_disk is still NULL.
+	 */
+	ub->dev_info.state = UBLK_S_DEV_DEAD;
+	ub->dev_info.ublksrv_pid = -1;
+
+	/*
 	 * 64bit flags will be copied back to userspace as feature
 	 * negotiation result, so have to clear flags which driver
 	 * doesn't support yet, then userspace can get correct flags


