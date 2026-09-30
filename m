Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A788E511E90;
	Wed, 30 Sep 2026 18:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792320; cv=none; b=fsioAhUmQ7P/Rdl/mfoV6xzMRhkg3jO6gCpyxwtS6y25jFYdSLFUbObHrT8M/nI7Tox1R8pY7mdYu0FZtocXEcN7ZABFDVY0SSj2AdK2FN4FlWWMJI46OEQnH2Jd+a5zLcwGU1XCNXlEWVmVpvR6vcDGCx/mgroJx6RUVHbgOH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792320; c=relaxed/simple;
	bh=2lq30bRUH5yN5xRQ7/mqJsSO3NMMu1AyWr28bKdGuw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J28SWCX0Y9j/PXd2mWw1F6DWpoSvc4Ro9C9wTlyQVKtxqRzeFadz9YnyHTFZUdIQWbckmk16deW5WH1BOiArTG037+yAVzEWlPynzIQmcsRglX+MWRP/13nocRak3reZ+H0EpH+JM3EYysp77oJOa4N/QEsTGcpJujr8DEqbfc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qc1I+1hf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qc1I+1hf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17F91F000FF;
	Wed, 30 Sep 2026 18:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792319;
	bh=z+ra/ngQ7OJXnxj7nwqvVTgaLypjChoZCCnatw+0D6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qc1I+1hfYH3o/tPMHAlREPTYCsswmbjyI9jAH8Rso0bqVr+m/esYZmuEkkWavN4UA
	 iqxZw/q74PvlMkuMoCV9rERBt1XcGkObVhGam0F7O5FEKJ3pYwrfF71fuXRqmwSMHF
	 oMoHGfasKT/UORRXdWI0skD8JwFIyNulEZVLX5Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 614/752] netfilter: flowtable: allow unidirectional rules
Date: Wed, 30 Sep 2026 17:28:04 +0200
Message-ID: <20260930152411.569378392@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 664c3637e283c..d36877efa5c75 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -160,6 +160,7 @@ enum nf_flow_flags {
 	NF_FLOW_HW_DYING,
 	NF_FLOW_HW_DEAD,
 	NF_FLOW_HW_PENDING,
+	NF_FLOW_HW_BIDIRECTIONAL,
 };
 
 enum flow_offload_type {
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index dcbae058c59a3..ffcd43ed1fc9b 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -946,8 +946,9 @@ static int flow_offload_rule_add(struct flow_offload_work *offload,
 
 	ok_count += flow_offload_tuple_add(offload, flow_rule[0],
 					   FLOW_OFFLOAD_DIR_ORIGINAL);
-	ok_count += flow_offload_tuple_add(offload, flow_rule[1],
-					   FLOW_OFFLOAD_DIR_REPLY);
+	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
+		ok_count += flow_offload_tuple_add(offload, flow_rule[1],
+						   FLOW_OFFLOAD_DIR_REPLY);
 	if (ok_count == 0)
 		return -ENOENT;
 
@@ -977,7 +978,8 @@ static void flow_offload_work_del(struct flow_offload_work *offload)
 {
 	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
-	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
+	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
+		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
 	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
 }
 
@@ -996,7 +998,9 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
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



