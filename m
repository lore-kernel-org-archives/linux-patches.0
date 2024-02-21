Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23026A8D6;
	Wed, 21 Feb 2024 14:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525004; cv=none; b=UGwMMiTibEWECvTXSP0yCf4qELE/VpvHwO+OqJ0vEXYJ5vwcA4nqejYb08gXFJYIfm6IqMbUFhNIXQxV2OHr4784R/GT0O+vR4TW1niSMUor/dr+nBYlo+dgeYPMxV3Ir0+u29FHPsNSXmCq3PzkeJoasIYcZrsQqYT+yjFb5IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525004; c=relaxed/simple;
	bh=kag4PtrrdQ0Px7B1PCmZZJ0/xy987hT2r59awfozZA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g57JiRkFcExGYis6/C43N+cRpOYl16eV7SyQ+Xosu7h7IPn5Gn18FCfbFi6BAwS+Qd8w/5KwihWVr3/coS2hBIEIqFjv0xSIY4a3F9bfIMbsH9YDi0xta2zvNMRJTIP8UsMbzp9tKsY4dR45Ar042RiZR+SDw8+jNbkG+Iw6ygc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNSZGwgs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNSZGwgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B53C433F1;
	Wed, 21 Feb 2024 14:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525003;
	bh=kag4PtrrdQ0Px7B1PCmZZJ0/xy987hT2r59awfozZA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNSZGwgs8vE1zceFenuirWLm1nZ8QhzhtJsRQULv3is/sJdxh1Ht8yT2JsRgtsYJb
	 ZzIY8Z9yQOt0p5HY2xZbnbR7p3B4A3G/F3XV2PUQC6ZMJ+eE93aDtX/WcQtSNIFdJj
	 cJ3PWgAY2NWJAWALXf09PWKyjHkjEDyCA1VYSH34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Sharath Srinivasan <sharath.srinivasan@oracle.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/267] net/rds: Fix UBSAN: array-index-out-of-bounds in rds_cmsg_recv
Date: Wed, 21 Feb 2024 14:06:11 +0100
Message-ID: <20240221125940.986179127@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sharath Srinivasan <sharath.srinivasan@oracle.com>

[ Upstream commit 13e788deb7348cc88df34bed736c3b3b9927ea52 ]

Syzcaller UBSAN crash occurs in rds_cmsg_recv(),
which reads inc->i_rx_lat_trace[j + 1] with index 4 (3 + 1),
but with array size of 4 (RDS_RX_MAX_TRACES).
Here 'j' is assigned from rs->rs_rx_trace[i] and in-turn from
trace.rx_trace_pos[i] in rds_recv_track_latency(),
with both arrays sized 3 (RDS_MSG_RX_DGRAM_TRACE_MAX). So fix the
off-by-one bounds check in rds_recv_track_latency() to prevent
a potential crash in rds_cmsg_recv().

Found by syzcaller:
=================================================================
UBSAN: array-index-out-of-bounds in net/rds/recv.c:585:39
index 4 is out of range for type 'u64 [4]'
CPU: 1 PID: 8058 Comm: syz-executor228 Not tainted 6.6.0-gd2f51b3516da #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.15.0-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x136/0x150 lib/dump_stack.c:106
 ubsan_epilogue lib/ubsan.c:217 [inline]
 __ubsan_handle_out_of_bounds+0xd5/0x130 lib/ubsan.c:348
 rds_cmsg_recv+0x60d/0x700 net/rds/recv.c:585
 rds_recvmsg+0x3fb/0x1610 net/rds/recv.c:716
 sock_recvmsg_nosec net/socket.c:1044 [inline]
 sock_recvmsg+0xe2/0x160 net/socket.c:1066
 __sys_recvfrom+0x1b6/0x2f0 net/socket.c:2246
 __do_sys_recvfrom net/socket.c:2264 [inline]
 __se_sys_recvfrom net/socket.c:2260 [inline]
 __x64_sys_recvfrom+0xe0/0x1b0 net/socket.c:2260
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x40/0x110 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0x6b
==================================================================

Fixes: 3289025aedc0 ("RDS: add receive message trace used by application")
Reported-by: Chenyuan Yang <chenyuan0y@gmail.com>
Closes: https://lore.kernel.org/linux-rdma/CALGdzuoVdq-wtQ4Az9iottBqC5cv9ZhcE5q8N7LfYFvkRsOVcw@mail.gmail.com/
Signed-off-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/af_rds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index 1a5bf3fa4578..af22f47c8612 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -421,7 +421,7 @@ static int rds_recv_track_latency(struct rds_sock *rs, char __user *optval,
 
 	rs->rs_rx_traces = trace.rx_traces;
 	for (i = 0; i < rs->rs_rx_traces; i++) {
-		if (trace.rx_trace_pos[i] > RDS_MSG_RX_DGRAM_TRACE_MAX) {
+		if (trace.rx_trace_pos[i] >= RDS_MSG_RX_DGRAM_TRACE_MAX) {
 			rs->rs_rx_traces = 0;
 			return -EFAULT;
 		}
-- 
2.43.0



