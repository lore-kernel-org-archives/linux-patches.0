Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B23519DE7;
	Wed, 30 Sep 2026 16:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784913; cv=none; b=qGQtT2wh6XaDOaHDIdj3+nNSuW4LPXJfweT0xQbe5f5B5o7LaggvNEH2HI90UrWK+k9MPGW0EQHc8i6JewIk85gxqXrd6JngRZbnWLLLaObcyMnjO9bsVln/yBQAnRftwetDzijGJE0XWVT9juBz3iI9HqBQl+gS316UlizbY7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784913; c=relaxed/simple;
	bh=WWUYm2R4pCcDfsa4gSHHnXow8oGRi6DnxC87PY6hbfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjJnkkZq2F5EbOazXy/cl6XnbK7eLP9ubiIf6p88wa+2EbCG4bEGh/RmvrbIeyW6YHynERv863rA+PMI/kzdg4sPc4lCb+1JfQnjTIYMq61Tpy8SIFl2Sbf0N+2boYxN/QM+cdMudULL5BsDWazbeeCOO0+JQxb5xMvs1crra/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AiBD1dLN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AiBD1dLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D341F000FF;
	Wed, 30 Sep 2026 16:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784909;
	bh=UPAeYSdJ/J1Yqden3CE9PScs98QXlTUJ1FfjybRzTF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AiBD1dLNL4J7Xz9nm9FfIyGECl2sFP2pn84VTowsmQeijed0yvZ/z8HmTm4kZqjw+
	 LL57zssMYBEFdlnCUTw8di15MWkc4I02sZL1UU5dI4aeK6RVxcKDva7QBl3yAK76Ks
	 h0TsBzYFZ8PR7NimeLmMOi5fVL6cnv5LayWGciVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 322/982] EDAC/igen6: Fix channel address decode for non-hash mode
Date: Wed, 30 Sep 2026 17:17:38 +0200
Message-ID: <20260930152423.736228007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d91b775173621..97468fbf17b74 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -507,13 +507,12 @@ static void decode_addr(u64 addr, u32 hash, u64 s_size, int l_map,
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



