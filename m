Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CBF52FE29;
	Wed, 23 Sep 2026 14:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173258; cv=none; b=LCq1hpQoCcGZPSpOmxfxRgydd8fUH9ViDyxN3FqG+anftljwsfouJdwe/Dyo2BTeieLSZmCZejLBXOErNCQG7pxwhRbByvlC0lrbVZw/mvIbgZPSwgIGwxqnTu+l9PV42Hpux58aVB7Y0GernmVzKgpge6a5FkAijMrxb2aYYVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173258; c=relaxed/simple;
	bh=g5gylv3nTychLdZTjOWtpNmVv0Kyw5BBApeFiSGUdTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vA1LMTrxTlN9xA3Kyf47CtT7LziADPAjN2gzPtGIZNucUTSUkZqfl+ApA5ToDWvzxWu0QZ5u8NHJkOhCDEMk9xlZmXkUpZeM0W+3WFRmsstsxUxiKCit6xee4x5eTSYGKNe7Q16bZbcmcmqsOk164cGmi6ADlPx8Y5+mBCBrsL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAqKG/ob; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAqKG/ob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D91F1F000FF;
	Wed, 23 Sep 2026 14:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173256;
	bh=Ru6rg8WgbupbT+rGO/aP031qi8uQWx+hOyCRV9nzrSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAqKG/obqy1LxwBnBa/8+POVuGn2/Z62Mm4u6VK0/JVF7wTDuPXPF7dvaY33SXaCH
	 6UU8rXSqkn+hyfWpLpQIZ8GTWlwPVvWiJe1RPhxrurxDeGkILWQRoVQ/hCNKestp8J
	 urpLHAqYSm/no5SFuqiODWqhq6ln23ccWwkXPm8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 183/438] drop_monitor: synchronize tracepoint unregistration on error path
Date: Wed, 23 Sep 2026 16:03:24 +0200
Message-ID: <20260923140649.509366492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index abaf108ac4db8..018d19e3a71de 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1173,6 +1173,7 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 
 err_unregister_trace:
 	unregister_trace_kfree_skb(ops->kfree_skb_probe, NULL);
+	tracepoint_synchronize_unregister();
 err_module_put:
 	for_each_possible_cpu(cpu) {
 		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
-- 
2.53.0



