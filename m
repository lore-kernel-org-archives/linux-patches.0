Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A604D26FDB7;
	Tue, 27 May 2025 17:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368043; cv=none; b=nCDzfPmzovYF1xVSYBi0iYbQJ/HZ+sYRv9x6ZHn63GqCxKk+nde5XOgyaZHhRRcz4u7pOdBpIBwxGPY+0woOR+AdEadoLQolt24Xd5oik0XgVZsUQnoy3TL7qbgSvBYyxqEcEiQeicw/G5mvJOqq6NgTmu/QwAqjKJ205UncdIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368043; c=relaxed/simple;
	bh=FzQT9ockW0Kg0hDYq4WpmvY0cMHyWhMNBz0FS1XFUQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjalED9zP38JliyUsGASed3pGjtR+YIhj+eopzwWe2AvOjz+qf7sUPc7vi8dPoDhjL6lbPBE/hB/9qG5WxYfV+SHcgsgqaJtvNYWGw9zJ2FfJAnSGQDtG241RTIXFkFyr0vif5lpO9cIGIrVJsVc+y3DyjuTPp6jLPiXM/Z9lac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImmRlfEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImmRlfEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284F8C4CEE9;
	Tue, 27 May 2025 17:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368043;
	bh=FzQT9ockW0Kg0hDYq4WpmvY0cMHyWhMNBz0FS1XFUQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ImmRlfEnYZTQNcJmj+5FMyX5+qT5ayuP5qaDNc9qJfjvARjr2RTGWfNHbjkUsYj1k
	 64LGy6YABW2zJdVMM8gDqVuaCuFs7AUQSDI9fSukyx7MPhIBjYSZb9Gd9HaqFwNX/B
	 PPbOmm/Rj/VIwilkAsYhYSy/EWX02uAwvbE0dPC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 550/783] netdevsim: allow normal queue reset while down
Date: Tue, 27 May 2025 18:25:47 +0200
Message-ID: <20250527162535.549400525@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 285b3f78eabd951e59e98f01f86abaaa6c76cd44 ]

Resetting queues while the device is down should be legal.
Allow it, test it. Ideally we'd test this with a real device
supporting devmem but I don't have access to such devices.

Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250206225638.1387810-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/netdev.c           | 10 ++++------
 tools/testing/selftests/net/nl_netdev.py | 18 +++++++++++++++++-
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index e4c0d77849b82..a41dc79e9c2e0 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -664,8 +664,11 @@ nsim_queue_mem_alloc(struct net_device *dev, void *per_queue_mem, int idx)
 	if (ns->rq_reset_mode > 3)
 		return -EINVAL;
 
-	if (ns->rq_reset_mode == 1)
+	if (ns->rq_reset_mode == 1) {
+		if (!netif_running(ns->netdev))
+			return -ENETDOWN;
 		return nsim_create_page_pool(&qmem->pp, &ns->rq[idx]->napi);
+	}
 
 	qmem->rq = nsim_queue_alloc();
 	if (!qmem->rq)
@@ -773,11 +776,6 @@ nsim_qreset_write(struct file *file, const char __user *data,
 		return -EINVAL;
 
 	rtnl_lock();
-	if (!netif_running(ns->netdev)) {
-		ret = -ENETDOWN;
-		goto exit_unlock;
-	}
-
 	if (queue >= ns->netdev->real_num_rx_queues) {
 		ret = -EINVAL;
 		goto exit_unlock;
diff --git a/tools/testing/selftests/net/nl_netdev.py b/tools/testing/selftests/net/nl_netdev.py
index 93e8cb671c3d9..beaee5e4e2aab 100755
--- a/tools/testing/selftests/net/nl_netdev.py
+++ b/tools/testing/selftests/net/nl_netdev.py
@@ -35,6 +35,21 @@ def napi_list_check(nf) -> None:
                         comment=f"queue count after reset queue {q} mode {i}")
 
 
+def nsim_rxq_reset_down(nf) -> None:
+    """
+    Test that the queue API supports resetting a queue
+    while the interface is down. We should convert this
+    test to testing real HW once more devices support
+    queue API.
+    """
+    with NetdevSimDev(queue_count=4) as nsimdev:
+        nsim = nsimdev.nsims[0]
+
+        ip(f"link set dev {nsim.ifname} down")
+        for i in [0, 2, 3]:
+            nsim.dfs_write("queue_reset", f"1 {i}")
+
+
 def page_pool_check(nf) -> None:
     with NetdevSimDev() as nsimdev:
         nsim = nsimdev.nsims[0]
@@ -106,7 +121,8 @@ def page_pool_check(nf) -> None:
 
 def main() -> None:
     nf = NetdevFamily()
-    ksft_run([empty_check, lo_check, page_pool_check, napi_list_check],
+    ksft_run([empty_check, lo_check, page_pool_check, napi_list_check,
+              nsim_rxq_reset_down],
              args=(nf, ))
     ksft_exit()
 
-- 
2.39.5



