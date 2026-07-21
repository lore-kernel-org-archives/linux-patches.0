Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7108F3BE156;
	Tue, 21 Jul 2026 21:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669519; cv=none; b=mRJVFuVLPh6+5xGrpQZDkgTqXXGpWC9elAB+AgnHDZ+3wVCe2VNYU9ro456jkVtqLJeuQxgmtbHzIlPlylAUatoUU7OU/Wa5p4CTEOS7dA3TkH/g4H8noslvLB3FN2n4XjKvPyKn6hjmIScmY6TyWDvEDji6USK2bQPsR0u1Q0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669519; c=relaxed/simple;
	bh=P0nm/zqd9tHbFY01y4iOgWpVKyTBvpSZYFfNxOjMNXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3z722+sABSyUUywKDZaQ2zvBB0gEn5XJomK5NLGAqa/JrSRb5/nj9/OI1zNM5q1qqbLg6I+rf3jnmE5wgDX9e9zuZC0Yr9F2NGXXW2YOOb2bDjPR9VpfIZCOpejnfr+yuC+AxARH9NlUFazdiAWUP/UinchcJa+ISkKUNk/dtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkzGwIJT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkzGwIJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FDE1F000E9;
	Tue, 21 Jul 2026 21:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669517;
	bh=Zf1T5sXK8ShM3SjO4rSrimsVnvQ80C+u6ToIV1NBL/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GkzGwIJT1SslzllmB3f+tP92Gsn7JZZow4GVJpQEVUzdY2ECOO+Fw2Jv0TZPHmMAJ
	 nijhWZiUwJ3u1wGg9tfOmpw3+biijC42dbuJ84T96Vtvj++t749NgK9d85lNJ5mczZ
	 aWd9a1u+c+9XPvuXbTCEVh5ttw0zh99DzNMZKEWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0585/1067] virtio-net: fix len check in receive_big()
Date: Tue, 21 Jul 2026 17:19:46 +0200
Message-ID: <20260721152437.692197004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 9e5ad06ea826322ce8c58b4a68442a96f600c3c4 ]

receive_big() bounds the device-announced length by
(big_packets_num_skbfrags + 1) * PAGE_SIZE.  That is still too loose:
add_recvbuf_big() sets sg[1] to start at offset
sizeof(struct padded_vnet_hdr) into the first page, so the chain
actually carries hdr_len + (PAGE_SIZE - sizeof(padded_vnet_hdr)) +
big_packets_num_skbfrags * PAGE_SIZE bytes -- 20 bytes less than the
check allows for the common hdr_len == 12 case.

A malicious virtio backend can announce a len in that gap.  page_to_skb()
then walks one frag past the page chain, storing a NULL page->private
into skb_shinfo()->frags[MAX_SKB_FRAGS], which is both an out-of-bounds
write past the static frag array and a NULL frag handed up the rx path.

Bound len by the size add_recvbuf_big() actually advertised.

Fixes: 0c716703965f ("virtio-net: fix received length check in big packets")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Bui Quang Minh <minhquangbui99@gmail.com>
Link: https://patch.msgid.link/20260616042837.2249468-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2fb00df795d4ab..9bbb26efb82573 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -945,15 +945,18 @@ static struct sk_buff *receive_big(struct net_device *dev,
 				   struct virtnet_rq_stats *stats)
 {
 	struct page *page = buf;
+	unsigned long max_len;
 	struct sk_buff *skb;
 
+	max_len = (vi->big_packets_num_skbfrags + 1) * PAGE_SIZE -
+		  sizeof(struct padded_vnet_hdr) + vi->hdr_len;
+
 	/* Make sure that len does not exceed the size allocated in
 	 * add_recvbuf_big.
 	 */
-	if (unlikely(len > (vi->big_packets_num_skbfrags + 1) * PAGE_SIZE)) {
+	if (unlikely(len > max_len)) {
 		pr_debug("%s: rx error: len %u exceeds allocated size %lu\n",
-			 dev->name, len,
-			 (vi->big_packets_num_skbfrags + 1) * PAGE_SIZE);
+			 dev->name, len, max_len);
 		goto err;
 	}
 
-- 
2.53.0



