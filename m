Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811F5316905;
	Thu, 28 May 2026 20:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001474; cv=none; b=E6YnI5gNLoX2PhlLkvNI2fMaMWbzxxxpuPZ0CJwzjR4vksobijci8DLhLiqeWixsGr6SmEYpaLILq1fxVPHB4CgBnOOiGv5UL4NOVAtaSpaUEVFLmMlcN3y0uoFJ3Yt9VMwc97NvLGq6OR3HKm+PF3FMiPn9tOEGCHspcEqWdOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001474; c=relaxed/simple;
	bh=5APLEk4X3hRU3BlyO3phD2/Mlnpq90oBLP3lxVhNZmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDWk0jrR427XUCHJqQhce+4FFyWRhyJoFlEg9F52TPzWFMWmzQpd98sO4EjzV/P86IDMKWzmLMDwnMLJJkCm/e5th5hGyLwLz2asm0kfVLcYYoi3aY+WU9IIhu00k0QLOlBjN4oZa/FdFPJDYN2w3iudRCmMdajdBnfMyNcL1BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rn/goW7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rn/goW7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1D11F000E9;
	Thu, 28 May 2026 20:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001473;
	bh=+Lo22FxV8KsOc5lKscqLaQe1p9CF+Q8nxDBcrzTukcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rn/goW7i9T8g9neyjOdEKnFpeZ8lDmtXZs2Iq/0CHZfnu9c0y9kfzwH7TZ5DclxN6
	 ZFmvsyj7l+t0BkbdC/+f+3oe6NW5A2TE3gZ/o5fBxwLWrOgeIgTUHJ7F/cfyv2DOIH
	 pGIzT2D0+iVkYEdc3rM8zLpqmojCfCZY2gPA5MCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/186] ethtool: fix ethnl_bitmap32_not_zero() bit interval semantics
Date: Thu, 28 May 2026 21:50:19 +0200
Message-ID: <20260528194932.703419204@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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



