Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5858E155A2F;
	Wed,  5 Mar 2025 18:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197627; cv=none; b=Z0j2gNX3ERmIXnLQ9ET95bZjuCf2wkIXrt3i1PUq/7wswgdfVDgPUTwmPixK3y9u1WbU9GZkthpUupUAM9LKyr2sAkfua5YrEk96A7E0pQYb0FD/mVxAglCGJQklWDUrwy0oHM9+WAej6YcorJFj/wXvn1YygnxDlqfRmJEvqDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197627; c=relaxed/simple;
	bh=6ersQOe7jzVkDGycgW0WYIrqZ6RSpgwMXDa65dndJUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEqseolbpcUdGLeVSt0VYoM0bhH/ewj+PUkkweXenTlCI/NV3f1BfFjJ6Gus74gTcgZuA5KH2G+eVMYOVy8IZMbcqS2xlk+0LiMtDA6pBKQaAGWPOp3JEOHWeoqxWcoVWaxk+Uw0rqhzXrcKKCrtBMDzj1NAtepEH7k72lY4ZNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PviVZ4cf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PviVZ4cf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D360FC4CED1;
	Wed,  5 Mar 2025 18:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197627;
	bh=6ersQOe7jzVkDGycgW0WYIrqZ6RSpgwMXDa65dndJUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PviVZ4cfX0j8dxjkSJjofuY/Xxnf539vca3LF3ZZfx8Hj3RMmD5kn/v+71HtpypUW
	 ZocwEh2uCL38WOtn7Su0/0mTk3u8HP93lxFs/Dcpxpv59oGsvLcn41ElWNH5HUz2BX
	 Hlxf7NxJPpZEtjpYSS7QRqY/pzmfxyNV4m8nSALM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/142] include: net: add static inline dst_dev_overhead() to dst.h
Date: Wed,  5 Mar 2025 18:47:44 +0100
Message-ID: <20250305174502.150554353@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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
index 78884429deed8..16b7b99b5f309 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -448,6 +448,15 @@ static inline void dst_set_expires(struct dst_entry *dst, int timeout)
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



