Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D95761FFE;
	Tue, 12 Aug 2025 18:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023748; cv=none; b=dh/EXrHPNRsKgpBe1VZPI6awbCEzV3nxVfC7whWbbhZx2JwgXzujP0Qi9imOu2Hc9Wjajazf5/kRh26ZtjywDzCn6Oxpx5VW1ADYJCEXn0zQ840/rpDnHL6d1kcymR0iCAwTImhubodMtcDJVBT8UApEhmshboOjdBL62kah5pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023748; c=relaxed/simple;
	bh=0W/wXZk5n+3jpkga1XcjdYTYICu5I2Yqw/TRIRZ0A/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bq/UfdmTaRdfGsH+HPngpDlpK2yu2z7zJSMqzxuf7rNgNDT94Tw/j8pCrE3L/peLmycctO68o9ZTtOvDjuExUr0IXYEp5StadFXEYHLkNjA2PrbN7keNWO3cQ+mrkPazB6gUkC68VPvXuTNKYYEWGgq9AaFy1DnwEJckdH6X3Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZtmgu8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZtmgu8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3F9C4CEF0;
	Tue, 12 Aug 2025 18:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023748;
	bh=0W/wXZk5n+3jpkga1XcjdYTYICu5I2Yqw/TRIRZ0A/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZtmgu8lMnninONTXWEjjZLfP04eEyNKYguCb1EHHVeOsR/D8uXKV2huDYmvxRjvx
	 f/yz78Pzu55xJEgTQT6L5fkPmTo9nh44EFJuq7LUnDp1trspWUlpB8vjUQZhRaGzTj
	 wBoBEX2BoDPl6sNx9veH5ipAI+/U5zPOg4X1TxrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 137/627] wifi: rtw89: mcc: prevent shift wrapping in rtw89_core_mlsr_switch()
Date: Tue, 12 Aug 2025 19:27:12 +0200
Message-ID: <20250812173424.514777256@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 53cf488927a0f79968f9c03c4d1e00d2a79731c3 ]

The "link_id" value comes from the user via debugfs.  If it's larger
than BITS_PER_LONG then that would result in shift wrapping and
potentially an out of bounds access later.  In fact, we can limit it
to IEEE80211_MLD_MAX_NUM_LINKS (15).

Fortunately, only root can write to debugfs files so the security
impact is minimal.

Fixes: 9dd85e739ce0 ("wifi: rtw89: debug: add mlo_mode dbgfs")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/aDbFFkX09K7FrL9h@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 49447668cbf3..3604a8e15df0 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -5239,7 +5239,8 @@ int rtw89_core_mlsr_switch(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif,
 	if (unlikely(!ieee80211_vif_is_mld(vif)))
 		return -EOPNOTSUPP;
 
-	if (unlikely(!(usable_links & BIT(link_id)))) {
+	if (unlikely(link_id >= IEEE80211_MLD_MAX_NUM_LINKS ||
+		     !(usable_links & BIT(link_id)))) {
 		rtw89_warn(rtwdev, "%s: link id %u is not usable\n", __func__,
 			   link_id);
 		return -ENOLINK;
-- 
2.39.5



