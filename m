Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0103C0B;
	Tue, 11 Mar 2025 15:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707348; cv=none; b=LR6bqIwep9WDhVUf5OHlNFNNL9OUzyybCksL9JHqecliErf11vzh3LrcJ3HVdoB+i6mrFmf/N13NBZxxVVyCfkjwt0twhANl+3he9oI6aH3G0i8tBpD8Rr4bZ43mpkUVQUMH8beX5Iq77wZ2x5bhvsTmYyh1MfyR111iNN78d5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707348; c=relaxed/simple;
	bh=crVPTwOdY0c3tMc6Vd7JPvZlnMaKjLZw4z5v0ui+iAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHnGceAfpWNb6iJO0z9RTYBEauYS/DrrDqem1V2+QJvtAvmTQ1Wi57Uf8xcspr2NMN2IYdODRv9yhVk0UjIhXwnYLL9oMK2qHw8VoOe4x1tEs9az/Iq9pwedBvoGMu1zrZavFb+JL61n3OOh1drwjDZ5EUYUiKYScjakqgNKiVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qE1rIOie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qE1rIOie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6B1C4CEE9;
	Tue, 11 Mar 2025 15:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707348;
	bh=crVPTwOdY0c3tMc6Vd7JPvZlnMaKjLZw4z5v0ui+iAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qE1rIOie1EMLg33NaBjGSqLK+NMiI608baVacQU/pRageUvxV7j6rI/FWNVnJeOgl
	 3ZZ9Adxc3VxHf+wnvUD8rtc6sCRoOD7olFnzgTfqM4xgjzzncTc75++/ZcSbq4KM/H
	 DmWLb7WDQuHPq/dXhY8XlRowR3QydGcraqnMyuh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philo Lu <lulie@linux.alibaba.com>,
	Julian Anastasov <ja@ssi.bg>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 359/462] ipvs: Always clear ipvs_property flag in skb_scrub_packet()
Date: Tue, 11 Mar 2025 16:00:25 +0100
Message-ID: <20250311145812.537082605@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 754dc70293109..297a2efd6322d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5361,11 +5361,11 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
 	skb->offload_fwd_mark = 0;
 	skb->offload_l3_fwd_mark = 0;
 #endif
+	ipvs_reset(skb);
 
 	if (!xnet)
 		return;
 
-	ipvs_reset(skb);
 	skb->mark = 0;
 	skb->tstamp = 0;
 }
-- 
2.39.5



