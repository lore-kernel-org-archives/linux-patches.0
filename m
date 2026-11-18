Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027165;
	b=4pB0q7lrR/alhIZBn/JOaGnegskZhRH2ANbVXXTSXQj/EZQOPJ6S4gur2pSHp3TEuX8M
	 TV/LQLcWeuW/bFrSxBMWp/wLk1lRH0sKfLikKkXFHHc48BHG1yASMNuQBUuQSohg2rfi6
	 EV+HM6lgHHGp02F9dPfeQxrji+/HSUPbHlATim2hHphd8goGvI4WwDXNg+NejC/lAK3/W
	 yAN0jnKaGDxksVAHDaMH9VtNZ86qNgm9O+R4179RdvHMgwncXzQorj1AY04pYlwZ82I8y
	 FUUbM9+N9lNtqWnjHFpagwc2fZhM4UGNbmjkbjUMOAqsdC+/bE8z98loG7bRlIuF4ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Ktmaafo5U+oQXAJptNWHyjdHprOms3/dtRYpgun0J0=;
	b=yOcSZrr1dFPuakaTnOM8lf0VsaAptrScPzIsuKejUObwmoBelSVAdQ67zBoYdbeLFFVf
	 uKUZ84zyT4EPSOtxmzT7Q6ORrKow2bO8gVvLcRtA6tqWZ8e1NKSkIGWAN6es7w0qbPvvk
	 dO1804TLwswGUbgSGjbPgj/QAUHsylu3z3coHRI3R6/xJurekI74yYhTVL3hU/9I5R87W
	 lyr8vCGbsVxbeZm/L8xepTRum5B5H0A6pIfYOPuRVuHd/9qtfRDKXKch0sS8ka8aI0gK5
	 fPMEX01J8OQijtdaWVt3iS9YlrraP9+L0HSopMqu7ADYYFYw4pVyFfpPz0UnYPfYRxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FrWa7xAA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BBB606A320;
	Wed, 18 Nov 2026 18:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FrWa7xAA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70A41F000C4;
	Wed, 18 Nov 2026 18:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027165;
	bh=3Ktmaafo5U+oQXAJptNWHyjdHprOms3/dtRYpgun0J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FrWa7xAA4PCHlP5526l2O0GcrqheaCLX0Z7EbTt/ESsMUctYGMglanArKeI/KrqL/
	 cdpPbwSAu4545Qd+JIP76LnhiwoimZqHI81/umiVqduv/mFLP7Coe5bmQZl+Bda6IX
	 DhRl/Kdx00NNhEnnqKbhTmM9yRNtVbmvmD2Wku0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1651/2151] ublk: allow a NULL io->cmd in the cancel callback
Date: Wed, 18 Nov 2026 15:56:26 +0100
Message-ID: <20261118150221.990323960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

[ Upstream commit 4915dc0a1834457520ef0592bfd454b26901614f ]

A cancel from the control path, like STOP_DEV's ublk_cancel_dev() after
dropping ub->mutex, takes the command and clears io->cmd under
cancel_lock, then completes it with io_uring_cmd_done(), which takes
uring_lock to remove it from the cancelable list. The server's io_uring
cancel runs ublk_uring_cmd_cancel_fn() under uring_lock in between:

  control path cancel                    io_uring cancel (uring_lock)
  io->cmd = NULL, CANCELED
  io_uring_cmd_done()
    waits for uring_lock                 cmd still on the list
                                         ublk_uring_cmd_cancel_fn(cmd)
                                           io->cmd == NULL: WARN

ublk_cancel_cmd() then sees CANCELED and leaves the command alone, so
nothing is wrong; only warn if io->cmd holds another command.

Fixes: ab03a61c6614 ("ublk: have a per-io daemon instead of a per-queue daemon")
Tested-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261011063555.1142277-7-tom.leiming@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 197825f44b1d0..3dc070de93c83 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2029,6 +2029,7 @@ static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
 {
 	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
 	struct ublk_queue *ubq = pdu->ubq;
+	struct io_uring_cmd *cur;
 	struct task_struct *task;
 	struct ublk_io *io;
 
@@ -2045,7 +2046,9 @@ static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
 
 	ublk_start_cancel(ubq->dev);
 
-	WARN_ON_ONCE(io->cmd != cmd);
+	/* NULL if a cancel from the control path took it meanwhile */
+	cur = READ_ONCE(io->cmd);
+	WARN_ON_ONCE(cur && cur != cmd);
 	ublk_cancel_cmd(ubq, pdu->tag, issue_flags);
 }
 
-- 
2.53.0



