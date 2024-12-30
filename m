Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DB815E8B;
	Mon, 30 Dec 2024 15:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573785; cv=none; b=rY4nHKR9JUZpv+FgfeJ/eBFFzbfNqBuMhC4Mn6y6L8fk1+e7TImCW/21Tt3HxwSXAMVl3oAHNMFifp3KL5Mvjpnd2IruCxsKhvQFIkyqK+Ser4quUzUXg1N0tB73A+XrIrkBq6z7Ps8A81865Rm15fi1VmK++sZ5WfDyuamWxac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573785; c=relaxed/simple;
	bh=QUETmkJkJh9/gyMWjwNK6k2HdH8ymU4B3Y8OaCP9JCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwOe9UUmBAR84xruPiU3CzZOzf2wy2sNVkkJJlA1B0+gAcV/Wa0wVKLdZglXBu1GjyPLAYzOrMRNx9qY2X/50mz8PCdbxMoc+gC//D1kJL6Yc3NBqUKeISeNLIMCY2ME2Bs+nI1lhkfKHwO4R2Pc3/iVfbItl7xaMs3le7cSDT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJKtKWOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJKtKWOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169ECC4CED0;
	Mon, 30 Dec 2024 15:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573785;
	bh=QUETmkJkJh9/gyMWjwNK6k2HdH8ymU4B3Y8OaCP9JCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJKtKWOWpoXvvSgPrND2Tv92OliEWwPtgDRStngOpNamu2rY9M3ulrQ9fxUaOaY/O
	 9J0Y4zhO6swCV1wYpnQvHn/tpSicjbwEGfYjj6QL2MbquDmKQJQ5HJvzzz5bE/x5pq
	 ATLDOOvy1OhEaF7YCDBck8/uMY93OQnOWh4oKmsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <cong.wang@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 08/86] bpf: Check negative offsets in __bpf_skb_min_len()
Date: Mon, 30 Dec 2024 16:42:16 +0100
Message-ID: <20241230154212.032708953@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 9ecc4d858b92c1bb0673ad9c327298e600c55659 ]

skb_network_offset() and skb_transport_offset() can be negative when
they are called after we pull the transport header, for example, when
we use eBPF sockmap at the point of ->sk_data_ready().

__bpf_skb_min_len() uses an unsigned int to get these offsets, this
leads to a very large number which then causes bpf_skb_change_tail()
failed unexpectedly.

Fix this by using a signed int to get these offsets and ensure the
minimum is at least zero.

Fixes: 5293efe62df8 ("bpf: add bpf_skb_change_tail helper")
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20241213034057.246437-2-xiyou.wangcong@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index bc52ab3374f3..34320ce70096 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3731,13 +3731,22 @@ static const struct bpf_func_proto bpf_skb_adjust_room_proto = {
 
 static u32 __bpf_skb_min_len(const struct sk_buff *skb)
 {
-	u32 min_len = skb_network_offset(skb);
+	int offset = skb_network_offset(skb);
+	u32 min_len = 0;
 
-	if (skb_transport_header_was_set(skb))
-		min_len = skb_transport_offset(skb);
-	if (skb->ip_summed == CHECKSUM_PARTIAL)
-		min_len = skb_checksum_start_offset(skb) +
-			  skb->csum_offset + sizeof(__sum16);
+	if (offset > 0)
+		min_len = offset;
+	if (skb_transport_header_was_set(skb)) {
+		offset = skb_transport_offset(skb);
+		if (offset > 0)
+			min_len = offset;
+	}
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		offset = skb_checksum_start_offset(skb) +
+			 skb->csum_offset + sizeof(__sum16);
+		if (offset > 0)
+			min_len = offset;
+	}
 	return min_len;
 }
 
-- 
2.39.5



