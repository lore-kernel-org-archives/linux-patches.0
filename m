Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708473DD874;
	Thu, 17 Sep 2026 17:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665151; cv=none; b=FQS9EVWLcT1KNjh7BAV8FuKOHcUFG/Lwq/PEuFOE8MImjfTSi7OqDurnLomAW8Uilv2vDQ03+g1SNhzr/re18N/n0MM90XzF9Zeoaz01qxDdaZAzX7zKAL4awsoh4evloQRtsqgEUFINZJU8egsp0AY7Y8v89Odn01RmyaCDEMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665151; c=relaxed/simple;
	bh=V3Q/73gp6ujmLpCrYmrnG1v2F7nslIpPK3rysPV3a6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jupoK67ZLMJsJulZcO//F0WV2LyzOoxzYO9zV4+0H1NRTLk+gTdkAMRX54YwFUxHcTlhAbv2VhZtEyQYTE7yfyLN5h3bMsT1LQq6bhbSJd9O59C9zBzq2g3KFlS6eHHO03Ibh31ZjoG2avYu5cmR2ACcXn+CVTiFsr1bajGaIsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9V/FsG5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9V/FsG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93C51F000FF;
	Thu, 17 Sep 2026 17:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665150;
	bh=reyzMqJL4uL3EDRyJBY7T9y9M0CAgk44PetY02wW4SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c9V/FsG547hPRhsFefiUz9k2LAy11wBgacFlZhAu19J/1bBCO5RHFHSNvU7f5e+h9
	 Q/I4x7q6TQtDwpA1rbrm36I+mWsuLh/SXyyQrO2db9JZWtpsNLZEtLpB5y+rgEGdYP
	 yshNMoWo9jOk5NL7wnU4yZEEyYtQG+ph4lXDzfD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0602/1250] EDAC/igen6: Fix interleave boundary condition
Date: Thu, 17 Sep 2026 16:06:37 +0100
Message-ID: <20260917151608.198185565@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit f4008169bd320eedb9ddf2b39eeb21370ddac278 ]

The address translation logic splits the memory space into interleaved
and non-interleaved regions using a boundary at 2 * s_size.

The current check uses '>' and incorrectly classifies the boundary
address (2 * s_size) as part of the interleaved region. This leads to
incorrect channel/sub-channel selection at the region boundary.

Fix the classification by using '>=' so that the boundary address is
handled in the non-interleaved region, matching the hardware layout.

Fixes: 10590a9d4f23 ("EDAC/igen6: Add EDAC driver for Intel client SoCs using IBECC")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260730024238.4096623-3-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index 42eadece2d71b..d1ab46895d7a5 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -730,7 +730,7 @@ static void decode_addr(u64 addr, u32 hash, u64 s_size, int l_map,
 {
 	int intlv_bit = CHANNEL_HASH_LSB_MASK_BIT(hash) + 6;
 
-	if (addr > 2 * s_size) {
+	if (addr >= 2 * s_size) {
 		*sub_addr = addr - s_size;
 		*idx = l_map;
 		return;
-- 
2.53.0



