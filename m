Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFBD2F260C;
	Thu, 28 May 2026 20:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998775; cv=none; b=GQpTgzwNQn81l5MmthH7i5ALqBPgX3rjxYeW23noZir5fhsYrjRfHgER26lcsu5+Yb93BVcNYUE4Nnt6IsdkebCxEbq7DudtWY+iMMOKxohqvAS5Y75QStSAn51R3Guzikrupjiy2rJTxvnsiCkq17S739X9pr4qUSicJUtcmv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998775; c=relaxed/simple;
	bh=38J9KwLMLa4kpmz7D8R+kyahRwDRfo8tnh6osJnLLqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QI+0+uGf/vyFDdWDQrxGJIavkkQTqXlLIV0L5BA1F6lx8ces5cF6j9DJ44lFmhUDU/OT5+UerIpxFje5D8iesaMM1ujV/qTyfrn0zgGmB0jDl0jBXCoBKwluzwMpi5cIXFTnrUa1npNiJfLzs+AtUHVm+CZ97qTEECZ8vdOJ4r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dxa3qPsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dxa3qPsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545B91F000E9;
	Thu, 28 May 2026 20:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998774;
	bh=XuV8xe7VJAFUPjwzetsfFcDCqJZ1NV4KLNlRux9r/eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dxa3qPsjjX1X6XUxjISMu+WroQFN9ODuB93Zby6gxCZfbhe4Xdeh8AyF33DVAD/FM
	 fwzPyLza2mbMVHB/6B+1Mo2QLRybJ6SBLIZ7m2ThkwBMMmD6xvUgAjdR39fIy/XHoo
	 ND9Gf3LDQypdI0qAHlgDf34jzk16tidZ03ImuLpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 293/461] ethtool: fix ethnl_bitmap32_not_zero() bit interval semantics
Date: Thu, 28 May 2026 21:47:02 +0200
Message-ID: <20260528194655.698234638@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



