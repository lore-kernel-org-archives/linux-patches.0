Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063479;
	b=UTGIE+LxHZF07zGttQqGSDxDnd7sxcfCAFmjw3o0SnQ8PjwYeAqSQW5Ff+qCHUt4nazm
	 E1OaeHnZIvDhRyObzDnpDxkItcciOoR9fa1/Sb5Tz77lpIrM//0rDyw73h8QsyXLp7HaS
	 Qxe4iQKTTCoiOO7k7COKnfIdlB3+B4pdIAMombvQOvVPlofzOsbE5ejyntw+WycAOTuuX
	 IsxAMtjVxO8w+ZlMRLf9NLdfqx3km0FF5scgxc/LjjrGTsCoGydk32GZ+/8Afm6k5br1x
	 VF7jz5Utwa880U24keAvYRcwhC+G7CyV7EF+WsLO4sQwgwGYscWHay84jy3LNbNprTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=psC1zAQwMTKazK2R2RMhLCutn1/cijFZuBw2lNikbXU=;
	b=Toqxno4+76OgWZpnwK/KIWi079Cw2QVWpSHGUwEB/CkUoBukVSmiNobOKpnho3I5/A5O
	 sJsf+abu9UXVc+60mr4hAE/zYyof8HUjhp5d/R/QsofPMentuPPvBG+rOSOlxQqEbY4l5
	 y615eUb8dMkBZ0HOY+ab/767Ztvw9M1NiJh6k+b0kzOx8695NfPyKwakCpv9JBH31WvKz
	 lfPJiaLkmucIBMiO/ElS1a1HZ3B4BKXHKvzWwnMlUXvPqj/2eVS6ovPf+8rqOaCKcxEvL
	 OeBYHzbgS7ZmdczT5g0dwska/NZT0s2K+v9Ca2Vv35+vGX6QKm/qrLbIp96nafQV/fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hQWQos/v";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834FE606D837;
	Sat,  7 Nov 2026 14:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQWQos/v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2596C1F0089F;
	Sat,  7 Nov 2026 14:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063479;
	bh=psC1zAQwMTKazK2R2RMhLCutn1/cijFZuBw2lNikbXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQWQos/voV9K2SwL/P/yOzaaq8X/ytJ4g7Jtd4DrIOVuzPs3owqJrcOfupTc9tVz1
	 UYL0QHLW/6bYpCrupT7RycJWpVosGCcguKR2qEnSV5nHMsxcXQtQEGVba6q6fIsdUy
	 mdBPJdRwPZj8Cc3KK3cJtT6SPwyqKjoppQOuPJWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 601/869] ublk: reset the FETCH round under ub->mutex
Date: Sat,  7 Nov 2026 08:54:43 -0500
Message-ID: <20261107134913.432614624@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

[ Upstream commit 84824afdb5a4dc127fbd7036142d7611c5e53651 ]

The release work resets the FETCH round without ub->mutex, while
START_DEV checks it under ub->mutex:

  START_DEV (ub->mutex)               release work
  all queues ready? yes
  ublksrv_tgid matches? yes
                                      ublk_reset_ch_dev():
                                        io->cmd = NULL, nr_queue_ready = 0
  go live: a request then reaches ublk_queue_cmd() with a NULL io->cmd

Do the reset under ub->mutex. Then START_DEV sees the round either ready
or reset. The work already takes ub->mutex when there is a disk, after
it has aborted the requests; nothing holding ub->mutex waits for it.

Fixes: 728cbac5fe21 ("ublk: move device reset into ublk_ch_release()")
Cc: stable@vger.kernel.org
Tested-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261011063555.1142277-6-tom.leiming@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index f85d66cee9c3a..c9109731d29ba 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1766,8 +1766,10 @@ static void ublk_ch_release_work_fn(struct work_struct *work)
 	 * reset, so that a new server can fetch and start the device.
 	 */
 	disk = ublk_get_disk(ub);
-	if (!disk)
+	if (!disk) {
+		mutex_lock(&ub->mutex);
 		goto reset;
+	}
 
 	/*
 	 * All uring_cmd are done now, so abort any request outstanding to
@@ -1799,7 +1801,7 @@ static void ublk_ch_release_work_fn(struct work_struct *work)
 
 	/* double check after grabbing lock */
 	if (!ub->ub_disk)
-		goto unlock;
+		goto reset;
 
 	/*
 	 * Transition the device to the nosrv state. What exactly this
@@ -1825,12 +1827,14 @@ static void ublk_ch_release_work_fn(struct work_struct *work)
 				WRITE_ONCE(ublk_get_queue(ub, i)->fail_io, true);
 		}
 	}
-unlock:
-	mutex_unlock(&ub->mutex);
-	ublk_put_disk(disk);
 reset:
-	/* all uring_cmd has been done now, reset device & ubq */
+	/*
+	 * All uring_cmd has been done now, reset device & ubq. Under
+	 * ub->mutex, so START_DEV sees the round either ready or reset.
+	 */
 	ublk_reset_ch_dev(ub);
+	mutex_unlock(&ub->mutex);
+	ublk_put_disk(disk);
 	clear_bit(UB_STATE_OPEN, &ub->state);
 
 	/* put the reference grabbed in ublk_ch_release() */
-- 
2.53.0



