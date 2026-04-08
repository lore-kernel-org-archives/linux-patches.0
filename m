Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18493AEF45;
	Wed,  8 Apr 2026 18:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672039; cv=none; b=Wd98VC/Q+vCOg0mtoGQBuxHciFxstNam3vBCH8G0hFA6CpRiHQMFH4J7SNwB0jK6GqHb32hAWnzkxkgdtuS2elYcXEUR4oOKOmd6xKtI0nBoA305HAs4KLyqpRn9J9UQD/wjit47wsaYQE3xLj7vKya/c0G8r6zdEYFKy/lKrJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672039; c=relaxed/simple;
	bh=kH2mioqp1aCbOm3QeQuifrny8hZB2tg+y79dPHkhhFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIhkW+BW7f4b/TqSjl4YJDtGl0ctvEctcFlg/X5vvN8HVq8PuOrd/rf3jQ0K+sqVUKbdvnSYnKfRO4A1z5ljM4STwaqjbfy8bMXlo46SEXlo2pyN/9LAnVN34N9S9KfyRrUO0XGdPvQbeCcXuTFzHmBcDQFj2t1GPeOgfs9nwYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvbK2ZlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvbK2ZlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784AAC19421;
	Wed,  8 Apr 2026 18:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672038;
	bh=kH2mioqp1aCbOm3QeQuifrny8hZB2tg+y79dPHkhhFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvbK2ZlZ3AUArJcIbqVK+6NX+46FR563zLAiPSgYyYGmxHon/3ZsGUuUr+G06MisA
	 at1dOQM4mifPw/LpeYnRlmeQdQMqFPwbXuGvy+MOD+zx29A3p+1XbYQsWYRA7RYbS7
	 FhpCoRfqFtgsF2V6B0EMzIbP0dwkcVz+yvtej2yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/312] netfilter: ipset: use nla_strcmp for IPSET_ATTR_NAME attr
Date: Wed,  8 Apr 2026 20:01:23 +0200
Message-ID: <20260408175939.964054310@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit b7e8590987aa94c9dc51518fad0e58cb887b1db5 ]

IPSET_ATTR_NAME and IPSET_ATTR_NAMEREF are of NLA_STRING type, they
cannot be treated like a c-string.

They either have to be switched to NLA_NUL_STRING, or the compare
operations need to use the nla functions.

Fixes: f830837f0eed ("netfilter: ipset: list:set set type support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter/ipset/ip_set.h | 2 +-
 net/netfilter/ipset/ip_set_core.c      | 4 ++--
 net/netfilter/ipset/ip_set_list_set.c  | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 0b217d4ae2a48..d82413e6098a7 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -309,7 +309,7 @@ enum {
 
 /* register and unregister set references */
 extern ip_set_id_t ip_set_get_byname(struct net *net,
-				     const char *name, struct ip_set **set);
+				     const struct nlattr *name, struct ip_set **set);
 extern void ip_set_put_byindex(struct net *net, ip_set_id_t index);
 extern void ip_set_name_byindex(struct net *net, ip_set_id_t index, char *name);
 extern ip_set_id_t ip_set_nfnl_get_byindex(struct net *net, ip_set_id_t index);
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 56215fb63b645..f4f65fa948ff8 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -823,7 +823,7 @@ EXPORT_SYMBOL_GPL(ip_set_del);
  *
  */
 ip_set_id_t
-ip_set_get_byname(struct net *net, const char *name, struct ip_set **set)
+ip_set_get_byname(struct net *net, const struct nlattr *name, struct ip_set **set)
 {
 	ip_set_id_t i, index = IPSET_INVALID_ID;
 	struct ip_set *s;
@@ -832,7 +832,7 @@ ip_set_get_byname(struct net *net, const char *name, struct ip_set **set)
 	rcu_read_lock();
 	for (i = 0; i < inst->ip_set_max; i++) {
 		s = rcu_dereference(inst->ip_set_list)[i];
-		if (s && STRNCMP(s->name, name)) {
+		if (s && nla_strcmp(name, s->name) == 0) {
 			__ip_set_get(s);
 			index = i;
 			*set = s;
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 5cc35b553a048..7d1ba6ad514f5 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -367,7 +367,7 @@ list_set_uadt(struct ip_set *set, struct nlattr *tb[],
 	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
-	e.id = ip_set_get_byname(map->net, nla_data(tb[IPSET_ATTR_NAME]), &s);
+	e.id = ip_set_get_byname(map->net, tb[IPSET_ATTR_NAME], &s);
 	if (e.id == IPSET_INVALID_ID)
 		return -IPSET_ERR_NAME;
 	/* "Loop detection" */
@@ -389,7 +389,7 @@ list_set_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_NAMEREF]) {
 		e.refid = ip_set_get_byname(map->net,
-					    nla_data(tb[IPSET_ATTR_NAMEREF]),
+					    tb[IPSET_ATTR_NAMEREF],
 					    &s);
 		if (e.refid == IPSET_INVALID_ID) {
 			ret = -IPSET_ERR_NAMEREF;
-- 
2.53.0



