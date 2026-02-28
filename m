Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D694A359A70
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302394; cv=none; b=sLC3sBPydoqkVnFdqF9oGDlWC2B5pcyY9lbXW8xrJdKbRiKILIZNLM9WrzRrpT2ZFZ8s5uXlTWU/kU2YkjDRd8ycdrAhogrVPOPbIy4vP7dV0dk9AYpt/qDOn+KGfU+VV8yfLeJKPI75zyt2s++KB+Rra2+TW97ae0nMHTHftHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302394; c=relaxed/simple;
	bh=6e04TdOE9E5mc05JyiiVQoGDrS+NoUoqf6GjE7GsNws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nP9UKdOirQrZm3calagrbI0ix0BUm1G7F5jo2UphgK7WJ8fn0rhMjyAcqcQ27XKPO0pg3mgYOlKFO0245G1eYHfMt7eipiJhK7ayVTR5aqy9AZ1ELJ0Er8VIMeebMRo2v9qP8q/M9Mir00kRr2IXMiYgGByZIE4D/L6sy2l8TRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zvo83FX0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zvo83FX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4591EC116D0;
	Sat, 28 Feb 2026 18:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302394;
	bh=6e04TdOE9E5mc05JyiiVQoGDrS+NoUoqf6GjE7GsNws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zvo83FX0sPmyVXGhwp0/wjE3Y1WdFcKwzh0NLWQPYKrERm3Cptt/+fU7Kd6kw8pZc
	 EOMoEV8sxy91Dw+7W/cD+EiJgBDprkcMXG4SFOM+WPi47SCz0sxVFLRqXfQ7X8CwaD
	 iNQrBqdX4kyIUEqQb91BwNB2tw2PQjX6UioRFjs3dsBP78eMLDFvyAxr4EMUMaixzN
	 C/edK5Mcl2sMnxe9euWLPCFBAeaXyqM1wVXaZ/HAhl3W6FRDWTtYFp5EK8PjCUhPon
	 asb0ZiCQUrxGtcPcyRxXc9uJA4k6mYpg3pYbmulnXJZ/7hYQm4a4x6dispjBLX4MGD
	 J1+ikoTsZnj2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/232] net: Add skb_dstref_steal and skb_dstref_restore
Date: Sat, 28 Feb 2026 13:09:37 -0500
Message-ID: <20260228181127.1592657-124-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Stanislav Fomichev <sdf@fomichev.me>

[ Upstream commit c3f0c02997c7f8489fec259e28e0e04e9811edac ]

Going forward skb_dst_set will assert that skb dst_entry
is empty during skb_dst_set to prevent potential leaks. There
are few places that still manually manage dst_entry not using
the helpers. Convert them to the following new helpers:
- skb_dstref_steal that resets dst_entry and returns previous dst_entry
  value
- skb_dstref_restore that restores dst_entry previously reset via
  skb_dstref_steal

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250818154032.3173645-2-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 81b84de32bb2 ("xfrm: fix ip_rt_bug race in icmp_route_lookup reverse path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9a04a188b9f8e..af868e03b7dc8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1119,6 +1119,38 @@ static inline struct dst_entry *skb_dst(const struct sk_buff *skb)
 	return (struct dst_entry *)(skb->_skb_refdst & SKB_DST_PTRMASK);
 }
 
+/**
+ * skb_dstref_steal() - return current dst_entry value and clear it
+ * @skb: buffer
+ *
+ * Resets skb dst_entry without adjusting its reference count. Useful in
+ * cases where dst_entry needs to be temporarily reset and restored.
+ * Note that the returned value cannot be used directly because it
+ * might contain SKB_DST_NOREF bit.
+ *
+ * When in doubt, prefer skb_dst_drop() over skb_dstref_steal() to correctly
+ * handle dst_entry reference counting.
+ *
+ * Returns: original skb dst_entry.
+ */
+static inline unsigned long skb_dstref_steal(struct sk_buff *skb)
+{
+	unsigned long refdst = skb->_skb_refdst;
+
+	skb->_skb_refdst = 0;
+	return refdst;
+}
+
+/**
+ * skb_dstref_restore() - restore skb dst_entry removed via skb_dstref_steal()
+ * @skb: buffer
+ * @refdst: dst entry from a call to skb_dstref_steal()
+ */
+static inline void skb_dstref_restore(struct sk_buff *skb, unsigned long refdst)
+{
+	skb->_skb_refdst = refdst;
+}
+
 /**
  * skb_dst_set - sets skb dst
  * @skb: buffer
-- 
2.51.0

