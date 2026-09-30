Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0CE4FC320;
	Wed, 30 Sep 2026 15:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783715; cv=none; b=a81Mf0ryuuaogasKWu9wu9ialAdlTgggZYudMQicsz34nAbv6W6kKS+glNRYF1BWjDk1w/PQrFx0IFbptmyPeispS/x3Z6EQUL7abhAG5lISPdM13XIUsojTZh8eZPYp/fELI54plaXMyEPFoHiEIUdRIPWM1eGWZxGWyDexFFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783715; c=relaxed/simple;
	bh=MF8zIdAmhdwOW1mrTPIW4fQAUD14Oa/1FhaJbPrZf/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6GtEjQduDtl19U87pd3Y6w7b7Pp7Npxvc1SHty6gbZcLTFlk7MAHuCd6+15/TMrJqXIIhwrgu+nxRZ7jcVTnz7UXekTXldMeE4daP9MzMeQMtoK8y5pgrvKmdpvtrv6jbXwolXYTf0nMt68WFUAKpnK06khOsKOW7fur+KJbMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sz1MJEBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sz1MJEBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00E51F00898;
	Wed, 30 Sep 2026 15:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783710;
	bh=NuafsN+xeiPfSx9+0gycqRvdF4iU2oSfRyUBc2+Ryoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sz1MJEBIY6AW6pkclioHonqMM50AWOHNhVtO4nVHzEWrNH8Pn3iwETm4fAnHdJsqR
	 GkjBTA008UreV+XizvTJWpZt1LrhRVmNciniMC6OSN32fxaWf5ysHZQZuYnJIINZOQ
	 mdkuoQpJXij5WP6j2NBcEUp5z+//2oudkRqpUjv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 493/595] netfilter: flowtable: allow unidirectional rules
Date: Wed, 30 Sep 2026 17:26:26 +0200
Message-ID: <20260930152358.296269676@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit 8f84780b84d645d6e35467f4a6f3236b20d7f4b2 ]

Modify flow table offload to support unidirectional connections by
extending enum nf_flow_flags with new "NF_FLOW_HW_BIDIRECTIONAL" flag. Only
offload reply direction when the flag is set. This infrastructure change is
necessary to support offloading UDP NEW connections in original direction
in following patches in series.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: d644b23afe1e ("netfilter: flowtable: publish HW_DEAD after worker is done")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_offload.c | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index b338638f22792..d7c81aa90c802 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -127,6 +127,7 @@ enum nf_flow_flags {
 	NF_FLOW_HW_DYING,
 	NF_FLOW_HW_DEAD,
 	NF_FLOW_HW_PENDING,
+	NF_FLOW_HW_BIDIRECTIONAL,
 };
 
 enum flow_offload_type {
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index f6275d93f8a51..b383f6241d834 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -734,8 +734,9 @@ static int flow_offload_rule_add(struct flow_offload_work *offload,
 
 	ok_count += flow_offload_tuple_add(offload, flow_rule[0],
 					   FLOW_OFFLOAD_DIR_ORIGINAL);
-	ok_count += flow_offload_tuple_add(offload, flow_rule[1],
-					   FLOW_OFFLOAD_DIR_REPLY);
+	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
+		ok_count += flow_offload_tuple_add(offload, flow_rule[1],
+						   FLOW_OFFLOAD_DIR_REPLY);
 	if (ok_count == 0)
 		return -ENOENT;
 
@@ -765,7 +766,8 @@ static void flow_offload_work_del(struct flow_offload_work *offload)
 {
 	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
-	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
+	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
+		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
 	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
 }
 
@@ -784,7 +786,9 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 	u64 lastused;
 
 	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
-	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY, &stats[1]);
+	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
+		flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY,
+					 &stats[1]);
 
 	lastused = max_t(u64, stats[0].lastused, stats[1].lastused);
 	offload->flow->timeout = max_t(u64, offload->flow->timeout,
-- 
2.53.0



