Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E9B19E7DB;
	Tue, 16 Jul 2024 16:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146031; cv=none; b=OtramU00f2DkR2/4v4j+gTavyK3oqVjxu9J7ZHumx7wA7urXpU4WMLPM31ciyN/j3bi8ZGiPRuG+ddOwoh1JJM9UKJHQ6eIOodug/k0JD8imTq4asJHoX/Q3YKz81KLHoChBHtsWKI7hnRgI69P0okqnUmuQgPknvhRGc3JlgPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146031; c=relaxed/simple;
	bh=fMm2cW87j2ZXsGqhIG/bA6fzkucWiHTz+RH1udU3tjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGLdLu09UtfV4ZkHDLj0mRjKYtGZ7FNpBmzekODRw5gqiuWkamgnxFP8BSNm4lmmwRYhnKQmdOS6tLzL5yIKPTPka1d65m9WR4j2XAiax8XpivBsp9kSH2NI+UZ6PZxljMqh21jq+UOCED2sH7XzAu5upg+gm6zp60fZDmknLJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOeI/EE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOeI/EE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA768C4AF0B;
	Tue, 16 Jul 2024 16:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146031;
	bh=fMm2cW87j2ZXsGqhIG/bA6fzkucWiHTz+RH1udU3tjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOeI/EE9AF0+IcHlErF0JnmH02EUTfU+f53HsyQoe48OhBXOpiAo/V2CjeZZ7q+ji
	 8gMHRf2JDCMBzitNPmpeLOlJvZ8fipDSM+wLo92cGvPirSltZ/de2w0F5fmWvcTKKM
	 cHWkDNkXq2E6nQIXJjlOhKxSc4hpr1p8ahEwRwH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/144] net: allow skb_datagram_iter to be called from any context
Date: Tue, 16 Jul 2024 17:31:44 +0200
Message-ID: <20240716152753.892421938@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit d2d30a376d9cc94c6fb730c58b3e5b7426ecb6de ]

We only use the mapping in a single context, so kmap_local is sufficient
and cheaper. Make sure to use skb_frag_foreach_page as skb frags may
contain compound pages and we need to map page by page.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202406161539.b5ff7b20-oliver.sang@intel.com
Fixes: 950fcaecd5cc ("datagram: consolidate datagram copy to iter helpers")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Link: https://patch.msgid.link/20240626100008.831849-1-sagi@grimberg.me
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/datagram.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 1ff8241217a9c..6b7db06eafe68 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -440,15 +440,22 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 
 		end = start + skb_frag_size(frag);
 		if ((copy = end - offset) > 0) {
-			struct page *page = skb_frag_page(frag);
-			u8 *vaddr = kmap(page);
+			u32 p_off, p_len, copied;
+			struct page *p;
+			u8 *vaddr;
 
 			if (copy > len)
 				copy = len;
-			n = INDIRECT_CALL_1(cb, simple_copy_to_iter,
-					vaddr + skb_frag_off(frag) + offset - start,
-					copy, data, to);
-			kunmap(page);
+
+			skb_frag_foreach_page(frag,
+					      skb_frag_off(frag) + offset - start,
+					      copy, p, p_off, p_len, copied) {
+				vaddr = kmap_local_page(p);
+				n = INDIRECT_CALL_1(cb, simple_copy_to_iter,
+					vaddr + p_off, p_len, data, to);
+				kunmap_local(vaddr);
+			}
+
 			offset += n;
 			if (n != copy)
 				goto short_copy;
-- 
2.43.0



