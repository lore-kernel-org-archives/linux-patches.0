Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE051DED77;
	Wed, 19 Feb 2025 09:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956187; cv=none; b=Zc8ti0M7vLPGTiVAN7uT8z8j30EAOdamcLFFdkHhKkPRvQrKRHoF42llxdaJSR0U+p3MLppJBCD7w7A0URQtFdnQkRSHItIBkZfYoXwHKBCs1uTraczhrtTdlPGVwCaaGdbcggMLBgp1Cf0S1I7VJnMrRXZmwKIPId1lNjnBrH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956187; c=relaxed/simple;
	bh=7rJucKKGxpGGZe5Qzm/e+Ln2PlEZJX9FlWTsAe4wOQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jk5JhhnWVVauRoyu8sXzVotVnWHVo/Wz540mF0MZZ/ae3JgUGonalGxystE/VANZEVgYJVWvxocFZE161V/WsP55Li8FPFcKtzorQTM5/dv4BzxPlwrWaAsLcn03/dE4PUvgG7KJfWNVzUDad7SQwLlvY2hL8ZP9mUmhVmBfoJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tx79slKa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tx79slKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85130C4CED1;
	Wed, 19 Feb 2025 09:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956187;
	bh=7rJucKKGxpGGZe5Qzm/e+Ln2PlEZJX9FlWTsAe4wOQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tx79slKaJqnDqM1+uyMbfUoDLeI029ubeHdhK8VY9GpqVNfci38V3Eas72Awhdcpz
	 yx5SaY5os01Nr/nFYk/l/VZ7DcSgHs420CEvtYU7rj+kdumuCn9a5l2aoOQ+iwOibj
	 0VTN8tYuYXulFf7qc4QRlQ8F/Q0G1LumPWyNHpWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/578] net: let net.core.dev_weight always be non-zero
Date: Wed, 19 Feb 2025 09:21:38 +0100
Message-ID: <20250219082656.656351193@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit d1f9f79fa2af8e3b45cffdeef66e05833480148a ]

The following problem was encountered during stability test:

(NULL net_device): NAPI poll function process_backlog+0x0/0x530 \
	returned 1, exceeding its budget of 0.
------------[ cut here ]------------
list_add double add: new=ffff88905f746f48, prev=ffff88905f746f48, \
	next=ffff88905f746e40.
WARNING: CPU: 18 PID: 5462 at lib/list_debug.c:35 \
	__list_add_valid_or_report+0xf3/0x130
CPU: 18 UID: 0 PID: 5462 Comm: ping Kdump: loaded Not tainted 6.13.0-rc7+
RIP: 0010:__list_add_valid_or_report+0xf3/0x130
Call Trace:
? __warn+0xcd/0x250
? __list_add_valid_or_report+0xf3/0x130
enqueue_to_backlog+0x923/0x1070
netif_rx_internal+0x92/0x2b0
__netif_rx+0x15/0x170
loopback_xmit+0x2ef/0x450
dev_hard_start_xmit+0x103/0x490
__dev_queue_xmit+0xeac/0x1950
ip_finish_output2+0x6cc/0x1620
ip_output+0x161/0x270
ip_push_pending_frames+0x155/0x1a0
raw_sendmsg+0xe13/0x1550
__sys_sendto+0x3bf/0x4e0
__x64_sys_sendto+0xdc/0x1b0
do_syscall_64+0x5b/0x170
entry_SYSCALL_64_after_hwframe+0x76/0x7e

The reproduction command is as follows:
  sysctl -w net.core.dev_weight=0
  ping 127.0.0.1

This is because when the napi's weight is set to 0, process_backlog() may
return 0 and clear the NAPI_STATE_SCHED bit of napi->state, causing this
napi to be re-polled in net_rx_action() until __do_softirq() times out.
Since the NAPI_STATE_SCHED bit has been cleared, napi_schedule_rps() can
be retriggered in enqueue_to_backlog(), causing this issue.

Making the napi's weight always non-zero solves this problem.

Triggering this issue requires system-wide admin (setting is
not namespaced).

Fixes: e38766054509 ("[NET]: Fix sysctl net.core.dev_weight")
Fixes: 3d48b53fb2ae ("net: dev_weight: TX/RX orthogonality")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Link: https://patch.msgid.link/20250116143053.4146855-1-liujian56@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sysctl_net_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index d281d5343ff4a..47ca6d3ddbb56 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -238,7 +238,7 @@ static int proc_do_dev_weight(struct ctl_table *table, int write,
 	int ret, weight;
 
 	mutex_lock(&dev_weight_mutex);
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 	if (!ret && write) {
 		weight = READ_ONCE(weight_p);
 		WRITE_ONCE(dev_rx_weight, weight * dev_weight_rx_bias);
@@ -363,6 +363,7 @@ static struct ctl_table net_core_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_do_dev_weight,
+		.extra1         = SYSCTL_ONE,
 	},
 	{
 		.procname	= "dev_weight_rx_bias",
@@ -370,6 +371,7 @@ static struct ctl_table net_core_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_do_dev_weight,
+		.extra1         = SYSCTL_ONE,
 	},
 	{
 		.procname	= "dev_weight_tx_bias",
@@ -377,6 +379,7 @@ static struct ctl_table net_core_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_do_dev_weight,
+		.extra1         = SYSCTL_ONE,
 	},
 	{
 		.procname	= "netdev_max_backlog",
-- 
2.39.5



