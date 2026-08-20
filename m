Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B4A47CC73;
	Thu, 20 Aug 2026 16:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244607; cv=none; b=jD2BRlOvS3bql+NsZgXOo9mp24XugRyhSJpfasZdN99KbCH+EYPUSGlKBBZaUDF9jm+h6e5VD89PbHyS7a5fJ1mH9QM66gDeE1v2SlDtRNJVXAh4jcBvpRnhtBTONoPCprohLhchAj/ciNGD1T578RTA5RhNlnKJ8lHFGzjT9mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244607; c=relaxed/simple;
	bh=TXyhDf0UCfCcKYs5dUIh3xnxf6ZnScPeHC/WID2WLtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ikBsuu7UD+YQ7FERZ1ssUgEMj5HpPLvp5yxnV5w9s3AzE8r/idaw2tYwHeukh2t4wvNgtazLDOvHzCBd+Ttkmp/qxLvAliFP/s9Y3Ph9atQNieGpNTlsSTlsoLZuDtwoyqW1EXIH0uxl2N38LNyMuVyxx1PQJlADw5otz7224AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKxOLKUX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKxOLKUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B421F000E9;
	Thu, 20 Aug 2026 16:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244605;
	bh=c7/agWVy2pvIcKN2X/xGtA1nBydwsplFalxBeSnBJZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zKxOLKUXoYQs0512yeF2F+DEcRHbjHPWC916RyXQe5Ex156Q9L43W+fpAWT9WybOa
	 q9Tvjjc/9aBkVorFzNH7BYJt3ZAbRwI724XdKAZFVERLj65svIVTo9bXmf3szq2Nvj
	 GI7Qk0TErygVskvWMwrHjFAYruKXytLWNz65Bn4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 220/235] netfilter: flowtable: publish GC-visible tuple last
Date: Thu, 20 Aug 2026 16:57:36 +0200
Message-ID: <20260820145223.287824868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 2014ac62df9d45bb9a004a043e85df7be09ed780 ]

nf_flow_table_iterate() only treats original-direction tuple nodes as
owning entries. Publishing the original node first lets GC observe and
free a flow while flow_offload_add() is still inserting the reply node.
Publish the reply node first and the original node last so GC never
sees a partially installed flow.

KASAN can trigger slab-use-after-free read and write reports in the
flowtable/rhashtable path (rht_deferred_worker, jhash, flow_offload_del,
flow_offload_lookup, etc.).

Fixes: ac2a66665e23 ("netfilter: add generic flow table infrastructure")
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Assisted-by: Codex:gpt-5
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index e05e09c07b971..8f6b791918ae7 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -228,17 +228,18 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
 
 	err = rhashtable_insert_fast(&flow_table->rhashtable,
-				     &flow->tuplehash[0].node,
+				     &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 				     nf_flow_offload_rhash_params);
 	if (err < 0)
 		return err;
 
+	/* GC only iterates original-direction entries; publish original last. */
 	err = rhashtable_insert_fast(&flow_table->rhashtable,
-				     &flow->tuplehash[1].node,
+				     &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
 				     nf_flow_offload_rhash_params);
 	if (err < 0) {
 		rhashtable_remove_fast(&flow_table->rhashtable,
-				       &flow->tuplehash[0].node,
+				       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 				       nf_flow_offload_rhash_params);
 		return err;
 	}
-- 
2.53.0



