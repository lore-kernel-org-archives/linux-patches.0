Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210715;
	b=K0dsT1WHOMxIIdzem/YOMP9L7KGkIRk3lKW0gDe7dmGplhysmjBo+UuRv+iRJSdKwCbU
	 Idj79BIPqdcnPLyZsYRAmA5RDbbmHWY3HGJ9lHJAJ8o1vybg2rFkJ6V248aIuvCLyKCsy
	 RtfiNorfOb3UQcwVGWxCthniy86ZtPG1dVSlOQ4U/MpcsC214sgDUHAMk3RE1EcfuNC3e
	 a/IiS7syCo55xc8tQONOYTC//NeX63elRpcevwEZ0YIFEjThVOUSvTa6OWRW/Yt3swob8
	 RkMJsa6xjOzGdhZpbUZVrWm6O6Vvwdq0lJrXu9XcwP24KP5JCocRThed9Yd+7HgjRBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zg716/JYqgJZx//wkJGcLiakVLDIE3IWJqUn2fw5R7g=;
	b=rEK0GmtsgRWwbs0c3ktnzLn2rRZEBsXkgGLm+ourb7zDMCdCiOf7exUXuGh5NiwdYxJn
	 7Mb/zACEP0jOCVyewfXvd53ULGKS7zhcNYZqlZV7Kj5KnWxlg23tvkCFA+cAnxXUfoEFq
	 6+KlODWkLA+PLciagcS0cjGoVxfkq/Sr6cT7+HzAbCZb2JnluqKnOkAXi9AIaPbziS6fV
	 MPQ9YqWPbCey0fyppXgmq1x14mqMHBcL95cldKCqp4ihr1DA9NTjiY9XaTtavim6oXlR0
	 imAJXVrwYzlx9F39Ed2d6kMY/BRjBWovW9lTTYON4/GArJHX4cCXZBesh+iXminRQww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BkuQOR4O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EA9606A31C;
	Wed, 28 Oct 2026 18:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BkuQOR4O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9F11F01825;
	Wed, 28 Oct 2026 18:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210715;
	bh=Zg716/JYqgJZx//wkJGcLiakVLDIE3IWJqUn2fw5R7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BkuQOR4Okfc45bSTTXJIt7YQq8TliiTpHqmtrLEEdjx53271LA3ioT6E+v2rlEkwE
	 tb+9DBieGEmpakFY0ReIn9J9oJp7kzZjQ+8YFrMpuCCVx6qhT7hovYYmiwgSfE1b/n
	 5cgkGOURdUuePm9y5+NGdA02g88uhlguhxnbFrA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/571] netfilter: nf_tables: skip expired catchall elements on insert and delete
Date: Wed, 28 Oct 2026 17:54:28 +0100
Message-ID: <20261028170010.889689462@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aohan Mei <henrymei@tencent.com>

[ Upstream commit 70194dc37670bd08e44b471389861cc01bd3a3c9 ]

nft_setelem_catchall_insert() looks up duplicates with
nft_set_elem_active() only, while nft_set_catchall_lookup() and the
dump path additionally skip expired elements.

Once a catchall element with a timeout expires, this predicate drift
makes it invisible to userspace dumps, yet it still blocks
re-insertion: with NLM_F_EXCL the request fails with -EEXIST, and
without it the request reports success but silently inserts nothing.
The stale entry only goes away when the (user-tunable) gc interval
elapses, so the catchall rule may silently stop matching for an
arbitrarily long time after its first expiration.

The delete path shows the same drift: nft_setelem_catchall_deactivate()
picks the first active-next entry in the catchall list, so with an
expired entry still pending GC it retires the stale entry instead of
the fresh one, and it deactivates an element that userspace no longer
sees instead of failing with -ENOENT.

Align both walks with the lookup and dump predicates: only an element
that is active and not expired counts as a duplicate or delete
candidate, using the per-netns timestamp taken at transaction start,
in line with the set backend .insert/.deactivate and catchall GC sync
paths.

Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 91b1bcaf7facf..90048faccf2a3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6079,11 +6079,14 @@ static int nft_setelem_catchall_insert(const struct net *net,
 {
 	struct nft_set_elem_catchall *catchall;
 	u8 genmask = nft_genmask_next(net);
+	u64 tstamp = nft_net_tstamp(net);
 	struct nft_set_ext *ext;
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (nft_set_elem_active(ext, genmask)) {
+		if (nft_set_elem_active(ext, genmask) &&
+		    !__nft_set_elem_expired(ext, tstamp) &&
+		    !nft_set_elem_is_dead(ext)) {
 			*priv = catchall->elem;
 			return -EEXIST;
 		}
@@ -6144,11 +6147,14 @@ static int nft_setelem_catchall_deactivate(const struct net *net,
 					   struct nft_set_elem *elem)
 {
 	struct nft_set_elem_catchall *catchall;
+	u64 tstamp = nft_net_tstamp(net);
 	struct nft_set_ext *ext;
 
 	list_for_each_entry(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (!nft_is_active_next(net, ext))
+		if (!nft_is_active_next(net, ext) ||
+		    __nft_set_elem_expired(ext, tstamp) ||
+		    nft_set_elem_is_dead(ext))
 			continue;
 
 		kfree(elem->priv);
-- 
2.53.0



