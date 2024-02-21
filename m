Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A5C762C1;
	Wed, 21 Feb 2024 13:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523753; cv=none; b=pRk2N8aIQxrCZiG9GzGoSLk4kw7JmQxHYAKMbyUqREUT329yoRceqi0btZvRD5+Pu0OdOzj9JEOnKqRjRznwETm6lu5rihRFAvLLsvXy1e+g46OZxicezJHyD8oQ5F9CW1tJWNLrQmOF+1aaqV4xhzgvoq4KcJPzrQlYvxjc/Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523753; c=relaxed/simple;
	bh=pRG0FZNwgLkmzSYJnMbhzYxl3MvrW8h4MqeR0dJCq1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCc7aDVt9eQlquGtQVbfWQWKUWlqef2lvyrZmd8KxPE/sL/nSlA82LqSAcM1wO5rtJFMepsQbXr5PvOMWJLprmMl+/Ilz+gQ2q78jlg2FlPTFqduB5jCdSzF/C8xfaMnA2xN/lbp3m80BIf43gqXuGpsiulmyqlhzCSL3jPsZPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BsH/Gq8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsH/Gq8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303C4C433C7;
	Wed, 21 Feb 2024 13:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523753;
	bh=pRG0FZNwgLkmzSYJnMbhzYxl3MvrW8h4MqeR0dJCq1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsH/Gq8fZvGjPU7aJAWB/gvc+FkJge+lddO0IgbpBpDOQisuuSJDYHxPAbfJl3X9u
	 If1sB5UDBPnM/07J++SF5+KLPkSfLvE5YV4MfsYjlHW4rbHLCOn2Grjkd9OHDHgY4c
	 KUj6WoRLwyblCeQjEivSfBWwCg2oFBJJOqIjzehQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Sharath Srinivasan <sharath.srinivasan@oracle.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/379] net/rds: Fix UBSAN: array-index-out-of-bounds in rds_cmsg_recv
Date: Wed, 21 Feb 2024 14:03:47 +0100
Message-ID: <20240221125956.338911429@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b239120dd9ca..0ec0ae148349 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -419,7 +419,7 @@ static int rds_recv_track_latency(struct rds_sock *rs, sockptr_t optval,
 
 	rs->rs_rx_traces = trace.rx_traces;
 	for (i = 0; i < rs->rs_rx_traces; i++) {
-		if (trace.rx_trace_pos[i] > RDS_MSG_RX_DGRAM_TRACE_MAX) {
+		if (trace.rx_trace_pos[i] >= RDS_MSG_RX_DGRAM_TRACE_MAX) {
 			rs->rs_rx_traces = 0;
 			return -EFAULT;
 		}
-- 
2.43.0



