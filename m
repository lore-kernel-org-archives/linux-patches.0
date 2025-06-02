Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C2B224B02;
	Mon,  2 Jun 2025 14:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876117; cv=none; b=f8gFXH4C4QyLzdui66JNQ8dChqw5bUa/rXxG/aiwu3IFQq9rMfik7SxKe2tpzxrXr6JqT/ctHJ9sxCIq57JCaa+H5HGdf43CKjdu9XSy9OYke0Pw/9aW9JPKWitmbLXa8lCBv6n7Yrcey88CnWmhP9D4dgoZOJY/1iWEv9ynRS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876117; c=relaxed/simple;
	bh=gYZctUuCMJ4ZI3Z/29qtbhcRvJ0X0l0S67che+p5ZgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFsqHxtZT/blJTh8yof6LhyARAKjfH3nFEoY6J8u9dAWICdlBYeVTlzJp/5YOH3oyTIzR/mtF+/cshuD4gpcKSFxPbWA20+6eIeikTtX10puKldSXfH2hyDajoCAaHYnSg5jb+O1SSQx1cxfF1NDRrPv3UjtApAyPgXBH7JR6ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14mk6no3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14mk6no3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9458FC4CEEE;
	Mon,  2 Jun 2025 14:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876117;
	bh=gYZctUuCMJ4ZI3Z/29qtbhcRvJ0X0l0S67che+p5ZgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=14mk6no36OIUhwMx3+0gR5ddV3atFHDNQh8I7F1Lq2+cXbq3aTN1fkw9MyVTCfA1B
	 Sc+idxlgKM9KbZZtBDSDZCefOeqnUCchGqcDjn/JW3lNE5BxbQCbvraGx0kGsAizai
	 4mRoYE6l8b2WJseeALgU/h26l1FlMXlPGoKHL2kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/207] ipv4: fib: Move fib_valid_key_len() to rtm_to_fib_config().
Date: Mon,  2 Jun 2025 15:47:28 +0200
Message-ID: <20250602134301.714215915@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 254ba7e6032d3fc738050d500b0c1d8197af90ca ]

fib_valid_key_len() is called in the beginning of fib_table_insert()
or fib_table_delete() to check if the prefix length is valid.

fib_table_insert() and fib_table_delete() are called from 3 paths

  - ip_rt_ioctl()
  - inet_rtm_newroute() / inet_rtm_delroute()
  - fib_magic()

In the first ioctl() path, rtentry_to_fib_config() checks the prefix
length with bad_mask().  Also, fib_magic() always passes the correct
prefix: 32 or ifa->ifa_prefixlen, which is already validated.

Let's move fib_valid_key_len() to the rtnetlink path, rtm_to_fib_config().

While at it, 2 direct returns in rtm_to_fib_config() are changed to
goto to match other places in the same function

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250228042328.96624-12-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_frontend.c | 18 ++++++++++++++++--
 net/ipv4/fib_trie.c     | 22 ----------------------
 2 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 545dd994f0609..ced6bd48bb416 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -817,19 +817,33 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
 		}
 	}
 
+	if (cfg->fc_dst_len > 32) {
+		NL_SET_ERR_MSG(extack, "Invalid prefix length");
+		err = -EINVAL;
+		goto errout;
+	}
+
+	if (cfg->fc_dst_len < 32 && (ntohl(cfg->fc_dst) << cfg->fc_dst_len)) {
+		NL_SET_ERR_MSG(extack, "Invalid prefix for given prefix length");
+		err = -EINVAL;
+		goto errout;
+	}
+
 	if (cfg->fc_nh_id) {
 		if (cfg->fc_oif || cfg->fc_gw_family ||
 		    cfg->fc_encap || cfg->fc_mp) {
 			NL_SET_ERR_MSG(extack,
 				       "Nexthop specification and nexthop id are mutually exclusive");
-			return -EINVAL;
+			err = -EINVAL;
+			goto errout;
 		}
 	}
 
 	if (has_gw && has_via) {
 		NL_SET_ERR_MSG(extack,
 			       "Nexthop configuration can not contain both GATEWAY and VIA");
-		return -EINVAL;
+		err = -EINVAL;
+		goto errout;
 	}
 
 	if (!cfg->fc_table)
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index ec0113ecf3949..8ab6ad65d0b86 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1187,22 +1187,6 @@ static int fib_insert_alias(struct trie *t, struct key_vector *tp,
 	return 0;
 }
 
-static bool fib_valid_key_len(u32 key, u8 plen, struct netlink_ext_ack *extack)
-{
-	if (plen > KEYLENGTH) {
-		NL_SET_ERR_MSG(extack, "Invalid prefix length");
-		return false;
-	}
-
-	if ((plen < KEYLENGTH) && (key << plen)) {
-		NL_SET_ERR_MSG(extack,
-			       "Invalid prefix for given prefix length");
-		return false;
-	}
-
-	return true;
-}
-
 static void fib_remove_alias(struct trie *t, struct key_vector *tp,
 			     struct key_vector *l, struct fib_alias *old);
 
@@ -1223,9 +1207,6 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 
 	key = ntohl(cfg->fc_dst);
 
-	if (!fib_valid_key_len(key, plen, extack))
-		return -EINVAL;
-
 	pr_debug("Insert table=%u %08x/%d\n", tb->tb_id, key, plen);
 
 	fi = fib_create_info(cfg, extack);
@@ -1715,9 +1696,6 @@ int fib_table_delete(struct net *net, struct fib_table *tb,
 
 	key = ntohl(cfg->fc_dst);
 
-	if (!fib_valid_key_len(key, plen, extack))
-		return -EINVAL;
-
 	l = fib_find_node(t, &tp, key);
 	if (!l)
 		return -ESRCH;
-- 
2.39.5



