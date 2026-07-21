Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23EC3B6C05;
	Tue, 21 Jul 2026 20:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666526; cv=none; b=aS+Kauzw7oMQqGuN76PzGd2iA/ZWRVRuqgjnInAUmxk7vdXVi35HnA0hvo8WwkmLBaIWH7KJprYdLKK6LlzAC91218P4EpXEq9gFKhT7XfBNQsE2COk8yCDtBd+U8lfLwDRYYzd5Kuw49h0Yy2Nui8WV4mUyMaSfdKht5aSJBeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666526; c=relaxed/simple;
	bh=ck/d8anx51Y7ry5TD17ACXZmzLsDq8aHqr6F0MKUE18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJavaQg95lhCe+m3Vr5HCi4LEOrB/bzvXtYVaBC4oADjC0p/TMMyfnKm/N/fNf8JS5fZntOvZNatNrnhj5rxjwb2fdNZbeQfodC4Czo82AOZPwnq4ix27JNqS3c164KrcVQ1jLBKmEbefta1iRfYRM1Q237CXF4oqAlL9NX2I3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFWhDCF1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFWhDCF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93FE1F000E9;
	Tue, 21 Jul 2026 20:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666525;
	bh=hKCWz0hIFKoKL8SFSCqRM4SRwltkJfsKSNnssZHEG2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tFWhDCF17uFMCY68BwpFv9/afNalAnWphYPsOUl7WBzJ39M0gi+xn0cHVCL1/nF6e
	 mNPrVHtgXyssPeUHr5UzxklKagXdEXC9CNQVT1SBSwHn7FhlkrYOGvLCgJRP9g+R6E
	 Xg0eGovK9Sw/gOKiYWgnoPg03hYvSz8Os3l/LVnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9383b1ff0df4b29ca5e6@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0716/1266] xfrm: validate selector family and prefixlen during match
Date: Tue, 21 Jul 2026 17:19:13 +0200
Message-ID: <20260721152457.888938561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c499c142097453..3d63e52254ed02 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -836,6 +836,9 @@ static inline bool addr_match(const void *token1, const void *token2,
 	unsigned int pdw;
 	unsigned int pbi;
 
+	if (prefixlen > 128)
+		return false;
+
 	pdw = prefixlen >> 5;	  /* num of whole u32 in prefix */
 	pbi = prefixlen &  0x1f;  /* num of bits in incomplete u32 in prefix */
 
@@ -860,6 +863,10 @@ static inline bool addr4_match(__be32 a1, __be32 a2, u8 prefixlen)
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
index 6ac96f7bfc7ed4..7eaaaf56e631a0 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -223,6 +223,9 @@ __xfrm6_selector_match(const struct xfrm_selector *sel, const struct flowi *fl)
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



