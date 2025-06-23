Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0324315A;
	Mon, 23 Jun 2025 21:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714863; cv=none; b=jiKBm8nTOagel2G67NpNnSNOHdMymBtMfsOZ9/b7mxH6mBC5vkPboX55uSZoeaCMjWn6iRBLDWFWQb7++pfSshR10dmoDJd8aMbfWuXwk3CTTJv5UntZM7qUITMVTissKaiQ+FpmdrgLWsQvKtTVpl3MhnV68QSr1nJ3Jg2NoIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714863; c=relaxed/simple;
	bh=PfilexD8Os8Wia3vVZLuYShLaPCWq4g3wn/+iA8g5GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0ea+8rT+fL8SUvLvnSvMfwFjfTwMVT6U1AiMA8ABJjYmjkOAYnJsAITOzcoX4cwmd8bU/zGafJFHNqRX2bZLw0nPq1o7Sdiva6J4kvpVttOqF3+ON6xR3KTN+aVco2sdtPvU0ejnzFAB7n8QCx7iTdncT9IdbJ0YfTQIr7Q/sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVAW/w/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVAW/w/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5D0C4CEEA;
	Mon, 23 Jun 2025 21:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714863;
	bh=PfilexD8Os8Wia3vVZLuYShLaPCWq4g3wn/+iA8g5GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVAW/w/kqOz1daVJD3BVSRZAlyQ7f1Y7VkkE8PfaKTxVdnp5GMaNou5PJxqXuDnmo
	 49MNTLjtEv8Ty5I05oWCNZP9LJK23XPZ9vO1wGAC6s4ovnyNsiXgaIGyzfyyYEJHHV
	 pf4Mhi9x2n4322rI8KAQxcmAHlxmD7/eSGlAk5iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 258/355] ipv4/route: Use this_cpu_inc() for stats on PREEMPT_RT
Date: Mon, 23 Jun 2025 15:07:39 +0200
Message-ID: <20250623130634.512700864@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a2a7f2597e201..815b6b0089c29 100644
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



