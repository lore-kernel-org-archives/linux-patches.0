Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880C8154BE0;
	Mon, 10 Mar 2025 17:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628789; cv=none; b=NcplJWOgp1Vs6idwq9YsjRVTEBq8SURd5XmPs7HZ9jaY00H/09UIFsMidVmGDXgfuPijhkvHsmpYJIj7Cqx4/p/kgkswWfJqRPYlie8rmnUIBGBLgOLNmNXwI8+A82HjyDcPiluf755k/0vQfB8nxBlOk1qDqonAB/jgdN/nYJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628789; c=relaxed/simple;
	bh=bJM08IPsLUnQtXuzZB47QJo6UA5BQymbOIazH930n9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2UK9DMBTs5VBkWBBK8UiRCk1xAL74D/VfoJViPD6N1qnhjODAKyHk6ofazV6MtA5ZXgX9/71tQbYAHB2GzJ3mH7KoM5qrrmpDB43QI2vqs07S9s6xmL2ut6rWCrWK2+yG7FlRsDUSg8y0ugf5p7a3cvnQYPQYU29p1fEPn/XG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOarwf1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOarwf1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1216DC4CEE5;
	Mon, 10 Mar 2025 17:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628789;
	bh=bJM08IPsLUnQtXuzZB47QJo6UA5BQymbOIazH930n9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOarwf1gDe0Dt43zQpYYhZoQZRYFq1jZUG3N7fIGKTr4r397B4979XDJkfCtJkrfB
	 fALH7HPuYcW+t2rad2Q/wGJtIoIR/y7w0d4eieaSO2obpMxOBhGQF9kKFmmLOSN5Ge
	 K/25hF6rI5v5kZ772Eljzr/9ggNgmmQ+mRciNtCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/620] net: let net.core.dev_weight always be non-zero
Date: Mon, 10 Mar 2025 17:58:35 +0100
Message-ID: <20250310170548.303463744@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ed20cbdd19315..60ea97aaea7d9 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -240,7 +240,7 @@ static int proc_do_dev_weight(struct ctl_table *table, int write,
 	int ret, weight;
 
 	mutex_lock(&dev_weight_mutex);
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 	if (!ret && write) {
 		weight = READ_ONCE(weight_p);
 		WRITE_ONCE(dev_rx_weight, weight * dev_weight_rx_bias);
@@ -351,6 +351,7 @@ static struct ctl_table net_core_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_do_dev_weight,
+		.extra1         = SYSCTL_ONE,
 	},
 	{
 		.procname	= "dev_weight_rx_bias",
@@ -358,6 +359,7 @@ static struct ctl_table net_core_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_do_dev_weight,
+		.extra1         = SYSCTL_ONE,
 	},
 	{
 		.procname	= "dev_weight_tx_bias",
@@ -365,6 +367,7 @@ static struct ctl_table net_core_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_do_dev_weight,
+		.extra1         = SYSCTL_ONE,
 	},
 	{
 		.procname	= "netdev_max_backlog",
-- 
2.39.5



