Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53E4502D78;
	Thu, 17 Sep 2026 17:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665055; cv=none; b=O7sRRK3tMwHKN/5b+gT51cY1j00KiAz1pRw0PwpH3jmOuQJkiFGWl6oNhYZU/llBf/XlVUEt5nSlC5/qD6r/PUgA22EaCK/oIhhlYSXP3/5b17EMtcl9Czv38zmLQDi1UB2Ebs49jLFTKJIdREpJ7ix4RAf4ArKvwlqdVc8cD/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665055; c=relaxed/simple;
	bh=+U+zqJgvYrzQBa5GQzm/cRWL88ExHNxmsaHd5smECmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yt709iEUJngwql3oKPUFP1Re2cC6gohMqBPWjVOJrMBndNMyc5xwxxf7rBDDNq5Uxkk36XNYgOHXbqp0u9ZdcdhnIUirf834Cj/jKIUe1MSiY45ElFNRFiArmRjB7jjRgyjGNuua/QjMrUXy6gHgRkAPkGnLRvgllqmoN/nzn20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSm3WNOP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSm3WNOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DCB1F00893;
	Thu, 17 Sep 2026 17:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665053;
	bh=HOYPKgPXK4dsmA6h7Jgn6cUOsF7Ly06QQTE8Jg9izLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cSm3WNOP/Y6DxczQ4OirwEhJUHvaiJMoZVVfUBVZbaVVZizQXQGqrOgpy5hVZc/+J
	 KzRq+5963EuJ5ksGLVQkmJJq9w1beNJvOOtOuhsQkRiVZTUeFHCXGo4Us8GscHjXAd
	 DaMZtIjNy4rY8JX5nGC36k6NiH05BYLhY4Iwi9Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0577/1250] net: drop_monitor: fix info leak in NET_DM_ATTR_PAYLOAD
Date: Thu, 17 Sep 2026 16:06:12 +0100
Message-ID: <20260917151607.536933231@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1383e90735edc..a5e75cd04d6ca 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -672,9 +672,7 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 	if (nla_put_u16(msg, NET_DM_ATTR_PROTO, be16_to_cpu(skb->protocol)))
 		goto nla_put_failure;
 
-	attr = skb_put(msg, nla_total_size(payload_len));
-	attr->nla_type = NET_DM_ATTR_PAYLOAD;
-	attr->nla_len = nla_attr_size(payload_len);
+	attr = __nla_reserve(msg, NET_DM_ATTR_PAYLOAD, payload_len);
 	if (skb_copy_bits(skb, 0, nla_data(attr), payload_len))
 		goto nla_put_failure;
 
@@ -832,9 +830,7 @@ static int net_dm_hw_packet_report_fill(struct sk_buff *msg,
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



