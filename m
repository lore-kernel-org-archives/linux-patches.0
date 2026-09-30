Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821E92222D0;
	Wed, 30 Sep 2026 19:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794950; cv=none; b=rnPWpbUiH2/2oJN7R03blKNIvlywwo8MKFW62vWYDhStwYZSJOw5kGawzrMnO24HXPOFVcTvrOa/cyCyExJbH9VKjWiDjfhncR+/+a+wUgYbcJRQsn7AbVx7zWSE/GpX9fLhositEe60RdJErTxYa9mIKrqIt/xzRB6ODbRsTo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794950; c=relaxed/simple;
	bh=CgI2lBpzZhE24uvA+b5jUC/LFUIRA+HhuYHyPZvzbTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APAeFO4mnHuP/seCciLd3HbmvZWJTfkZiRZ2+kRwS9M4zWf/hBDqffN9+nkh1s6nSJNz/JHJPmY+LczrIYErJ2YPJtfwvgAnSFZMo6XlsBqTmhXvg2JUcPjFzTBw0WjX2TZruevLBpOo2Q3rjLu2tDUIbhTGGIFDe6P6E3kVSPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrsARnBi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrsARnBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21E81F000FF;
	Wed, 30 Sep 2026 19:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794949;
	bh=WLITTJA7liFU+d5oXqG3PmLUGY4lK41qH4DP18r8L3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RrsARnBiYHLIAD37tdlPUPXrUeiYY7yo7sk/kvGvJB8XCxmGp1wjJzcqYtpb+oLzk
	 M7LTppsctDGoc+4ivk9pGYaf9JaRPEN9/DAkQdoF687aptuxu/ZaAbHKpqOWEBchYD
	 oQpPdzgMgRkYyeArA2LPWqlECrhHAyOjQBepmC0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0373/1193] EDAC/igen6: Fix interleave boundary condition
Date: Wed, 30 Sep 2026 17:17:37 +0200
Message-ID: <20260930152442.467352201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0b408299699a8..56d3ec3db67d2 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -493,7 +493,7 @@ static void decode_addr(u64 addr, u32 hash, u64 s_size, int l_map,
 {
 	int intlv_bit = CHANNEL_HASH_LSB_MASK_BIT(hash) + 6;
 
-	if (addr > 2 * s_size) {
+	if (addr >= 2 * s_size) {
 		*sub_addr = addr - s_size;
 		*idx = l_map;
 		return;
-- 
2.53.0



