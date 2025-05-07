Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400A61E22E9;
	Wed,  7 May 2025 19:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644565; cv=none; b=Rygn5kwRc5+t4v0f4rl169F5gODWPDqgtE4RBLDUXTWnca+SINnYJQypz7RIQFKvDqhmkoJlfzVttX5+w61WEdPm7akF8jBhWl42imxCAx37kG52bAT8TcR7uCr7m86iuWdWaOb7ZmpaAbTbogodyQFrYsf5I2oDR6x0RVz83RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644565; c=relaxed/simple;
	bh=9/btidaj0r97E6khCpRANVcYhB+xFk1Yq8fzEfdVtWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmG1HshcvyF/+C36II9pH8LLdeonorLtNhbPAFxM+vhcXqwXVUbJohHCUUvorXDb2DTdCAts9y1PrNGTAB60bygNeSPTHtaVvzntceXV+9QyxpYw6SItdZ9VVJ1P/SydyqaeWRTtiEf/9qODpI8aDCHsGGNA7eywmB4x11k8laY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfytvBKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfytvBKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C455EC4CEE2;
	Wed,  7 May 2025 19:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644565;
	bh=9/btidaj0r97E6khCpRANVcYhB+xFk1Yq8fzEfdVtWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cfytvBKFmsyH2UgSbsDZjuQgGv1SUFRigqTzCK1v2LSNT1LIeayrnOuSsP8kPKNhC
	 6lolJpt/mlP87s6IkM1ZYvsupFVePOIv4u+GUoDkPruh2gHfuqy1w/NBmsAB935Te/
	 4b6Lo+bfiXVjbNKPZfIQVv/QjiSEr6FZZlkuhUec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Justin Lai <justinlai0215@realtek.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/164] rtase: Modify the condition used to detect overflow in rtase_calc_time_mitigation
Date: Wed,  7 May 2025 20:39:29 +0200
Message-ID: <20250507183824.363112467@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Lai <justinlai0215@realtek.com>

[ Upstream commit 68f9d8974b545668e1be2422240b25a92e304b14 ]

Fix the following compile error reported by the kernel test
robot by modifying the condition used to detect overflow in
rtase_calc_time_mitigation.

In file included from include/linux/mdio.h:10:0,
                  from drivers/net/ethernet/realtek/rtase/rtase_main.c:58:
 In function 'u16_encode_bits',
     inlined from 'rtase_calc_time_mitigation.constprop' at drivers/net/
     ethernet/realtek/rtase/rtase_main.c:1915:13,
     inlined from 'rtase_init_software_variable.isra.41' at drivers/net/
     ethernet/realtek/rtase/rtase_main.c:1961:13,
     inlined from 'rtase_init_one' at drivers/net/ethernet/realtek/
     rtase/rtase_main.c:2111:2:
>> include/linux/bitfield.h:178:3: error: call to '__field_overflow'
      declared with attribute error: value doesn't fit into mask
    __field_overflow();     \
    ^~~~~~~~~~~~~~~~~~
 include/linux/bitfield.h:198:2: note: in expansion of macro
 '____MAKE_OP'
   ____MAKE_OP(u##size,u##size,,)
   ^~~~~~~~~~~
 include/linux/bitfield.h:200:1: note: in expansion of macro
 '__MAKE_OP'
  __MAKE_OP(16)
  ^~~~~~~~~

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202503182158.nkAlbJWX-lkp@intel.com/
Fixes: a36e9f5cfe9e ("rtase: Add support for a pci table in this module")
Signed-off-by: Justin Lai <justinlai0215@realtek.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250424040444.5530-1-justinlai0215@realtek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/rtase/rtase_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/rtase/rtase_main.c b/drivers/net/ethernet/realtek/rtase/rtase_main.c
index 86dd034fdddc5..3a588aaa89c58 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -1924,8 +1924,8 @@ static u16 rtase_calc_time_mitigation(u32 time_us)
 
 	time_us = min_t(int, time_us, RTASE_MITI_MAX_TIME);
 
-	msb = fls(time_us);
-	if (msb >= RTASE_MITI_COUNT_BIT_NUM) {
+	if (time_us > RTASE_MITI_TIME_COUNT_MASK) {
+		msb = fls(time_us);
 		time_unit = msb - RTASE_MITI_COUNT_BIT_NUM;
 		time_count = time_us >> (msb - RTASE_MITI_COUNT_BIT_NUM);
 	} else {
-- 
2.39.5



