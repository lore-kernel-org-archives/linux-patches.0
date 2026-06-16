Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32407466B65;
	Tue, 16 Jun 2026 16:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626520; cv=none; b=sNdZo/gWjdF1wGSCvxDxdbBg7ISWBVUzO3l1Nu6lLyjRgkfQLmh5K+Ef2th31lvPHrenar1RxArord38MQAeWnZJGHEwRnECbk/lCJ6DK8DdqF6sY7pNXhBW/fzrBgrww4jcdhUD5t+QbQkKWXzsIi597+Y7FMYjNeP5tuY3idg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626520; c=relaxed/simple;
	bh=xELqS50gv0U90naUCIQRN2/iI3soq/wacurEFfxW0nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+vjyKY1vq0rtLCnOXus1ewclegO9ApgY+z+uKidlCAfwNlJ89txjW0HFRtGo1UUiDDdAMgNRjiKzmSDTsVbG9X7zcJMUmrFQBaMP2K5UwRRs2zQqMdlATCWAbUoBKOBvZma3+H7HJt1rJolteNEdvzjv6htItG/rN0EXveAiNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUHAMAVJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUHAMAVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F151F00A3D;
	Tue, 16 Jun 2026 16:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626519;
	bh=o4ZCZz/N7EWcIONmKpYWVeErnxwcqdew8sSWBmEEmXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WUHAMAVJHrIGDNgmh5e6UCaSkkm5x2hWipahUaKoWMTYOKGOgtBtiiq7VZGZ9OB/z
	 OiY4EavXPhL39tVBJYwY7hzDEWnI1oBMLmQKW3cqTkqXbv4P0lyrGa9q8PaNuCI2H+
	 7hPPv1pPx/YssB6t02LzbWZ0s1aDVZHjyrjEuUjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/261] netfilter: xt_NFQUEUE: prefer raw_smp_processor_id
Date: Tue, 16 Jun 2026 20:27:36 +0530
Message-ID: <20260616145045.857865234@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit c6c5327dd18bec1e1bbf139b2cf5ae53608a9d30 ]

With PREEMPT_RCU this triggers a splat because smp_processor_id() can be
preempted while inside a RCU critical section. If xt_NFQUEUE target is
invoked via nft_compat_eval() path, we are inside a RCU critical
section.

Just use the raw version instead.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_NFQUEUE.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 466da23e36ff47..b32d153e3a1862 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -91,7 +91,7 @@ nfqueue_tg_v3(struct sk_buff *skb, const struct xt_action_param *par)
 
 	if (info->queues_total > 1) {
 		if (info->flags & NFQ_FLAG_CPU_FANOUT) {
-			int cpu = smp_processor_id();
+			int cpu = raw_smp_processor_id();
 
 			queue = info->queuenum + cpu % info->queues_total;
 		} else {
-- 
2.53.0



