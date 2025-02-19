Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2671DE3AF;
	Wed, 19 Feb 2025 08:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954399; cv=none; b=bQpQv+RRls9h8+bP4wZelFHVog862SnluiNx4ZxHgzsIYK7LK2kGy4M1WYeeNnrjjQlufTvCpVePqH8F6/e6OnJh2HVlehe9YuHx1sc5pa5qL/Q7NZbfNVEg3aPSNwktoAE2WLPDXSKaavvrbqhR+LT5H4SUbW4OjO9eyfZCd7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954399; c=relaxed/simple;
	bh=+usUyI6wykrAQ63WndMt6pLy3i6T5v/fU25ht01jX4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULvxHXFd94ZSRbB+G7nhPoF60h7sLKVgnDtiAQgplixKQ1gQSk8YHLUo8Nvq22/DpRF2XKEKYKGvup/o7DCJc4AiL3MMTfIxqYKEar13xaO5fkCmIedS0JzCXAZz6GEThn9BSvFFc1d2RpkWJvQELfo51qVjMUTEhvTbHBIe7d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrlceq7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrlceq7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECE3C4CED1;
	Wed, 19 Feb 2025 08:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954399;
	bh=+usUyI6wykrAQ63WndMt6pLy3i6T5v/fU25ht01jX4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrlceq7pRAXOR3c6+n+2YYZV/ksokgs9gUgWUcIuKIDbyF/c9iqT0cbw3SCB2yF6N
	 hNJMeIoTqPhsXTabhOzGFNuFxcQOxZk9eeVS62h+9wBumL0BnZ/9ZvBBwEpibSL55S
	 hbugoZ1AH3nckS6UJIgNLRry/9HYNutFBBRHE7mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 192/274] include: net: add static inline dst_dev_overhead() to dst.h
Date: Wed, 19 Feb 2025 09:27:26 +0100
Message-ID: <20250219082617.097076049@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 92191dd10730 ("net: ipv6: fix dst ref loops in rpl, seg6 and ioam6 lwtunnels")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dst.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/net/dst.h b/include/net/dst.h
index 0f303cc602520..08647c99d79c9 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -440,6 +440,15 @@ static inline void dst_set_expires(struct dst_entry *dst, int timeout)
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



