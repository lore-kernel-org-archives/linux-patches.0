Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384381BBBFD;
	Mon, 10 Mar 2025 18:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630711; cv=none; b=fWNSkl0914VVOmfWGdOPMjrVnAInZspX03Mka3Yo3Hnl4iJQb+hhd7hB2UJdUDuc3MUzrXydbOJl+MSPRze13Ciu87iKcgwZFQq0bUak34V9FVPoZk1AMWU2hrglG+I0H7EgL9xd1P+5b4FeLDgu+engUtiXfbDQMrLBaWWeYCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630711; c=relaxed/simple;
	bh=q4sMQjdAQyi4+NJ6HtpZhyKadFZxu1R5CkKHQM6LSdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7Dw26g5Go5FMtt/fo1S7Fd5v7b08NLictrspZ03IDJclzciJ3wc4X0zioDPvtnBE5SMWt7GIOAuXyllDY08rGpIz/k+Vio/pKZs7ybAaEeWni8HbY5+Djttj9vxya5G35nLwK+MymdBRTgtUVO2iymruq27Jhy87KGWThETyUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cwjf24Jt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cwjf24Jt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2425C4CEED;
	Mon, 10 Mar 2025 18:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630711;
	bh=q4sMQjdAQyi4+NJ6HtpZhyKadFZxu1R5CkKHQM6LSdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cwjf24Jt+IYSNnBpFRmhpk0URvEEsd+jYgmahGVD4qu4zqutNea5rkrutDWK1xaYb
	 pO4LlaXdZyDDBwZ5qF2lqfQap5cvIlY+DUpkwIhIFUdFD/EijQDgFmxtSqugGoxkWV
	 n4UbL+D3UPjTe2nPkekzzcn5u9/zLgCDOQVQiPU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 508/620] include: net: add static inline dst_dev_overhead() to dst.h
Date: Mon, 10 Mar 2025 18:05:54 +0100
Message-ID: <20250310170605.610947999@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Iurman <justin.iurman@uliege.be>

[ Upstream commit 0600cf40e9b36fe17f9c9f04d4f9cef249eaa5e7 ]

Add static inline dst_dev_overhead() function to include/net/dst.h. This
helper function is used by ioam6_iptunnel, rpl_iptunnel and
seg6_iptunnel to get the dev's overhead based on a cache entry
(dst_entry). If the cache is empty, the default and generic value
skb->mac_len is returned. Otherwise, LL_RESERVED_SPACE() over dst's dev
is returned.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Cc: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: c64a0727f9b1 ("net: ipv6: fix dst ref loop on input in seg6 lwt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dst.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/net/dst.h b/include/net/dst.h
index 827f99d577331..bf0a9b0cc269c 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -433,6 +433,15 @@ static inline void dst_set_expires(struct dst_entry *dst, int timeout)
 		dst->expires = expires;
 }
 
+static inline unsigned int dst_dev_overhead(struct dst_entry *dst,
+					    struct sk_buff *skb)
+{
+	if (likely(dst))
+		return LL_RESERVED_SPACE(dst->dev);
+
+	return skb->mac_len;
+}
+
 INDIRECT_CALLABLE_DECLARE(int ip6_output(struct net *, struct sock *,
 					 struct sk_buff *));
 INDIRECT_CALLABLE_DECLARE(int ip_output(struct net *, struct sock *,
-- 
2.39.5



