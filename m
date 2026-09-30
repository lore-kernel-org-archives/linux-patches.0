Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D3F519DF1;
	Wed, 30 Sep 2026 17:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788485; cv=none; b=nxG54huxHLvc2sXGs60Bx84lQlhgnofE0gl/o4PPPrVZ1IhpUXzN/ajjs8W6UyE6xh2hdMEorsdJGMGG0RwCX8GtQNG7ct6lg+c5wU/5gb1xVqqTR4pQiuBStlxNFEZXqFSgb42/4I3NAsIJAmBc31MHIeLBrs7rfIlayrvxfU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788485; c=relaxed/simple;
	bh=nWeLDKsTXd8qxytzGndNRyQ/YnAnRbiZSnctYn8mZ0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ae6MmTs9wEBCDz2pRoH5hyRu8emUYzHz1AQv1ULBkrM9GO/BeQ/cqEJ18L3b7tVRQ/rLD8o3tpnhLy2VuZ4HrD20XECi58h5gc78Auc1+jjRhQ0XrI0fq6UUbXpRZhHvt3YcoayhpOyFFtFPLozcXdqGcA4CDDqAvKo8Az7jdeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9M0A2RN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9M0A2RN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9621F000FF;
	Wed, 30 Sep 2026 17:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788484;
	bh=t9z1ZmvPbIdgAJWiJHZETrh1QAgfpKCcj++SqwsAxHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r9M0A2RNYc0+4hCdjfQit2X0T59JQrMTdbXAxA0HDBdgOUxELmnu9jTlKLRzpWPLN
	 WzuVKxX0pgibQA37Lc5VrcdPO1Svd6mM8nL17FcAF0b3u8mazFB1P0bcGTKQxdyf/w
	 Xv/VmMC+TEm8o4NYfnABBsgopMLi4ULU2xoxICGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 140/877] drop_monitor: synchronize tracepoint unregistration on error path
Date: Wed, 30 Sep 2026 17:17:31 +0200
Message-ID: <20260930152417.750240684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6a038ef2b57922b6d9ca98ddac0df0681849b704 ]

If register_trace_napi_poll() fails in net_dm_trace_on_set(),
unregister_trace_kfree_skb() is called to roll back the kfree_skb
tracepoint registration.

However, tracepoint_synchronize_unregister() is omitted before calling
cancel_work_sync() and module_put(). An in-flight probe executing
concurrently on another CPU could call schedule_work() after
cancel_work_sync() has already returned, leaving a pending work item
scheduled after the module reference is dropped. If the module is then
unloaded, executing the work item triggers a kernel panic.

Add tracepoint_synchronize_unregister() after unregister_trace_kfree_skb()
in the error path, matching net_dm_trace_off_set() and
net_dm_hw_probe_unregister().

Fixes: 7c747838a558 ("drop_monitor: Split tracing enable / disable to different functions")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20260910204612.3762015-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/drop_monitor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 308e0fa8f723f..a9c604ef2c826 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1174,6 +1174,7 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 
 err_unregister_trace:
 	unregister_trace_kfree_skb(ops->kfree_skb_probe, NULL);
+	tracepoint_synchronize_unregister();
 err_module_put:
 	for_each_possible_cpu(cpu) {
 		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
-- 
2.53.0



