Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F2835DA40;
	Tue, 21 Jul 2026 19:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662754; cv=none; b=c8O67J9qTu8OqX7iHO/KSTgKUC/NK5v73lafWP/Vhxreqqv9G7S0t9cVANUpvvEPgmri8bcbsIYYgJCdoZrg8kRt+I9ajjx90kffpTt5R3wwwOzCSl0UObKoKqH/B27pxD4HQfserc1OTCScOQGjqD5MFOKbUKpFghaLmM1giqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662754; c=relaxed/simple;
	bh=WHlMWe05uOGirMW/w1I828paG3dHcWn7XM0EM9aStVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDE9uJay7c6b5ydxk6SX/gX3knL5F/w8suV5yI1n1a3eDI/SwROHCsvz5reb3Sr2lpnxOJiGrsqMuL3zV+AXo79RNqdHue56w8kIB2U19CXbMXweKhgev3kQOXCHcMD1VGVfo06FGxVA5w2v993ur6+nMel8kNOJEL9fw86Cwfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6vTHWe8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6vTHWe8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E1B1F000E9;
	Tue, 21 Jul 2026 19:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662753;
	bh=HUKFpZkwGhlAUPKi+gB0f+3PCMyZKo4EVNjfZyXPB3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6vTHWe8l3MalR54XLJwfS+AjSno0fDGmGnaFqxDbtZMSCq9Gplw5FGJ9uzLpuXOy
	 XUJRg5qXxD1VCsUXEmc2MyeAQOZUPmcP4tIRfirQeO15P9itZAVIHnQO1rJazNaOTy
	 sV0G6q1q0G8GSBlbIJFPJ6/Et2wUpEp9qwaWaHeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9383b1ff0df4b29ca5e6@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0565/1276] xfrm: validate selector family and prefixlen during match
Date: Tue, 21 Jul 2026 17:16:48 +0200
Message-ID: <20260721152458.761326150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 40f0b1047918539f0b0f795ac65e35336b4c2c78 ]

syzbot reported a shift-out-of-bounds in xfrm_selector_match()
due to AF_UNSPEC selector with large prefixlen (e.g. 128) matched
against IPv4 flow (when XFRM_STATE_AF_UNSPEC is set).

Fix this by:

- Rejecting mismatched families in xfrm_selector_match.
- Returning false in addr4_match if prefixlen > 32.
- Returning false in addr_match if prefixlen > 128 (prevents overflow).

Fixes: 3f0ab59e6537 ("xfrm: validate new SA's prefixlen using SA family when sel.family is unset")
Reported-by: syzbot+9383b1ff0df4b29ca5e6@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a2fbe35.be3f099c.2836ae.0018.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h     | 7 +++++++
 net/xfrm/xfrm_policy.c | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index b5a14b39046e51..a20a01dd6f98e3 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -878,6 +878,9 @@ static inline bool addr_match(const void *token1, const void *token2,
 	unsigned int pdw;
 	unsigned int pbi;
 
+	if (prefixlen > 128)
+		return false;
+
 	pdw = prefixlen >> 5;	  /* num of whole u32 in prefix */
 	pbi = prefixlen &  0x1f;  /* num of bits in incomplete u32 in prefix */
 
@@ -902,6 +905,10 @@ static inline bool addr4_match(__be32 a1, __be32 a2, u8 prefixlen)
 	/* C99 6.5.7 (3): u32 << 32 is undefined behaviour */
 	if (sizeof(long) == 4 && prefixlen == 0)
 		return true;
+
+	if (prefixlen > 32)
+		return false;
+
 	return !((a1 ^ a2) & htonl(~0UL << (32 - prefixlen)));
 }
 
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 0a03005a64c3da..f74e45a34b70df 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -242,6 +242,9 @@ __xfrm6_selector_match(const struct xfrm_selector *sel, const struct flowi *fl)
 bool xfrm_selector_match(const struct xfrm_selector *sel, const struct flowi *fl,
 			 unsigned short family)
 {
+	if (family != sel->family && sel->family != AF_UNSPEC)
+		return false;
+
 	switch (family) {
 	case AF_INET:
 		return __xfrm4_selector_match(sel, fl);
-- 
2.53.0



