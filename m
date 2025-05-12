Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5EE12FF69
	for <patches@lists.linux.dev>; Mon, 12 May 2025 02:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747018382; cv=none; b=Pz6R2ExPQUPLySjWkf0CrVJJWUA6o/O0Dn8MQFdvhRHzK/44GcBheX6Foj8NmCwb16tK3eoVx2wq5eG449zW26u17AXvcxmtWn/5sKJkjOjSt+Az5TF/+l7TX/QV/kBk9RyA1rym+erc/ZjaNH5tGa5JLAXQYsdfUGCm4rmvVb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747018382; c=relaxed/simple;
	bh=YMA93/Do0rPqYwX/U4VcdAsbH1ftL8fuolp56Uow/2s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WhPG1SJuY3UYyUPU8E4MoJtXZI+7LNqt/x/rYPbsoFPqgxdmABxtOIAD9zC6UgnLOYc9LAHHIXFwavyp0WqYpEXjrYresPcN6rdDly8q2FgEyRExp99QPQ+kjqk/V385nYyzU9g5LB8SEjSbp2IQBc+Fh0n0HdWgF7shm+82NIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54C1A3rw005877;
	Mon, 12 May 2025 02:52:37 GMT
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 46hv11hakp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 12 May 2025 02:52:36 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Sun, 11 May 2025 19:52:35 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Sun, 11 May 2025 19:52:32 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <jianqi.ren.cn@windriver.com>, <akpm@linux-foundation.org>,
        <osalvador@suse.de>, <hannes@cmpxchg.org>, <ying.huang@intel.com>,
        <shy828301@gmail.com>, <linux-mm@kvack.org>, <byungchul@sk.com>,
        <hyeongtak.ji@sk.com>, <baolin.wang@linux.alibaba.com>
Subject: [PATCH 6.1.y] mm/vmscan: fix a bug calling wakeup_kswapd() with a wrong zone index
Date: Mon, 12 May 2025 10:52:31 +0800
Message-ID: <20250512025231.3328659-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=TZCWtQQh c=1 sm=1 tr=0 ts=68216274 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=ph6IYJdgAAAA:8 a=ID6ng7r3AAAA:8 a=SRrdq9N9AAAA:8 a=QyXUC8HyAAAA:8 a=ufHFDILaAAAA:8
 a=Z4Rwk6OoAAAA:8 a=t7CeM3EgAAAA:8 a=H6QpYm678JWB0EKp6agA:9 a=ty6LBwuTSqq6QlXLCppH:22 a=AkheI1RvQwOzcTXhi5f4:22 a=ZmIg1sZ3JBWsdXgziEIF:22 a=HkZW87K1Qel5hWWM3VKY:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: 67dy1ERlcH9PLZy0Ers4U-qDbnxz99yL
X-Proofpoint-ORIG-GUID: 67dy1ERlcH9PLZy0Ers4U-qDbnxz99yL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEyMDAyOSBTYWx0ZWRfX9/fCTKpihrbG ARjz3102fQQH9zHIHdoPkIAxAQFSoe7LPixXTY2jHCQaFl87pRuOVKuyXP4wZbdEU9YEpPDsrUE C+b6J1yGQQIg6CjnasvE9Ltr6wjhS151el5YsWh+WIyg+a1u442hFcIP7tiFC2DBCB3717MsEIv
 TvBuFP+Yc+fl6UGeCQiGMNyBN8DJzdeErGlf91QLxs6NtSZCpikpxfgstbDmss86JaDKCi86lrc ievwuMqa6T57JqKcgMtbAT+SxyFnlC3UXeS/xpl7ixslWpdeUfmZMYS77losSfM302TgI7hmTJv VdvXhxwuXfXPNKKWJQFXS0JiK1ydlasYX9lKfypdkrYpYkxKpXvfEY7niUMMiVypNiP6S3g2/lM
 7q3tGV3BGjQNrfiFOp+Spowh6epVHPw3ddG0y7i8LwITveKd9P41PvC3pxddW+XFqNK/RzYP
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_01,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.21.0-2504070000
 definitions=main-2505120029

From: Byungchul Park <byungchul@sk.com>

[ Upstream commit 2774f256e7c0219e2b0a0894af1c76bdabc4f974 ]

With numa balancing on, when a numa system is running where a numa node
doesn't have its local memory so it has no managed zones, the following
oops has been observed.  It's because wakeup_kswapd() is called with a
wrong zone index, -1.  Fixed it by checking the index before calling
wakeup_kswapd().

> BUG: unable to handle page fault for address: 00000000000033f3
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 2 PID: 895 Comm: masim Not tainted 6.6.0-dirty #255
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>    rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> RIP: 0010:wakeup_kswapd (./linux/mm/vmscan.c:7812)
> Code: (omitted)
> RSP: 0000:ffffc90004257d58 EFLAGS: 00010286
> RAX: ffffffffffffffff RBX: ffff88883fff0480 RCX: 0000000000000003
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88883fff0480
> RBP: ffffffffffffffff R08: ff0003ffffffffff R09: ffffffffffffffff
> R10: ffff888106c95540 R11: 0000000055555554 R12: 0000000000000003
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff88883fff0940
> FS:  00007fc4b8124740(0000) GS:ffff888827c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000000033f3 CR3: 000000026cc08004 CR4: 0000000000770ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  <TASK>
> ? __die
> ? page_fault_oops
> ? __pte_offset_map_lock
> ? exc_page_fault
> ? asm_exc_page_fault
> ? wakeup_kswapd
> migrate_misplaced_page
> __handle_mm_fault
> handle_mm_fault
> do_user_addr_fault
> exc_page_fault
> asm_exc_page_fault
> RIP: 0033:0x55b897ba0808
> Code: (omitted)
> RSP: 002b:00007ffeefa821a0 EFLAGS: 00010287
> RAX: 000055b89983acd0 RBX: 00007ffeefa823f8 RCX: 000055b89983acd0
> RDX: 00007fc2f8122010 RSI: 0000000000020000 RDI: 000055b89983acd0
> RBP: 00007ffeefa821a0 R08: 0000000000000037 R09: 0000000000000075
> R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
> R13: 00007ffeefa82410 R14: 000055b897ba5dd8 R15: 00007fc4b8340000
>  </TASK>

Link: https://lkml.kernel.org/r/20240216111502.79759-1-byungchul@sk.com
Signed-off-by: Byungchul Park <byungchul@sk.com>
Reported-by: Hyeongtak Ji <hyeongtak.ji@sk.com>
Fixes: c574bbe917036 ("NUMA balancing: optimize page placement for memory tiering system")
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 mm/migrate.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index e37b18376714..7b986c9f4032 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2422,6 +2422,14 @@ static int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
 			if (managed_zone(pgdat->node_zones + z))
 				break;
 		}
+
+		/*
+		 * If there are no managed zones, it should not proceed
+		 * further.
+		 */
+		if (z < 0)
+			return 0;
+
 		wakeup_kswapd(pgdat->node_zones + z, 0, order, ZONE_MOVABLE);
 		return 0;
 	}
-- 
2.34.1

