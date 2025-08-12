Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5241E1EBFE0;
	Tue, 12 Aug 2025 18:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022920; cv=none; b=ke9K9r7xS0LnbpxLD8aRXhCPdUE0iMz+13BmatzNnd6MkxHxCreefDwtK3d4Gyj5Q8oaW6QGEykVoVVteNY2sTfEexa/ImEmd+O605fQpOMqSXa8tFIxdwCq2s7wCyZRggeKewj29yIQWCcXFK9DfIT1GGankF0yeB0IpbqIzoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022920; c=relaxed/simple;
	bh=orXrSWQQYXig+AcYOQuj1ARvJ+KbglaJoDrFpawf3d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCsNbgVS303YlXKayQmsm3OJbRkBqSm9TkOUt5J35ox5M40rxS3CWyb0Ie0ZS2zocqGQjJH7xlraHXnOph3RRhkrelozKQLaRyfHabK09uCDvTQMqGtWZY7NA8t8Dl0Qa1dRQuCMDS2xf0pCEaUDKyW6EpQfCCKai8hso2t1Fb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=daj6VUnz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="daj6VUnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5ACEC4CEF0;
	Tue, 12 Aug 2025 18:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022920;
	bh=orXrSWQQYXig+AcYOQuj1ARvJ+KbglaJoDrFpawf3d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=daj6VUnzk61XvdkQuCzUJkUwlUj6eoTS9LJ4oWDwLa+ZvLflUnxbZixntvgJhjAzP
	 1IJkoPlezf27TgeW9tbSabZruZcd2TQ6OSAAuydsy9CxxqfL1ZwiXiOYhuC6gDCOWe
	 VxkoEUZALJFImO69s7QrmiFa80ILWwOM3XpDT+ik=
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
Subject: [PATCH 6.12 299/369] ipv6: reject malicious packets in ipv6_gso_segment()
Date: Tue, 12 Aug 2025 19:29:56 +0200
Message-ID: <20250812173027.977694193@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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
index 39f1d16f3628..a726a698aac4 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2991,6 +2991,29 @@ static inline void skb_reset_transport_header(struct sk_buff *skb)
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
index 9822163428b0..fce91183797a 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -148,7 +148,9 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
 
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



