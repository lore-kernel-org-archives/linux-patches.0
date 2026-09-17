Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F194CDDD3;
	Thu, 17 Sep 2026 15:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658801; cv=none; b=aQxasak6s7k1Dlw5CYMfIbKbzl9t937YKI9gxiAR9gOdeQUxn/xNjBiVTziwGFSG6k2OydegnG+wL7PQzRWuImQCblL6odlPu14tdVv5i1yJTVMpJownTuH0J+B0pLP8iSGWHN07rfdvdslmVRTvoxg26tA3rzYlFlIjMBYUXBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658801; c=relaxed/simple;
	bh=JcAiz7t7nW00WVmhVevyUbpe7GkjAMOdIXeumu0uXeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ji68r4h6gxTI1GoVNj1jgOUfcMV4ecMKOoUVKGIDAh/jnR6I+61ii/bN4qOFXsCmlDLc01iA4Ci1DMRugMGuDaiyIdMFkXwQ261q+l0EVbkx/ciFM/Fqw1CYQhR/hQ8p3IEqwV7pBMiYTiG/sfUE1Kl5O9fgV8B1EBhpZshZl+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kub2Low8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kub2Low8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684151F0089B;
	Thu, 17 Sep 2026 15:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658787;
	bh=ATBHs6nCAkx6EGgp8xwraEHHZKptTPQzETD+Sm3i1qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kub2Low80eCfAwNrvbKE+pScOvZhket9dpU6dpBOZpYvt46UNL5nMlLnSs990pL0n
	 d8/Oafo+q3TFF3C5w8Zlme2Iw4S+8mLybCbW8bMsDdj61fBOKH70bidcEmRT+O1RDz
	 nRbrGajv90QKttmYMuNCpbF4/7hpNWaSy0TvG7cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 009/733] EDAC/igen6: Fix channel address decode for non-hash mode
Date: Thu, 17 Sep 2026 16:05:17 +0100
Message-ID: <20260917151350.874450328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index f1fb644154ae3..ea5628d780eba 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -1049,13 +1049,12 @@ static void decode_addr(u64 addr, u32 hash, u64 s_size, int l_map,
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



