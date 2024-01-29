Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D564B7404E;
	Mon, 29 Jan 2024 17:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548568; cv=none; b=LyOr0LZCdDvC1QKphwqdHADzqHEopf8ytan7F1ajL3Kwov0k6Zl+9POApE3mSvxjo/DLYF3TyGzwexqIad4mnhnrSSzcSoourBaJTZaL+JYmpe8cjBMRevl2GKjwPn+4D6FQ/Y+SUusn1E7MXmFpdSTXVp6CXINYNwuDl2NpIgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548568; c=relaxed/simple;
	bh=Bt+rHsc3uaFTytD9bcQCzUZ5MG1DEoGLqqPE1TcrpLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHQAuVR282rFqTv1I++wYubK1L9HwM1/Vu5xLN8tRXILCo/sbBjPDRC2ow4kxLyPTj7TghYe8EnhzEl6DWjd5KZj/6JXWTQQlt0JPpY6xq/2J+Hc9D8KepAHvU1bZSOoLWFWiMTvgfZmoHjNej9gjFlgKFxbKTZSjWf0ktbGYow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GW0H9+91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GW0H9+91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F95AC433C7;
	Mon, 29 Jan 2024 17:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548568;
	bh=Bt+rHsc3uaFTytD9bcQCzUZ5MG1DEoGLqqPE1TcrpLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GW0H9+91dj8q4oU0aJwpSsK9ec1Jq3EhP1Aiomid8cwaKsCOrM/w0W+TdlmuQEiS6
	 iFwEFQ71Pl/8AOmhhwX2+BYs1vuMXbIKNTbTDb7tjEewqlpsK+zoxMx3/V+/lslBbh
	 cYyw2DU54dZkWjQbukBdH7NAqM305rcrI6cq9RWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tirthendu Sarkar <tirthendu.sarkar@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/331] i40e: handle multi-buffer packets that are shrunk by xdp prog
Date: Mon, 29 Jan 2024 09:04:42 -0800
Message-ID: <20240129170021.257261865@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>

[ Upstream commit 83014323c642b8faa2d64a5f303b41c019322478 ]

XDP programs can shrink packets by calling the bpf_xdp_adjust_tail()
helper function. For multi-buffer packets this may lead to reduction of
frag count stored in skb_shared_info area of the xdp_buff struct. This
results in issues with the current handling of XDP_PASS and XDP_DROP
cases.

For XDP_PASS, currently skb is being built using frag count of
xdp_buffer before it was processed by XDP prog and thus will result in
an inconsistent skb when frag count gets reduced by XDP prog. To fix
this, get correct frag count while building the skb instead of using
pre-obtained frag count.

For XDP_DROP, current page recycling logic will not reuse the page but
instead will adjust the pagecnt_bias so that the page can be freed. This
again results in inconsistent behavior as the page refcnt has already
been changed by the helper while freeing the frag(s) as part of
shrinking the packet. To fix this, only adjust pagecnt_bias for buffers
that are stillpart of the packet post-xdp prog run.

Fixes: e213ced19bef ("i40e: add support for XDP multi-buffer Rx")
Reported-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
Link: https://lore.kernel.org/r/20240124191602.566724-6-maciej.fijalkowski@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 40 ++++++++++++---------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index b047c587629b..2e5546e549d9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2100,7 +2100,8 @@ static void i40e_put_rx_buffer(struct i40e_ring *rx_ring,
 static void i40e_process_rx_buffs(struct i40e_ring *rx_ring, int xdp_res,
 				  struct xdp_buff *xdp)
 {
-	u32 next = rx_ring->next_to_clean;
+	u32 nr_frags = xdp_get_shared_info_from_buff(xdp)->nr_frags;
+	u32 next = rx_ring->next_to_clean, i = 0;
 	struct i40e_rx_buffer *rx_buffer;
 
 	xdp->flags = 0;
@@ -2113,10 +2114,10 @@ static void i40e_process_rx_buffs(struct i40e_ring *rx_ring, int xdp_res,
 		if (!rx_buffer->page)
 			continue;
 
-		if (xdp_res == I40E_XDP_CONSUMED)
-			rx_buffer->pagecnt_bias++;
-		else
+		if (xdp_res != I40E_XDP_CONSUMED)
 			i40e_rx_buffer_flip(rx_buffer, xdp->frame_sz);
+		else if (i++ <= nr_frags)
+			rx_buffer->pagecnt_bias++;
 
 		/* EOP buffer will be put in i40e_clean_rx_irq() */
 		if (next == rx_ring->next_to_process)
@@ -2130,20 +2131,20 @@ static void i40e_process_rx_buffs(struct i40e_ring *rx_ring, int xdp_res,
  * i40e_construct_skb - Allocate skb and populate it
  * @rx_ring: rx descriptor ring to transact packets on
  * @xdp: xdp_buff pointing to the data
- * @nr_frags: number of buffers for the packet
  *
  * This function allocates an skb.  It then populates it with the page
  * data from the current receive descriptor, taking care to set up the
  * skb correctly.
  */
 static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
-					  struct xdp_buff *xdp,
-					  u32 nr_frags)
+					  struct xdp_buff *xdp)
 {
 	unsigned int size = xdp->data_end - xdp->data;
 	struct i40e_rx_buffer *rx_buffer;
+	struct skb_shared_info *sinfo;
 	unsigned int headlen;
 	struct sk_buff *skb;
+	u32 nr_frags = 0;
 
 	/* prefetch first cache line of first page */
 	net_prefetch(xdp->data);
@@ -2181,6 +2182,10 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
 	memcpy(__skb_put(skb, headlen), xdp->data,
 	       ALIGN(headlen, sizeof(long)));
 
+	if (unlikely(xdp_buff_has_frags(xdp))) {
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		nr_frags = sinfo->nr_frags;
+	}
 	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
 	/* update all of the pointers */
 	size -= headlen;
@@ -2200,9 +2205,8 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
 	}
 
 	if (unlikely(xdp_buff_has_frags(xdp))) {
-		struct skb_shared_info *sinfo, *skinfo = skb_shinfo(skb);
+		struct skb_shared_info *skinfo = skb_shinfo(skb);
 
-		sinfo = xdp_get_shared_info_from_buff(xdp);
 		memcpy(&skinfo->frags[skinfo->nr_frags], &sinfo->frags[0],
 		       sizeof(skb_frag_t) * nr_frags);
 
@@ -2225,17 +2229,17 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
  * i40e_build_skb - Build skb around an existing buffer
  * @rx_ring: Rx descriptor ring to transact packets on
  * @xdp: xdp_buff pointing to the data
- * @nr_frags: number of buffers for the packet
  *
  * This function builds an skb around an existing Rx buffer, taking care
  * to set up the skb correctly and avoid any memcpy overhead.
  */
 static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
-				      struct xdp_buff *xdp,
-				      u32 nr_frags)
+				      struct xdp_buff *xdp)
 {
 	unsigned int metasize = xdp->data - xdp->data_meta;
+	struct skb_shared_info *sinfo;
 	struct sk_buff *skb;
+	u32 nr_frags;
 
 	/* Prefetch first cache line of first page. If xdp->data_meta
 	 * is unused, this points exactly as xdp->data, otherwise we
@@ -2244,6 +2248,11 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
 	 */
 	net_prefetch(xdp->data_meta);
 
+	if (unlikely(xdp_buff_has_frags(xdp))) {
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		nr_frags = sinfo->nr_frags;
+	}
+
 	/* build an skb around the page buffer */
 	skb = napi_build_skb(xdp->data_hard_start, xdp->frame_sz);
 	if (unlikely(!skb))
@@ -2256,9 +2265,6 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
 		skb_metadata_set(skb, metasize);
 
 	if (unlikely(xdp_buff_has_frags(xdp))) {
-		struct skb_shared_info *sinfo;
-
-		sinfo = xdp_get_shared_info_from_buff(xdp);
 		xdp_update_skb_shared_info(skb, nr_frags,
 					   sinfo->xdp_frags_size,
 					   nr_frags * xdp->frame_sz,
@@ -2603,9 +2609,9 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 			total_rx_bytes += size;
 		} else {
 			if (ring_uses_build_skb(rx_ring))
-				skb = i40e_build_skb(rx_ring, xdp, nfrags);
+				skb = i40e_build_skb(rx_ring, xdp);
 			else
-				skb = i40e_construct_skb(rx_ring, xdp, nfrags);
+				skb = i40e_construct_skb(rx_ring, xdp);
 
 			/* drop if we failed to retrieve a buffer */
 			if (!skb) {
-- 
2.43.0



