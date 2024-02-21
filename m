Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902647F469;
	Wed, 21 Feb 2024 14:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524988; cv=none; b=nxnb+QRjzG+UJwugX2I2qrhYButjU4s4OVwZMwf94h/DrDtvAHcFohwK+ISO9vCjcG4BLPSJDltGuPdIz7hETfwWjIWgNthbs1OtiIy5zRvC9R/LXyUQvn1sTwnwjX2bXwhTD2L+8V2FmAt79/BjSFAyrhFuq9IhLU8t/HaGJEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524988; c=relaxed/simple;
	bh=VEFxyFaJt/a64b/DtUL/rHax/MpldilbwWxl6MqPcPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeaU3jX6tDl54I7jLxh+nKLS2rwqNjOUali3w3YAs0ejk9+M7uo9GF5QrF7+R7BAc5nLqqTxGLcaTvugwhh7POwsxZ9Iuaz3r+SdQh3LfaqoBycGFfImStlYnVWvKxT8LT4Z/6byTRsZ1rICTH2ZgXZ7574JvCL90yCzaQhscz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXdd8BBA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXdd8BBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1355AC433F1;
	Wed, 21 Feb 2024 14:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524988;
	bh=VEFxyFaJt/a64b/DtUL/rHax/MpldilbwWxl6MqPcPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXdd8BBAqHytoM6KnXfKJITotQx6VXNiFZtutHDss7z8HvQseNF4i9ztiXewQxO70
	 jGWPx9xrswlT1HmZ4f6BxlS1CjZkCUj4RJsSC2SwvC/eXcfnh8k2aNNX8e+VT5UDly
	 PdV4DuKURFbidYQ+/3MOFH5kYAS6QuBIPdArWy34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gu <guwen@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/267] net/smc: fix illegal rmb_desc access in SMC-D connection dump
Date: Wed, 21 Feb 2024 14:06:07 +0100
Message-ID: <20240221125940.868285553@linuxfoundation.org>
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

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit dbc153fd3c142909e564bb256da087e13fbf239c ]

A crash was found when dumping SMC-D connections. It can be reproduced
by following steps:

- run nginx/wrk test:
  smc_run nginx
  smc_run wrk -t 16 -c 1000 -d <duration> -H 'Connection: Close' <URL>

- continuously dump SMC-D connections in parallel:
  watch -n 1 'smcss -D'

 BUG: kernel NULL pointer dereference, address: 0000000000000030
 CPU: 2 PID: 7204 Comm: smcss Kdump: loaded Tainted: G	E      6.7.0+ #55
 RIP: 0010:__smc_diag_dump.constprop.0+0x5e5/0x620 [smc_diag]
 Call Trace:
  <TASK>
  ? __die+0x24/0x70
  ? page_fault_oops+0x66/0x150
  ? exc_page_fault+0x69/0x140
  ? asm_exc_page_fault+0x26/0x30
  ? __smc_diag_dump.constprop.0+0x5e5/0x620 [smc_diag]
  ? __kmalloc_node_track_caller+0x35d/0x430
  ? __alloc_skb+0x77/0x170
  smc_diag_dump_proto+0xd0/0xf0 [smc_diag]
  smc_diag_dump+0x26/0x60 [smc_diag]
  netlink_dump+0x19f/0x320
  __netlink_dump_start+0x1dc/0x300
  smc_diag_handler_dump+0x6a/0x80 [smc_diag]
  ? __pfx_smc_diag_dump+0x10/0x10 [smc_diag]
  sock_diag_rcv_msg+0x121/0x140
  ? __pfx_sock_diag_rcv_msg+0x10/0x10
  netlink_rcv_skb+0x5a/0x110
  sock_diag_rcv+0x28/0x40
  netlink_unicast+0x22a/0x330
  netlink_sendmsg+0x1f8/0x420
  __sock_sendmsg+0xb0/0xc0
  ____sys_sendmsg+0x24e/0x300
  ? copy_msghdr_from_user+0x62/0x80
  ___sys_sendmsg+0x7c/0xd0
  ? __do_fault+0x34/0x160
  ? do_read_fault+0x5f/0x100
  ? do_fault+0xb0/0x110
  ? __handle_mm_fault+0x2b0/0x6c0
  __sys_sendmsg+0x4d/0x80
  do_syscall_64+0x69/0x180
  entry_SYSCALL_64_after_hwframe+0x6e/0x76

It is possible that the connection is in process of being established
when we dump it. Assumed that the connection has been registered in a
link group by smc_conn_create() but the rmb_desc has not yet been
initialized by smc_buf_create(), thus causing the illegal access to
conn->rmb_desc. So fix it by checking before dump.

Fixes: 4b1b7d3b30a6 ("net/smc: add SMC-D diag support")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index da9ba6d1679b..3d8f551cec30 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -168,7 +168,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
 	}
 	if (smc->conn.lgr && smc->conn.lgr->is_smcd &&
 	    (req->diag_ext & (1 << (SMC_DIAG_DMBINFO - 1))) &&
-	    !list_empty(&smc->conn.lgr->list)) {
+	    !list_empty(&smc->conn.lgr->list) && smc->conn.rmb_desc) {
 		struct smc_connection *conn = &smc->conn;
 		struct smcd_diag_dmbinfo dinfo;
 
-- 
2.43.0



