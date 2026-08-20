Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A392746D091;
	Thu, 20 Aug 2026 17:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247236; cv=none; b=uz5VSRf4vwqGxMotkHLjqmw1XelH9J1nS7a8ZdAL91SYhx1/igmOC+hd7oKSKTb0BT6tWc1tZ1TvPIJF3qIOEnYryUJj46MRq5XUJgk539pHfOt+q4edDjfcKp6uuit23z4ZuOxUWOueoHS4q9KI91EUt9YfJSSFUIBpsG+nUMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247236; c=relaxed/simple;
	bh=H5XgvQRVhux6sCTSYaNu+Kbr5jGpdsvMpRjODOMMo2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i7qJD9gDcOF4sVWRd5qRCKKRUiVQSfVcAopVAW+EcD+wP91hWTjr3R9iQ2o5JGJy0F99o8u0KiZQNytdM5FTYVz80mVI3hJzobEmBJg+fKyCfA9tC2MMPkqUdVhGLeZFk8DorsieB0d8n9gw1iCizjaGMz6sF7e5X1rbnL9UXfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTMTSQPO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTMTSQPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6961F000E9;
	Thu, 20 Aug 2026 17:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247235;
	bh=06HxX9SUCfNKa42j0eaOaHbMrJH3SN859lMh2LBY9y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fTMTSQPO/xPuVxV/igvNyFg7nh6xiAhJPuRUnbV3FuaFL7AZRTeFjMHbtkK5m28Ab
	 xoKNyGdc9CgltQkoUa0utWcUctvxh+cUQ7WfkUGs7Lf/q/kPNaubN8qj3N+V4vG/1a
	 3NsUjfuhwcKTaa5Jt6s/oadsUQf/ulZ6OizgS4Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 197/220] netfilter: flowtable: publish GC-visible tuple last
Date: Thu, 20 Aug 2026 16:56:27 +0200
Message-ID: <20260820145229.434181138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index df72b03769706..b9e3ac950894f 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -279,17 +279,18 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 	flow->timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
 
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



