Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056093;
	b=3MleiAeVpMzaQm4GyRoMPDxPFi0NMmE6fHU387iGYQNtbSgN2u2rz3B78gV9stl6VcTB
	 FCzshDzgtr5o901o7jGuFgm66HvFfWlYciRKHHlZYwLXnCjb1SZVTy90w9+vf9E87ML4W
	 gbFt+alwEhGjTdxEZGAwbxWVgCZxgFCJpOUsB4oS92x57u6n+pShbQTtzdvY+4HxxKoJU
	 D0fLxntX/24S1S2lPlF6LYlUMY4naA5E9k7yUjT0itqwNjaW8udmpywosa6oM+WreH527
	 n9MPYSHA2JxoBb+dQmRrBxtmSG1rE3igfEHeZyZYhvsIIVo7Yklvbtsp4C7CfNB3dew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FRPAkPN1+ThUiLYqwRz2uGmVicbuVcScXGmyjbj3Mj4=;
	b=1r6YcEgPuqN+jbrfrqszfAabDZpt3xo05g1ahZ9XtC1mbaaJ8gf7NeEB68R4dhcEps2o
	 Yi9leqNXGc0WdZYqAbuR4+cqu6+3aPUFJ6OCZdlgZ+MBgw1GXyN3DsoeHtISr3X99zsQk
	 ChjthAmrCf7umD5YmQmmj07ssyUQT2B9VbMuvJbXgPkNmWsVJcaErmuZpa5/KXGYJjL/D
	 JuColqYZgwLsceDSjxnAxirKlhUZSnSdh9KzGz6a5CHKJhk3j33CdMaRjyR3AcV18jvaE
	 D9dRTqXA9WDrGFnN2FsAuPrJmaFL7Y2k+y0Mus5okDKt5WBfpS5ew2gP0TGu/Ofu2pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vG3ntVwy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B1B606A32A;
	Thu, 19 Nov 2026 02:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vG3ntVwy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3875F1F000C4;
	Thu, 19 Nov 2026 02:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056093;
	bh=FRPAkPN1+ThUiLYqwRz2uGmVicbuVcScXGmyjbj3Mj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vG3ntVwyDG2JyaUULQh6pZK/b2rMCMTk3ipQeWdW6hah85jdLw6jwmNzTBG95cv9u
	 U0EfoMhpNsvDgMu8Owh2tmylWqchDrMYbBfL86WxIrBq3lGCtECc9s1e1gwJe/y/jt
	 9WM3i7AlAJl7kDTzIyDvVhjwLcjH0XfqefmGkovs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chien Wong <m@xv97.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1866/2214] wifi: mac80211: fix encryption tailroom
Date: Wed, 18 Nov 2026 15:59:02 +0100
Message-ID: <20261118150125.957219182@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chien Wong <m@xv97.com>

[ Upstream commit c49f54fd2abff08964677db8fdc1674c713ab42c ]

BIP-CMAC-256 and BIP-GMAC append a 26-byte MME but mac80211
currently reserves only 18 bytes of encryption tailroom.

Generating 26-byte MME may happen to work because the actual skb
tailroom can exceed the requested amount. For example, dev_alloc_skb()
rounds the allocation to kmalloc size buckets or alignment boundaries,
and the extra space may cover the 8-byte shortfall.

Reserve enough tailroom for the 26-byte MME.

Fixes: 56c52da2d554 ("mac80111: Add BIP-CMAC-256 cipher")
Signed-off-by: Chien Wong <m@xv97.com>
Link: https://patch.msgid.link/20261012140738.70178-2-m@xv97.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9ef4b0790b7be..9769aaa181e7a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -49,7 +49,7 @@ struct ieee80211_local;
 
 /* Required encryption head and tailroom */
 #define IEEE80211_ENCRYPT_HEADROOM 8
-#define IEEE80211_ENCRYPT_TAILROOM 18
+#define IEEE80211_ENCRYPT_TAILROOM 26 /* current max: GMAC/CMAC-256 MME */
 
 /* power level hasn't been configured (or set to automatic) */
 #define IEEE80211_UNSET_POWER_LEVEL	INT_MIN
-- 
2.53.0



