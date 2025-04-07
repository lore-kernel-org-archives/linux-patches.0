Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED751210F4A;
	Mon,  7 Apr 2025 01:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743988827; cv=none; b=r8aa2QFWS3/rZgbxgB2BiGdM1Ny2DhTfWcaYO5XrRwKyoAAQjT0xFsu1C1a0enF2nEu1fp67GuRBH9RX9W/d34JeKpkTsz/j9V1m44/Q7+HN4IJEXFhjixJbeMX+CMsxpI4i+Yga88iSf1RDHIHJ0n6T2NHovgZhP0XFBJ4Fm88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743988827; c=relaxed/simple;
	bh=GNC6gI20n/y7hAYduB7VM5z3XBalJpO9iCpNiHBfxo8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JEmfHT6Z6aGsVT07F8cmswBA2OqmUKuiIFOF0NTw0Mnih9XzITHs5H/jfaz3g7CsBPmmCc6WSxZqlegI7ee6xl5k944HxGNw/4z5TtbP013bU4T6K9VtQY0pNm87iNJpv3iiTJnG+RkYaYIYj6oRuja6KLQwFPpSwrNyMXDmZf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5370T7Te021845;
	Mon, 7 Apr 2025 01:10:04 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45tug8hqg0-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 07 Apr 2025 01:10:04 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Sun, 6 Apr 2025 18:10:03 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Sun, 6 Apr 2025 18:10:01 -0700
From: <jianqi.ren.cn@windriver.com>
To: <stable@vger.kernel.org>
CC: <ivan.orlov0322@gmail.com>, <davidgow@google.com>, <kees@kernel.org>,
        <patches@lists.linux.dev>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <jianqi.ren.cn@windriver.com>
Subject: [PATCH 6.1.y] kunit/overflow: Fix UB in overflow_allocation_test
Date: Mon, 7 Apr 2025 09:10:00 +0800
Message-ID: <20250407011000.207933-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: i32mhfwF9Nffn5scDBsC_1vS_XSRUdZo
X-Authority-Analysis: v=2.4 cv=YJefyQGx c=1 sm=1 tr=0 ts=67f325ec cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=1XWaLZrsAAAA:8 a=t7CeM3EgAAAA:8 a=sRwAWNXhmHWHE5Be58cA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: i32mhfwF9Nffn5scDBsC_1vS_XSRUdZo
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-06_08,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0
 mlxscore=0 clxscore=1011 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2504070007

From: Ivan Orlov <ivan.orlov0322@gmail.com>

[ Upstream commit 92e9bac18124682c4b99ede9ee3bcdd68f121e92 ]

The 'device_name' array doesn't exist out of the
'overflow_allocation_test' function scope. However, it is being used as
a driver name when calling 'kunit_driver_create' from
'kunit_device_register'. It produces the kernel panic with KASAN
enabled.

Since this variable is used in one place only, remove it and pass the
device name into kunit_device_register directly as an ascii string.

Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Reviewed-by: David Gow <davidgow@google.com>
Link: https://lore.kernel.org/r/20240815000431.401869-1-ivan.orlov0322@gmail.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 lib/overflow_kunit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/overflow_kunit.c b/lib/overflow_kunit.c
index b8556a2e7bb1..e499e13856fb 100644
--- a/lib/overflow_kunit.c
+++ b/lib/overflow_kunit.c
@@ -608,7 +608,6 @@ DEFINE_TEST_ALLOC(devm_kzalloc,  devm_kfree, 1, 1, 0);
 
 static void overflow_allocation_test(struct kunit *test)
 {
-	const char device_name[] = "overflow-test";
 	struct device *dev;
 	int count = 0;
 
@@ -618,7 +617,7 @@ static void overflow_allocation_test(struct kunit *test)
 } while (0)
 
 	/* Create dummy device for devm_kmalloc()-family tests. */
-	dev = root_device_register(device_name);
+	dev = root_device_register("overflow-test");
 	KUNIT_ASSERT_FALSE_MSG(test, IS_ERR(dev),
 			       "Cannot register test device\n");
 
-- 
2.34.1

