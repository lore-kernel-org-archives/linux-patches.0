Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEA951C328;
	Wed, 30 Sep 2026 16:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784993; cv=none; b=NCjyM/jHVllYqrj4xKFPB3zLooTKEyJQ5pOqSBd5NAqjCm9lSNbu0//j7ibIIMYUTJwwE5WuUxkaqkCQ020qj4Mg0jP5Ov6aRdiICXmawE3g1s5DUutpTX3l1bU351Xnhct+A+6FFb2/DbDXoxFGlO+3m9opH5cArGlfpNwGulw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784993; c=relaxed/simple;
	bh=jp5D/4cOJwEDDysDHiTIlnEucrB0RcQwwuZ4S+vbtNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6Xzh2plNev99I+ecDa41Vfsc8m/43cdUIQRnB+tE67bVyyyuzGr/zcKQrEazIXB8idhszbdro06Q9pvyUkBWPBKoqBN6fnEaAgzPbdibkcCnFCXFRuTUHG01Mi0Uf94UYDcG6Gm5jTtw+oRnvXPHBKC4NgTBbz6pobyTlE30AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URA+EtXQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URA+EtXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FEC1F000FF;
	Wed, 30 Sep 2026 16:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784988;
	bh=9DAl49SRR8Hozqm6Si/bdYtwrTHT3cqNco1RmJJj0SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=URA+EtXQ5KcqPFtjoHwHK68KwY+HcrPVnhgjm7klqWNyKOWxvTswILVulPqsKmmhB
	 Jc8sWvVxaj/SNJIxcETbMMOnfwiXP6wknFsEGAZJXvRx9uTPlbOmVJaWi6gVcv7f9s
	 L/CL8mkDTsxWmrHP0+1L1EXTT/yVNK/qWajMAhqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 305/982] net: drop_monitor: fix info leak in NET_DM_ATTR_PAYLOAD
Date: Wed, 30 Sep 2026 17:17:21 +0200
Message-ID: <20260930152423.367765373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index eb5956d15cde0..78c248b9b6860 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -652,9 +652,7 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 	if (nla_put_u16(msg, NET_DM_ATTR_PROTO, be16_to_cpu(skb->protocol)))
 		goto nla_put_failure;
 
-	attr = skb_put(msg, nla_total_size(payload_len));
-	attr->nla_type = NET_DM_ATTR_PAYLOAD;
-	attr->nla_len = nla_attr_size(payload_len);
+	attr = __nla_reserve(msg, NET_DM_ATTR_PAYLOAD, payload_len);
 	if (skb_copy_bits(skb, 0, nla_data(attr), payload_len))
 		goto nla_put_failure;
 
@@ -814,9 +812,7 @@ static int net_dm_hw_packet_report_fill(struct sk_buff *msg,
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



