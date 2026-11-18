Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031335;
	b=BNyK3deg37pSX01f1uiUNr2/OkijSNg8WZfcO2nSRJM3H5Of89M9xzVi0gtshvY0EIwk
	 XvNneza+16Fi2eNNhD0Iv0QDI8Ge4+ht588XoSfkyYdVoLF43L4Ypm24paNrVyRhR0znz
	 EcQnuPOcZxNXvB2NKhhjebOEVxpczXBUxsBHNRG4KkBDXFg4Ygu+HAx5ylHEDgiQQ7yh3
	 YOzyBZwsyrGedkKJxs9zzrhddyBfIthtCmTcZTNisoS2KSzGLt6rASfAQylSCpNMEwIEQ
	 O2/yE2UYRl7VVUOOjTaxzaZ5FjZBVk3P1nKC8HxW/qJRi9Efu/GcaHRGMeCFjpzyNZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HNIwZcmlktbZmmP2mjMRIy9AYcBd22K2UociC+wExSM=;
	b=VmEELBpXh2kJE4R91xwlHKxwtaQpnVFFE0Nwfj/h2lIUGV/JAHNCyl5MuxBJ8OFJTxzX
	 Sd6Vv4Ad5uV/T03qn/xYw49U4Rr2Ym0ZVQkdca5WonUo0s2/CJ+Nf84GN/76GYyqXeNtD
	 QACRFmXQvS55EeEckTX4/g2JrMiovECOsotNSz23ydpSOnFA1ZP9uJ3BIvBuQCSSQzKRs
	 nDk79NEQHg4f8G5KkCInrhYA/xxlt+brlcfn2fdHNjBM6e8KXvz61RUVB8KjM3hJ7hNv/
	 ZMT2dvoZWDry/eTBPAh1lCZFu1bBNe0GVAbMwuUz9BQMzP7v5uT9FLJ2mLmfAmZi8JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sV5Ierze;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09055606A320;
	Wed, 18 Nov 2026 19:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sV5Ierze
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9521F000C4;
	Wed, 18 Nov 2026 19:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031334;
	bh=HNIwZcmlktbZmmP2mjMRIy9AYcBd22K2UociC+wExSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sV5IerzexCPtHqh2rQK8r8JHvy5mqN74Gn9KZh6y7EJ7Yy/tT6WtBeDw+nsGes5tF
	 N931D6BfWolamzTSxqsedjiUBZaWRQVCq2INnfMgM4g1e+HoZWGu0xI39t6k1/OWvN
	 kSODx1xnhYWPieWFuVUuurq6Du0VtgKxxR+I0BA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1023/1756] wifi: mac80211: clear fragment cache entry is_protected
Date: Wed, 18 Nov 2026 15:52:30 +0100
Message-ID: <20261118150050.827191646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 261add4790307..1af24cd4d88f4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2188,6 +2188,7 @@ ieee80211_reassemble_add(struct ieee80211_fragment_cache *cache,
 	entry->rx_queue = rx_queue;
 	entry->last_frag = frag;
 	entry->check_sequential_pn = false;
+	entry->is_protected = false;
 	entry->extra_len = 0;
 
 	return entry;
-- 
2.53.0



