Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EBC41C312;
	Wed,  4 Feb 2026 15:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217418; cv=none; b=omUICZ/avOKJhxfyg8KicU2ic4f2KvBb4BnIqEKA7H4ocmJL2KD5bp6ErkQWnhBbXWGy/H500kD1sdWn3YDA4sJjT3lPeRXn3GYzRkJl7xsXoBVn+EpEikot043PVviR+9XcGLlPSWhNyfQFjP9ihaB9SqVyHX9rxoJ81nCiLFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217418; c=relaxed/simple;
	bh=bCOufrvwaVZ9nlHa1fcRhIAv3hzNChTMeWqWQDAA/fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gs/k9vSxJc4cqr9W1qz0vESrMlMfmSlnWjdYOtV23Jp4E57T/bB3noAy3wRUthJloGRJLwtVA66M7Dh9i19hoK+COlljSNlTTZB3+S2ly5vbwP8MU+14XtR4PdS0BRD8cWHTcapctkFv3cSuYkul/oqzSzZg3CAZsvNeOqBziq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUI6Req/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUI6Req/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCEDC4CEF7;
	Wed,  4 Feb 2026 15:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217418;
	bh=bCOufrvwaVZ9nlHa1fcRhIAv3hzNChTMeWqWQDAA/fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUI6Req/7hVs35ogQVcSdca89rf5nrarozX6VS6R8QGOPzjntLbyaD4uL3fFEUHuP
	 v/tvGO1Hoek2tHa1Pmlg/tyJtxAfz8yRD9/jqZy81YwKdpnxzBXLCvnIKC8fvtXZtu
	 t1mnaNmdzlVOqo2NMlTCeUoLsBHiXIQrbrY40VFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/280] net: update netdev_lock_{type,name}
Date: Wed,  4 Feb 2026 15:36:25 +0100
Message-ID: <20260204143910.034728597@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit eb74c19fe10872ee1f29a8f90ca5ce943921afe9 ]

Add missing entries in netdev_lock_type[] and netdev_lock_name[] :

CAN, MCTP, RAWIP, CAIF, IP6GRE, 6LOWPAN, NETLINK, VSOCKMON,
IEEE802154_MONITOR.

Also add a WARN_ONCE() in netdev_lock_pos() to help future bug hunting
next time a protocol is added without updating these arrays.

Fixes: 1a33e10e4a95 ("net: partially revert dynamic lockdep key changes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260108093244.830280-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 114fc8bc37f8b..69bb7ac73d047 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -449,15 +449,21 @@ static const unsigned short netdev_lock_type[] = {
 	 ARPHRD_IEEE1394, ARPHRD_EUI64, ARPHRD_INFINIBAND, ARPHRD_SLIP,
 	 ARPHRD_CSLIP, ARPHRD_SLIP6, ARPHRD_CSLIP6, ARPHRD_RSRVD,
 	 ARPHRD_ADAPT, ARPHRD_ROSE, ARPHRD_X25, ARPHRD_HWX25,
+	 ARPHRD_CAN, ARPHRD_MCTP,
 	 ARPHRD_PPP, ARPHRD_CISCO, ARPHRD_LAPB, ARPHRD_DDCMP,
-	 ARPHRD_RAWHDLC, ARPHRD_TUNNEL, ARPHRD_TUNNEL6, ARPHRD_FRAD,
+	 ARPHRD_RAWHDLC, ARPHRD_RAWIP,
+	 ARPHRD_TUNNEL, ARPHRD_TUNNEL6, ARPHRD_FRAD,
 	 ARPHRD_SKIP, ARPHRD_LOOPBACK, ARPHRD_LOCALTLK, ARPHRD_FDDI,
 	 ARPHRD_BIF, ARPHRD_SIT, ARPHRD_IPDDP, ARPHRD_IPGRE,
 	 ARPHRD_PIMREG, ARPHRD_HIPPI, ARPHRD_ASH, ARPHRD_ECONET,
 	 ARPHRD_IRDA, ARPHRD_FCPP, ARPHRD_FCAL, ARPHRD_FCPL,
 	 ARPHRD_FCFABRIC, ARPHRD_IEEE80211, ARPHRD_IEEE80211_PRISM,
-	 ARPHRD_IEEE80211_RADIOTAP, ARPHRD_PHONET, ARPHRD_PHONET_PIPE,
-	 ARPHRD_IEEE802154, ARPHRD_VOID, ARPHRD_NONE};
+	 ARPHRD_IEEE80211_RADIOTAP,
+	 ARPHRD_IEEE802154, ARPHRD_IEEE802154_MONITOR,
+	 ARPHRD_PHONET, ARPHRD_PHONET_PIPE,
+	 ARPHRD_CAIF, ARPHRD_IP6GRE, ARPHRD_NETLINK, ARPHRD_6LOWPAN,
+	 ARPHRD_VSOCKMON,
+	 ARPHRD_VOID, ARPHRD_NONE};
 
 static const char *const netdev_lock_name[] = {
 	"_xmit_NETROM", "_xmit_ETHER", "_xmit_EETHER", "_xmit_AX25",
@@ -466,15 +472,21 @@ static const char *const netdev_lock_name[] = {
 	"_xmit_IEEE1394", "_xmit_EUI64", "_xmit_INFINIBAND", "_xmit_SLIP",
 	"_xmit_CSLIP", "_xmit_SLIP6", "_xmit_CSLIP6", "_xmit_RSRVD",
 	"_xmit_ADAPT", "_xmit_ROSE", "_xmit_X25", "_xmit_HWX25",
+	"_xmit_CAN", "_xmit_MCTP",
 	"_xmit_PPP", "_xmit_CISCO", "_xmit_LAPB", "_xmit_DDCMP",
-	"_xmit_RAWHDLC", "_xmit_TUNNEL", "_xmit_TUNNEL6", "_xmit_FRAD",
+	"_xmit_RAWHDLC", "_xmit_RAWIP",
+	"_xmit_TUNNEL", "_xmit_TUNNEL6", "_xmit_FRAD",
 	"_xmit_SKIP", "_xmit_LOOPBACK", "_xmit_LOCALTLK", "_xmit_FDDI",
 	"_xmit_BIF", "_xmit_SIT", "_xmit_IPDDP", "_xmit_IPGRE",
 	"_xmit_PIMREG", "_xmit_HIPPI", "_xmit_ASH", "_xmit_ECONET",
 	"_xmit_IRDA", "_xmit_FCPP", "_xmit_FCAL", "_xmit_FCPL",
 	"_xmit_FCFABRIC", "_xmit_IEEE80211", "_xmit_IEEE80211_PRISM",
-	"_xmit_IEEE80211_RADIOTAP", "_xmit_PHONET", "_xmit_PHONET_PIPE",
-	"_xmit_IEEE802154", "_xmit_VOID", "_xmit_NONE"};
+	"_xmit_IEEE80211_RADIOTAP",
+	"_xmit_IEEE802154", "_xmit_IEEE802154_MONITOR",
+	"_xmit_PHONET", "_xmit_PHONET_PIPE",
+	"_xmit_CAIF", "_xmit_IP6GRE", "_xmit_NETLINK", "_xmit_6LOWPAN",
+	"_xmit_VSOCKMON",
+	"_xmit_VOID", "_xmit_NONE"};
 
 static struct lock_class_key netdev_xmit_lock_key[ARRAY_SIZE(netdev_lock_type)];
 static struct lock_class_key netdev_addr_lock_key[ARRAY_SIZE(netdev_lock_type)];
@@ -487,6 +499,7 @@ static inline unsigned short netdev_lock_pos(unsigned short dev_type)
 		if (netdev_lock_type[i] == dev_type)
 			return i;
 	/* the last key is used by default */
+	WARN_ONCE(1, "netdev_lock_pos() could not find dev_type=%u\n", dev_type);
 	return ARRAY_SIZE(netdev_lock_type) - 1;
 }
 
-- 
2.51.0



