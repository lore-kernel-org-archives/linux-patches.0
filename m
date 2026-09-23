Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BBB3C7691;
	Wed, 23 Sep 2026 14:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174569; cv=none; b=rmD+mvghqDxUQ3aevu/xAq4Q5xZPH2iU4E6qbEAabEj+CrwchwMDv7GtMud1oNEFI3uVfAKdy2DsmwCq4k91C0V6hV7gaTJ7Gpt78yLcdMMgwhW1oYbTkNnIxwGmnlmIrH33YRN1jRfc8pijmA5IWCZrKDYvYoyVF+vMWSdR0WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174569; c=relaxed/simple;
	bh=SAonyX/CAvgixc1zNHRtxB/ssDfjYlEdn6HZE8YEH4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3F6Tae+GeBScBdEjHqB6NBUnrl0K21mffi8ODPsxdK+CrjjpNDngEDfv/02aXyZmpGw79K0h+2V2NOZuwJ+mrPCTp6dEi9GNw6YtasRpCJ9sA/3byh8Z7w94j7lV1TtAn1kTTwcDWpn5ANw6iZEdb9zJllEFrackv9/SP2ShR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmlxdCjx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmlxdCjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F551F000FF;
	Wed, 23 Sep 2026 14:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174567;
	bh=MZBGErDIjEHhWruy6eSXNIq2r+Mg7k9x/CzLNWzWBrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HmlxdCjxUMlHePyGuAQ805gapF68XWZ6M/57LGQTux8p4KpQo7ewwPlw1bVIoF1ea
	 DpqaRwBMJtuMQZemX2Bd469Z+3bzE7qgWEsU955UQJP/WVwvqAsiEtwCqlEaUXmYTd
	 NdAuNHKstN+RIY+TB8YQmEGr4VjR1XT4fHKspi8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 156/398] drop_monitor: synchronize tracepoint unregistration on error path
Date: Wed, 23 Sep 2026 16:03:50 +0200
Message-ID: <20260923140647.480838290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a5e75cd04d6ca..172fd2dcbfe93 100644
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



