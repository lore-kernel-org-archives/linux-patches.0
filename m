Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B733F37FF6F;
	Thu, 17 Sep 2026 18:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668673; cv=none; b=VBmfjjoCY5wuH1BmGWPgWeBA29Jwo1uZnMrKUzsjk33IU4ytpTPVIiqBeNUG/Za7XT0H0TgJWHWsxtKjSY2z0UuSmzQjK+LMu93A3c72i1x4hyhjj2S3ddOfdfgjYK96E+/bdVDzzM48Pvl/krDi7e3QlilduY/fRtrIW5uDdyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668673; c=relaxed/simple;
	bh=o8UAJjF4iXEBjWnj4AvmZsum9Dgwizdcy6NrF97T0VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubFnZX6YkeQoid8aYLPcNjKr5WwixVO6ZBNvfnrdF3yzssvnvxyPmclcTLPfAokgqVx6m27U35j+QmSy3eJWHjGgIEur1Q4Vt6BYrmYYFQxyjudfyISrAu7RbQP7NMJ/i3kr8H52MsgYp5Z0VjT7siVU0J1nieexQDUzQJDK7y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8WigzZM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8WigzZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85581F000FF;
	Thu, 17 Sep 2026 18:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668672;
	bh=F1yND7ScuzaqFvv6Ro50jMe0Mak+Se4PmUfqb1rVK5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q8WigzZMhxrSUlbKlLdlFGoYqB7ARdn2ZcxqWO3k3QrTBive6ZlHUmbbBN6Cri/R3
	 9DWqfzdtmykA2XBKxurwzlweeP7Wa0gcUk4OsjBqGWE/mkwSMIcMWvf0QTn9libaEn
	 Cm7f9jIwUDrfqQ66MHsY3bt6gjosuibg1Hnr2eI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0501/1102] EDAC/igen6: Fix interleave boundary condition
Date: Thu, 17 Sep 2026 16:07:24 +0100
Message-ID: <20260917151552.310171605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 07dacf8c10be3..13da52bc29cae 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -674,7 +674,7 @@ static void decode_addr(u64 addr, u32 hash, u64 s_size, int l_map,
 {
 	int intlv_bit = CHANNEL_HASH_LSB_MASK_BIT(hash) + 6;
 
-	if (addr > 2 * s_size) {
+	if (addr >= 2 * s_size) {
 		*sub_addr = addr - s_size;
 		*idx = l_map;
 		return;
-- 
2.53.0



