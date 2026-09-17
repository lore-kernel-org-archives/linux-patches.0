Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1093D75AA;
	Thu, 17 Sep 2026 17:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665220; cv=none; b=j8UvWI2yGGCsy50GsN8lT/5sGV+Lr4c4Y51WKcr3VrCa6itpuvt8JI6i8B/8Z1+ULfTOe0Auakoh3fj7pYJw0UE5sV+/IqVmD8W6pZQuBJSGAJTlrabs1tGOMrnxYBdZYux4sy+AMt+ffYdiIX9D90Sv0s+EE6Og4oX2YU3PyMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665220; c=relaxed/simple;
	bh=1HM6xDFfo9baeoUfyJquoLBbnW7KjZ/6RmIUn9uXwv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSgFqiaxSEnOLyKLikJ/uHk2Qy9dPcFl72Xv9IxFflouYmtRj7H/fPys9CBC/xjN8HnwMxUXlTR8acSxU9PhAme6c/KNSWitvizc4Jp8eJLTi8ahOyLy1fRD4816MDpGiramDb/6r0OeSODAQHu8a1SC5qF9Jb/GvewTx29N1J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZStZzWx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZStZzWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558941F008A7;
	Thu, 17 Sep 2026 17:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665215;
	bh=7tbqfTsGfppfbYBrA4cnoKsAuaSkEakqY5j1CmCJ2No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZStZzWxm2WsjCmNC2sFYIT+XkwtXOGb/KkwRt/vlJ5S78mS7fiEAuWGEN0tUWp1O
	 NZB/gmkuRXrpqM8hEOOpxKWv3D9Pk0PgKAGhxMd/OGoFuZhwad2vRLFwequi7CjDlF
	 z6y/FqGfeBH87rQHSHlvxCHObUlEktchPD/6QPQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0604/1250] EDAC/igen6: Fix channel address decode for non-hash mode
Date: Thu, 17 Sep 2026 16:06:39 +0100
Message-ID: <20260917151608.249297722@linuxfoundation.org>
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

[ Upstream commit 7b348d0d401d478f1923ba20a34a61681d1f7971 ]

In non-hash mode, decode_channel_addr() and channel index extraction
used a hardcoded interleave bit position 6 instead of the actual
intlv_bit parameter, causing incorrect channel address decoding.

Fix this by using intlv_bit consistently in both hash and non-hash modes.

Fixes: 10590a9d4f23 ("EDAC/igen6: Add EDAC driver for Intel client SoCs using IBECC")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260730024238.4096623-5-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index f56eaa6b9a058..c25081f61a51f 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -744,13 +744,12 @@ static void decode_addr(u64 addr, u32 hash, u64 s_size, int l_map,
 		return;
 	}
 
-	if (CHANNEL_HASH_MODE(hash)) {
-		*sub_addr = decode_channel_addr(addr, intlv_bit);
+	*sub_addr = decode_channel_addr(addr, intlv_bit);
+
+	if (CHANNEL_HASH_MODE(hash))
 		*idx = decode_chan_idx(addr, CHANNEL_HASH_MASK(hash), intlv_bit);
-	} else {
-		*sub_addr = decode_channel_addr(addr, 6);
-		*idx = GET_BITFIELD(addr, 6, 6);
-	}
+	else
+		*idx = GET_BITFIELD(addr, intlv_bit, intlv_bit);
 }
 
 static int igen6_decode(struct decoded_addr *res)
-- 
2.53.0



