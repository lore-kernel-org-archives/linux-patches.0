Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB931519BE;
	Wed,  5 Feb 2025 14:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765198; cv=none; b=eaPHETpN8tysjUQ+aHedsIUGJkwE52KQNdkRfwxAb6KExFbWZgjwZTL8uGaTo2xxk8QF5hl0mmg6bNjFN9qjmwFj5IH7ZlCz1fSU9uoYtInASS74b0AUSS8Gsa7cxyc47MCHVWhT+qK9M10Y/F98KoBewuiGOTNXhFHZ/o1HsjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765198; c=relaxed/simple;
	bh=AaCkyQMwTvoWF96CmLS5D9RG0xIpOwfmx/iEFx09/jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IU4xKl9AKy3WTpNRH7MdY1JLOQo0QqFNE8DRhYHSGThkZPWhGWQpiIRlmyvxXLCGbAYm+eFmcLjGdadFq7Jx1bjUf4tBlXa2praskluDlbV2c6eesA42dy3noGeMOwawmmyPUgciBVk8mDptWm9eDMtb1jf0oCKfWfrFIeGzAQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNLd5DJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNLd5DJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5451C4CED1;
	Wed,  5 Feb 2025 14:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765198;
	bh=AaCkyQMwTvoWF96CmLS5D9RG0xIpOwfmx/iEFx09/jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNLd5DJca1oeTuGQ6PwZ9O+qoNEIQJSV/fJutKh4K0vbmjUytaoM5mpfii+FrtlkH
	 4AF5iWt0tYRe1zfTqn2cMzatuYpajZMqDVxzXBfpg8mBMqy6+cN1Sonse18UpGquIm
	 nAmiCP4jRkxvKBaS7U9pyRtWkjxrQ7DwCUIhtMNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 155/623] wifi: rtw89: chan: fix soft lockup in rtw89_entity_recalc_mgnt_roles()
Date: Wed,  5 Feb 2025 14:38:17 +0100
Message-ID: <20250205134502.166534728@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit e4790b3e314a4814f1680a5dc552031fb199b878 ]

During rtw89_entity_recalc_mgnt_roles(), there is a normalizing process
which will re-order the list if an entry with target pattern is found.
And once one is found, should have aborted the list_for_each_entry. But,
`break` just aborted the inner for-loop. The outer list_for_each_entry
still continues. Normally, only the first entry will match the target
pattern, and the re-ordering will change nothing, so there won't be
soft lockup. However, in some special cases, soft lockup would happen.

Fix it by `goto fill` to break from the list_for_each_entry.

The following is a sample of kernel log for this problem.

watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [wpa_supplicant:2055]
[...]
RIP: 0010:rtw89_entity_recalc ([...] chan.c:392 chan.c:479) rtw89_core
[...]

Fixes: 68ec751b2881 ("wifi: rtw89: chan: manage active interfaces")
Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241231004811.8646-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/chan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/chan.c b/drivers/net/wireless/realtek/rtw89/chan.c
index abc78716596d0..c06d305519df4 100644
--- a/drivers/net/wireless/realtek/rtw89/chan.c
+++ b/drivers/net/wireless/realtek/rtw89/chan.c
@@ -391,11 +391,12 @@ static void rtw89_entity_recalc_mgnt_roles(struct rtw89_dev *rtwdev)
 
 				list_del(&role->mgnt_entry);
 				list_add(&role->mgnt_entry, &mgnt->active_list);
-				break;
+				goto fill;
 			}
 		}
 	}
 
+fill:
 	list_for_each_entry(role, &mgnt->active_list, mgnt_entry) {
 		if (unlikely(pos >= RTW89_MAX_INTERFACE_NUM)) {
 			rtw89_warn(rtwdev,
-- 
2.39.5



