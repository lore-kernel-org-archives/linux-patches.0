Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67D03E00A1;
	Wed, 30 Sep 2026 19:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796277; cv=none; b=eQ0pixXMMktFaRGLIDvJQtJ+/DFTjzBZ5daALcB5ZFltAU3XmfMlXwjnRzOQLRpP1pR7XZcrRxY765PwijNIq2vvmb2sKYwX9Msnpk4VqHC1M/dGkgQHAHV4G9b6db5JZIpJeWoaJ4U/NQQm4L5IEoYz3MF865kU9LDvmfs3HJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796277; c=relaxed/simple;
	bh=n0gRjuMr8z6sTJlmTYJoUbN379J8vlFATqOs3bJu87c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onp34v1Xn5zESSGa0mfOh8AJL47P4by0o4qDTqrEwOwdlWLGxtsY3nNhJgZZQ/I5dVPvNHJKxwrVxLH6ISvodemBkejITg2fm+tCmreatK3uZNjtw8adxFrhHMcmxlvo80z0cBguX0aUnIAujkAx3AvpaDqxvHcmysouv8ylJrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkWwlkym; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkWwlkym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF5E1F000FF;
	Wed, 30 Sep 2026 19:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796275;
	bh=uBVlQZxdi9CTevxIuuAfAU30DeYxKqO5E6DhULEmdXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BkWwlkym0+4VrWqIpBpBzDtWkp6a0yBQ6VGbaLjYtWEUsJ2wkaEjlowaSm/I4t8vn
	 FnIpODMnTVyYuzxWqRsFLrY72KyN+NIEfW6PqB0s5Y9LmKEV3u2ut/CHMUfa9cpL7i
	 3nudJIsQZsmrJVFX50OjyhTX0kj7zA525M2OW20o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0811/1193] drop_monitor: synchronize tracepoint unregistration on error path
Date: Wed, 30 Sep 2026 17:24:55 +0200
Message-ID: <20260930152452.263969967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 60ca18b440a34..052abd988e80a 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1171,6 +1171,7 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
 
 err_unregister_trace:
 	unregister_trace_kfree_skb(ops->kfree_skb_probe, NULL);
+	tracepoint_synchronize_unregister();
 err_module_put:
 	for_each_possible_cpu(cpu) {
 		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
-- 
2.53.0



