Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FD42BEFEF;
	Wed, 30 Sep 2026 19:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795013; cv=none; b=Bv/zBeaROHt3Z+zP/bJsTTKcSa7622GiPude1NnKZ83epCGJcAhr/KambBXm3OW2qr1NXBLUsM4X2903efpkqUnTjtawqT00ctPyIU3lrbu6orCR4V7P7in6Im+RIP41SBn/r+mRlVqaeR68mEc0YPxTzK7EJEqK8nxHyGz9tyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795013; c=relaxed/simple;
	bh=CrWHJIdbohOVvhXsLNKrHWUbO8J88VxXgKIB+BvTIBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldtTCl1iPxtDkzk9sR31iVoGgVVKxBtyAVide8ObNshfXvffjv1CJQf9CBcXujcsyyQFiZY5fRu5vC9iFmRb+S0lYvyD+gEqgD32y7p5j6TUW0G1mUsPTtk4QlcIcDWeUC7yLIzvy807rJCALh9nZhPiO1xXtMPyLHbk3XEtO5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCGq80Q6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCGq80Q6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9431F000FF;
	Wed, 30 Sep 2026 19:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795011;
	bh=rll7Dwbjqv1HW+3wJs0DpC5DeLPVB1IyNErog3wTR24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCGq80Q6Kx3KZiBDJDS+o4Hpk/tTeyRmplJYUguCNOkgTgblDSe5jYcg7/QwXgUzU
	 gWk7nbz8M1atQrOfzSPNM3eLB6IYILha60on4o8u9ahCC9LxZY3ybexESR2src826n
	 +QIQw1Gq0inD6R6pDVyWD/ZLrmkdgCVRDTQ2XarM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0375/1193] EDAC/igen6: Fix channel address decode for non-hash mode
Date: Wed, 30 Sep 2026 17:17:39 +0200
Message-ID: <20260930152442.510005134@linuxfoundation.org>
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
index a7e8356651399..34a25103402e3 100644
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



