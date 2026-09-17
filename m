Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1144E4C3A;
	Thu, 17 Sep 2026 17:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665186; cv=none; b=ADT+QkpgQ7iUh/5KkpnZx1hM8MaBsS0EZu1ap1LbS/XrFdzvyW51K+FZUZYRdNs0k8xzEEi8AfIswuBnATFFuoyH9gLwEChA2jFMxvV1jxCOzjbpsfFyVKR4dH3Svun6ZKcDs2KVili8uTm7pvx2p24Z9xWntauprHA2EH24SKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665186; c=relaxed/simple;
	bh=4BN2AHz/RH6/cljz6FcqFIYNb9+XElD8rYbLRwPAalo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bt9gMR5dzkh+LPXXtdSN7gkf2Y355y5he28tikwB/kvWnx1d3aqRw0pEEf6+tJzswTzbFNVLivZ/TzHDU45abbP0jyRQjurJLvu3KlPxgiZyULq9Rx2FpL0DazcTgGsf+MwgQOTgvq9+fuEStjOWTDuOXrBrdPvSYXB9cD7Z26Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpZh5TPA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpZh5TPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D8B1F000FF;
	Thu, 17 Sep 2026 17:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665183;
	bh=zUPijl8MBnjNm7cvBdB09QO9/u2AJUW4qO9vX4FWImE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DpZh5TPAAU2Oz/xPDb89S61ZDPYJNrdd5MN5jzFT7Xq/gR5h2HaWd1fJia0w7icOh
	 ozGTpHUIyLI94EdCtTQk08W20q4bMq9YvpjuBqkaBW32mxYWaoDJOdvaXvTZPR1pBc
	 BKT5j4pxwpe7/p07cYK/UU3NQt7aH3KN1/IHgCE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0603/1250] EDAC/igen6: Fix channel selection hash
Date: Thu, 17 Sep 2026 16:06:38 +0100
Message-ID: <20260917151608.223422853@linuxfoundation.org>
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

[ Upstream commit 540b79536f3a89a66c5b6c490110298d43025618 ]

In channel selection hash mode, the hardware decoding logic always
includes the channel interleave bit in XOR operations. However, the
hash mask may or may not include this channel interleave bit. When
the mask does include this bit, the current igen6_edac code performs
XOR on the interleave bit twice, effectively ignoring it - which is
incorrect.

Fix this issue by ensuring the hash mask always includes the interleave
bit, so XOR is performed on the interleave bit exactly once.

Fixes: 10590a9d4f23 ("EDAC/igen6: Add EDAC driver for Intel client SoCs using IBECC")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260730024238.4096623-4-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index d1ab46895d7a5..f56eaa6b9a058 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -704,14 +704,22 @@ static enum mem_type get_memory_type(u32 mad_inter)
 
 static int decode_chan_idx(u64 addr, u64 mask, int intlv_bit)
 {
-	u64 hash_addr = addr & mask, hash = 0;
-	u64 intlv = (addr >> intlv_bit) & 1;
+	u64 hash_addr, hash = 0;
 	int i;
 
+	/*
+	 * In hash mode, the @intlv_bit is the lowest selected bit of @addr
+	 * to be XORed. While @mask may or may not include this @intlv_bit,
+	 * we enforce that @mask includes @intlv_bit to ensure @intlv_bit is
+	 * XORed exactly once.
+	 */
+	mask |= 1 << intlv_bit;
+	hash_addr = addr & mask;
+
 	for (i = 6; i < 20; i++)
 		hash ^= (hash_addr >> i) & 1;
 
-	return (int)hash ^ intlv;
+	return (int)hash;
 }
 
 static u64 decode_channel_addr(u64 addr, int intlv_bit)
-- 
2.53.0



