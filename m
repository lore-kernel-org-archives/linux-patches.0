Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6869F15E8B;
	Mon, 30 Dec 2024 15:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573521; cv=none; b=kaDSYx6oKIbrIwyrRw7bDPJ0A7B0H9BHSYcXwkr4E/xAvYi+3o4HcvSzZJxPCgUoQN/giruTTRQt8YBuYVcfavOuZdjRFatxmmN/XppGgyzwcD4/gw5EN8rHsyAyY0u9s9izgtYSweeB5qzOO8WQrG+p3Vo3qrgVADfIU3QGf0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573521; c=relaxed/simple;
	bh=nr1BhGzAfk3tUDHECv2PRX+6hi5fAtcZ2iOMmNy0yIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vvil/EyF8KV/7kHto4v1VkdknSr8me52GCLprX1UThHaCazKQwIWbvtivIo7lHuFuXiBndNle2qJCcYxzqYipk8CdEbYF167tLPEiGaSyeyXkGhZmuT+cdStRDxheDps5szPUGwGsg7MD//KkZvaio8qFQ9sqDRcPAJQDYxSM40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYlogBRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYlogBRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89D8C4CED0;
	Mon, 30 Dec 2024 15:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573521;
	bh=nr1BhGzAfk3tUDHECv2PRX+6hi5fAtcZ2iOMmNy0yIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYlogBRD9Mbq8/EpPKOlvhJMtgmH7QUNMD5nkYR+mpuyHqNwW4ioXYXC42iHV++Ut
	 C5k8JBmzVqKGA/sDUYi55kM3FwM4YH3Ld23/9gV9DT+ipKtGFwr+F0t+1LUjRvEtaX
	 wkrN4EjoeryyEr3eZBEC1Ul98RjQhaEFdqvFHSS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <cong.wang@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 05/60] bpf: Check negative offsets in __bpf_skb_min_len()
Date: Mon, 30 Dec 2024 16:42:15 +0100
Message-ID: <20241230154207.485534736@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 34cefd85aaf6..cf87e29a5e8f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3695,13 +3695,22 @@ static const struct bpf_func_proto bpf_skb_adjust_room_proto = {
 
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



