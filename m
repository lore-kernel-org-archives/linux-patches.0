Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375CC38D014
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302159; cv=none; b=Bep3Re6tTD7/T0jcjrA1JrH+vfv2ee66Ax6yy1D/dwVCbyBlLYAbCzVu5hbemRXnl8PyuZG2Ntf1Y4nLsBRbFk0NOV5OrRZG2QRnyBlZZCfD9kPSdgNTEv6H1obu6d2uNAZGfteMTHSKkLpnwjUlGwcGEj1LgzJXYZ/m1CNMBHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302159; c=relaxed/simple;
	bh=nlSMyTbgWVUWv+E5mKvbTf6KhtRUcEy0P8tto7jjIDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAN9BYXO/tW/w8t+Lv3YAIipF88Db3dfB2VTJdgiOEjnQZFK68bdKBj3ltH8OgJOfhYSmMUdK7uFhzfj0ykCugbxvSv1AIchW7HIdcGec+KfYU/W3bKlKSREBYto595nKXU42JEvKTkyaR4jkAYGMW8oV2EjjLEroIuQJb2jWw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sJ/0D5YA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sJ/0D5YA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E22C19425;
	Sat, 28 Feb 2026 18:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302159;
	bh=nlSMyTbgWVUWv+E5mKvbTf6KhtRUcEy0P8tto7jjIDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJ/0D5YAYcFCuw35Z/qRq+3+z1v4ID1VlTgEVmfT9iZB5vnvmDieLz0Pf8FLAyfdw
	 8ULqxiP9isNo138eemMMcGbRfeVKQ/hUQkbaw/+mhO+Q+2UKTJG2y+hhyoYfnfBQsG
	 hm8udim4fOm/ClNHNWLfpj9ooUiOf0oNW/j/0j1g42/nD8kyAEOj3RrJc7qpV62qWe
	 8URK6+PQVwnWdMHHiA/HnNooOo8Q6z7U7sk3YEDj+LIXmhozl/XVDiVpzGZN1zLmEs
	 W+sHlk8qtR2yRjE5RK3BLuUpm1+hw85Zt9ErSpezZnU/sFjx4Tc2eGXGndS/CnhDvZ
	 0CovbRPusjkzg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/283] net: Add skb_dstref_steal and skb_dstref_restore
Date: Sat, 28 Feb 2026 13:04:56 -0500
Message-ID: <20260228180709.1583486-154-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 69b392dc10aa3..1a91645fa2497 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1122,6 +1122,38 @@ static inline struct dst_entry *skb_dst(const struct sk_buff *skb)
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

