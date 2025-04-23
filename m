Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3292701B2
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 08:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745398780; cv=none; b=G8RTcHo5rzC+FPUGCJpTMLzYkajC2fZqtkptncvm1v+GNQ68IjGXtm+41faqaWEXYxDwj7I2uZLD5GNbpK8CATK6sAplqaTyWxvrV7Od39msBTOCJtGh83bu/sLzv4MUALfZB27Y0+sFjJe7pz2mrEPaXIKKAWVWcVqiwPHw4u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745398780; c=relaxed/simple;
	bh=uHWekA94BHUStyZoX5LJyDtvPegkwkDK+SHYN1zdReg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UAcX8LB3IiD1zeApZnwRzkukFd92/J3iDIBr8tB3blIsnnDrPhQxlMh/aoL/bUlzVTCCSQfG0dZlAKmYrUb6t8q5x5RWzY1egxLLexCOAmFMm8+qX6EOcb991582ogp8UrkGrv1pPRVrjCe6O/ebs3b0zL9fgGMsTZKCXudys6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53N7lBYB025978;
	Wed, 23 Apr 2025 08:59:29 GMT
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 466jhj8h9w-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 23 Apr 2025 08:59:28 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Wed, 23 Apr 2025 01:59:27 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Wed, 23 Apr 2025 01:59:23 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <jianqi.ren.cn@windriver.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <michal.swiatkowski@linux.intel.com>
Subject: [PATCH 5.15.y] net/sched: act_mirred: don't override retval if we already lost the skb
Date: Wed, 23 Apr 2025 16:59:23 +0800
Message-ID: <20250423085923.2890055-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: IEluZoRdqirOPmjxdYA4XupcAB1J8Z7l
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA2MCBTYWx0ZWRfX1DCx4QgzP1eT V7bkHXk0uxGxAdOYczLh1Os+Z3ICuxlVea4uNIKt8uEoraFjPw0NLVxockOYz78qapziTu8svOV 1Il5u1NCjMOv2ezzm7tbzG3/KMG0HrBEGAo3NlIgf8DV8UnvmVnR8TQbVO5nA4KKmNQKYnGz2y3
 vgfDogb2axwTt+N0JAyEYjHaE3vK3ts0i9T/3EtowoXibBOlYJrhrmUo/3caGAkF3PqOu99LQO+ KsRjky49T4tH0ufdMLsYIk53jjogwe739+PzG0gOgvmnhQTIqANE0G4GbEuGzSczo98Cz3eDuTG dCaBNqXQ4vs2XbnoeGS0a46bPeLIM1V6Xi1LxlrjE5aycDrKUDXd7/33TFwVAClchQYJ7ZtVNOj
 ykJqaNkuPcy62VHFT4JcijhyheK3oPvTuEl6n+y0Ojf3s4zJUJMH+pNhgVm86AsHl7V511bi
X-Authority-Analysis: v=2.4 cv=ONQn3TaB c=1 sm=1 tr=0 ts=6808abf0 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=A7XncKjpAAAA:8 a=J1Y8HTJGAAAA:8 a=t7CeM3EgAAAA:8
 a=z6SZLS2PjRZJ6NiNSX0A:9 a=R9rPLQDAdC6-Ub70kJmZ:22 a=y1Q9-5lHfBjTkpIzbSAN:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: IEluZoRdqirOPmjxdYA4XupcAB1J8Z7l
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-23_06,2025-04-22_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 phishscore=0 spamscore=0
 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2504070000
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
index 97cd4b2377d6..e1c183b28306 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -258,13 +258,13 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
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
@@ -278,7 +278,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	if (!use_reinsert) {
 		skb2 = skb_clone(skb, GFP_ATOMIC);
 		if (!skb2)
-			goto out;
+			goto err_cant_do;
 	}
 
 	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
@@ -321,12 +321,16 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
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

