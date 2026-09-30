Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743C44E36F1;
	Wed, 30 Sep 2026 18:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792011; cv=none; b=PLbEBkp9ESL+kGl6U5msRS+2CXX5UbxQQmjpgi0kraH1s2pp7f404cqdAGedChCFwnFkNTp9etMmj0G96I67YicPOECBaFk9Z7UCDuzZniCdEYjVijDpYjog1bWBHyB1qBNNlKjqgHfOy2NgydH2Akp3v0IlZB9rCFBAPgGLpOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792011; c=relaxed/simple;
	bh=yrbWkvUQYQD5uKvJP9kU7g2pbC8vaEK93KhXlmn0Ico=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiB83VPmgS3EG44atV3W5+fJyUw9NRj/tZ7o+z0yqYe4NnCvN+jgRoOuWZSlBwZL0MmQYWEWwtz8qXtcRHbT2j95exodISrxwkqGQvmg/kSxSrmU1py6iBQOF6mkU7HAUc8S9Wd6jLexqLWM/eLj+K/zlNc2QLhj5taIlr7T0JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJpyqtpb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJpyqtpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF94D1F000FF;
	Wed, 30 Sep 2026 18:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792010;
	bh=t/m5DvlaLrHFmetrcL0Glee8gGBl1bj2mQZoRdXMQhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HJpyqtpbHItH+R93CJT8I0e/ek2240wTkhCt+mUgl10LOenISlRjIV5JzrANZZ/z/
	 2Hhx/kcGSoKadTAcvUt35YfwIicBLujJJ4y9+XY7NGSGfSjggXbNLNeXvz8ivCAiLo
	 D77v7235pOUUcWqRD8vLptJhyx1hNMl2E7HPhKbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 502/752] drop_monitor: synchronize tracepoint unregistration on error path
Date: Wed, 30 Sep 2026 17:26:12 +0200
Message-ID: <20260930152409.123842706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ad5d3090f13fe..0449fd8e2936f 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1153,6 +1153,7 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 
 err_unregister_trace:
 	unregister_trace_kfree_skb(ops->kfree_skb_probe, NULL);
+	tracepoint_synchronize_unregister();
 err_module_put:
 	for_each_possible_cpu(cpu) {
 		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
-- 
2.53.0



