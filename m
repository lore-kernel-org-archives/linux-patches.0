Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F5C171A1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D2EC433EF;
	Mon,  8 May 2023 11:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545570;
	bh=I7TWc+zbSwUy1238BHBZPc4xTNJ7aBbXXL03QZk5LpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PX3RM9SvcCLBXuxxxxiZJVX9EJU1E3KBKxFxhD6RIYpDNhI8iXZp+347bAHIkOwas
	 NpiyqAQYrd1pgPibv9MHHNd0t/xm6e3EY705BCkuIJ/dhoe/OZYeS/o+Sm0RlnC2SX
	 VcPZbqAa25t3F94g7RwxwN/Z/TSUAOVCReQzmJas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Xu <feng.f.xu@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/371] EDAC/skx: Fix overflows on the DRAM row address mapping arrays
Date: Mon,  8 May 2023 11:44:44 +0200
Message-Id: <20230508094815.391531422@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 71b1e3ba3fed5a34c5fac6d3a15c2634b04c1eb7 ]

The current DRAM row address mapping arrays skx_{open,close}_row[]
only support ranks with sizes up to 16G. Decoding a rank address
to a DRAM row address for a 32G rank by using either one of the
above arrays by the skx_edac driver, will result in an overflow on
the array.

For a 32G rank, the most significant DRAM row address bit (the
bit17) is mapped from the bit34 of the rank address. Add this new
mapping item to both arrays to fix the overflow issue.

Fixes: 4ec656bdf43a ("EDAC, skx_edac: Add EDAC driver for Skylake")
Reported-by: Feng Xu <feng.f.xu@intel.com>
Tested-by: Feng Xu <feng.f.xu@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/all/20230211011728.71764-1-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/skx_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/skx_base.c b/drivers/edac/skx_base.c
index 1abc020d49ab6..984c93c8825f0 100644
--- a/drivers/edac/skx_base.c
+++ b/drivers/edac/skx_base.c
@@ -510,7 +510,7 @@ static bool skx_rir_decode(struct decoded_addr *res)
 }
 
 static u8 skx_close_row[] = {
-	15, 16, 17, 18, 20, 21, 22, 28, 10, 11, 12, 13, 29, 30, 31, 32, 33
+	15, 16, 17, 18, 20, 21, 22, 28, 10, 11, 12, 13, 29, 30, 31, 32, 33, 34
 };
 
 static u8 skx_close_column[] = {
@@ -518,7 +518,7 @@ static u8 skx_close_column[] = {
 };
 
 static u8 skx_open_row[] = {
-	14, 15, 16, 20, 28, 21, 22, 23, 24, 25, 26, 27, 29, 30, 31, 32, 33
+	14, 15, 16, 20, 28, 21, 22, 23, 24, 25, 26, 27, 29, 30, 31, 32, 33, 34
 };
 
 static u8 skx_open_column[] = {
-- 
2.39.2



