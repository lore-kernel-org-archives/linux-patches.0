Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E6A1D86C6
	for <patches@lists.linux.dev>; Tue, 20 May 2025 08:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747730088; cv=none; b=p/JinwBXGUcjUhG4v/zBTnSxVK6aGeSpT+TmVCcFyjEyUXk9qEcwQqXddpJkeNuGMaH5pQnHeyOVb+IuAo6sAQyOF2AapYW4VpntIb+qp2ADaGFRVltkvL5Ot5ygYlvykzlhNJJKdGla9qDmMKUNUbk+RyuN6h5xwfM1+ACX+dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747730088; c=relaxed/simple;
	bh=baaNnB5mw6P6bMCAwvRD2yCzeVDnqWbowLwoQ3gRqBU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=c+w7BJqNgJMQppdmW2hW1ltU0UR1QTdh6lEm43t/LpZXFxABB/hJwyHTRgBIO1JoivKr3v/PENaauPhJY0yrazhgd54rN/+/Xr9BPoKWxreea7zKvVUNYtwcAKl6Ne1e9U5hWXKD0B+HiGj572oOl21ONHR3mFVeKEE3m5Xep1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54K6KccP028082;
	Tue, 20 May 2025 01:34:40 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 46psykjn66-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 20 May 2025 01:34:40 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Tue, 20 May 2025 01:34:24 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Tue, 20 May 2025 01:34:20 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <jianqi.ren.cn@windriver.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <atenart@kernel.org>, <kareemem@amazon.com>, <netdev@vger.kernel.org>
Subject: [PATCH 5.15.y] net: decrease cached dst counters in dst_release
Date: Tue, 20 May 2025 16:34:36 +0800
Message-ID: <20250520083436.1956589-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=a8kw9VSF c=1 sm=1 tr=0 ts=682c3ea0 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=dt9VzEwgFbYA:10 a=bC-a23v3AAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=t7CeM3EgAAAA:8 a=RSTy8_7DnOH_di7dvoIA:9
 a=-FEs8UIgK8oA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: BnuNRq0N2AnM-9QjhHY5rghkzHYzyerE
X-Proofpoint-ORIG-GUID: BnuNRq0N2AnM-9QjhHY5rghkzHYzyerE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDA2OSBTYWx0ZWRfX7V+o0cpuP0ED SKJuEbV+Ne49fSGoLidRfnT7LVcyUt1GTDxB+tXbFX/7t8TJ5rIUD1xLA6kJwmwRY0ZckDV2og0 Vq0VQ9bLUPuNOgBpTQ5x3a85K6/R0kQhC3ior7XYLuCF5+bWpr2q3+MDqGmA9ZsBB3V+knnuVc9
 TMTscfUAyfTO/LmYlPUk/+fciHF4fwStuxOTZH45XUEoSpX1Ojnw0aETgAAdVv8c45GRH7sIe6o 8g/P2oGe+CQOFlSnVGmO43LnPwdj9iSk4VRESvnwNYzmrg+P51BS4OjgwmKYK4798rnidfCxwrc G2BsvcGZ5zuQY4TsELWNbaxGgMZf/IjJnU01eVQLkUF9UfXBfciFdgkMEbrrObuoHTBTfwHp0xE
 hwCXGF1jYPjbcZgM/Pyg6agjO/LdNvPy+QmyQ1Bey63uRgKJ2+3rt9g58dCXyMSNR0xVpfiN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_03,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 bulkscore=0 phishscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2505070000
 definitions=main-2505200069

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
index 6d74b4663085..c1ea331c4bfd 100644
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

