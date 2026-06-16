Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED75332EC1;
	Tue, 16 Jun 2026 17:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631462; cv=none; b=bhi+QjWlO/eKJEfQbWh+V9un3ShiC6bjEV4WmfGf2fHY4tSQW6kJ7yozKLmJTKOF/qnDAMTCuNnKvH6MJPfegbjNDkWeB8F4wQ9YirVMzsU4onjisxYZK6ZKt7napzPGyPIKBJ9n6sHbXdH4a8rFZ/CeGV319owZ9QI0SY1hQ7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631462; c=relaxed/simple;
	bh=Rfim4QM77hG7918igRCN7Xqhr5yCeiuhZa1zoGJ2yAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvbC4n1NZ3DIBy4kcnxQOs0Ut1EPAtIOPWSejryWAVcRz90+c0m1QrOAxrj/s8+kNdD36kmMNIzQtxxBx9f/P1nAdQtTlPseaiFruvHT9PJdpCRG8s2nWV7rF2T2oZ5+e4tbZsVyr0DkfIYGR+k0SbuxeDd1FZH0W52xgVV646c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wNe0SvC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wNe0SvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118511F000E9;
	Tue, 16 Jun 2026 17:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631461;
	bh=fb/qhLHAsUIJ+o/1YbK/VmZXMVh//ghy5G2yTnyxbFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2wNe0SvCmkSgPaa1qX+3y1yrcf+YyEzg6aC5yocHDfNF9uyq11kqvPd5/iZ0IaIXo
	 ICLR69yjkREWPSnE/v2i3NWofbYEpgRbsB8XFQJ68gXBrptCvXa3kjI0Rfr35OlbiU
	 yazlFuGhQHfCHn7m4ukDW6LW7j+nTZ0DWan02bn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yuqi Xu <xuyq21@lenovo.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 226/522] sctp: purge outqueue on stale COOKIE-ECHO handling
Date: Tue, 16 Jun 2026 20:26:13 +0530
Message-ID: <20260616145136.582546578@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit e374b22e9b07b72a25909621464ff74096151bfb ]

sctp_stream_update() is only invoked when the association is moved into
COOKIE_WAIT during association setup/reconfiguration. In this path, the
outbound stream scheduler state (stream->out_curr) is expected to be
clean, since no user data should have been transmitted yet unless the
state machine has already partially progressed.

However, a corner case exists in sctp_sf_do_5_2_6_stale(): when a
Stale Cookie ERROR is received, the association is rolled back from
COOKIE_ECHOED to COOKIE_WAIT. In this scenario, user data may already
have been queued and even bundled with the COOKIE-ECHO chunk.

During the rollback, sctp_stream_update() frees the old stream table
and installs a new one, but it does not invalidate stream->out_curr.
As a result, out_curr may still point to a freed sctp_stream_out
entry from the previous stream state.

Later, SCTP scheduler dequeue paths (FCFS, RR, PRIO, etc.) rely on
stream->out_curr->ext, which can lead to use-after-free once the old
stream state has been released via sctp_stream_free().

This results in crashes such as (reported by Yuqi):

  BUG: KASAN: slab-use-after-free in sctp_sched_fcfs_dequeue+0x13a/0x140
  Read of size 8 at addr ff1100004d4d3208 by task mini_poc/9312
  CPU: 1 UID: 1001 PID: 9312 Comm: mini_poc Not tainted
     7.1.0-rc1-00305-gbd3a4795d574 #5 PREEMPT(full)
   sctp_sched_fcfs_dequeue+0x13a/0x140
   sctp_outq_flush+0x1603/0x33e0
   sctp_do_sm+0x31c9/0x5d30
   sctp_assoc_bh_rcv+0x392/0x6f0
   sctp_inq_push+0x1db/0x270
   sctp_rcv+0x138d/0x3c10

Fix this by fully purging the association outqueue when handling the
Stale Cookie case. This ensures all pending transmit and retransmit
state is dropped, and any scheduler cached pointers are invalidated,
making it safe to rebuild stream state during COOKIE_WAIT restart.

Updating only stream->out_curr would be insufficient, since queued
and retransmittable data would still reference the old stream state and
trigger later use-after-free in dequeue paths.

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Reported-by: Yuqi Xu <xuyq21@lenovo.com>
Reported-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/94318159b9052907a6cbb7256aee8b5f8dfbfccb.1780510304.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 1685f73602d5e3..f5dc7822d220f2 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2599,11 +2599,7 @@ static enum sctp_disposition sctp_sf_do_5_2_6_stale(
 	 */
 	sctp_add_cmd_sf(commands, SCTP_CMD_DEL_NON_PRIMARY, SCTP_NULL());
 
-	/* If we've sent any data bundled with COOKIE-ECHO we will need to
-	 * resend
-	 */
-	sctp_add_cmd_sf(commands, SCTP_CMD_T1_RETRAN,
-			SCTP_TRANSPORT(asoc->peer.primary_path));
+	sctp_add_cmd_sf(commands, SCTP_CMD_PURGE_OUTQUEUE, SCTP_NULL());
 
 	/* Cast away the const modifier, as we want to just
 	 * rerun it through as a sideffect.
-- 
2.53.0



