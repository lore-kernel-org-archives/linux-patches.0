Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020F61E98EF;
	Sun,  7 Jun 2026 10:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827214; cv=none; b=XW1SIUBi+Rf6PY1WiA8FHbIkhsbO9dBJRPlLqqqL/ZY7IRLCmtdQAE9Aa5/J5360v87WgxCfQE4h6ErA4noFYgXP5rmkiInHx5pJzyJiDXGNmlP8sG/DjFl8hbuyNphi8W3J1NNmtpPF26y0aF5im7YiCt4hGRhXoSC4dmleMH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827214; c=relaxed/simple;
	bh=5J7PapYpLQWUQo9mjBXSxWtotqhnY0Fp1G3I4WRK2Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fI8xIX4wU8IL/ELF63gv53KbqSVgqNLJazxa2mvLm5bAyXh1C3+bkENYnnquZRj4eiOXTvg2G/CWCYxGRnJF8YNXJKN9+hcdWbes8UcBRkApWJzXIuLQ4E3/UnZU9P+xoifrUdy0WE0ZghyeFAUwEei1hI0CH9SS/2SheckI07k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/DiLpzz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/DiLpzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8681F00893;
	Sun,  7 Jun 2026 10:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827213;
	bh=v7k4wdLJS9R6m10NwMyvwY47IIOvKneRvo6HMJEmtco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F/DiLpzz00W62DXtb0Kh5VJsOh+PVOD3i6+SV5tdDOrQBvNer6KLU7V+fOXGPge2x
	 Zd35NujbtQjwgP9cjbqzaZL9qxba4CcJaXc98GLdHGI/x4NNhxhOlHe/Zwhn/sHKcr
	 FJMZIxaH3DxY/VAQ3Pj7E+V/hsUBmhARn6CeuyM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+690d3e3ffa7335ac10eb@syzkaller.appspotmail.com,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/307] netfilter: xt_cpu: prefer raw_smp_processor_id
Date: Sun,  7 Jun 2026 11:57:09 +0200
Message-ID: <20260607095728.842399003@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c376f07e16c02239ed44cabb97145d03f65b4d15 ]

With PREEMPT_RCU we get splat:

BUG: using smp_processor_id() in preemptible [..]
caller is cpu_mt+0x53/0xd0 net/netfilter/xt_cpu.c:37
CPU: 1 .. Comm: syz.3.1377 #0 PREEMPT(full)
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 check_preemption_disabled+0xd3/0xe0 lib/smp_processor_id.c:47
 cpu_mt+0x53/0xd0 net/netfilter/xt_cpu.c:37
 [..]

Just use raw version instead.
This is similar to 14d14a5d2957 ("netfilter: nft_meta: use raw_smp_processor_id()").

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Reported-by: syzbot+690d3e3ffa7335ac10eb@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_cpu.c b/net/netfilter/xt_cpu.c
index 3bdc302a0f9137..9cb259902a586b 100644
--- a/net/netfilter/xt_cpu.c
+++ b/net/netfilter/xt_cpu.c
@@ -34,7 +34,7 @@ static bool cpu_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_cpu_info *info = par->matchinfo;
 
-	return (info->cpu == smp_processor_id()) ^ info->invert;
+	return (info->cpu == raw_smp_processor_id()) ^ info->invert;
 }
 
 static struct xt_match cpu_mt_reg __read_mostly = {
-- 
2.53.0



