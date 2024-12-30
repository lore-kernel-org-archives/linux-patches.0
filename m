Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1337015E8B;
	Mon, 30 Dec 2024 15:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574006; cv=none; b=FAk5D6WhEa/CFReV1Rmj0iyvYgMytxoVA2Kmm9wsopKOO8SQOeFSHpoO2VQRV6CFTbSdhFQQ/XnaZ9dWIaKAztd5SHHTgiQ3BzqOXQgFltDEoOszSpl8tEOtiFlWgRqH9mOsn+NybZYLlfnVUziZln/treDiNbzV4HP9NZ/hnTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574006; c=relaxed/simple;
	bh=iOJm096VGkPwolyqK2rw134RM1Hybi5f6LXed2GphLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMW7S0jtPRCggZ+sLMGYS0dr87Kzza3rsbJL9FGYg3/GITXBXJmOJ/Y3dooBOQwnlFaX4ApWsmJnmbtHpB5aBDRQ0p1KE4JWtDQxgNaTIlgwiccKriowsAQLWkMYX9c+7EdXC8qSblWthVVdiAKPkVs5mlaiYu2XYzZ6e1rVTxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tj/LKtQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tj/LKtQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901F4C4CED0;
	Mon, 30 Dec 2024 15:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574006;
	bh=iOJm096VGkPwolyqK2rw134RM1Hybi5f6LXed2GphLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tj/LKtQXGINiV4Wcywl3/7h78Lkw5Jd2W22q0JXxnUf7WPar0owJMR8sbV+w63SoK
	 lIVBSfVdfH2YOiYaiPdsnzzOzOVWKPamZlWVYr+LLnNbNZb8MpdSQLEFReihBuZsNF
	 e7wZQJrGrMCX2Etn+hrAu192//rS94br+pcDAWLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <cong.wang@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/114] bpf: Check negative offsets in __bpf_skb_min_len()
Date: Mon, 30 Dec 2024 16:42:09 +0100
Message-ID: <20241230154218.531064005@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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
index 9a459213d283..55495063621d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3751,13 +3751,22 @@ static const struct bpf_func_proto bpf_skb_adjust_room_proto = {
 
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



