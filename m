Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B9A4C74;
	Mon, 23 Jun 2025 22:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716206; cv=none; b=NA8SWkbZf8cz2AuSmO+LSOhEinPvqCkkixhVQOq7HrleK17rcPR5H9+mxxehdU9w2JMhsfVSsd5zgMsLcXh3hYFq2Bd6PHETqjd40XoCYPnYcRTEJw4J3Y2RlAHIWIXaJ/VNCse8tFqtMVHARJwtB3W7WukDSmAzJirEfaNc8HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716206; c=relaxed/simple;
	bh=mPdALuOpMVjJWWhBBv6WZaFtzkn/BlcQ7NYiK5bvxfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1ClDPNQPJlHOneLYgn0pZyiZsTKSg224nr/1YSfv0QM8to+KVWw7k8UCRYctm9/OxUzCx83OQ0N7WrKQy1x+achOocZMqfKQMWHD30JBJ1Nc+60G1QLHoP8CZryMlnOvTkpq2Gs+j9A4XRmZgMKn/jyjWBOHzKtoPiJsd/kt/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDNlgk1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDNlgk1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC71C4CEEA;
	Mon, 23 Jun 2025 22:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716205;
	bh=mPdALuOpMVjJWWhBBv6WZaFtzkn/BlcQ7NYiK5bvxfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDNlgk1Q+rjZyiObOurX7FnA7uLzqWDHw9X2NJ8vGNiuAGEOEGm/yWbD7sbAhj11K
	 qDt2x4Oy6UJ/++rdAOGt5cXYcVzytaM1z7Ts9cIUj18FPND9mMcpwRpSu7MdF5V0ob
	 WkLJ4gWf0SFplL0kgP4EgkysjFAT181h22ZS1o4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 316/411] ipv4/route: Use this_cpu_inc() for stats on PREEMPT_RT
Date: Mon, 23 Jun 2025 15:07:40 +0200
Message-ID: <20250623130641.593660861@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a4884d434038e..cbc584c386e9e 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -200,7 +200,11 @@ const __u8 ip_tos2prio[16] = {
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



