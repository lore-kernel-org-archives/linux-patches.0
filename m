Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5051FF5EC;
	Wed,  7 May 2025 18:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644004; cv=none; b=ONnEFhISfNx4/9TLHGeSthni1nrP+IxrQ5cb8uMStY5/qYI6RoJ9501820hkMkAyLqSb2vWgaVeN2K+R0O6y4w4ohzLEmyJR4nCx0siwFfZ234MsiIKMr6zCfxH8yYoF2Vx/IslpLetaX4TYneMS3HoKAbegIu72bpE4zJCJoSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644004; c=relaxed/simple;
	bh=DHWPukoH2pJ04nAcLk7rzKMeUZpcoup+m+3erVyhVHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhgRHClGFbuBCrlB3ZXLC2sYJE5GdQBWzzwsPB+NQjryiNokUVq/xa1FesCSpQPqoAJBgs24yflGtIkcjb+QEcY8MWLvNL2EHeEWHKC6pbtFTqq8G1p8/mgpP3oSbxBYmdZpGE5Ae6qRYYnzs3Ag80LXIsnF0OF9N73g94cUU2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMo47RPh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMo47RPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F638C4CEE2;
	Wed,  7 May 2025 18:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644004;
	bh=DHWPukoH2pJ04nAcLk7rzKMeUZpcoup+m+3erVyhVHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMo47RPhgskvKZtU3hbbWuzwWJTpauhKTh34ifVb7bsG8kLBPO0iZUxDKBEWqn0d3
	 SF53Q14RjdBys+sskyP3hSPDINQaY9Nm14hK+a4EevBhsUxLzoDUtJUg/jJYQhZKVu
	 ARiSZAxkMYrPMqU68fH04JezqY1YWNmKUVr7OAHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Justin Lai <justinlai0215@realtek.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 089/183] rtase: Modify the condition used to detect overflow in rtase_calc_time_mitigation
Date: Wed,  7 May 2025 20:38:54 +0200
Message-ID: <20250507183828.431970777@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 2aacc1996796d..55b8d36661530 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -1925,8 +1925,8 @@ static u16 rtase_calc_time_mitigation(u32 time_us)
 
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



