Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A0B46D562;
	Tue, 21 Jul 2026 19:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660741; cv=none; b=cGJEsc6GcFOpVphIjqwIw9k+g1zG+Fsz5o3+xPfhdv/a1tCYyjo3Vq03VEqat8cxvR2D833a+0pZcS7rX2HlLw6BId926WwcxGMhFqd4wQ9u41TTnWj0KTCs3BYGAHLk9kf0xh7tRSMGxYiEg2P5OexCJNYxd/7Qeh5qTKncMr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660741; c=relaxed/simple;
	bh=uI5ZWrs8uCO9x+CXWkAdCe2+iwRwxApS2cX2y3dkXUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNu24w1Rzzt712RslV+5iXIB87Cb00nyT6m6G0MmaJkGASlzEC0ZwDmtnBH83ok6Z1DM20mny3Rj6QdfeOoA8oqLqE/Avqabv0qynPZrd7LDGLupeclF8as1FXYV/yaFiGuZDR27o60aqX0BXPq+FNKtkRRkJHEEsN7xnSSddLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2eaLBHO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2eaLBHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E244E1F000E9;
	Tue, 21 Jul 2026 19:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660740;
	bh=eYBK/rlhp0HDiSwYGw3RguVedZj0VhXhr5TGdz71Xqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z2eaLBHOmp9/FYBSTMGz5qNuxFLQc171kl/Ag2/TGrYx6II8lHBkll0+Hp4F6hnQF
	 M7ukFMSsB01hCXjTuYTvlR+HVKuBGh5JP24mWBxN6THYhcV168s57ewRuSTAMWPBQC
	 qUKJxmBPgXYiYBOeTGAIcJkhKz3gWqeGprJ/VRus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9383b1ff0df4b29ca5e6@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1093/2077] xfrm: validate selector family and prefixlen during match
Date: Tue, 21 Jul 2026 17:12:46 +0200
Message-ID: <20260721152618.603206984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 35a7431293298a..f8c909b0f0c34e 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -943,6 +943,9 @@ static inline bool addr_match(const void *token1, const void *token2,
 	unsigned int pdw;
 	unsigned int pbi;
 
+	if (prefixlen > 128)
+		return false;
+
 	pdw = prefixlen >> 5;	  /* num of whole u32 in prefix */
 	pbi = prefixlen &  0x1f;  /* num of bits in incomplete u32 in prefix */
 
@@ -967,6 +970,10 @@ static inline bool addr4_match(__be32 a1, __be32 a2, u8 prefixlen)
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
index 1f4afd580105f9..639934f300167e 100644
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



