Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B601B219E0;
	Mon, 23 Jun 2025 21:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712766; cv=none; b=nfEpNMVEx4JLokTdDtr3G0ivFibTQkm+B1tQUVg33fZ1yMj49acKgMjlnNotNi0XdOwt6IGNDS/AyimaLpuf3ved9DslTQfY3I3lmbsddoS/0ZFPm/KEzEIasMHAWhWyIAmmi+Hao0q/pJJsxNfIQjeGZr0YNzKD1zynZ0FSxDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712766; c=relaxed/simple;
	bh=rdc9eWul1cZj/dBuri4Wdiv8gfeM3nrpacHMF1eWO7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eez0EUb2evcCZ1s+wJcGW6n4sVNRwlB6kYt/cnH9C4X44GkAXa7xOZnkOA8hk/EGtUq+tvt5oxArCIn3jpC9c5I0VqtEKu7cifCHrkMGl/uNZ1pwn7gPNlGMFGL5wGZ7rsQLQ7HRIco7Y/AybUOm4hYSlpSyiIp+nZhRl+Du70E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijOE7/tp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijOE7/tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2AAC4CEEA;
	Mon, 23 Jun 2025 21:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712766;
	bh=rdc9eWul1cZj/dBuri4Wdiv8gfeM3nrpacHMF1eWO7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijOE7/tph74vsnsIABXYWCjRevx0ZyqldfIk5t0nPLIiGVGKzjI+QLGNcvUzEixwD
	 Pd/ngBxNU9m+DI7EQTxbaJzCanXG/aZBVZ/Cxw6uqLjniN4s+vz9eBU3mnLUNK6E1R
	 cHY6ErL8vy3Ek3pLWORjsSJVdtZHMTbti4dpo8jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 166/222] ipv4/route: Use this_cpu_inc() for stats on PREEMPT_RT
Date: Mon, 23 Jun 2025 15:08:21 +0200
Message-ID: <20250623130617.067126016@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 1c0829788a6e6e165846b9bedd0b908ef16260b6 ]

The statistics are incremented with raw_cpu_inc() assuming it always
happens with bottom half disabled. Without per-CPU locking in
local_bh_disable() on PREEMPT_RT this is no longer true.

Use this_cpu_inc() on PREEMPT_RT for the increment to not worry about
preemption.

Cc: David Ahern <dsahern@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20250512092736.229935-4-bigeasy@linutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index da280a2df4e66..d173234503f94 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -197,7 +197,11 @@ const __u8 ip_tos2prio[16] = {
 EXPORT_SYMBOL(ip_tos2prio);
 
 static DEFINE_PER_CPU(struct rt_cache_stat, rt_cache_stat);
+#ifndef CONFIG_PREEMPT_RT
 #define RT_CACHE_STAT_INC(field) raw_cpu_inc(rt_cache_stat.field)
+#else
+#define RT_CACHE_STAT_INC(field) this_cpu_inc(rt_cache_stat.field)
+#endif
 
 #ifdef CONFIG_PROC_FS
 static void *rt_cache_seq_start(struct seq_file *seq, loff_t *pos)
-- 
2.39.5



