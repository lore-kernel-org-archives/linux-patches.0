Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F989333434
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301821; cv=none; b=ehCieaz9qVyHdS4KAde6DfnoHGnMt8/KAwqRh73gVD/T6hd7AzqJBr8aQVS/x1sZD+OLoSYasRb7hS6GV+eMyW8jCYVyW/JqIjOizAQ1uBu0pwUdiKixhFJqMWtI0AXGg3B0h/En31zsGCy1z+H40EZGVcBi3dnw1osQRcIY7Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301821; c=relaxed/simple;
	bh=ibnFo5Ual+3BC4zOzKZGUO9Wp8eJM/Imlm5xLSgM9oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+WfUc2vIu2lTu2Psr0TB0LQczZ4hcp5/9wUNsIh3FZ4H32RvFjVFMjr18iIupWb4M9raaefEuNnzXbozVNz020D56+gxmEpNYy9bW4Ngh4ffwaLEZu6E5bEP2eR7r5UDL1bCKa8IwsqIqcf1TrZgaLv4c5N5cqpzm8F+mxZDwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=StwlIWog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="StwlIWog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4B8C116D0;
	Sat, 28 Feb 2026 18:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301821;
	bh=ibnFo5Ual+3BC4zOzKZGUO9Wp8eJM/Imlm5xLSgM9oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StwlIWog6eGt656PP8+2i+r3OvivR45wdn9WYgsVWBS+QA+pRCKOhSnqALxYPSPrr
	 Ncr+6UbOIS26eXMAmomW18wAJq20oQwr7ttGGANfxaDceFGPQVprxunyHis0zlnVDL
	 32zJFcGOjj99TVARsJU5fdYcfs6LYV4f8xpBmkEDczpEBw62Hes2Ohe3ijX+CWwsTn
	 rRPtTddGF7iNYIELyvQ/zVQdKx0OxMU8Tx41mj6/VUjNi36COKmX6N0C6iVwNbFTIc
	 tCf2GhQxgiTiOgWjTvzKNwpmkOWsVr9Twv0mcQwWDmcXU0rcvdxeVWVGm57UyIpERv
	 S6k6vGrqLfZJg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/385] net: Add skb_dstref_steal and skb_dstref_restore
Date: Sat, 28 Feb 2026 12:57:38 -0500
Message-ID: <20260228180011.1568201-236-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 2e26a054d260c..4344724a97821 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1146,6 +1146,38 @@ static inline struct dst_entry *skb_dst(const struct sk_buff *skb)
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

