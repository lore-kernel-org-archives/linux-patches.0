Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618E421CC51
	for <patches@lists.linux.dev>; Tue, 20 May 2025 08:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747729784; cv=none; b=LU8XjvVMYiDN7krZGoqPlPo2PiZF2zn05gfm4eKxgaP4xZ4CtdeVP74UrqH85mnLICwBu80JVrCHtqoYLPzPaDbBY+Q8rvn0jQ5CfnrI4v39lnSUGxiGktwki1U1OgN84cYmOe9tiSCcLYBtShkbIUQuS3bxt5LVubCwn2/eWxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747729784; c=relaxed/simple;
	bh=POiTATqg05LVeisM3BzKZGvxLNPea9Z+h0WRmR+dEnM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CyfU5+j4d4HSMLQNUGT02Uwvp90xGelNYGzIeZ0Dq4cuHNENMAhtWakDBgSEVHQr9hcYRzCkoTKYXE90ZSn8IOwbv3JkqfaIukl3iUqB3bnwqRlKB573PsNewBIliaNrIqlhF0YjqUT+zEIzlPLaUBxzDGXIoB9OMK1RN/U0Nt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54K596md015733;
	Tue, 20 May 2025 01:29:36 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 46pnr3jtnx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 20 May 2025 01:29:36 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Tue, 20 May 2025 01:29:19 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Tue, 20 May 2025 01:29:15 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <jianqi.ren.cn@windriver.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <atenart@kernel.org>, <kareemem@amazon.com>, <netdev@vger.kernel.org>
Subject: [PATCH 6.1.y] net: decrease cached dst counters in dst_release
Date: Tue, 20 May 2025 16:29:31 +0800
Message-ID: <20250520082931.1956136-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDA2OCBTYWx0ZWRfX7GxItn7y2WNl 1nESQBDIFku7/ujVd2tyVMldMS2fp5dLUk9armUR84/G6sqviVpNPL2/FRwGoO1XAZ8sQ1FcMDD lum8NdhET4skwqskzoW0z+uPKQ5Op2W9XVxBlv35jG9bzXZndsSs+5glgPSvDu8DlqqF346GgGL
 6N8qXhNLveogGuE2SiEMelkfnixcuiHxz74MWtoy0xZRd+Zp/yHy9vMqcMYXtVv0KafnRk1UxDy BFjkwSRLfNV3dlXb+1xJKAGQ/2Qbf9sWY4ReebbxI9xDKv4DY+Sw32YZwarv0EXqZGt5g89h/8s fvoLz4VxsLMvSafUKVUyy/hFLusHuweZGaTRv1b98ZN4Scja7iQxGKs0CexiGYQtnayRER9RlBt
 not5aV3+Ww/TJlrGz0nhNo3JcD/rSMA2nlpAEwZ/towoZtW3EiyutOktVd4sh4MhUhw7fjl/
X-Authority-Analysis: v=2.4 cv=Z8XsHGRA c=1 sm=1 tr=0 ts=682c3d70 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=dt9VzEwgFbYA:10 a=bC-a23v3AAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=t7CeM3EgAAAA:8 a=RSTy8_7DnOH_di7dvoIA:9
 a=-FEs8UIgK8oA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: dNukir9HOYc7GMkEcLq8JVK2yJgTaYqz
X-Proofpoint-GUID: dNukir9HOYc7GMkEcLq8JVK2yJgTaYqz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_03,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0 clxscore=1011
 adultscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2505070000
 definitions=main-2505200068

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 3a0a3ff6593d670af2451ec363ccb7b18aec0c0a ]

Upstream fix ac888d58869b ("net: do not delay dst_entries_add() in
dst_release()") moved decrementing the dst count from dst_destroy to
dst_release to avoid accessing already freed data in case of netns
dismantle. However in case CONFIG_DST_CACHE is enabled and OvS+tunnels
are used, this fix is incomplete as the same issue will be seen for
cached dsts:

  Unable to handle kernel paging request at virtual address ffff5aabf6b5c000
  Call trace:
   percpu_counter_add_batch+0x3c/0x160 (P)
   dst_release+0xec/0x108
   dst_cache_destroy+0x68/0xd8
   dst_destroy+0x13c/0x168
   dst_destroy_rcu+0x1c/0xb0
   rcu_do_batch+0x18c/0x7d0
   rcu_core+0x174/0x378
   rcu_core_si+0x18/0x30

Fix this by invalidating the cache, and thus decrementing cached dst
counters, in dst_release too.

Fixes: d71785ffc7e7 ("net: add dst_cache to ovs vxlan lwtunnel")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Link: https://patch.msgid.link/20250326173634.31096-1-atenart@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[Minor conflict resolved due to code context change.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 net/core/dst.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/dst.c b/net/core/dst.c
index 8db87258d145..1c16821581c8 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -173,6 +173,14 @@ void dst_release(struct dst_entry *dst)
 			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
 					     __func__, dst, newrefcnt);
 		if (!newrefcnt){
+#ifdef CONFIG_DST_CACHE
+			if (dst->flags & DST_METADATA) {
+				struct metadata_dst *md_dst = (struct metadata_dst *)dst;
+
+				if (md_dst->type == METADATA_IP_TUNNEL)
+					dst_cache_reset_now(&md_dst->u.tun_info.dst_cache);
+			}
+#endif
 			dst_count_dec(dst);
 			call_rcu(&dst->rcu_head, dst_destroy_rcu);
 		}
-- 
2.34.1

