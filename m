Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD86267F67;
	Tue,  8 Apr 2025 11:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113583; cv=none; b=SIsaqvRYsdyGWCTnJflBh8EOJEAjORt97y+nHp4XzKLGlIuM8vkHttQWFeNQ9OE/9mVL5/oF0tRwZuFUGBwo8KRGrrkjd25CoxOjG/h8m90/Ld85TWycD5YAqvyholOYVi21c5MgelPFtkg32pfZJG1Uqr26W3U3HugW+l6Pj2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113583; c=relaxed/simple;
	bh=H5XtKZkpaeuzDGsoiF/37pGDpodIg7UJOF/tnw042fY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ey9PDLozzTZh9N8HXj9bxWYJ9kdA+c04luhweZXQeodOJt+1gneNoC/JMhosZGXKv4/sSn17QM4c8WiVCAZJ/jJYRPaInssOdH0CJPmP/X8B5HWSNkKP/c85wmWz5U2mxLHbH84lCz1UpWzUOa5oUDrs+mmLIyxY92EC79b0fCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2Jyh8jd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2Jyh8jd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0663C4CEE5;
	Tue,  8 Apr 2025 11:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113583;
	bh=H5XtKZkpaeuzDGsoiF/37pGDpodIg7UJOF/tnw042fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2Jyh8jdkLp3vz00Cv6UGxaeo1P1GVqYc39lr9NdgLXvTaYkcXxstyAo7SjXcNdeg
	 JDBtg77CXwrqPe1LKSa+05i9zmv2EqQjuDDt0SBJshQEg1FSw10y7zl8VYAbzbjoK7
	 ZwR1yJUvzrVxsSCopxlMQC6Xug2XOV5K3UbgwsGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 213/268] net: decrease cached dst counters in dst_release
Date: Tue,  8 Apr 2025 12:50:24 +0200
Message-ID: <20250408104834.326650047@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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
index 137b8d1c72203..aad197e761cb4 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -167,6 +167,14 @@ static void dst_count_dec(struct dst_entry *dst)
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



