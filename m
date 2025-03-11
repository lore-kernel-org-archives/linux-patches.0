Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C489255E37;
	Tue, 11 Mar 2025 15:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707369; cv=none; b=uBOE2D87ECXctZ+qM6+B6YeuEmwt8NeH0Cmx8oDT37mDyG1CY7N3PHg5TXyjJKhfEnXiAhMvVHIKnYTIZMBQiYIltrsGXQ1x/YgsFkUra9NEDYhIUJ65MH+Kcnrcn9Gh3V/W1THCNI8s644NjeRPJuq31MV8THm/PlK0jAMTQS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707369; c=relaxed/simple;
	bh=sWHDbdHENMYRVelj+8djnTgHAPVp22+BEZGYff9njzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODtMcmQC0LlhP+OfeT1pBptyg/VFyZ57W7YNKMQwPa3TAv9tYICnz47m3ZNi3L1b8UoYMs8ymb3vjqeo+7ZT7EnDIVMFqJzorRkLDBtOW9QXM7MnbVk6nhCYF9U4TgInlQbVw0M8yLYnZK7eihwyI8d2AlbJiLXET7OG9H4bC8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDtqDSkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDtqDSkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B000C4CEE9;
	Tue, 11 Mar 2025 15:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707368;
	bh=sWHDbdHENMYRVelj+8djnTgHAPVp22+BEZGYff9njzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDtqDSkEkqbk2DG3gbgHVq2LgbzjjvfzrWFF8jyJUngX+2+54kc2g67+W3vUj2WlF
	 JQZ4nBW7uVW2DB7iRYnP0wuRHCRcWYFXJtDmojMZxKLNE2trPOkHW0Fm1WZ67qSk70
	 ShBh9tSCQDQoNhheAui+7YbzS4n/Ip5KU6BsbAh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 365/462] include: net: add static inline dst_dev_overhead() to dst.h
Date: Tue, 11 Mar 2025 16:00:31 +0100
Message-ID: <20250311145812.768970777@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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
Stable-dep-of: 13e55fbaec17 ("net: ipv6: fix dst ref loop on input in rpl lwt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dst.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/net/dst.h b/include/net/dst.h
index af57a6284444c..9114272f81009 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -431,6 +431,15 @@ static inline void dst_set_expires(struct dst_entry *dst, int timeout)
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



