Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BE21C2420;
	Tue,  8 Oct 2024 12:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391567; cv=none; b=nhIJQfyCbyMjiPMApjCY6wz9rkeBkeQLb92FLMvCzaXKAxk6RjvBG7CNkeYOmKEnfqFcqI9JKDA939JI8k1dp2IVh/4iNk34vIvJkwCTaq/MzM4kksJwZ1TN2uEOMxnDkun5LdWS/I/z9Xrf5QfdGsEm87S193lJmHtIZUaJMfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391567; c=relaxed/simple;
	bh=7z9Q55X7XsuuPNBZX52kpzC5CjQ9phzrDIvBv8jngK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXq3K9pC5fp2GStvgBxNorgHJUod0q7/P2CBMPH6uJyOzQpWnKsZG5ZEM5CFGAaQJqGzQpHb+6jE8DIyyb/6O40RM1GDO3sw3T2/WeJXwosBvK7+H3HwbG1JVG4G3IS2qnp9eR+oVvw2TFb4QvNFaKDtDwATS1nvxwMuQEt2y9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZ9yxRlY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZ9yxRlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B701C4CEC7;
	Tue,  8 Oct 2024 12:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391567;
	bh=7z9Q55X7XsuuPNBZX52kpzC5CjQ9phzrDIvBv8jngK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZ9yxRlY0XRuV8rcEW37vRbz5NU+uPYiAkBgYZb1cxZaICnNcxvB6bjAx2OYigjjt
	 jaiZyuJeenl5hfcGNqvMiG+kWhOPKe/UDakDzA7oA0v4wp81GrACsT7Ch5Y74AHhak
	 RcJuFkD6mZyoHLXvEe12b7cSJoQp/jGanCanFeiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 155/558] wifi: rtw89: avoid reading out of bounds when loading TX power FW elements
Date: Tue,  8 Oct 2024 14:03:05 +0200
Message-ID: <20241008115708.461711990@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit ed2e4bb17a4884cf29c3347353d8aabb7265b46c ]

Because the loop-expression will do one more time before getting false from
cond-expression, the original code copied one more entry size beyond valid
region.

Fix it by moving the entry copy to loop-body.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240902015803.20420-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.h | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 9c282d84743b9..46dfb0b294db9 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -3909,16 +3909,22 @@ struct rtw89_txpwr_conf {
 	const void *data;
 };
 
+static inline bool rtw89_txpwr_entcpy(void *entry, const void *cursor, u8 size,
+				      const struct rtw89_txpwr_conf *conf)
+{
+	u8 valid_size = min(size, conf->ent_sz);
+
+	memcpy(entry, cursor, valid_size);
+	return true;
+}
+
 #define rtw89_txpwr_conf_valid(conf) (!!(conf)->data)
 
 #define rtw89_for_each_in_txpwr_conf(entry, cursor, conf) \
-	for (typecheck(const void *, cursor), (cursor) = (conf)->data, \
-	     memcpy(&(entry), cursor, \
-		    min_t(u8, sizeof(entry), (conf)->ent_sz)); \
+	for (typecheck(const void *, cursor), (cursor) = (conf)->data; \
 	     (cursor) < (conf)->data + (conf)->num_ents * (conf)->ent_sz; \
-	     (cursor) += (conf)->ent_sz, \
-	     memcpy(&(entry), cursor, \
-		    min_t(u8, sizeof(entry), (conf)->ent_sz)))
+	     (cursor) += (conf)->ent_sz) \
+		if (rtw89_txpwr_entcpy(&(entry), cursor, sizeof(entry), conf))
 
 struct rtw89_txpwr_byrate_data {
 	struct rtw89_txpwr_conf conf;
-- 
2.43.0



