Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB0F32E728;
	Tue, 16 Jun 2026 17:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629297; cv=none; b=D6JLqmuDNftT8jA2+Ou2lwFbk/gJEjgcCz1hoXGhQOk/t32dSfdSenRCZxgmzLd0gT23dGEqeiXA+iczzT1ZdNT62kqw+uFryM29JoiO6JTHN4lHKre75kjmBeSZxv0oTkuo4KLQLcGyUAAtxl2dHHLKTKcANAVFFJSpQSoJv4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629297; c=relaxed/simple;
	bh=56aMzBOGh3nxML8WcOqoUNH3UACGgdwaSmIIfU/IauE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BL0nnjWPBh31FYyvirRVxvI0rNAzzuU3Z1xcLwqsb9ROjuvrIqmmg9EBfTGvloeDxqzEaiVwF7VRqhjNuXr2SetjD1R7pqgwrCfh5pqMgsHUpcW+Mz2Iruj4BBuSXrS6FtPoR0q/ugCINAPJ86311tTY6T6KQD7RQ6IlZA3bGG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0iGDT/Bl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0iGDT/Bl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8881F000E9;
	Tue, 16 Jun 2026 17:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629296;
	bh=xAIGbAYwFQinBNPnfgtqhBw7ovPK5IKk5gE/iGGLv8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0iGDT/Bl8NsU4DEDgJyeevi5v8t7afUCaSH3+hQsk4BmmsKL+8rgytE/UXyRkU3UC
	 AlljwLwRyuF9BFVPGnV4cbjrykUVO7Bf8ln/1GfolwqKk0OMRNkoxqyC+wjVaRJWz8
	 rm1SyiINXMG0RYys/pzLBG9b8HJazTQaWRl+3iR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 215/452] netfilter: xt_NFQUEUE: prefer raw_smp_processor_id
Date: Tue, 16 Jun 2026 20:27:22 +0530
Message-ID: <20260616145129.087152262@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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



