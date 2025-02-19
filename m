Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B211E1A2D;
	Wed, 19 Feb 2025 08:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955227; cv=none; b=BU4+3P78oM0JOCOkmHjCHe2iofNc+VuE3BL7ZhbYP0Liwa82fQt0cF9c8uY5bWtpPjEPnZZS/CtQbW7HCDy3Os+eZ1BKdw7rqZr0xHQD4rM2dxnrCwO5/D+x5nnidsXnlfqUhTWMxlmHwUcTPbzeV74tvGbteuyl0vOlUc5a2sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955227; c=relaxed/simple;
	bh=mZQUkcJo5k3KNrpAUfFx3AMG8QrEND13GhxcbazXzEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUwwOfWoJMr6v5UGS0ga/WxU/A4clw/E0ab/dXZjEE7aJh3tj3P4l7zCnsakDRKh9xfi6fAbWh9uYWO0UXAlXxI8bKKTtG9sMF8WY8w4Pz+aj+FaRrRLkV7Zwnn4i6smpLctKo42PqEUnvmAgxT2R0NjBJd1quNiDr5Q6kwwzvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbTJdjgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbTJdjgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6425DC4CED1;
	Wed, 19 Feb 2025 08:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955226;
	bh=mZQUkcJo5k3KNrpAUfFx3AMG8QrEND13GhxcbazXzEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbTJdjgwlp9MDuhU+pMQRFw3kgS9GkIRbUX1oPnOGdf74XI9RUgQeJ2AelExojhUl
	 adcBFflscWeX+JNSLsJMLKwqVfoktxC9rhjF3GsqGwPNU3dGYZ/WDrz5AJmS1CdJKz
	 jv7mW+O1VB47qVOtWYed3l3SmxvvxI6jrciV3RnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 163/230] include: net: add static inline dst_dev_overhead() to dst.h
Date: Wed, 19 Feb 2025 09:28:00 +0100
Message-ID: <20250219082608.073557854@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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



