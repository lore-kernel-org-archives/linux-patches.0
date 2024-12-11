Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA36C1FF1CA
	for <patches@lists.linux.dev>; Wed, 11 Dec 2024 09:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733908407; cv=none; b=KXXbH3GgzDoA4C6hjgizzcs6P5QsySSLQUf7RCxLM61o7OVswz/sBho3fV3hxjHZ28WVFIiUjvkBlLXVNPh+r3mrUsDo5L4GKQOmbqQEVRrQElK7BVLtlm2wAqvbSapEhacxF7y1m1QoDlamtW9AXhEOxFFIwkPTiTQGb8WF5gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733908407; c=relaxed/simple;
	bh=XRUbHwyQJfMjlhl4yYYx2nMCEEWfAaFjnaY1xKjMuzs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rWRN5wACCDXR+e8OBQWO1GNaC3THK9xcK+V1cNFLy49MQZWERFeM9ezKhUgSbccZ+5O5Tv3ZgCVxv5I7vAqa2NoaXN8d3TFNHrvsip9hqA1DqzXLnJXfnp7QtXJaCezYN/yDrd/7IQLQ/ncmjga8/Zt3jGpcI0hwxy/sVNU0fAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BB6pZao008972;
	Wed, 11 Dec 2024 01:13:18 -0800
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 43cx1u4046-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 11 Dec 2024 01:13:18 -0800 (PST)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Wed, 11 Dec 2024 01:13:04 -0800
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Wed, 11 Dec 2024 01:13:01 -0800
From: <jianqi.ren.cn@windriver.com>
To: <jdamato@fastly.com>, <gregkh@linuxfoundation.org>,
        <jianqi.ren.cn@windriver.com>
CC: <kuba@kernel.org>, <edumazet@google.com>, <patches@lists.linux.dev>,
        <stable@vger.kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <sashal@kernel.org>, <jamie.bainbridge@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 6.1.y] net: napi: Prevent overflow of napi_defer_hard_irqs
Date: Wed, 11 Dec 2024 18:10:55 +0800
Message-ID: <20241211101055.2070018-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=H/shw/Yi c=1 sm=1 tr=0 ts=675957ae cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=RZcAm9yDv7YA:10 a=bC-a23v3AAAA:8 a=Cy2GHhHaAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=t7CeM3EgAAAA:8
 a=rXHdJJzl5kBpg4_CTW8A:9 a=-FEs8UIgK8oA:10 a=FO4_E8m0qiDe52t0p3_H:22 a=bTms1Ghn32FVZww6NAbk:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: IDDmhlwAS5WRW5iySiboI35XiGXuTXdA
X-Proofpoint-GUID: IDDmhlwAS5WRW5iySiboI35XiGXuTXdA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-11_09,2024-12-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 clxscore=1015
 impostorscore=0 adultscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam authscore=0 adjust=0 reason=mlx scancount=1
 engine=8.21.0-2411120000 definitions=main-2412110069

From: Joe Damato <jdamato@fastly.com>

[ Upstream commit 08062af0a52107a243f7608fd972edb54ca5b7f8 ]

In commit 6f8b12d661d0 ("net: napi: add hard irqs deferral feature")
napi_defer_irqs was added to net_device and napi_defer_irqs_count was
added to napi_struct, both as type int.

This value never goes below zero, so there is not reason for it to be a
signed int. Change the type for both from int to u32, and add an
overflow check to sysfs to limit the value to S32_MAX.

The limit of S32_MAX was chosen because the practical limit before this
patch was S32_MAX (anything larger was an overflow) and thus there are
no behavioral changes introduced. If the extra bit is needed in the
future, the limit can be raised.

Before this patch:

$ sudo bash -c 'echo 2147483649 > /sys/class/net/eth4/napi_defer_hard_irqs'
$ cat /sys/class/net/eth4/napi_defer_hard_irqs
-2147483647

After this patch:

$ sudo bash -c 'echo 2147483649 > /sys/class/net/eth4/napi_defer_hard_irqs'
bash: line 0: echo: write error: Numerical result out of range

Similarly, /sys/class/net/XXXXX/tx_queue_len is defined as unsigned:

include/linux/netdevice.h:      unsigned int            tx_queue_len;

And has an overflow check:

dev_change_tx_queue_len(..., unsigned long new_len):

  if (new_len != (unsigned int)new_len)
          return -ERANGE;

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240904153431.307932-1-jdamato@fastly.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
---
 include/linux/netdevice.h | 4 ++--
 net/core/net-sysfs.c      | 6 +++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fbbd0df1106b..8379e938cd89 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -352,7 +352,7 @@ struct napi_struct {
 
 	unsigned long		state;
 	int			weight;
-	int			defer_hard_irqs_count;
+	u32			defer_hard_irqs_count;
 	unsigned long		gro_bitmask;
 	int			(*poll)(struct napi_struct *, int);
 #ifdef CONFIG_NETPOLL
@@ -2193,7 +2193,7 @@ struct net_device {
 
 	struct bpf_prog __rcu	*xdp_prog;
 	unsigned long		gro_flush_timeout;
-	int			napi_defer_hard_irqs;
+	u32			napi_defer_hard_irqs;
 #define GRO_LEGACY_MAX_SIZE	65536u
 /* TCP minimal MSS is 8 (TCP_MIN_GSO_SIZE),
  * and shinfo->gso_segs is a 16bit field.
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 8a06f97320e0..4ce57e75d139 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -30,6 +30,7 @@
 #ifdef CONFIG_SYSFS
 static const char fmt_hex[] = "%#x\n";
 static const char fmt_dec[] = "%d\n";
+static const char fmt_uint[] = "%u\n";
 static const char fmt_ulong[] = "%lu\n";
 static const char fmt_u64[] = "%llu\n";
 
@@ -405,6 +406,9 @@ NETDEVICE_SHOW_RW(gro_flush_timeout, fmt_ulong);
 
 static int change_napi_defer_hard_irqs(struct net_device *dev, unsigned long val)
 {
+	if (val > S32_MAX)
+		return -ERANGE;
+
 	WRITE_ONCE(dev->napi_defer_hard_irqs, val);
 	return 0;
 }
@@ -418,7 +422,7 @@ static ssize_t napi_defer_hard_irqs_store(struct device *dev,
 
 	return netdev_store(dev, attr, buf, len, change_napi_defer_hard_irqs);
 }
-NETDEVICE_SHOW_RW(napi_defer_hard_irqs, fmt_dec);
+NETDEVICE_SHOW_RW(napi_defer_hard_irqs, fmt_uint);
 
 static ssize_t ifalias_store(struct device *dev, struct device_attribute *attr,
 			     const char *buf, size_t len)
-- 
2.25.1

