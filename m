Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F3C3BFAEE;
	Wed, 30 Sep 2026 19:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794879; cv=none; b=LlX9mHTGedOVajaF63J519H5A45H8+hFDtKRKie6gPHM64cRwOJIl0VoXoWQIVJg1Q0wPC72HAxaeGVnQucyN45bIgRSP7Bch9IBjodxmrHmfMcaa/5Rz9VRpalTB0b5MAvuXWIcfMTS6lwUoHR0aPBfkqWKwQtxRoB9xbmvEfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794879; c=relaxed/simple;
	bh=2JEfmT4z8UBIKbzqpvWcJMgK9Gy6rCy8nT2eVB2mlvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1JMKhoFsOvb8D4W9q0LicaRqoJQswkoviy+1Jr00YuidFhc6LwJl3ODEiV8JVk7iY0HY1B5G0/FYiSaFfYr2nnScimraEd73TlGWjaTPDJlWQyA1TOG5qKChcINlU5rm3ffivVRRbkvXWToa//7kFTVo+LP9sVIkyLIRAV/HXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUVPUR0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUVPUR0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BD31F000FF;
	Wed, 30 Sep 2026 19:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794850;
	bh=IMvM6+Uuw5za00wu4W5I8OG2YRGZmgEsrpho4wWxZeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUVPUR0anhsihDOIH58R+vfuPtlIhTRNhPFHEj6ojDDF/kXNsr99P7pY6h5mJ1q3n
	 9DMNmWGUNEUYdxo28ZLvCBwrgStSBT5yxBDE8QQacGz8L+dpBtH2uG5yS4AaQ/AbeP
	 l748Ur6pfZle6OuISkxmFrcDW86bLX5QIVxOs5f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0354/1193] net: drop_monitor: fix info leak in NET_DM_ATTR_PAYLOAD
Date: Wed, 30 Sep 2026 17:17:18 +0200
Message-ID: <20260930152442.032393436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit 5e9c8baee0329fbefe7c67aea945e2a07f15e98b ]

net_dm_packet_report_fill() and net_dm_hw_packet_report_fill() open code
the NET_DM_ATTR_PAYLOAD attribute to avoid zeroing the packet payload
before overwriting it with skb_copy_bits().

skb_put() reserves nla_total_size(payload_len), i.e. the header plus the
NLA_ALIGN() padding, but only payload_len bytes are copied in. When
payload_len is not a multiple of 4 the 1-3 padding bytes are never
initialized and are leaked to user space inside the netlink message.

KMSAN confirms the leak for the software path when the packet payload
length is not 4-byte aligned:

  BUG: KMSAN: kernel-infoleak in _copy_to_iter
   _copy_to_iter
   __skb_datagram_iter
   skb_copy_datagram_iter
   netlink_recvmsg
   sock_recvmsg
   __sys_recvfrom
  Uninit was created at:
   kmem_cache_alloc_node_noprof
   __alloc_skb
   net_dm_packet_work
  Bytes 173-175 of 176 are uninitialized

Use __nla_reserve(), which sets up the attribute header and zeroes the
padding, instead of open coding the attribute construction.

Fixes: ca30707dee2b ("drop_monitor: Add packet alert mode")
Fixes: 5e58109b1ea4 ("drop_monitor: Add support for packet alert mode for hardware drops")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Link: https://patch.msgid.link/20260722122817.5548-1-yhlee@isslab.korea.ac.kr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/drop_monitor.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index fe560b2d161f9..60ca18b440a34 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -669,9 +669,7 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 	if (nla_put_u16(msg, NET_DM_ATTR_PROTO, be16_to_cpu(skb->protocol)))
 		goto nla_put_failure;
 
-	attr = skb_put(msg, nla_total_size(payload_len));
-	attr->nla_type = NET_DM_ATTR_PAYLOAD;
-	attr->nla_len = nla_attr_size(payload_len);
+	attr = __nla_reserve(msg, NET_DM_ATTR_PAYLOAD, payload_len);
 	if (skb_copy_bits(skb, 0, nla_data(attr), payload_len))
 		goto nla_put_failure;
 
@@ -829,9 +827,7 @@ static int net_dm_hw_packet_report_fill(struct sk_buff *msg,
 	if (nla_put_u16(msg, NET_DM_ATTR_PROTO, be16_to_cpu(skb->protocol)))
 		goto nla_put_failure;
 
-	attr = skb_put(msg, nla_total_size(payload_len));
-	attr->nla_type = NET_DM_ATTR_PAYLOAD;
-	attr->nla_len = nla_attr_size(payload_len);
+	attr = __nla_reserve(msg, NET_DM_ATTR_PAYLOAD, payload_len);
 	if (skb_copy_bits(skb, 0, nla_data(attr), payload_len))
 		goto nla_put_failure;
 
-- 
2.53.0



