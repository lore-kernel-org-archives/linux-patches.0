Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF121514F6;
	Mon,  6 Jan 2025 15:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178226; cv=none; b=Sjh20QDSKYEAw7oHhooCcqJPAmSd8aXjDtUyHC98ZPaaRF4rin1Bj6VDmpc37yJ2m7qXqcDvjpd/z83lLkmwlR1TG1Ea95gnga68awbC9BdHJ/fVCusTCiTGMGnoSSc1PJ5MHbMMeCwTDGfqRvOod/OialNNULCTvx1xBczIBVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178226; c=relaxed/simple;
	bh=tDvckh5ptd/CzVXwzS4ByGFqPEWwN3eF16+K9J3HiuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SD6KuQp1HHu+1bi1QEna9Z1Vy2U73eIOGiMH0gahhgrfYxT4uFy7Q6zRVddnIj8AfPbB6I5oKD3iojLIZisXJkTse+tk4xkXEB7Nni9M+dquaQSrosfOQcTjrNXpSXSWiwMlsAyxW655eKatjY792qWWKrl6vNzWwbXMhVtpAwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQMZ6AQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQMZ6AQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A3EC4CED6;
	Mon,  6 Jan 2025 15:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178226;
	bh=tDvckh5ptd/CzVXwzS4ByGFqPEWwN3eF16+K9J3HiuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQMZ6AQqiQwyosbrI8cvCWpTioSGR3+tBT6i7hplhXaY41FOio1MqiTB5i8VLKiYJ
	 Lt/jJ7B/opS648G156ZvvxnG7BLfxyTEmnx74LZrvV54FTsOQUkjKqqo6k6RvMndHL
	 grhfW3adbhyUFpNheo7XL576wnwtaR6WMY5cpsZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <cong.wang@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/138] bpf: Check negative offsets in __bpf_skb_min_len()
Date: Mon,  6 Jan 2025 16:16:11 +0100
Message-ID: <20250106151135.018737467@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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
index 0b61575df86e..b80203274d3f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3710,13 +3710,22 @@ static const struct bpf_func_proto bpf_skb_adjust_room_proto = {
 
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



