Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE79242C513;
	Wed, 30 Sep 2026 18:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791251; cv=none; b=LVX0UyPaI1xNVPXY3a68GUEmWbipIksRvO4F+3S3AMJ4pFtpilFtvisibSnq7zC55id0iYL7jqgV6AGnJrWuhFlAq6e2KmZS4e/0H3RNOZlfGUAsVDrIIz4J9yN/9VBo6VC6N1/yGADylMWdXQWm3e9KGDVfvzyLHcdCoQhyLqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791251; c=relaxed/simple;
	bh=Ylk0Hws5cVncCrte324t0QfaQY0Cm6+sZvSRuXlOy4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9byd4kyihm6iDSghblK3u4d/mdwGysO0KDoThuQZjzPGBMn48piDYCOSy+l8VZZdYtsouiTywz3axQBbtaNmAcqKhQ1JPGwm/oxgQwBAvsbHZU+RA3vg7SlPK5xrTwO6RHL2mn9PiTozVEHfgy+ghz/p1/NtBeCRLwS0cVAlyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NG94JY75; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NG94JY75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A741F000FF;
	Wed, 30 Sep 2026 18:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791249;
	bh=W2jwsvYOmq35CgDZv1Z5OYUaLLrCfyFZy5arTfYruzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NG94JY75VFNegmSHTQ932NFuvPtHcrLsx6iuwdPr2FzYYXQ+1jotMn/5jRFx47d8i
	 Ec/lwJGYu6r5BGuajAej9dPb+OhOF1ppjSo3vThrRmgejsC62JqBiIW2ewbFEcYKaH
	 MGNZ+LBX9Suobk40xvpr5wVB7xDS7SWbi7I6rl0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 237/752] EDAC/igen6: Fix channel address decode for non-hash mode
Date: Wed, 30 Sep 2026 17:21:47 +0200
Message-ID: <20260930152403.395656866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



