Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055985;
	b=PqK36Lt1GzSHhAzFKCMg6n/zZ8VIHNaLfZZb+ZzFnzEzwwM5Rxw68MgfgT7BsFOz/0ao
	 4DlCP1mQHuL7pBnhYsc82nVj+nbz3e86Oo0DzACp7x/JZsczWlCzd50gTJes+y3BKqH9q
	 4CBE8HtYCaNto69XCNPIKWbRucqnDHVZKfF8pNp73xbADxPs9zjjheUtGCaAzhJyDt2ql
	 HuuYO/sNgcnoaKesDrTiOqgnvV0T59WE7BIZTW9YcSrF31kXk8OU/3VGua5BMVQeUtwqs
	 1hdEm+Db+MZarDx5JwDuN7olAAwt57Bq+dz+Y9419MGYZdk/yT4m2AJTJIlh7iQPDAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aVwlxZcrD0/p1dwCTCPqP/bYGhBS4xqHWp5S8V9pRM8=;
	b=Bey0l9Mn4YkfzE4quc6X29kkpteDnZbmAHHCkd2sjQUt6ZeUkl4FiUrO/iQJxFIwd2fV
	 tEE6NvjvJMgQlTzjEI5S7vOhQrDq0Kpt20ztHcoXKA2VMvNU7HWd2pPN6omV1qm437T0G
	 awQzSe1crt63mnlDUt89Is3VffxDTX8wVpmK8B4X9QOK3rGX3zhA/M0FxDAu0R1pQPmxb
	 3u5ghiGOygL8DCjG8l8wzx8yHy8HtqgToi3T5o2DxjQoKquzeY+SQtwgvxhAtV1+cFfX4
	 XJAkWBe3Hrzw7zeH2/iWxgh++6vxgzLzcCsgZm7VYX4XiaGECjAdw78iHWwxxTNLhyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qnVb514z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05F8606A320;
	Thu, 19 Nov 2026 02:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qnVb514z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C37C1F000C4;
	Thu, 19 Nov 2026 02:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055984;
	bh=aVwlxZcrD0/p1dwCTCPqP/bYGhBS4xqHWp5S8V9pRM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnVb514zG+RTlTxx/CYP5ua6UOcTSZrMTkbh2im8HWdvxEZfODN3ooo2ykMhXWSae
	 iqm/ZqQCFGZ6vdzfZjK9Bp3uAAupR0XxCZgG90SF6bFR9BdncK33jbCtDfXKmJX2ia
	 iWqxMhNvdod2QyRll/Hk11aXpNn7+6meo7zJEK3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1827/2214] wifi: mac80211: clear fragment cache entry is_protected
Date: Wed, 18 Nov 2026 15:58:23 +0100
Message-ID: <20261118150124.533818101@linuxfoundation.org>
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
index dda1ee11f8a8c..9959cb82cf8bc 100644
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



