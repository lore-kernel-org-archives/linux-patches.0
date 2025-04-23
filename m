Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5071C6FF9
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 08:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745398788; cv=none; b=jgMrMQlVBZk7MGoFERPt3XvvsaNpqiZGospZB3IkwqSeaxorH5OV4p8cLcKZQYtLxoDLAnbRwv/rlKQFQvVRlLV5p/yJSwtHAn8C1/7/2PBfo/NcJF0kGy38xAuOf8Vp9xKS9mcKJf8t8nVVlyirkSzjFt6gz5Mkxb7FWbDo5zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745398788; c=relaxed/simple;
	bh=D+UMp305emUDWoNQq7isR9+zbumo1GF0fkmUTSlPRvo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FD7r2IYU5z+taewvQRQa/7DRjN3GSt9R1pZDwTeac21smP+gO3tTwDBhdnn/T9myazBQnvzbBL/Md0wK023iEF2Pdy2Bpl/xYeke/s9vcWGT5o1NIB+ieXqnCeQXh6JhVjFZOXVOYOabC355ch2HHf/5wwLLLZGNNoEqTU9igZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53N4cJ9R020546;
	Wed, 23 Apr 2025 01:59:41 -0700
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 466jhd0gts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 23 Apr 2025 01:59:41 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Wed, 23 Apr 2025 01:59:40 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Wed, 23 Apr 2025 01:59:37 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <jianqi.ren.cn@windriver.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <michal.swiatkowski@linux.intel.com>
Subject: [PATCH 5.10.y] net/sched: act_mirred: don't override retval if we already lost the skb
Date: Wed, 23 Apr 2025 16:59:36 +0800
Message-ID: <20250423085936.2892096-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=ZNDXmW7b c=1 sm=1 tr=0 ts=6808abfd cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=A7XncKjpAAAA:8 a=J1Y8HTJGAAAA:8 a=t7CeM3EgAAAA:8
 a=z6SZLS2PjRZJ6NiNSX0A:9 a=R9rPLQDAdC6-Ub70kJmZ:22 a=y1Q9-5lHfBjTkpIzbSAN:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: hh35COSBTRb_j_HFiMsLPNNvsrM-ULbI
X-Proofpoint-GUID: hh35COSBTRb_j_HFiMsLPNNvsrM-ULbI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA2MCBTYWx0ZWRfXyqRk6/V2NLAi QGE3YnxsNl/PtmV7dz8DswCOxjwzv44oP6LzZzbsct3gob5l3C/uodrn9av0dl0Cpl9Y5yuiobu gErqDqsyO6Xqg5HNcbWYwtMDO7wxOV5T9e/GcDLqdXzbM1wyqrjgRXiZYK1yrn2NM47U9A/+9CZ
 2f2J7lguReouQrMsLZs6yIf905pGleoDWQAtv3iKSYhj354ZI6BJnfAvXjwRVtdbqTUMGbLRs4o w2dcetE/5mW/o8Vs7K6unphiKIP5BVFchsxqkOVMS+1AQ7WG9/zP5Rv0QlVBALSUyBCR52OmOTt 288PZx1sc3aLOjbCy6CM+KQdrnHj2+su7Zhbjy557MbQLlQtWofkD7sRXNvgFdC6RfnuN8LOsoh
 HH8vLA1VAiBhuqHfMVDqGAGv5CGRAise95aAP50VKx4xdeP+5aNvuuAzaGNNsD764SVxB2EO
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-23_06,2025-04-22_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 spamscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.21.0-2504070000
 definitions=main-2504230060

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 166c2c8a6a4dc2e4ceba9e10cfe81c3e469e3210 ]

If we're redirecting the skb, and haven't called tcf_mirred_forward(),
yet, we need to tell the core to drop the skb by setting the retcode
to SHOT. If we have called tcf_mirred_forward(), however, the skb
is out of our hands and returning SHOT will lead to UaF.

Move the retval override to the error path which actually need it.

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Fixes: e5cf1baf92cb ("act_mirred: use TC_ACT_REINSERT when possible")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Minor conflict resolved due to code context change.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 net/sched/act_mirred.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 91a19460cb57..89201c223d7c 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -260,13 +260,13 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	dev = rcu_dereference_bh(m->tcfm_dev);
 	if (unlikely(!dev)) {
 		pr_notice_once("tc mirred: target device is gone\n");
-		goto out;
+		goto err_cant_do;
 	}
 
 	if (unlikely(!(dev->flags & IFF_UP)) || !netif_carrier_ok(dev)) {
 		net_notice_ratelimited("tc mirred to Houston: device %s is down\n",
 				       dev->name);
-		goto out;
+		goto err_cant_do;
 	}
 
 	/* we could easily avoid the clone only if called by ingress and clsact;
@@ -280,7 +280,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	if (!use_reinsert) {
 		skb2 = skb_clone(skb, GFP_ATOMIC);
 		if (!skb2)
-			goto out;
+			goto err_cant_do;
 	}
 
 	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
@@ -323,12 +323,16 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	}
 
 	err = tcf_mirred_forward(want_ingress, skb2);
-	if (err) {
-out:
+	if (err)
 		tcf_action_inc_overlimit_qstats(&m->common);
-		if (tcf_mirred_is_act_redirect(m_eaction))
-			retval = TC_ACT_SHOT;
-	}
+	__this_cpu_dec(mirred_nest_level);
+
+	return retval;
+
+err_cant_do:
+	if (is_redirect)
+		retval = TC_ACT_SHOT;
+	tcf_action_inc_overlimit_qstats(&m->common);
 	__this_cpu_dec(mirred_nest_level);
 
 	return retval;
-- 
2.34.1

