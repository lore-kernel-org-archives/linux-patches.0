Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DDDBA34;
	Mon,  6 Jan 2025 15:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179124; cv=none; b=LWCkw0XjpxqGvD9uvZbIZIhDyo8ntqihTUsg6nsq17OHlrr0k+9UgnGG4mhLS0MGWNjOKLBtHfcvPmPYDPmtB941lt7IsLUtB8AI7vHSEFv9nfpeJOdvZ4WWxPR0UPP2O8tQ42PD2mSUw0hIdRqwWM8zBIzvs6KhFTEt1p3VZMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179124; c=relaxed/simple;
	bh=A44yEl0d7Hs5p+wiYrwjEzirTRDslHQuqEd8xDvqBLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmjUDYFjXMwWNtTXAQSnjaaaPfTgOx8y99R7t6IV8+8kh4S0BfTf+3FhS7UU96VWPYgfBUoun7JSNe/6LdLHX4L+UV6hfeO7+Y7gL2meSs4t3E+AYhiKJvZ/sxafEMki3TbYLE49SLgdeN2sUV4mznh4ZiurEyzQA6IwuVxNmP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJGg0ggK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJGg0ggK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1CCC4CED2;
	Mon,  6 Jan 2025 15:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179124;
	bh=A44yEl0d7Hs5p+wiYrwjEzirTRDslHQuqEd8xDvqBLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJGg0ggK6INuWdDF5l6N8cu6lpcwGrTOU+clsv3T7HZ26UkLHyS9ar7T/jJTLSShh
	 gz1Em0z/6ElZCUgbEbm5SEaxNPhnBK32lbQCc9hUdQOr1MXveEwRyT0mViVZevwjQz
	 srJKTIlCpWDWEaNs+9fSCb2t/knUuJX1HhEUNcm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <cong.wang@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 34/93] bpf: Check negative offsets in __bpf_skb_min_len()
Date: Mon,  6 Jan 2025 16:17:10 +0100
Message-ID: <20250106151129.990746372@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 net/core/filter.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 9f67d9f20ae0..6ba1121a9f34 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3252,13 +3252,22 @@ static const struct bpf_func_proto bpf_skb_adjust_room_proto = {
 
 static u32 __bpf_skb_min_len(const struct sk_buff *skb)
 {
-	u32 min_len = skb_network_offset(skb);
-
-	if (skb_transport_header_was_set(skb))
-		min_len = skb_transport_offset(skb);
-	if (skb->ip_summed == CHECKSUM_PARTIAL)
-		min_len = skb_checksum_start_offset(skb) +
-			  skb->csum_offset + sizeof(__sum16);
+	int offset = skb_network_offset(skb);
+	u32 min_len = 0;
+
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



