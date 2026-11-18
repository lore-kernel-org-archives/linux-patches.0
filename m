Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049409;
	b=e03WNu85TS3vmI9+oRftkUNCxZXON74WS4IMTWJhcG0lWi3y6MV1Une5xpxjt60HfSQ1
	 2I7alRC1LVpnymUg2v9QMElG+6HNq5V3QP0VSiCU1gNu1h+yeJDUzeEpTFOpbnsiazzKj
	 2v7VkjtpRb/NjvoP6o6Uq5WQWTHzmV0suFxP3k+NYaN3QOJxI3JYK6oPoP9HC3xhW4oh2
	 31S+zAxtgyP/DAzB5bI/wHY9tF4cidy7Gs8Usb0RhXfGtaFo751CgBGbrVixC7uc0yrwp
	 udCL+sy06FIPnBpcM6Hp+WnqLG/3CZYe8YcAE/0QEtvzo/lCNupIt/pFQd+hkY5F6zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xrRtTLfMVnNCVa2tp3Po4NaLdlyqy6tVTSuwdeaNDB8=;
	b=xXkEumj4pmfX1AhY1GNLTZ+DFA37l78hsaQ0UlXttdkEEsx80jEtn82ntipB/CIo0Cnj
	 QmWwq1oJp4DBrPJ5BJVuZugCjXx5O9tbBN3m4xwX6s4EdZNsH7vjrOt+e9VsZyQLDoLVo
	 Gqy2uc5+yz5u8DKFAwf0g6vkCn85rw+iQsUgdKDLVhyPYXq9DDQsJXbkV9FjBtaFkbgqE
	 /tz7epCUP3bXBiHKhIdr1CfLYywKblLgAzO7ZRsGWBalhsmBAMPMRHs8ROW/hsC5aXDxf
	 9KETfb8xK+xnpuFa8YLXUxxQOOsRjbtZuae5FuYcMac815jkzBuv9Qsrc+StV5poR1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VlRqLKZj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE32F606A325;
	Thu, 19 Nov 2026 00:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VlRqLKZj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334601F000C4;
	Thu, 19 Nov 2026 00:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049408;
	bh=xrRtTLfMVnNCVa2tp3Po4NaLdlyqy6tVTSuwdeaNDB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlRqLKZjEpsqHkW5x3fJmtts52EhFbqnrd1mItOuNYqZbBEubqRKeFNn+ctBmpns0
	 DRjdTWUMZVzvJp/wnXw4uz1A9IY+DM1xogolt+hRqQ4/68FssDg8Z0XUwndWXkIFZD
	 z4zKUDVPKC3fxj1iZ+QRH3uymrqZajEPE3LE1fqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2341/2857] wifi: mac80211: clear fragment cache entry is_protected
Date: Wed, 18 Nov 2026 15:56:15 +0100
Message-ID: <20261118150325.822906250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1fbccdb37166a..76a1a46fc18ad 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2180,6 +2180,7 @@ ieee80211_reassemble_add(struct ieee80211_fragment_cache *cache,
 	entry->rx_queue = rx_queue;
 	entry->last_frag = frag;
 	entry->check_sequential_pn = false;
+	entry->is_protected = false;
 	entry->extra_len = 0;
 
 	return entry;
-- 
2.53.0



