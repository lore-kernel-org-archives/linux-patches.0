Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C9951E45B;
	Wed, 30 Sep 2026 18:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793544; cv=none; b=F0be+qjRYR90RXx0PYKfkqU6g3v3Ei5o/mnvx2pab2jrjVWl2ObbIaperY9Cza/acDlCRlRq3BIIkuiN+lAuTVtv5ZePfEnwTRC3XRJb+4C8dgR1Dm1Q15t41FoofCfdjq+qg2UciFrjO2Y3clGKfYzpHbJaMHp9PvLzCDNfTWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793544; c=relaxed/simple;
	bh=Eq349EDp7eJmldWpzIMLb1UfXdRHvlasJ+K3QP0igFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZM5GbwsKMPzn2jzGlyEohbc4UT49d/JjxDg6fVWcr6txIZERlFkurzn54Lus4/A7HECMJ4sNgt25Eiz60uFSxwpqTY9WA59wyemacFoplt8UHHymOKJb25LIxtQZqaIcPFSL6MciigKMFx8VhtcY9U+X3ivKtQRcKFgsHxm99LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YnFyGgJE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YnFyGgJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948BB1F000FF;
	Wed, 30 Sep 2026 18:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793543;
	bh=RK5rvy6z408BN6dOlA0IlHMEMc7poI1CfspMRxVhJ6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YnFyGgJEe2TuW2XB7wmh2MfHiRxJPZW+OLFX8bCTA5CBuUDwxJLjXuKhMhCmJHuBf
	 BJIxXnXGHcdOcC1lS7fnFGmePBerdsWUpnjzMQA0vIZPCSe02vO85w9xNsWsbwqNFy
	 KKjwXhcX5anN3ILWlpO+sZx7aF3F9WzSAQrqCCY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.18 292/395] netfilter: nf_tables: skip expired catchall elements on insert and delete
Date: Wed, 30 Sep 2026 17:29:14 +0200
Message-ID: <20260930152346.994561464@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aohan Mei <henrymei@tencent.com>

commit 70194dc37670bd08e44b471389861cc01bd3a3c9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6886,11 +6886,14 @@ static int nft_setelem_catchall_insert(c
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
@@ -6983,11 +6986,14 @@ static int nft_setelem_catchall_deactiva
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


