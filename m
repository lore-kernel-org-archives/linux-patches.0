Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C991D381B05;
	Thu, 20 Aug 2026 15:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239189; cv=none; b=r5RuL2h2XEScbnE1tBsM/TOGQCNq5zrgqLTaiXimj+bIY0YdvZdyicQ5YxKFqFbFxKCpyI6dZtn0UKKjWt4obeJQSGaKjZZkGsWMevT1tY5PUafJuCEoRyd7qaZ5kgLL8JwAE2WNLXubrmMMyb8kUlPteXrch44LhRGuKtv9iBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239189; c=relaxed/simple;
	bh=Of8QJ8e4kUWYN2XaL5x+WMFplA69e5JlHj4QfqV0690=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t1xLNq3YG7COuDB+nN0gvUqT+hgcZUzfyZlGr+iCwbpuCBpTDlD8zu46r7x8aqAQ5suToLfP7LMRv6hp8A8+aD+QBiD/pFam/Z8ZjEkHdpRMI8mGJScV+8cr+tDEyO2WMJA5oBi1QxfsamAopkRcmqKc+wvWAoETvT+gl3hpbVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FR6YBnbT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FR6YBnbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDC21F00A3A;
	Thu, 20 Aug 2026 15:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239188;
	bh=KZfrnWOBBvf1ApONr2lxc7jYsvoRuj5F/fN0BVYtt8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FR6YBnbTzx6XrU106y1PuDhgicgqoU5wlIifvzEa5A70OH2PgPHyOXUINxqi3/6BV
	 rkLvhH+BdwEqlormO7rBe2yJ7IvyGCE215ZpGKcPPffZtgMthc/iTKQVxYEjxyUI6d
	 wzYnonXnf2Fhw3rkbqAHoePolz/9+r4DCKNKYfrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 180/217] netfilter: flowtable: publish GC-visible tuple last
Date: Thu, 20 Aug 2026 16:55:48 +0200
Message-ID: <20260820145243.151110951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 595a0f19d15e7..7a93e22d049db 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -324,17 +324,18 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
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



