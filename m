Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039382;
	b=32bdKYeHFdF69DkwdyHw5IJEBdMxbBbgQkzzf2HsaU8n0zQxdi3d7cnMx/wUn/Td4Sg9
	 Y5Xp9TkXhSZRCcl8RzJ0tXifpeEp8G2wJ/5aiTLbw4urkgu/JIkVAK7R6FM7UH5vfIYLk
	 Nnc3uoiMcFnF6IU/7CSGycF+aqOWY298w1BpBZ0a99yLgQ37ByQxfGUCVXG/QtT9OakIm
	 9dS5PZ7MXLqlkiUmcFul58S6QmBFeglw9hanvL1Pwg2NZNKh7sszzkZuIxkm+XpUwTLDL
	 koxArirPjatk8HmluQ/KJT6c1alsmbm7LGb9TR8kANXUYcy92rll0uiiXCGGI3yDzaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uPgw4A8AI+rIeNu1nHHCPgShAz+U8WwsfDsT45x7lbM=;
	b=wmdGEfo4KXiGg7+zGjvk53Och5/o6bgmE3RQgfX8DVIqmtDFwFdJyX+WbchE/bdeFLyh
	 odWzFPTw2EJlXWEr1Iuh6PyqUWkAQa1+4ouH7q/k7T/QBU9JXXfiKbsYxyaRLB0SzCn3H
	 bbfXLb0WmUDOwylnZ/wC25PNWt/gCQ0Vcizu7ARyWHOpNMt1jstsjX/5GhyyDrNNnOhlW
	 ///naosKtvigU7bk8wOxu7YTQDzc1Bf0CMbp7BKyqydursGJF8gT4zTqQiPy2Mm0i/my9
	 rKrn77cb1ivqju9NXHkU9P60lkna6sW0qbieW1wGxdVZH4GfxtLg8RFrXYNMdZ8pDtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=brAGM8sm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E05C606A335;
	Wed, 18 Nov 2026 22:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=brAGM8sm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE521F000C5;
	Wed, 18 Nov 2026 22:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039381;
	bh=uPgw4A8AI+rIeNu1nHHCPgShAz+U8WwsfDsT45x7lbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=brAGM8smk6+B/kW1+j8wx4DicuONPUR1SN3FeYd+2paFpgw+BKAx30NPq4+k/PBL/
	 1e9To75s68EzDXXJ+xZY/zqwd2KZelt1+sLhW09wjudzafFdh1IWzD2dvBKFGQqd+6
	 1mgwJ+wwdfUws3XUu8xsnOwJnmaZuizmG8xgJ3lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2079/3318] mac80211: tx: Use info->flags in ieee80211_tx_h_select_key()
Date: Wed, 18 Nov 2026 15:45:01 +0100
Message-ID: <20261118150424.454698738@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bert Karwatzki <spasswolf@web.de>

[ Upstream commit 5f2530a4df8e0573e54cc0f4175c06ecb810a4dd ]

Without this ieee80211_select_key_8023() is never called and wifi never
connects.

Fixes: 0e80db08668b ("wifi: mac80211: fix key selection for encap offload frames")
Signed-off-by: Bert Karwatzki <spasswolf@web.de>
Link: https://patch.msgid.link/20260908094341.12196-1-spasswolf@web.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c31444570a76a..ed0706e038829 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -632,7 +632,7 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 
-	if (info->control.flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
+	if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
 		return ieee80211_select_key_8023(tx);
 
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) {
-- 
2.53.0



