Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE90A21D3DD;
	Mon, 23 Jun 2025 21:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714733; cv=none; b=oVtBP/1555adNIZ1XgsPJdGnDllvrNSJHan77dc2KaiFYcTU3nMw8hb68R7jOk6MWKiodv/RlIGdqjjrpT/m6BHXZkPTAHmkdMd17HNjZ7ZnJDjBjVX6AZRm9m85CImU7mLbBMxi8ri7XY//LkxYW5ldPcTD+O0o0hzCfD2g46Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714733; c=relaxed/simple;
	bh=rhLXm+WWBbOSlKUHJTnTh7O0nX0rqe2BsdhbciaT5kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxTZlmsdT5lmW0Ij9OER4vC2QML+t8G1nvekD7FiM8RBkN6wWixyFLdIfKgwjvtqj7kTnTBGNZYbZlWaDzpda8vn1Vxp18z2v46OfR52JpnQmYe+1i6TgsYvsXJYrLNhaygzob9o3QLor5LM1t2Qn+bvdwyxxhfmhJzfTnmGGx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ediI2v8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ediI2v8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3170C4CEEA;
	Mon, 23 Jun 2025 21:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714733;
	bh=rhLXm+WWBbOSlKUHJTnTh7O0nX0rqe2BsdhbciaT5kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ediI2v8dS3+x4kwxeAepcImE5M4awxrdEWp+DvfvMcOl9gW7JrGZoxz3v3fOkG4tJ
	 v/9SkXYzTmE7ImMM4lIAlX06ZX3rgRcv10tWNgYNwEt0Kg3mdTGTANSYg28OqafgnN
	 Ji5V+rg8M2XV37unH/OFf2z+ul0UqqXbN1/CRb4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 155/290] ipv4/route: Use this_cpu_inc() for stats on PREEMPT_RT
Date: Mon, 23 Jun 2025 15:06:56 +0200
Message-ID: <20250623130631.554617445@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 97dc30a03dbf2..8ee1ad2d8c13f 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -192,7 +192,11 @@ const __u8 ip_tos2prio[16] = {
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



