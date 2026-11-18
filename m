Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041156;
	b=J8CiVzusi+3UU/8Th5lh7fO4nvSO2ZhxaTpYQkpXZU2CdAjNdtBqyLkzcorwNW6aYeQ1
	 CHDAhCczIMk9XQ+UrMaowvnVtwsFIVWMPDvmt2nul1hGdsXpwYBrzRVMEbk3DU7OsEcB1
	 6uiI+xImsLGDd2bvpkcg5Y4RY3g28rQxbsSKYbcx0+eIEQaNEfeagTW4wTOtK1mKMMRhB
	 hdVSKvFvIPpmZji6SZQppzAEqdAl9BNV7sUgVFGjHb0wizXTsd5jMN+HeI7HKww8pich7
	 tbFAtuGYGM7hEayTY+Duzt5txtzUd0sei19J1kchou2e6CFjYpxkDEJ3zdiiq8E5yrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rSjpDLCM9+bTim0+X+uYc1CnHdPqZIYObSXZ/o/SLZE=;
	b=Bps8GCD7zA8wSyP7q2J/lAu8W/L41KryudJSVJsPpq1lOtiCYzRNnhrZjrDNC9LyqPPj
	 QjSCoJTzK4j0bf4tIOQ7997EenNWCyKSPPFisJR2pxYm10Qnexm7k4QcPIxb9JWIWkEaw
	 w5+6vzcPy+aREN0yztOEn17AMHvys/vrDAaCfNjzrdtQtopYWCusiWcY+5OMVKk7KWIKR
	 +F7x6hD30j8lsOF+E1W/ggIjLPlmGEmcUabI6c3vw/thH0fxwczrHcbggDBsOEgVFNX86
	 BEiQz8cn7GhVPhvuIYI9DoJxFPDVjXtv2vSnJ8QBV1J8p7uaGWwCq3fRJeVCAa82r3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E85rIlli;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC37606A320;
	Wed, 18 Nov 2026 22:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E85rIlli
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217211F000C4;
	Wed, 18 Nov 2026 22:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041156;
	bh=rSjpDLCM9+bTim0+X+uYc1CnHdPqZIYObSXZ/o/SLZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E85rIlliUFjkHkmy7APnFjId9TapVjVgG7LoIY5ZoUr48XZ9Gwkl6PZFKDztuhquj
	 yyvELgqbdYouSiG4u+qEU0Y8kz/2NflpvdMDtmBqFa9CVjLdhjE/Gw9jg97xB4w4bn
	 +d54xfmo98sxoaX2R5B7+gMC5lngNpoNZXNIUziU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2711/3318] wifi: mac80211: clear fragment cache entry is_protected
Date: Wed, 18 Nov 2026 15:55:33 +0100
Message-ID: <20261118150442.210666805@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit f3d29dc9224b0881d10d34664456adf113bc4777 ]

In practice, we probably shouldn't end up with a fragmented
frame that's protected, filled into the cache, finished or
dropped and then the next frame is unprotected, since only
unicast data frames can be fragmented.

However, tools complain and it's more correct to be able to
do this (e.g. an unencrypted fragmented EAPOL _could_, at
least in theory, happen), so clear the flag when the entry
is reused.

Assisted-by: LLM
Fixes: 7e44a0b597f0 ("mac80211: prevent attacks on TKIP/WEP as well")
Link: https://patch.msgid.link/20261005224950.c3e4106f34d5.I866c0862db031c3a810d2333acdd22e2733d2b8c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 378d58395532e..a58870b452720 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2158,6 +2158,7 @@ ieee80211_reassemble_add(struct ieee80211_fragment_cache *cache,
 	entry->rx_queue = rx_queue;
 	entry->last_frag = frag;
 	entry->check_sequential_pn = false;
+	entry->is_protected = false;
 	entry->extra_len = 0;
 
 	return entry;
-- 
2.53.0



