Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3561CEAD6;
	Tue, 27 Aug 2024 14:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770565; cv=none; b=qIT15P6D953vo7SAfFO0E3nXw2Zh9oo7VxM0rsCyDI2zYDAQwoCb6L9A6z688qKa+AxffcbkavlyD8ZDv4n+f///Y3Is9jeCICU/d9wDqPxqy+1H7UXlZIKg8sFdTKB3YvR3/JhxwnFa9fwVJNEmfXxlCjwpp9EHJzauSnmoU18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770565; c=relaxed/simple;
	bh=tBkYPnzRVBbx4fTbc/9XzM2CSTH+rYdQ2xCfdYX5hks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMjlz87OmD7oFnLd/lJGF1OL671CpyMI9XkoBDPf11HEqIjv0jIUtMVKNhQNFNiTX6YZe0Ol0oKX9v7Yb7OlkU6P5Wx0AtsECnjk1Yx0GiO7pFJvlaNj9sUyf7SPRlzZXu15TLvPK3aIPvlCU5R4SwHtSl9H0sQ+swnaWNzp4dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxiKpjpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxiKpjpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B95C4FDF6;
	Tue, 27 Aug 2024 14:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770564;
	bh=tBkYPnzRVBbx4fTbc/9XzM2CSTH+rYdQ2xCfdYX5hks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxiKpjpKJ76thLNv4+jQEL++Pbs5W+2r0HjjTcED6s/kOlTMXzV1WjN8nxdeNXq3L
	 qYO7+Cr/VDeyl5rhVZzDXMGWUMzlylMZk+457tw6TOlNjf8cG+hoDJs9nZfMe+uGJg
	 hziCaGF4rXqYaOlEW451I2MZP7hCBbk3x2bJeeVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 267/341] udp: fix receiving fraglist GSO packets
Date: Tue, 27 Aug 2024 16:38:18 +0200
Message-ID: <20240827143853.563926943@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit b128ed5ab27330deeeaf51ea8bb69f1442a96f7f ]

When assembling fraglist GSO packets, udp4_gro_complete does not set
skb->csum_start, which makes the extra validation in __udp_gso_segment fail.

Fixes: 89add40066f9 ("net: drop bad gso csum_start and offset in virtio_net_hdr")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20240819150621.59833-1-nbd@nbd.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 9cb13a50011ef..f544016e6eb3f 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -279,7 +279,8 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 		return ERR_PTR(-EINVAL);
 
 	if (unlikely(skb_checksum_start(gso_skb) !=
-		     skb_transport_header(gso_skb)))
+		     skb_transport_header(gso_skb) &&
+		     !(skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST)))
 		return ERR_PTR(-EINVAL);
 
 	if (skb_gso_ok(gso_skb, features | NETIF_F_GSO_ROBUST)) {
-- 
2.43.0



