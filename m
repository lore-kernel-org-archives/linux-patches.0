Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8031E2834;
	Wed, 25 Feb 2026 01:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984018; cv=none; b=RwQ5c/T9iBO1bMHk1XJHNO5irBKLrM1WJY8ANI5hr2QDauI4aZV3aL091y0L7ciWxTQLcQKIwqfEN++fzji0s9CkZOjSwqdDyQfgcZYUOLZeI5/KKCPxqbUHN6onCT1ZfcO58N9ALyQ7lQZ+pEcISxiN2LIPPlMoqMsPCd0yXrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984018; c=relaxed/simple;
	bh=G4fWBRfDK1B+RVGu5zB44ILtEGop6lFI56FjfRLFBUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEraAx+ClmabU3Rtk5fV4myj8gQNDhsXWORuA+ite1AozPfSlXHXnKmPREmRknozvkf3BlIUBTBdxS1DCy9+KH032J4hj3nkBlQ2KJ2YT/78IsAhbak2v0kTSk6NDXtQNeSBKsGCaKBuaqKHp6KkHxlGrKZ0KSB9p+9CrF1QwKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEQy7iiX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEQy7iiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417DBC116D0;
	Wed, 25 Feb 2026 01:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984018;
	bh=G4fWBRfDK1B+RVGu5zB44ILtEGop6lFI56FjfRLFBUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEQy7iiX4ViiiJ+/PZkt3tvRMzPEwVumnJkQK8ZGGo0b2BwgAoQjIS7z4HJ63jG4e
	 2AVdBcj227CpOnWMrWw1UReyRtVg06hEzxsD6SZkofWwYYOBYNK/iJWzQe4QAmI/fU
	 Q+aeehMcLcxZqCnDfx1+1Lll9pSfvHz7sB4oklkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Zilin Guan <zilin@seu.edu.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 265/641] wifi: rtw89: debug: Fix memory leak in __print_txpwr_map()
Date: Tue, 24 Feb 2026 17:19:51 -0800
Message-ID: <20260225012355.232397058@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 6070a44051b1c35714fa130de7726cfe91ca5559 ]

In __print_txpwr_map(), memory is allocated to bufp via vzalloc().
If max_valid_addr is 0, the function returns -EOPNOTSUPP immediately
without freeing bufp, leading to a memory leak.

Since the validation of max_valid_addr does not depend on the allocated
memory, fix this by moving the vzalloc() call after the check.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 036042e15770 ("wifi: rtw89: debug: txpwr table supports Wi-Fi 7 chips")
Suggested-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260116130834.1413924-1-zilin@seu.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/debug.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index 3dc7981c510fd..a82df3814069c 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -824,10 +824,6 @@ static ssize_t __print_txpwr_map(struct rtw89_dev *rtwdev, char *buf, size_t buf
 	s8 *bufp, tmp;
 	int ret;
 
-	bufp = vzalloc(map->addr_to - map->addr_from + 4);
-	if (!bufp)
-		return -ENOMEM;
-
 	if (path_num == 1)
 		max_valid_addr = map->addr_to_1ss;
 	else
@@ -836,6 +832,10 @@ static ssize_t __print_txpwr_map(struct rtw89_dev *rtwdev, char *buf, size_t buf
 	if (max_valid_addr == 0)
 		return -EOPNOTSUPP;
 
+	bufp = vzalloc(map->addr_to - map->addr_from + 4);
+	if (!bufp)
+		return -ENOMEM;
+
 	for (addr = map->addr_from; addr <= max_valid_addr; addr += 4) {
 		ret = rtw89_mac_txpwr_read32(rtwdev, RTW89_PHY_0, addr, &val);
 		if (ret)
-- 
2.51.0



