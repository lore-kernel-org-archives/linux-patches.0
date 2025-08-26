Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61648139579;
	Tue, 26 Aug 2025 13:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214575; cv=none; b=eTiEh1dArPnxjXibNT7Af4XSiWjCKWbm6+QSUA2720dyMSXbcnbAS31dHnmi7ogNry4sG4uZO0ZStXlsCaJQ8VyKZcg8PbGBgyiadA38ZlTVAiahBYZdwGExyjizatWzBCUNNHfxRKfDUF72LR/YPQ7wXEN+eF6s1cw+NHZPFlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214575; c=relaxed/simple;
	bh=n7r/3xhODj4OpJAjeCqpG1dd61GVD8CM/cfOeOGvFCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+vszLoZRvszlthmwv3hq19NFNVt9Rqol/hHo2rjHHHl9IAzPazeadsHK2n+pXi2LIqWXyO5ETn7PGKjoRrjLAVmMYpKfVix1vx/qWMr50TCWWqWAlH/5kIQTeIG3Hq5W2PjtqDUx74Fap4avtyC1sSqLE/148oTphe3DVGI4E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SR1AVUik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SR1AVUik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFB3C113CF;
	Tue, 26 Aug 2025 13:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214574;
	bh=n7r/3xhODj4OpJAjeCqpG1dd61GVD8CM/cfOeOGvFCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SR1AVUikMOA9CRxJy8v+M1oyT4ogyR6+uR2yd4cC55lWrl730sOeymSBZHXjqMbJ8
	 Mv9igL+8NObCkkEC1nNq8dRO/HPUIwNVn7KwGK8v7dOXZpop/1DWzjczG7J4mvO/oj
	 9zjoRf/9szkD+Kvc0hV2Yd4Yf9rW1ZluXNAeI2Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiji Yang <yangshiji66@outlook.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/482] MIPS: lantiq: falcon: sysctrl: fix request memory check logic
Date: Tue, 26 Aug 2025 13:07:23 +0200
Message-ID: <20250826110935.499534923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiji Yang <yangshiji66@outlook.com>

[ Upstream commit 9c9a7ff9882fc6ba7d2f4050697e8bb80383e8dc ]

request_mem_region() will return NULL instead of error code
when the memory request fails. Therefore, we should check if
the return value is non-zero instead of less than zero. In
this way, this patch also fixes the build warnings:

arch/mips/lantiq/falcon/sysctrl.c:214:50: error: ordered comparison of pointer with integer zero [-Werror=extra]
  214 |                                 res_status.name) < 0) ||
      |                                                  ^
arch/mips/lantiq/falcon/sysctrl.c:216:47: error: ordered comparison of pointer with integer zero [-Werror=extra]
  216 |                                 res_ebu.name) < 0) ||
      |                                               ^
arch/mips/lantiq/falcon/sysctrl.c:219:50: error: ordered comparison of pointer with integer zero [-Werror=extra]
  219 |                                 res_sys[0].name) < 0) ||
      |                                                  ^
arch/mips/lantiq/falcon/sysctrl.c:222:50: error: ordered comparison of pointer with integer zero [-Werror=extra]
  222 |                                 res_sys[1].name) < 0) ||
      |                                                  ^
arch/mips/lantiq/falcon/sysctrl.c:225:50: error: ordered comparison of pointer with integer zero [-Werror=extra]
  225 |                                 res_sys[2].name) < 0))
      |

Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/falcon/sysctrl.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/mips/lantiq/falcon/sysctrl.c b/arch/mips/lantiq/falcon/sysctrl.c
index 1187729d8cbb..357543996ee6 100644
--- a/arch/mips/lantiq/falcon/sysctrl.c
+++ b/arch/mips/lantiq/falcon/sysctrl.c
@@ -214,19 +214,16 @@ void __init ltq_soc_init(void)
 	of_node_put(np_syseth);
 	of_node_put(np_sysgpe);
 
-	if ((request_mem_region(res_status.start, resource_size(&res_status),
-				res_status.name) < 0) ||
-		(request_mem_region(res_ebu.start, resource_size(&res_ebu),
-				res_ebu.name) < 0) ||
-		(request_mem_region(res_sys[0].start,
-				resource_size(&res_sys[0]),
-				res_sys[0].name) < 0) ||
-		(request_mem_region(res_sys[1].start,
-				resource_size(&res_sys[1]),
-				res_sys[1].name) < 0) ||
-		(request_mem_region(res_sys[2].start,
-				resource_size(&res_sys[2]),
-				res_sys[2].name) < 0))
+	if ((!request_mem_region(res_status.start, resource_size(&res_status),
+				 res_status.name)) ||
+	    (!request_mem_region(res_ebu.start, resource_size(&res_ebu),
+				 res_ebu.name)) ||
+	    (!request_mem_region(res_sys[0].start, resource_size(&res_sys[0]),
+				 res_sys[0].name)) ||
+	    (!request_mem_region(res_sys[1].start, resource_size(&res_sys[1]),
+				 res_sys[1].name)) ||
+	    (!request_mem_region(res_sys[2].start, resource_size(&res_sys[2]),
+				 res_sys[2].name)))
 		pr_err("Failed to request core resources");
 
 	status_membase = ioremap(res_status.start,
-- 
2.39.5



