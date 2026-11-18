Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026105;
	b=G6d6F6OFQ7YezeAK+G19TIymUiGnVkATOYc1FqTLibxGF36oQZxtzoN4GQcadxYazs/n
	 2DPOB6IiHgaoduAHMfZuWBmZWlD+p/Ts4XQ3MAXe3vq3u/JDFYTla68dz6VJZVAvTrjx+
	 YDSjfH/EsaFo6cI4NM1gQhlDUtRU7K2luEZf2cirkyY9nsdPvROmT695CD4NFpHT9WDC5
	 Ii+Jl2zMAAKjv62SV65xB++VpoDuJkpLByDidhkmeQh2L0X0bJrq47Kcwo+lt8qNqdi1X
	 P9Z/aRGOJBWW80K74TIcr9JFYW4xfH3hw3XRXnnwticCSDV+YkAC1kYgIiaZ4rz+sBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lTCt5n23+7sVk302yDYeZ2LtWGGjhkoC/b2OKPfgGw4=;
	b=S1X8kBHaj8wEC9B4wn+zoXE/KtB3OUuvmToAvV+0VTsJYi1zkolSO95ChKQ5I5dbtCp0
	 GLiD0va373sMfNN1hLbEycwLByF6up7lEuWSaKiyURHFVCBB49rwtoz1HQwNRGi3lYgpS
	 PpCF0KKGkRTXHVQLdbMd1Md5st7KF1IgxXWCZ52obtgBxIz3r76pvhVZnyVQed+Cvvfw8
	 PClwwPJtbUVCvm2cf84F8xDiX1bPcjHoK8nDghbc0tilFW2K/Kn5RDh/8KvegZHtcbDp0
	 MHhf3rq0WMp1Yc0NudGQN/bWZ4W9vwfC56XCqP813V2QT2Z384zgbmPOqYUP+t9zEFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zzRUX/io";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A752606A32A;
	Wed, 18 Nov 2026 18:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zzRUX/io
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E90C1F000C4;
	Wed, 18 Nov 2026 18:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026104;
	bh=lTCt5n23+7sVk302yDYeZ2LtWGGjhkoC/b2OKPfgGw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zzRUX/ioJd1wDswsHaggoVxvn1nTltU3tPcOTz+0cf+Hoi62/EvmRXkOezvPNZu3b
	 mLeD1BzrBDJOr/IhKPF42MIjIhOfla4thiYYhPFkaHvECSwD2gKz77XhGBR0V8XO5d
	 bE9hh+W/113qKFDxU0sOM7Nr/aMNkfi4XkXwhg9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1289/2151] wifi: mac80211: clear fragment cache entry is_protected
Date: Wed, 18 Nov 2026 15:50:24 +0100
Message-ID: <20261118150209.084035371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3567544c34044..1f1b1e4f0df70 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2205,6 +2205,7 @@ ieee80211_reassemble_add(struct ieee80211_fragment_cache *cache,
 	entry->rx_queue = rx_queue;
 	entry->last_frag = frag;
 	entry->check_sequential_pn = false;
+	entry->is_protected = false;
 	entry->extra_len = 0;
 
 	return entry;
-- 
2.53.0



