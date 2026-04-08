Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453513446CA;
	Wed,  8 Apr 2026 18:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671678; cv=none; b=XpMDUvKSsIsQF+h/Cmsz2wlbE6GQQJ13Dtz4JTt32MptmyvjIqwsFLUZlH5g+hmzHMzqZw2wYW/Okha3r7oTDoHrbj8OErh1oUjwLQz9l3idFMo0l/TBa7fwhelcGH952wdC/xUsZ2D4tYsaPSqYp4b1FXYyRJghwlUA9dq9nfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671678; c=relaxed/simple;
	bh=Z6mGkIRuDGyGP8QtHhaLza2s/l1iCQ+aMFuQVz7euo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5A3chF5vpyWjyoVBQDu+p2zstPOGbNOKY1oTvI3687VDYD7kTAVOyxF2CPzGPHBqGQZ9KPNYoBOzEZmCBGIfYd+WM829XfRlZlJKL4/oXfBd6wDZ+Rko/IIMxsDxanxY0CO4AiacNvOlae/FYS6Yxe9EYs3RuMwBS6y4/KSFhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fn8IdunT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fn8IdunT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE1AC19421;
	Wed,  8 Apr 2026 18:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671678;
	bh=Z6mGkIRuDGyGP8QtHhaLza2s/l1iCQ+aMFuQVz7euo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fn8IdunTLuzuini9YgvJrLyuOKM21zX0TBhd+GUPSyzEpU1mZWnUdfmuC53kpjccL
	 zWabXtdBS6PGnKZZldbNwes5mMKekuNB7L0NmSOp6v3j6eO+7muWRcv7J35n3izKHu
	 uVbiENpYr7hStAfAgM29N6Y4x/BhLs32jkEBtST0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b518dfc8e021988fbd55@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/312] af_key: validate families in pfkey_send_migrate()
Date: Wed,  8 Apr 2026 19:59:03 +0200
Message-ID: <20260408175934.705256862@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

[ Upstream commit eb2d16a7d599dc9d4df391b5e660df9949963786 ]

syzbot was able to trigger a crash in skb_put() [1]

Issue is that pfkey_send_migrate() does not check old/new families,
and that set_ipsecrequest() @family argument was truncated,
thus possibly overfilling the skb.

Validate families early, do not wait set_ipsecrequest().

[1]

skbuff: skb_over_panic: text:ffffffff8a752120 len:392 put:16 head:ffff88802a4ad040 data:ffff88802a4ad040 tail:0x188 end:0x180 dev:<NULL>
 kernel BUG at net/core/skbuff.c:214 !
Call Trace:
 <TASK>
  skb_over_panic net/core/skbuff.c:219 [inline]
  skb_put+0x159/0x210 net/core/skbuff.c:2655
  skb_put_zero include/linux/skbuff.h:2788 [inline]
  set_ipsecrequest net/key/af_key.c:3532 [inline]
  pfkey_send_migrate+0x1270/0x2e50 net/key/af_key.c:3636
  km_migrate+0x155/0x260 net/xfrm/xfrm_state.c:2848
  xfrm_migrate+0x2140/0x2450 net/xfrm/xfrm_policy.c:4705
  xfrm_do_migrate+0x8ff/0xaa0 net/xfrm/xfrm_user.c:3150

Fixes: 08de61beab8a ("[PFKEYV2]: Extension for dynamic update of endpoint address(es)")
Reported-by: syzbot+b518dfc8e021988fbd55@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/69b5933c.050a0220.248e02.00f2.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/key/af_key.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 0fcd348c249fb..169045f595633 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3518,7 +3518,7 @@ static int set_sadb_kmaddress(struct sk_buff *skb, const struct xfrm_kmaddress *
 
 static int set_ipsecrequest(struct sk_buff *skb,
 			    uint8_t proto, uint8_t mode, int level,
-			    uint32_t reqid, uint8_t family,
+			    uint32_t reqid, sa_family_t family,
 			    const xfrm_address_t *src, const xfrm_address_t *dst)
 {
 	struct sadb_x_ipsecrequest *rq;
@@ -3583,12 +3583,17 @@ static int pfkey_send_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 
 	/* ipsecrequests */
 	for (i = 0, mp = m; i < num_bundles; i++, mp++) {
-		/* old locator pair */
-		size_pol += sizeof(struct sadb_x_ipsecrequest) +
-			    pfkey_sockaddr_pair_size(mp->old_family);
-		/* new locator pair */
-		size_pol += sizeof(struct sadb_x_ipsecrequest) +
-			    pfkey_sockaddr_pair_size(mp->new_family);
+		int pair_size;
+
+		pair_size = pfkey_sockaddr_pair_size(mp->old_family);
+		if (!pair_size)
+			return -EINVAL;
+		size_pol += sizeof(struct sadb_x_ipsecrequest) + pair_size;
+
+		pair_size = pfkey_sockaddr_pair_size(mp->new_family);
+		if (!pair_size)
+			return -EINVAL;
+		size_pol += sizeof(struct sadb_x_ipsecrequest) + pair_size;
 	}
 
 	size += sizeof(struct sadb_msg) + size_pol;
-- 
2.51.0



