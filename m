Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046214;
	b=wvscvJVDaSOeCGFsrzTh4YExIEX6MFgV5BXIO9ANqiB1moUgZVyWTzMdE5PGprJyPyVj
	 fo93jRHjuRjuB6BtkJLSX+VOoV2166aO+BzyGEWZBdWCgeOMN0dmIH2n4/BT8lm8NDMs7
	 hXcHLFn8V1M9iuRjqhNwXUuUg+Wgb5Ncu0A5xvw8SoEuA0x0ClcksQkoTWNu3cOLmpKPZ
	 fq1ZmVEW7MPLUGizNqJTGmI967OQSD+8xI51uQb0cTn/mOrtb6py0BH6jADA4XfVnoVFw
	 jCzrsXKOh/1S1mPuJAiqQYYjddp7ARjq3sOtmRBrAScbTR0Dst4E+6PS23O4miGzW5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e2atTvVGR5ddm9+AtB5cniZi06NIbDZhpcRCOFgbVXY=;
	b=mDqdokq0SBR64M534ngZiXsAHOo2LqxMluDv/n4PvGoKZga4nn9Tao7OV3S7/TTvw19i
	 clnli8aKk7bAVTG/W8v6UVlYj2TFrtE4aNamroKypXvogM2+fswWmCJOlWsfB+KQHNkZ0
	 ULXEpN0XoFpnKiehGn6/63IjZJ76hi72sFFEo6JVEFtFd1205bTA0r7WcKAZjDmX2mGvf
	 AvmOgWU0Tix03gasiYeDVZUl8v6bibPgBsE9KXje/3YQ/oJ2APes882o4eX5wmQJSEZVO
	 Qk0jKbrEZXNBWKNmOz2X6MhXfW56BYceHuCNBiCDyOeXYf5p82aestv3DxNGcQbABLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=or+R7M1r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5581606A32A;
	Wed, 18 Nov 2026 23:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=or+R7M1r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106141F000C4;
	Wed, 18 Nov 2026 23:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046214;
	bh=e2atTvVGR5ddm9+AtB5cniZi06NIbDZhpcRCOFgbVXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=or+R7M1rhltUtEFQH6ARVNForlUvQTSZX+TLTS3hGeViGjKU8mMJmeY8q5SiOlH6D
	 RDbNeoo4vhMirMXzfQXJvZuFm4oQDLaLHbRsixfHZp2er3GiUI80ST8Ral3MpFw94V
	 PJNWZHnEF4Pqyh/MxWcRZsUr/qbcASKcx22bZZOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijing Yin <yzjaurora@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1199/2857] wifi: cfg80211: fix out-of-bounds read in valid_rule()
Date: Wed, 18 Nov 2026 15:37:13 +0100
Message-ID: <20261118150244.784574971@linuxfoundation.org>
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

From: Zijing Yin <yzjaurora@gmail.com>

[ Upstream commit 9d8ec0b5b5295bd23d979d1b2b905de25c36fff2 ]

valid_rule() validates a struct fwdb_rule from the regulatory database
firmware file, but bounds checks only the first byte of the structure,
the length field itself.

It then uses that length, which comes straight out of the file, to
decide whether the optional fields are present, and reads rule->wmm_ptr
at offset 18 of the 20-byte structure once the length claims 20 bytes or
more.

A rule placed in the last bytes of the file therefore makes the parser
read up to 19 bytes past the end of the firmware image. The image comes
from vmalloc() in kernel_read_file(), so with the rule at the end of a
page the read falls into the guard page and oopses, with no memory
debugging enabled.

A length of at least offsetofend(max_bw) but below offsetofend(wmm_ptr)
takes the other branch, so valid_rule() returns true having read nothing
out of bounds, and the database is accepted. regdb_query_country() does
not re-check the rule, and reads rule->start, rule->end, rule->max_bw
and rule->cac_timeout off the end of the kmemdup()ed copy.

A malformed regulatory.db is parsed by cfg80211's own
request_firmware_nowait() at init time, and on demand from user space
through NL80211_CMD_RELOAD_REGDB, which needs CAP_NET_ADMIN but no
wireless hardware. Both paths require write access to the firmware
search path and CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=n.

Bound the whole declared rule, not just its length field. The existing
check on sizeof(rule->len) is still needed, since rule->len has to be
shown to be inside the file before it can be read, so the new test goes
after it. A rule reaching past the end of the file is now rejected,
which fails the database rather than reading out of bounds. That also
gives regdb_query_country() the bound it already assumes.

Fixes: 230ebaa189af ("cfg80211: read wmm rules from regulatory database")
Cc: stable@vger.kernel.org
Signed-off-by: Zijing Yin <yzjaurora@gmail.com>
Link: https://patch.msgid.link/20261015133159.1499728-1-yzjaurora@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 85a982a1e9f99..695f7159b2bba 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -689,6 +689,9 @@ static bool valid_rule(const u8 *data, unsigned int size, u16 rule_ptr)
 	/* mandatory fields */
 	if (rule->len < offsetofend(struct fwdb_rule, max_bw))
 		return false;
+	/* the rule must lie entirely within the database */
+	if ((u8 *)rule + rule->len > data + size)
+		return false;
 	if (rule->len >= offsetofend(struct fwdb_rule, wmm_ptr)) {
 		u32 wmm_ptr = be16_to_cpu(rule->wmm_ptr) << 2;
 		struct fwdb_wmm_rule *wmm;
-- 
2.53.0



