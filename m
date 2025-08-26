Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738A434F48B;
	Tue, 26 Aug 2025 14:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217527; cv=none; b=NHVaRubqy0sh+WqBw05LKXJ935eCdkp5l+6Y+ZhO6ab8IASA9xRQpT3/9DPwAq61gyemMGaz8dqqNy2U62nNwEkWyncDvhcVlkOTwiPt7mOOV0Y3N6RZEZhHj9QpuPkh1KAF1JbiNcwc0IeYlzaKOl55akpPvgS80a0nRxsmnMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217527; c=relaxed/simple;
	bh=OtNwsaw8UzkL2nv/gYvK2/62XR+p8aaT8gHN55620yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TN0l8vn6FXgBpwm+AES/n0jrM9SN1SgGlYUutgiTSKCTSaq0NpQ4Karp0u3u0zeg17KR8q83wJaMNjQ8C7LlBD8FXV8Spybgpy6anbh9LTiYQiIVqyYWKiro7qdOC17Wtk2nhWSmsxHxdW8m5w/Ns+ZNHNPLM/6kA7guWIYP2kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5XTzSnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5XTzSnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D2DC4CEF1;
	Tue, 26 Aug 2025 14:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217527;
	bh=OtNwsaw8UzkL2nv/gYvK2/62XR+p8aaT8gHN55620yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5XTzSnqfXs3kJ1NuiOLszD7w5KTY822kgcoV4e2TZ4qfCQX1eOSRcpRevwXGm8sF
	 fSYPKcQsykdV4+yOgxW8tsVbqpfnwEKZeoOpNZE1lJAQRpTmbHVXc7ONCfsef4PJKA
	 L22qaPBZnPAM7DncaJi1oCVehD6fZ35LOHWWQ2E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+af43e647fd835acc02df@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 177/523] ipv6: reject malicious packets in ipv6_gso_segment()
Date: Tue, 26 Aug 2025 13:06:27 +0200
Message-ID: <20250826110928.824353638@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d45cf1e7d7180256e17c9ce88e32e8061a7887fe ]

syzbot was able to craft a packet with very long IPv6 extension headers
leading to an overflow of skb->transport_header.

This 16bit field has a limited range.

Add skb_reset_transport_header_careful() helper and use it
from ipv6_gso_segment()

WARNING: CPU: 0 PID: 5871 at ./include/linux/skbuff.h:3032 skb_reset_transport_header include/linux/skbuff.h:3032 [inline]
WARNING: CPU: 0 PID: 5871 at ./include/linux/skbuff.h:3032 ipv6_gso_segment+0x15e2/0x21e0 net/ipv6/ip6_offload.c:151
Modules linked in:
CPU: 0 UID: 0 PID: 5871 Comm: syz-executor211 Not tainted 6.16.0-rc6-syzkaller-g7abc678e3084 #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
 RIP: 0010:skb_reset_transport_header include/linux/skbuff.h:3032 [inline]
 RIP: 0010:ipv6_gso_segment+0x15e2/0x21e0 net/ipv6/ip6_offload.c:151
Call Trace:
 <TASK>
  skb_mac_gso_segment+0x31c/0x640 net/core/gso.c:53
  nsh_gso_segment+0x54a/0xe10 net/nsh/nsh.c:110
  skb_mac_gso_segment+0x31c/0x640 net/core/gso.c:53
  __skb_gso_segment+0x342/0x510 net/core/gso.c:124
  skb_gso_segment include/net/gso.h:83 [inline]
  validate_xmit_skb+0x857/0x11b0 net/core/dev.c:3950
  validate_xmit_skb_list+0x84/0x120 net/core/dev.c:4000
  sch_direct_xmit+0xd3/0x4b0 net/sched/sch_generic.c:329
  __dev_xmit_skb net/core/dev.c:4102 [inline]
  __dev_queue_xmit+0x17b6/0x3a70 net/core/dev.c:4679

Fixes: d1da932ed4ec ("ipv6: Separate ipv6 offload support")
Reported-by: syzbot+af43e647fd835acc02df@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/688a1a05.050a0220.5d226.0008.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250730131738.3385939-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 23 +++++++++++++++++++++++
 net/ipv6/ip6_offload.c |  4 +++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3248e4aeec03..ca7f2a2c3e3f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2519,6 +2519,29 @@ static inline void skb_reset_transport_header(struct sk_buff *skb)
 	skb->transport_header = skb->data - skb->head;
 }
 
+/**
+ * skb_reset_transport_header_careful - conditionally reset transport header
+ * @skb: buffer to alter
+ *
+ * Hardened version of skb_reset_transport_header().
+ *
+ * Returns: true if the operation was a success.
+ */
+static inline bool __must_check
+skb_reset_transport_header_careful(struct sk_buff *skb)
+{
+	long offset = skb->data - skb->head;
+
+	if (unlikely(offset != (typeof(skb->transport_header))offset))
+		return false;
+
+	if (unlikely(offset == (typeof(skb->transport_header))~0U))
+		return false;
+
+	skb->transport_header = offset;
+	return true;
+}
+
 static inline void skb_set_transport_header(struct sk_buff *skb,
 					    const int offset)
 {
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index 673f02ea62aa..c145be2fd6e4 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -111,7 +111,9 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
 
 	ops = rcu_dereference(inet6_offloads[proto]);
 	if (likely(ops && ops->callbacks.gso_segment)) {
-		skb_reset_transport_header(skb);
+		if (!skb_reset_transport_header_careful(skb))
+			goto out;
+
 		segs = ops->callbacks.gso_segment(skb, features);
 		if (!segs)
 			skb->network_header = skb_mac_header(skb) + nhoff - skb->head;
-- 
2.39.5



