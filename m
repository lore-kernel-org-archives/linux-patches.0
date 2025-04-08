Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E727826B965;
	Tue,  8 Apr 2025 12:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115227; cv=none; b=rcFkk1JNsh3d2BObLwGWc4K8Z7jkX3R7Hx9qeTgHuSnfGA3SeKXbW9gIJ45YD1iJ8rsDlrdJv7kCmsX7BgNQenEnlzk0s/dYUH89jK8khR8wsTzNsrMS1zINGV94IxuQcrHdwH9L6fhFfIHcOxCZkyuaB2jmYu9fwM1dENymVRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115227; c=relaxed/simple;
	bh=4A8hZcoiSistRlaimzP+aUfVApVXKq6yLe9V4pcB4CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IH1+O5thhO7jYS8bYGRBiTAC528CiQEhJSeZEwrhSHLQCjPI4dEpQHn7Qw0UE+AXAiH1eh2NGo9n8vRraV2nQW3SXszNKGw5WVcX23b5FFsjtcmgAYWyHzfjqMgTbG0ZYg3vyXR8Lnr8R6NuTNB14+/dP3hR93IbhvQRQtGn5HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ryo5oae9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ryo5oae9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D19C4CEEA;
	Tue,  8 Apr 2025 12:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115226;
	bh=4A8hZcoiSistRlaimzP+aUfVApVXKq6yLe9V4pcB4CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ryo5oae9IYRHOtsPDRGZivJyNFtTIHUIwoWs8+Ji42g92xXvm+jBSUIGBLT57CuHB
	 d2h/zxA7F9dtau4mrUi665tSUAmQHY8TQuqSA1ERVUi/8ao1gRr99KrZC9kMD3RLUX
	 FGvniM6gF963gipMsJ1FgEs54UdiFHmPJkaKfIak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 397/499] net: decrease cached dst counters in dst_release
Date: Tue,  8 Apr 2025 12:50:09 +0200
Message-ID: <20250408104901.128070954@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 3a0a3ff6593d670af2451ec363ccb7b18aec0c0a ]

Upstream fix ac888d58869b ("net: do not delay dst_entries_add() in
dst_release()") moved decrementing the dst count from dst_destroy to
dst_release to avoid accessing already freed data in case of netns
dismantle. However in case CONFIG_DST_CACHE is enabled and OvS+tunnels
are used, this fix is incomplete as the same issue will be seen for
cached dsts:

  Unable to handle kernel paging request at virtual address ffff5aabf6b5c000
  Call trace:
   percpu_counter_add_batch+0x3c/0x160 (P)
   dst_release+0xec/0x108
   dst_cache_destroy+0x68/0xd8
   dst_destroy+0x13c/0x168
   dst_destroy_rcu+0x1c/0xb0
   rcu_do_batch+0x18c/0x7d0
   rcu_core+0x174/0x378
   rcu_core_si+0x18/0x30

Fix this by invalidating the cache, and thus decrementing cached dst
counters, in dst_release too.

Fixes: d71785ffc7e7 ("net: add dst_cache to ovs vxlan lwtunnel")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Link: https://patch.msgid.link/20250326173634.31096-1-atenart@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dst.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/dst.c b/net/core/dst.c
index 9552a90d4772d..6d76b799ce645 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -165,6 +165,14 @@ static void dst_count_dec(struct dst_entry *dst)
 void dst_release(struct dst_entry *dst)
 {
 	if (dst && rcuref_put(&dst->__rcuref)) {
+#ifdef CONFIG_DST_CACHE
+		if (dst->flags & DST_METADATA) {
+			struct metadata_dst *md_dst = (struct metadata_dst *)dst;
+
+			if (md_dst->type == METADATA_IP_TUNNEL)
+				dst_cache_reset_now(&md_dst->u.tun_info.dst_cache);
+		}
+#endif
 		dst_count_dec(dst);
 		call_rcu_hurry(&dst->rcu_head, dst_destroy_rcu);
 	}
-- 
2.39.5



