Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C04220967F
	for <patches@lists.linux.dev>; Wed, 11 Dec 2024 09:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733908554; cv=none; b=pA0y+ooM2G6eu+xCNr3SB6BUIjGnT4VUqWJ7m0fozIzNuH3RYP0u6COyp5q/daA+I7TavygQCl0BPqqIv1eKHGmpBjJWlhNjyW01TGXS2Mf1rZ0vttfyvs+/R1pYZ+ByrdDLovMu6AeDLczdsn4/9W4PjNZ/AaZWb82UN5IsgFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733908554; c=relaxed/simple;
	bh=DpAHoxvmiwXP/aLXfZTq3taee0LbmccDW5qzfUr5CbU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Shbj7A0EEUwSSQU5BdLRCd9Ne3XqMOjDqbZYr39oJIR2CGA1uP8M0WlFogrBmPA/ZWjbDUO3EHUTl5HvFSHLk6YSkjT+J+MFr9fEW7O8cHF0ijGKqCw39tgedW6QRYwFlBhfN8qTP0XNLsrF8IauFy/zcd8u3xxDYMDFSBPoZVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BB6USMj026604;
	Wed, 11 Dec 2024 09:15:48 GMT
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 43cx4xbyer-15
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 11 Dec 2024 09:15:47 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Wed, 11 Dec 2024 01:15:46 -0800
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Wed, 11 Dec 2024 01:15:44 -0800
From: <jianqi.ren.cn@windriver.com>
To: <quic_zijuhu@quicinc.com>, <jianqi.ren.cn@windriver.com>,
        <gregkh@linuxfoundation.org>
CC: <patches@lists.linux.dev>, <stable@vger.kernel.org>, <rafael@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 6.1.y] driver core: bus: Fix double free in driver API bus_register()
Date: Wed, 11 Dec 2024 18:13:38 +0800
Message-ID: <20241211101338.2070869-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: LVyzbo0fMTCNvifZA8Oz0rYyICNmQkyv
X-Proofpoint-ORIG-GUID: LVyzbo0fMTCNvifZA8Oz0rYyICNmQkyv
X-Authority-Analysis: v=2.4 cv=Y/UCsgeN c=1 sm=1 tr=0 ts=67595843 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=RZcAm9yDv7YA:10 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8 a=ag1SF4gXAAAA:8 a=t7CeM3EgAAAA:8 a=6aJXbah9MAW0KMSe_ywA:9
 a=TjNXssC_j7lpFel5tvFf:22 a=Yupwre4RP9_Eg_Bd0iYG:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-11_09,2024-12-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 classifier=spam authscore=0 adjust=0 reason=mlx
 scancount=1 engine=8.21.0-2411120000 definitions=main-2412110069

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit bfa54a793ba77ef696755b66f3ac4ed00c7d1248 ]

For bus_register(), any error which happens after kset_register() will
cause that @priv are freed twice, fixed by setting @priv with NULL after
the first free.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20240727-bus_register_fix-v1-1-fed8dd0dba7a@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Using bus->p instead of priv which will be consistent with the context ]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
---
 drivers/base/bus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 339a9edcde5f..028e45d2f7fe 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -853,6 +853,8 @@ int bus_register(struct bus_type *bus)
 	bus_remove_file(bus, &bus_attr_uevent);
 bus_uevent_fail:
 	kset_unregister(&bus->p->subsys);
+	/* Above kset_unregister() will kfree @priv */
+	bus->p = NULL;
 out:
 	kfree(bus->p);
 	bus->p = NULL;
-- 
2.25.1

