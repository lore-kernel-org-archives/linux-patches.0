Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBD11487CD;
	Thu, 12 Dec 2024 15:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016951; cv=none; b=kGT3pmzoI6rjkwE0+M6GgzoBOcWEFi31PUZ8yjg8VWv5c6M92zSkrex87//zwsWelhKTnglwRprHL0i+roDWmsWb38ir5SRDuXlOSrnH86sXxt2xgYKonOuyEslc5sF2Lb/SWCDtLh3jtl9pJLi3gVHBJQLHIqTAgwpYUA7tsXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016951; c=relaxed/simple;
	bh=2yVDHW+5diwAFssSy3a0hkH9icfX+Sk0rURYj9LA0MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBx5ed8VwQyaI3Wbf+119KkMWQ6MgEyyGC6DuQZGGi9fyumFDmVDQiPszbmOJFoQxnkMoHIqmgcfZL/capYXMyJ9XnenovrOWvJgMol6cu871qQdDrdF5bm6op1C/5S/+yT+ad0YQ1vdSMd0RsFu0Z4BFVzFbZKcTTYS3sj3eYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkNRadTi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkNRadTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866C6C4CECE;
	Thu, 12 Dec 2024 15:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016951;
	bh=2yVDHW+5diwAFssSy3a0hkH9icfX+Sk0rURYj9LA0MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkNRadTiDEcNokaZZVLeXa1pDexJEI3dT/z0/xsPHTmtLTm6jBqChixcYldhEHzOO
	 lXI+EAI9FEiCLRocngk29UxTDngNdp+pc531TyDttWsHwUvZcknK3lAyoDpntp2hXw
	 I/5Uioj3sr91S6ybdvlt1H+9jp48ABwO3gd2X7EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 324/466] net/tcp: Add missing lockdep annotations for TCP-AO hlist traversals
Date: Thu, 12 Dec 2024 15:58:13 +0100
Message-ID: <20241212144319.594125422@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dmitry Safonov <0x7f454c46@gmail.com>

[ Upstream commit 6b2d11e2d8fc130df4708be0b6b53fd3e6b54cf6 ]

Under CONFIG_PROVE_RCU_LIST + CONFIG_RCU_EXPERT
hlist_for_each_entry_rcu() provides very helpful splats, which help
to find possible issues. I missed CONFIG_RCU_EXPERT=y in my testing
config the same as described in
a3e4bf7f9675 ("configs/debug: make sure PROVE_RCU_LIST=y takes effect").

The fix itself is trivial: add the very same lockdep annotations
as were used to dereference ao_info from the socket.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20241028152645.35a8be66@kernel.org/
Signed-off-by: Dmitry Safonov <0x7f454c46@gmail.com>
Link: https://patch.msgid.link/20241030-tcp-ao-hlist-lockdep-annotate-v1-1-bf641a64d7c6@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp_ao.h |  3 ++-
 net/ipv4/tcp_ao.c    | 42 +++++++++++++++++++++++-------------------
 net/ipv4/tcp_ipv4.c  |  3 ++-
 net/ipv6/tcp_ipv6.c  |  4 ++--
 4 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 1d46460d0fefa..df655ce6987d3 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -183,7 +183,8 @@ int tcp_ao_hash_skb(unsigned short int family,
 		    const u8 *tkey, int hash_offset, u32 sne);
 int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
 		 sockptr_t optval, int optlen);
-struct tcp_ao_key *tcp_ao_established_key(struct tcp_ao_info *ao,
+struct tcp_ao_key *tcp_ao_established_key(const struct sock *sk,
+					  struct tcp_ao_info *ao,
 					  int sndid, int rcvid);
 int tcp_ao_copy_all_matching(const struct sock *sk, struct sock *newsk,
 			     struct request_sock *req, struct sk_buff *skb,
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index db6516092daf5..bbb8d5f0eae7d 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -109,12 +109,13 @@ bool tcp_ao_ignore_icmp(const struct sock *sk, int family, int type, int code)
  * it's known that the keys in ao_info are matching peer's
  * family/address/VRF/etc.
  */
-struct tcp_ao_key *tcp_ao_established_key(struct tcp_ao_info *ao,
+struct tcp_ao_key *tcp_ao_established_key(const struct sock *sk,
+					  struct tcp_ao_info *ao,
 					  int sndid, int rcvid)
 {
 	struct tcp_ao_key *key;
 
-	hlist_for_each_entry_rcu(key, &ao->head, node) {
+	hlist_for_each_entry_rcu(key, &ao->head, node, lockdep_sock_is_held(sk)) {
 		if ((sndid >= 0 && key->sndid != sndid) ||
 		    (rcvid >= 0 && key->rcvid != rcvid))
 			continue;
@@ -205,7 +206,7 @@ static struct tcp_ao_key *__tcp_ao_do_lookup(const struct sock *sk, int l3index,
 	if (!ao)
 		return NULL;
 
-	hlist_for_each_entry_rcu(key, &ao->head, node) {
+	hlist_for_each_entry_rcu(key, &ao->head, node, lockdep_sock_is_held(sk)) {
 		u8 prefixlen = min(prefix, key->prefixlen);
 
 		if (!tcp_ao_key_cmp(key, l3index, addr, prefixlen,
@@ -793,7 +794,7 @@ int tcp_ao_prepare_reset(const struct sock *sk, struct sk_buff *skb,
 		if (!ao_info)
 			return -ENOENT;
 
-		*key = tcp_ao_established_key(ao_info, aoh->rnext_keyid, -1);
+		*key = tcp_ao_established_key(sk, ao_info, aoh->rnext_keyid, -1);
 		if (!*key)
 			return -ENOENT;
 		*traffic_key = snd_other_key(*key);
@@ -979,7 +980,7 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 		 */
 		key = READ_ONCE(info->rnext_key);
 		if (key->rcvid != aoh->keyid) {
-			key = tcp_ao_established_key(info, -1, aoh->keyid);
+			key = tcp_ao_established_key(sk, info, -1, aoh->keyid);
 			if (!key)
 				goto key_not_found;
 		}
@@ -1003,7 +1004,7 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 						   aoh->rnext_keyid,
 						   tcp_ao_hdr_maclen(aoh));
 			/* If the key is not found we do nothing. */
-			key = tcp_ao_established_key(info, aoh->rnext_keyid, -1);
+			key = tcp_ao_established_key(sk, info, aoh->rnext_keyid, -1);
 			if (key)
 				/* pairs with tcp_ao_del_cmd */
 				WRITE_ONCE(info->current_key, key);
@@ -1163,7 +1164,7 @@ void tcp_ao_established(struct sock *sk)
 	if (!ao)
 		return;
 
-	hlist_for_each_entry_rcu(key, &ao->head, node)
+	hlist_for_each_entry_rcu(key, &ao->head, node, lockdep_sock_is_held(sk))
 		tcp_ao_cache_traffic_keys(sk, ao, key);
 }
 
@@ -1180,7 +1181,7 @@ void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb)
 	WRITE_ONCE(ao->risn, tcp_hdr(skb)->seq);
 	ao->rcv_sne = 0;
 
-	hlist_for_each_entry_rcu(key, &ao->head, node)
+	hlist_for_each_entry_rcu(key, &ao->head, node, lockdep_sock_is_held(sk))
 		tcp_ao_cache_traffic_keys(sk, ao, key);
 }
 
@@ -1256,14 +1257,14 @@ int tcp_ao_copy_all_matching(const struct sock *sk, struct sock *newsk,
 	key_head = rcu_dereference(hlist_first_rcu(&new_ao->head));
 	first_key = hlist_entry_safe(key_head, struct tcp_ao_key, node);
 
-	key = tcp_ao_established_key(new_ao, tcp_rsk(req)->ao_keyid, -1);
+	key = tcp_ao_established_key(req_to_sk(req), new_ao, tcp_rsk(req)->ao_keyid, -1);
 	if (key)
 		new_ao->current_key = key;
 	else
 		new_ao->current_key = first_key;
 
 	/* set rnext_key */
-	key = tcp_ao_established_key(new_ao, -1, tcp_rsk(req)->ao_rcv_next);
+	key = tcp_ao_established_key(req_to_sk(req), new_ao, -1, tcp_rsk(req)->ao_rcv_next);
 	if (key)
 		new_ao->rnext_key = key;
 	else
@@ -1857,12 +1858,12 @@ static int tcp_ao_del_cmd(struct sock *sk, unsigned short int family,
 	 * if there's any.
 	 */
 	if (cmd.set_current) {
-		new_current = tcp_ao_established_key(ao_info, cmd.current_key, -1);
+		new_current = tcp_ao_established_key(sk, ao_info, cmd.current_key, -1);
 		if (!new_current)
 			return -ENOENT;
 	}
 	if (cmd.set_rnext) {
-		new_rnext = tcp_ao_established_key(ao_info, -1, cmd.rnext);
+		new_rnext = tcp_ao_established_key(sk, ao_info, -1, cmd.rnext);
 		if (!new_rnext)
 			return -ENOENT;
 	}
@@ -1902,7 +1903,8 @@ static int tcp_ao_del_cmd(struct sock *sk, unsigned short int family,
 	 * "It is presumed that an MKT affecting a particular
 	 * connection cannot be destroyed during an active connection"
 	 */
-	hlist_for_each_entry_rcu(key, &ao_info->head, node) {
+	hlist_for_each_entry_rcu(key, &ao_info->head, node,
+				 lockdep_sock_is_held(sk)) {
 		if (cmd.sndid != key->sndid ||
 		    cmd.rcvid != key->rcvid)
 			continue;
@@ -2000,14 +2002,14 @@ static int tcp_ao_info_cmd(struct sock *sk, unsigned short int family,
 	 * if there's any.
 	 */
 	if (cmd.set_current) {
-		new_current = tcp_ao_established_key(ao_info, cmd.current_key, -1);
+		new_current = tcp_ao_established_key(sk, ao_info, cmd.current_key, -1);
 		if (!new_current) {
 			err = -ENOENT;
 			goto out;
 		}
 	}
 	if (cmd.set_rnext) {
-		new_rnext = tcp_ao_established_key(ao_info, -1, cmd.rnext);
+		new_rnext = tcp_ao_established_key(sk, ao_info, -1, cmd.rnext);
 		if (!new_rnext) {
 			err = -ENOENT;
 			goto out;
@@ -2101,7 +2103,8 @@ int tcp_v4_parse_ao(struct sock *sk, int cmd, sockptr_t optval, int optlen)
  * The layout of the fields in the user and kernel structures is expected to
  * be the same (including in the 32bit vs 64bit case).
  */
-static int tcp_ao_copy_mkts_to_user(struct tcp_ao_info *ao_info,
+static int tcp_ao_copy_mkts_to_user(const struct sock *sk,
+				    struct tcp_ao_info *ao_info,
 				    sockptr_t optval, sockptr_t optlen)
 {
 	struct tcp_ao_getsockopt opt_in, opt_out;
@@ -2229,7 +2232,8 @@ static int tcp_ao_copy_mkts_to_user(struct tcp_ao_info *ao_info,
 	/* May change in RX, while we're dumping, pre-fetch it */
 	current_key = READ_ONCE(ao_info->current_key);
 
-	hlist_for_each_entry_rcu(key, &ao_info->head, node) {
+	hlist_for_each_entry_rcu(key, &ao_info->head, node,
+				 lockdep_sock_is_held(sk)) {
 		if (opt_in.get_all)
 			goto match;
 
@@ -2309,7 +2313,7 @@ int tcp_ao_get_mkts(struct sock *sk, sockptr_t optval, sockptr_t optlen)
 	if (!ao_info)
 		return -ENOENT;
 
-	return tcp_ao_copy_mkts_to_user(ao_info, optval, optlen);
+	return tcp_ao_copy_mkts_to_user(sk, ao_info, optval, optlen);
 }
 
 int tcp_ao_get_sock_info(struct sock *sk, sockptr_t optval, sockptr_t optlen)
@@ -2396,7 +2400,7 @@ int tcp_ao_set_repair(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	WRITE_ONCE(ao->snd_sne, cmd.snd_sne);
 	WRITE_ONCE(ao->rcv_sne, cmd.rcv_sne);
 
-	hlist_for_each_entry_rcu(key, &ao->head, node)
+	hlist_for_each_entry_rcu(key, &ao->head, node, lockdep_sock_is_held(sk))
 		tcp_ao_cache_traffic_keys(sk, ao, key);
 
 	return 0;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5afe5e57c89b5..a7cd433a54c9a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1053,7 +1053,8 @@ static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
 			}
 
 			if (aoh)
-				key.ao_key = tcp_ao_established_key(ao_info, aoh->rnext_keyid, -1);
+				key.ao_key = tcp_ao_established_key(sk, ao_info,
+								    aoh->rnext_keyid, -1);
 		}
 	}
 	if (key.ao_key) {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c9de5ef8f2675..59173f58ce992 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1169,8 +1169,8 @@ static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
 			if (tcp_parse_auth_options(tcp_hdr(skb), NULL, &aoh))
 				goto out;
 			if (aoh)
-				key.ao_key = tcp_ao_established_key(ao_info,
-						aoh->rnext_keyid, -1);
+				key.ao_key = tcp_ao_established_key(sk, ao_info,
+								    aoh->rnext_keyid, -1);
 		}
 	}
 	if (key.ao_key) {
-- 
2.43.0



