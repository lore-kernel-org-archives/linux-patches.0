Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061515;
	b=jsMldPffhE4JWFtoa3ZpLDdkj1e2Hv/2XIgm2j7kkMI/8l+1VodPSvYic1EjgmdjVNOt
	 9REeKKC1PRwGyCde6cvO5j94F7aEg3+68NEOl0hWuxqwQUijSCb7vbW2a1az4mTmRolwN
	 RBvepa5VA/yI4p7rQHfCK+N6wSgI124zDAHI4L9/HTwp6fGDD0mwgTYhjkUlpPuSSpnbW
	 pfjffFZRf6a7i/jrLbuDS336uiTMj7BWftDq+2aY7Lbur5euxNcVSzsmLz1U8Gt7OzUeV
	 UGQGKkPEmRorynlrx1YDf92nS6bHEUZpP+MvA+P4NhD74KYJeVU082ThthNUwuAp9nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XgHGB5NFYW0SH9JghvQAAZfspKABf1cmAZvpIbj1818=;
	b=OtmTDNrAGr4scnnYlJMqgt54mUjETa4u6/hKioMYqZwki1uPtc3kzE6g/Vk0gwG1S8H2
	 w+44D80hqn7A8oBzfmChaT7AkQKlHcHsCGmQwnQQU4qOFUqb8bHIFgjxmRuiDkmFDmGh+
	 W6n0w9OMONEOWil7nUA4T5U/HO6NTSkYUXOe6ArmKOG/cjJOkhpCKK3aQ+nyuDQ0Qu1d0
	 2qQrne/I8lIjItZQ7lZOpCcw/8WnGxuZZL/FwRSX+hWFe3ubwyVwXtQgCd0vPtDR5t4Pe
	 dwYacU4gF4n0mqF9kdct/aFLDi5BPzSSj8xYT+kFPshX/ABNEsYlYPPEKqoSvO3WKfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NU32vruM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA36A60A2603;
	Thu, 19 Nov 2026 04:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NU32vruM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492B91F000C4;
	Thu, 19 Nov 2026 04:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061514;
	bh=XgHGB5NFYW0SH9JghvQAAZfspKABf1cmAZvpIbj1818=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NU32vruMJWNRzhHDGD4EUtVhb0+uw7hCVOx+uJv/ZwEhfUugFvcNTGr41KnWLkGPz
	 1HaZIU5PFg92yph1YIJ0E5KySmDGW3iMG5cShBO7o66qUqqO3/nZgKoBJivjrmLoUw
	 6K3iKO9VgD6tRnyxRxZyJWzBftM2Dwm1E+YRXCXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1553/1848] wifi: mac80211: clear fragment cache entry is_protected
Date: Wed, 18 Nov 2026 15:59:51 +0100
Message-ID: <20261118150024.626670410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c7504dff7b4b3..3fe07729731de 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2174,6 +2174,7 @@ ieee80211_reassemble_add(struct ieee80211_fragment_cache *cache,
 	entry->rx_queue = rx_queue;
 	entry->last_frag = frag;
 	entry->check_sequential_pn = false;
+	entry->is_protected = false;
 	entry->extra_len = 0;
 
 	return entry;
-- 
2.53.0



