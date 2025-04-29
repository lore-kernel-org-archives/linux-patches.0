Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A681C1C173F
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 07:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745912710; cv=none; b=hKcdTL9j0EQvA/w/7NChfXMAMzhVHI29zcurpWb4fCRVg/4OWLCu+Xlrx2oNDqgC1DRRtQynS6YX9lasMtT/0ZGY3VD/Bro0GcazRPpZJ8r31pBwMsdI9nurIASNnmFQwZW7StKPCHL43fXLJrRyncqt1nheB5ZUp/YlSGfQSJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745912710; c=relaxed/simple;
	bh=G8dU/8ZraGb4ZDw4STUDdNEQVI98PTS1z3Ot10oXmVU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ie1TTZYr5uDy/bDxNXkZ0/FeTOFmzLhmGVc/r875+pAmMroVnogmS0ZW/vFEUadDaXAXjFD+EOQTDZ7Tht/uIf4iFTcx3mDv94gd3T7QvSGqrkzEwbFKcATzE2lXJIvpUnrW/7bI7pTN3yNI9NFOCpsbo4+4X6M51Cj3atzL01k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53T3kYcd006268;
	Tue, 29 Apr 2025 00:45:01 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 468y0ksmxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 29 Apr 2025 00:45:01 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Tue, 29 Apr 2025 00:45:00 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Tue, 29 Apr 2025 00:44:57 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <jianqi.ren.cn@windriver.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <michal.swiatkowski@linux.intel.com>, <zhe.he@windriver.com>
Subject: [PATCH 6.1.y v3] net/sched: act_mirred: don't override retval if we already lost the skb
Date: Tue, 29 Apr 2025 15:44:56 +0800
Message-ID: <20250429074456.3626604-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDA1NyBTYWx0ZWRfX1Nc8ZcZ8rBQT QBwUzFC1J0xE8XOfxC9iBJn4HgRDdmKMnWfn/FxuvVvlJvxkRGoRect+QTs8bSzVF3xh4D4Q9lk X37auw/naTAmxWvLXbSk518A5FggQGI32rkV0s0uzqDpN01eVf+qaZVTnNSsGAGhWsQI6SrdmK2
 h90fj3wd7nOgX+wXuD6b246qiZefyW3QnlkzQsg3d+3GoFYo/OY/052VTYhwdenRN75mmzpHp1/ VLz8xMMtezVT2UEyCzMS6BTTOLumqxSwyaYi550DwXcRjBF8/8z8RzhkiT4VTxyly7pi3XzKI+Z cRJSHCsT3T2s35By/3/vbXFsCl3YoaOEzvoF+sBfw+Yu+qu5jxG+Ie8U20GubkwDy1sCojKihXP
 dvFwUemZRBfBjw9frCKpMXNDQ/CZXPKl/X4nYFm02SL2T0D7WYV/lzNQxM5YvNVWegRfsjsS
X-Proofpoint-ORIG-GUID: rIVTkqjRQilyT82V_WNgSXcEnFdkaigz
X-Authority-Analysis: v=2.4 cv=O8A5vA9W c=1 sm=1 tr=0 ts=6810837d cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=A7XncKjpAAAA:8 a=J1Y8HTJGAAAA:8 a=t7CeM3EgAAAA:8
 a=46DbhiKqDBczhwNKROYA:9 a=R9rPLQDAdC6-Ub70kJmZ:22 a=y1Q9-5lHfBjTkpIzbSAN:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: rIVTkqjRQilyT82V_WNgSXcEnFdkaigz
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_02,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0 malwarescore=0
 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.21.0-2504070000
 definitions=main-2504290057

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
v2: Fix the following issue
net/sched/act_mirred.c:265:6: error: variable 'is_redirect' is used
uninitialized whenever 'if' condition is true
found by the following tuxmake
(https://lore.kernel.org/stable/CA+G9fYu+FEZ-3ye30Hk2sk1+LFsw7iO5AHueUa9H1Ub=JO-k2g@mail.gmail.com/)
Verified the build test by cmd(tuxmake --runtime podman --target-arch arm
 --toolchain clang-20 --kconfig allmodconfig LLVM=1 LLVM_IAS=1)
---
 net/sched/act_mirred.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 36395e5db3b4..bbc34987bd09 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -255,31 +255,31 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 
 	m_mac_header_xmit = READ_ONCE(m->tcfm_mac_header_xmit);
 	m_eaction = READ_ONCE(m->tcfm_eaction);
+	is_redirect = tcf_mirred_is_act_redirect(m_eaction);
 	retval = READ_ONCE(m->tcf_action);
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
 	 * since we can't easily detect the clsact caller, skip clone only for
 	 * ingress - that covers the TC S/W datapath.
 	 */
-	is_redirect = tcf_mirred_is_act_redirect(m_eaction);
 	at_ingress = skb_at_tc_ingress(skb);
 	use_reinsert = at_ingress && is_redirect &&
 		       tcf_mirred_can_reinsert(retval);
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

