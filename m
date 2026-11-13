Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590192;
	b=PFqdhzueY6nn79z6DkY/SrNVQwM58oBdqH+ogwVKsmdUycCmIHgvgLirJqR1nwIq81Bs
	 s1koQq4mhWWGdT5iEsPF10vghjjlEVXZ6uTmLC5nOrY+WrgUAD17cZCB4dESJeJftTt3b
	 oIkr1bX6lybIXzSJQ4UHUHO9Sh/kADZDzftb4TnerIBhTODgu5gEa9nAr93zp0NjxUD/n
	 ug48Zh+LWI9q9MQjQjqmKOg4FYG/4Xwk2kjELqb9EDXC/S1BOOVaKZ3xFiHvbAEc4yfkY
	 SsobhE3Gie6jqvMsCzUnta4iJkm88S6pLIvPr+/uresL8k5DDvcWWpyCAML17qVmtUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8v7/7nMagx6rPpgM68q8f+w5gHWTVc1AmM45ay+HfAQ=;
	b=ezOM72OrSJxmCT3OEupWTV4WRv62r2o4Ayl/VEF9c/q1mDQTd/pE73sLIlT6ilU8C1VQ
	 E5+j76vw3yCsaRivEyjO7SHxd5Wr01h/6nqpVwUaNLeze/MJoVqecgINM7YArofoOGYbq
	 j3MqiziV2gdKnU6cWZXoCmfsAov2y/W2PNc3KFs+dhawkd6+hRLN9WoHQrckWsg/ZNFHv
	 OrKDvnBTQBBowHSQKUHTc0czjczqsBmjPe3lBJu3PXX+i6JIh+W/SjDpRZJwEQDtjoy21
	 URw+Sl8VujU+F8Pc6p2UTN6IRTODGjd+5rEyl3e7P+ATVimiJX8bFpvxpcbzWNkfzUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kDU04iNH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8608606B369;
	Fri, 13 Nov 2026 17:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kDU04iNH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C221F000C5;
	Fri, 13 Nov 2026 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590192;
	bh=8v7/7nMagx6rPpgM68q8f+w5gHWTVc1AmM45ay+HfAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kDU04iNHLcwewPYks3pjylvFok8LS8VM3OICI2FOgvpjFUmuWdj2IChBTeZnW3JLc
	 GVbNd8mLRjvcEQSkTWnA4sPw21XUftN8caFKhQPu42p6AxYSU70g+gYd+xmggcpDUz
	 qj3CoKpfbxbqklBAbqrJi2QYkQZ4IOG1QETj1Yvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijing Yin <yzjaurora@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 200/686] wifi: cfg80211: fix out-of-bounds read in valid_rule()
Date: Fri, 13 Nov 2026 10:45:33 -0500
Message-ID: <20261113153827.826176975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 15e56dfad00f7..3f685b1396ff0 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -691,6 +691,9 @@ static bool valid_rule(const u8 *data, unsigned int size, u16 rule_ptr)
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



