Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3623E42B738;
	Tue, 16 Jun 2026 15:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622735; cv=none; b=dkPzEucpoFcpGNtzxb5ijaLbEXHfD7wtZCHt16hu4CmhAangzYHJAv2rwTZsnJVMVMtnGBIjg5WGkMLiPjdWn/37hRh9YbVklUbZvmyOeOPiZuDqp82FHqrlzXTQB85r2nnEm2Lmu6+ecz7fLi+pD1N3AL8721PKSmPj5T8e4nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622735; c=relaxed/simple;
	bh=dl9bf0hfWv+rTdePdz6NcmgB4qNrlxCJSDcf2eHLAVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3YMCkpXQDj8glfbOLA8Jp6QK09Cp0ZlxyUAm34gafZF2JkQfF3lRTw6HH79/i8H5cixWlMTJnheomVGXkyy9tHz0dzfXOVTXKWE8rkkXM9LPfrcgoUObLGBhGX3Wd0+AEOM4Q6+cGNtMkDRzEKMc3mT+j0revbY3Qa/w4itipc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0k937/Cg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0k937/Cg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6141F000E9;
	Tue, 16 Jun 2026 15:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622734;
	bh=pF0yoktCPZNYrNADaGCngvykSBuT7of3/qcbDMp0wrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0k937/Cg9cXt9nuhjRZ0oh4Kq2bGc/7dtnC0CvPJzFZAXPD1Ldb5Z3dgp1SWgTryS
	 JRVThjf9zBV6bRL1tNZd/9HF76iKAKs93JH3DKhbXobmyzfGgxrClSPZ78lSXlSdac
	 sMCFANQuabWALDYKj5OyFm+3gOSxBBHJxzgRPWL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 019/378] netfilter: xt_NFQUEUE: prefer raw_smp_processor_id
Date: Tue, 16 Jun 2026 20:24:10 +0530
Message-ID: <20260616145110.839054740@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



