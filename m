Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0312F47A0DD;
	Wed, 30 Sep 2026 16:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785925; cv=none; b=g+Pvgm065i/a7zKhysyWAvPSXENqiaWFfOG62h7Mn885tmHzverUvBvetKuPsR4elWFRrpjzWvtG0MzzXKqmDlqMXvTAjVdTJ0dXcGqk8x3xX5k4LynwqjWwaF3ScqrThZy3Lc+CKOVv1vK2Prea9uhumtiYDORkzPOt5hCmlUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785925; c=relaxed/simple;
	bh=p2q4x80Nvha4BPZQWp1xaf7rZsFW2lTO5M+73LXW8Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GO8vMKM0Xp101MPkS+Qkm/bjECZmBZ7jVFTs/+QpYjquIodBVcaj1sGxrcogjToFywOjZjm2mTQfiLfQvgke3r0h98IV2xFCAT01+h/jEitQb75kGa60e1KOCdeUkrbBQnZm/Dsjq1SDhJP8yxNoo95/0ZBQRND6d/wixOf4Q88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQ6hEU3e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQ6hEU3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E77E1F000FF;
	Wed, 30 Sep 2026 16:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785923;
	bh=3TuQeN3OQfZHe/htKhkffez5tIAAw4SYIOSSCxTmcwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQ6hEU3edBvhzkThhpStENE8qSpZf2PiUX4jAruJGeOwmRr/B6AVStjvIXbKMtQ7e
	 o/ExuTRlPRZlRIRU434nOiKG7/zR5qO6sFqbuj4QPmm1CA4IzjkTtYLUSDuMbUaBfU
	 bmRkVED0GdJAIkTRwH7rz0/r+5EwfPMN9CeKghE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 678/982] drop_monitor: synchronize tracepoint unregistration on error path
Date: Wed, 30 Sep 2026 17:23:34 +0200
Message-ID: <20260930152431.325099741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index 78c248b9b6860..513b2f460aaa5 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1156,6 +1156,7 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 
 err_unregister_trace:
 	unregister_trace_kfree_skb(ops->kfree_skb_probe, NULL);
+	tracepoint_synchronize_unregister();
 err_module_put:
 	for_each_possible_cpu(cpu) {
 		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
-- 
2.53.0



