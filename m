Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD2C2E7389;
	Sat, 30 May 2026 18:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167199; cv=none; b=rTi8Lq4bHOqx90KFYNVBmTmk73w/CmwoukpO2sbkatAgKip4cZ+kFNgOZX2EB5l7SmFgGKE5Ba2DytgpwEbplB4kKO+jntEB2SaN+b/XgwIq1kSzQz/YYjz2vR4kkBXnzATutjCZmPJVNFGZrCzvkova5gGSCMndqBafhm+VBkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167199; c=relaxed/simple;
	bh=81YXtHo34dCEyrIJ0AQ96imJtUmy0u30jyswzJR4XCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnEEzhnU1O4t4yLLMdYNVgUi5YXbvV9SW5/pZqh8iWUU4j6xDyQPqkGjwEVwXZkFT1TmplNLjxI1Eu+3VbRlFjW7EPkOK9KlBN1kyWyV75tp5H8vveiw6w2ALRrg03IsrQTvyUQQFsRuLziTAqu4ks1kYhG1zoyerDXJWlgZZ58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPL0pMFe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPL0pMFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CC71F00893;
	Sat, 30 May 2026 18:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167198;
	bh=Nfv5i4XLFUohEfOEGIxWVEG0D2LG55qeGkD+3wbCBPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GPL0pMFe6PIzrgIc2vcKO8UxBnoQaHmOT7vr4N+xrfDmE4lFJ/pm70h/BGnHPqSxO
	 QPy/T8i3EnWsOnwCw7bN2IHR57LwwhNEsDR5jCTsWImcp/spMlFU/zfeZJikoJ5JfG
	 ytF0mE0l8rOybOh4mBfQKlgfc2FfK1zr3eQxLxNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 580/589] ethtool: fix ethnl_bitmap32_not_zero() bit interval semantics
Date: Sat, 30 May 2026 18:07:41 +0200
Message-ID: <20260530160239.841511634@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit 3d042592ebd4c7e44974d556de0b727cb7db4dab ]

ethnl_bitmap32_not_zero() should return true if some bit in [start, end)
is set:

- Fix inverted memchr_inv() sense: return true when the scan finds a
  non-zero byte, not when the middle words are all zero.
- Return false for an empty interval (end <= start).
- When end is 32-bit aligned, indices in [start, end) do not include any
  bits from map[end_word]; return false after earlier checks found no
  non-zero data.

Fixes: 10b518d4e6dd ("ethtool: netlink bitset handling")
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/bitset.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ethtool/bitset.c b/net/ethtool/bitset.c
index f0883357d12e5..4691d6d0f2b75 100644
--- a/net/ethtool/bitset.c
+++ b/net/ethtool/bitset.c
@@ -91,7 +91,7 @@ static bool ethnl_bitmap32_not_zero(const u32 *map, unsigned int start,
 	u32 mask;
 
 	if (end <= start)
-		return true;
+		return false;
 
 	if (start % 32) {
 		mask = ethnl_upper_bits(start);
@@ -104,11 +104,11 @@ static bool ethnl_bitmap32_not_zero(const u32 *map, unsigned int start,
 		start_word++;
 	}
 
-	if (!memchr_inv(map + start_word, '\0',
-			(end_word - start_word) * sizeof(u32)))
+	if (memchr_inv(map + start_word, '\0',
+		       (end_word - start_word) * sizeof(u32)))
 		return true;
 	if (end % 32 == 0)
-		return true;
+		return false;
 	return map[end_word] & ethnl_lower_bits(end);
 }
 
-- 
2.53.0



