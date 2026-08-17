Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DABB421259;
	Mon, 17 Aug 2026 15:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980232; cv=none; b=aPVZcDETAVmd0lRE+6fUEpxsweHlAvo3VUecrIdql2BtheqqVv0u9Dn3D72bdbHckGGwefzV+LdKbZpb/O+h2IuZe9+6hYxLxv+0kVn2GyK2Cq1BEguDaC0BycFpI/yeGWaAcF63KgocoeC4sdNXO4VkjwnpvxhmR3lXNZF6De0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980232; c=relaxed/simple;
	bh=5VpCAKderRgd29aVC8aQkbbmwW1UF1ho0KyDS7CjKoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KX5vWwUl5pzh/iGLv4+0XY73erlTqHnFg87s3scTGXN9hUXd+Ejk0J7ZdCTz5XT13sST2KaaPr+5TY+SZCBLV61pQZ9wMzFN6Poai6U5PIKLWQxTXu1xJuseUQe+fcSogWpJa1/vg2l6gumNGALmFS6PggtbdJuoa9qLoZeL3uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oodPmxPL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oodPmxPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F2A1F000E9;
	Mon, 17 Aug 2026 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980231;
	bh=Y4PPAuw2IzSAIQKyb5zd0o9vwazC0oM+T4SOQXBaF4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oodPmxPLAA8gWCkCM4LNtYvs24Eo37Pu1siZI//KUGdqgnn67yED8b70U+S6811ab
	 bFxKj2NG54Wjvp3ff1BO2r4bqkxx5FM7WUX26HW71KtdwZiHWBJu3vkoOMYACtBuTr
	 nV99zpj7V2SIMj9sa25//P2dezNmf/4fnGT6gc2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Wen <wenjian1@xiaomi.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 502/609] tcp: add a scheduling point in established_get_first()
Date: Mon, 17 Aug 2026 15:33:18 +0200
Message-ID: <20260817132600.680896186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Jian Wen <wenjianhn@gmail.com>

[ Upstream commit 9f4a7c930284bf2b5b84d3636a8e88857149328f ]

Kubernetes[1] is going to stick with /proc/net/tcp for a while.

This commit reduces the scheduling latency introduced by
established_get_first(), similar to commit acffb584cda7 ("net: diag:
add a scheduling point in inet_diag_dump_icsk()").

In our environment, the scheduling latency affects the performance of
latency-sensitive services like Redis.

Changes in V2 :
 - call cond_resched() before checking if a bucket is empty as
   suggested by Eric Dumazet
 - removed the delay of synchronize_net() from the commit message

[1] https://github.com/google/cadvisor/blob/v0.47.2/container/libcontainer/handler.go#L130

Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230711032405.3253025-1-wenjian1@xiaomi.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e5fd3f514e27 ("bpf: tcp: Fix use-after-free in bpf_iter_tcp_established_batch()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 00348cb9a211b..89200b4314018 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -57,6 +57,7 @@
 #include <linux/init.h>
 #include <linux/times.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 #include <net/net_namespace.h>
 #include <net/icmp.h>
@@ -2412,6 +2413,8 @@ static void *established_get_first(struct seq_file *seq)
 		struct hlist_nulls_node *node;
 		spinlock_t *lock = inet_ehash_lockp(hinfo, st->bucket);
 
+		cond_resched();
+
 		/* Lockless fast path for the common case of empty buckets */
 		if (empty_bucket(hinfo, st))
 			continue;
-- 
2.53.0



