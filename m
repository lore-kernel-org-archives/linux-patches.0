Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C68517B505;
	Wed,  5 Mar 2025 18:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198061; cv=none; b=U2oRtuKXMZWX2UNSK0mUWh8j3u4TpYlK9VGI1Mz6ciTsCDMkqVz4WC123bKHufmBPxyjagOayEHKXU1AtAwdK5XadJhT1j0QuqYevnqtt4dC+iwpAH9pi/G1CCYx/pJYj8N4O6SEKcTI1irFf6b6/kfbwCm/i7WGJY2dd0z2Pjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198061; c=relaxed/simple;
	bh=oyPhUNP4e0ZP5G3YkKSzhlKEfIr6Es7PkkoLkEiiEh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KIirMTGK37elmXD3whmV8J1H+KK00soxE/CCTygiGYq8w5y0bMgcdb45OANyTfzsPb5nIKBpIIUq9J819T6xP2L9ad2AVTkJMy0lvV5cML1/OyGdqCCZpoqLhJAQy5rwyEaeQkIgLXHjcmP9DecOh7DCJpTlMVB/SAzMAML0tAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvqDxKwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvqDxKwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE38C4CED1;
	Wed,  5 Mar 2025 18:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198059;
	bh=oyPhUNP4e0ZP5G3YkKSzhlKEfIr6Es7PkkoLkEiiEh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvqDxKwFVhvzp/uHOWpHI7LeO/ae7TfQYqZs3rI5eNdnt0aiI5NUVHjrv+iRU8Bh1
	 Wt04IurGBW1jV3uQGvNUwQJjXqjAXLyh9JeNnQxwCE+/345m4hRrmN+8nfr65PO3JA
	 SXu5f7wh/ryALQFCLC+yEM4Gt+eZsjruy4JJEwN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philo Lu <lulie@linux.alibaba.com>,
	Julian Anastasov <ja@ssi.bg>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/150] ipvs: Always clear ipvs_property flag in skb_scrub_packet()
Date: Wed,  5 Mar 2025 18:47:52 +0100
Message-ID: <20250305174505.552763835@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philo Lu <lulie@linux.alibaba.com>

[ Upstream commit de2c211868b9424f9aa9b3432c4430825bafb41b ]

We found an issue when using bpf_redirect with ipvs NAT mode after
commit ff70202b2d1a ("dev_forward_skb: do not scrub skb mark within
the same name space"). Particularly, we use bpf_redirect to return
the skb directly back to the netif it comes from, i.e., xnet is
false in skb_scrub_packet(), and then ipvs_property is preserved
and SNAT is skipped in the rx path.

ipvs_property has been already cleared when netns is changed in
commit 2b5ec1a5f973 ("netfilter/ipvs: clear ipvs_property flag when
SKB net namespace changed"). This patch just clears it in spite of
netns.

Fixes: 2b5ec1a5f973 ("netfilter/ipvs: clear ipvs_property flag when SKB net namespace changed")
Signed-off-by: Philo Lu <lulie@linux.alibaba.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Link: https://patch.msgid.link/20250222033518.126087-1-lulie@linux.alibaba.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 61a950f13a91c..f220306731dac 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6127,11 +6127,11 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
 	skb->offload_fwd_mark = 0;
 	skb->offload_l3_fwd_mark = 0;
 #endif
+	ipvs_reset(skb);
 
 	if (!xnet)
 		return;
 
-	ipvs_reset(skb);
 	skb->mark = 0;
 	skb_clear_tstamp(skb);
 }
-- 
2.39.5



