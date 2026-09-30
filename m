Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB36511221;
	Wed, 30 Sep 2026 15:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783590; cv=none; b=Hb2reXCnHO7aivh3rUfb+4rkFCh/FYZ4IuXU6O5+09P69bpuzwW/2jJrVudOm63Ek+h0fEotul5ahTuekE2k8/tQd7PO4mHHpucUjGrfQI97ifxB0womUpQituBIHOTNRbxh+uqw0QbUzrM0OMtKkqqbK8z3xQ5YYUCAPZgUBqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783590; c=relaxed/simple;
	bh=3YolT9aDib4+CVyE7SjqoXyeLRPeNnuGjjr1N+//pPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5LQ9y1uf5EPjfFqZFdbsF83FltgvKUwjL71pTEQSF0782iMd+XtfzDGnUF/oEVJgSxvsoFqkwjJ+Sz9YHqoJlKeKrxp5gjutiHMoFlSYv+/TEgPzTYnx48ZNWtmP9uFWVj6QL3aXpFvX9UyGXl8ULVEbAehoSPhTDEVtDa9RRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0OLLsYU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0OLLsYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603E71F000FF;
	Wed, 30 Sep 2026 15:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783585;
	bh=RQ0SmHm6asZ7fAh+DY4bzP2KFdAPq2FkceImpA7ECKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G0OLLsYUZKmhf1fN3Ozqwfwc4PBwC2wIQubk4fwDhsmiaD+5Da/zJv0zQaDGogeGv
	 AEbrS7ja+HDB7oE7DXAuL2Ak6Ni6MJtRVQ4VgfCqrMkFVMEZZji+raVW3ggr5pOd3y
	 pXBumfEOv1YyOvEh5Wo3E51R+N2aLfTTBKwBWNIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 406/595] drop_monitor: synchronize tracepoint unregistration on error path
Date: Wed, 30 Sep 2026 17:24:59 +0200
Message-ID: <20260930152356.410131991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 66112797f1aac..3ad706102ad18 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1149,6 +1149,7 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 
 err_unregister_trace:
 	unregister_trace_kfree_skb(ops->kfree_skb_probe, NULL);
+	tracepoint_synchronize_unregister();
 err_module_put:
 	for_each_possible_cpu(cpu) {
 		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
-- 
2.53.0



