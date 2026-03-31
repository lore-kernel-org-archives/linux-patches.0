Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A473F423A7C;
	Tue, 31 Mar 2026 16:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976385; cv=none; b=idRTGE+Uh2lyRFO6mm3ygFfF9hUl7V9Qr4kqFS/I8bdXnjgOXyaLQ3NJrVthtfu5iAUbdRV/o9aZRcJWkrypya1ujAqgNDqUfE2PsIbi/CEt1CKu7RlvIWdvU/6C9sBroXA1ZstZLRl+2A27JX+olCXnjp4VzsAF9Mdf/l6HfRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976385; c=relaxed/simple;
	bh=06mkK/eFmBm/rxmkUbOBB1uEFUuU3zmI+iPRMNmoUEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3k/ovQbibs2pUseBU621pdr+dHWCwwH+4RXtEgooZXAvj34MnwX8ULIHqZ3c6bIHheSFoE6nvtfjuAzjENS+loRoZX6faq9riQeGjoS+MGYWqJbL9Dv7Ro/p9/KM0t4yxDS6H4/9dD6ndH0EZc5LfjcQJoz/lC5DUjrh7qETQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBmBK8sM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBmBK8sM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3110BC19423;
	Tue, 31 Mar 2026 16:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976385;
	bh=06mkK/eFmBm/rxmkUbOBB1uEFUuU3zmI+iPRMNmoUEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBmBK8sM8DdpxZ96lmBkrndd0tKQ6PWhTHz2omrdR8WExj+xkSqx2/UuZdofSkWSr
	 TZBLqdUahaW0MzKgoviWgQVaSp0qOyi+dt7EZq5nsIQ2ut7H1/98lZhY+PZd83D7UJ
	 fFnRQNhf8a0uhEJOBiDYo63vBEMgSdkMG7KjI1JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Long <me@imlonghao.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 073/309] xfrm: iptfs: fix skb_put() panic on non-linear skb during reassembly
Date: Tue, 31 Mar 2026 18:19:36 +0200
Message-ID: <20260331161756.175655302@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 0b352f83cabfefdaafa806d6471f0eca117dc7d5 ]

In iptfs_reassem_cont(), IP-TFS attempts to append data to the new inner
packet 'newskb' that is being reassembled. First a zero-copy approach is
tried if it succeeds then newskb becomes non-linear.

When a subsequent fragment in the same datagram does not meet the
fast-path conditions, a memory copy is performed. It calls skb_put() to
append the data and as newskb is non-linear it triggers
SKB_LINEAR_ASSERT check.

 Oops: invalid opcode: 0000 [#1] SMP NOPTI
 [...]
 RIP: 0010:skb_put+0x3c/0x40
 [...]
 Call Trace:
  <IRQ>
  iptfs_reassem_cont+0x1ab/0x5e0 [xfrm_iptfs]
  iptfs_input_ordered+0x2af/0x380 [xfrm_iptfs]
  iptfs_input+0x122/0x3e0 [xfrm_iptfs]
  xfrm_input+0x91e/0x1a50
  xfrm4_esp_rcv+0x3a/0x110
  ip_protocol_deliver_rcu+0x1d7/0x1f0
  ip_local_deliver_finish+0xbe/0x1e0
  __netif_receive_skb_core.constprop.0+0xb56/0x1120
  __netif_receive_skb_list_core+0x133/0x2b0
  netif_receive_skb_list_internal+0x1ff/0x3f0
  napi_complete_done+0x81/0x220
  virtnet_poll+0x9d6/0x116e [virtio_net]
  __napi_poll.constprop.0+0x2b/0x270
  net_rx_action+0x162/0x360
  handle_softirqs+0xdc/0x510
  __irq_exit_rcu+0xe7/0x110
  irq_exit_rcu+0xe/0x20
  common_interrupt+0x85/0xa0
  </IRQ>
  <TASK>

Fix this by checking if the skb is non-linear. If it is, linearize it by
calling skb_linearize(). As the initial allocation of newskb originally
reserved enough tailroom for the entire reassembled packet we do not
need to check if we have enough tailroom or extend it.

Fixes: 5f2b6a909574 ("xfrm: iptfs: add skb-fragment sharing code")
Reported-by: Hao Long <me@imlonghao.com>
Closes: https://lore.kernel.org/netdev/DGRCO9SL0T5U.JTINSHJQ9KPK@imlonghao.com/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_iptfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/xfrm/xfrm_iptfs.c b/net/xfrm/xfrm_iptfs.c
index 3b6d7284fc70a..4e270628fc347 100644
--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -901,6 +901,12 @@ static u32 iptfs_reassem_cont(struct xfrm_iptfs_data *xtfs, u64 seq,
 	    iptfs_skb_can_add_frags(newskb, fragwalk, data, copylen)) {
 		iptfs_skb_add_frags(newskb, fragwalk, data, copylen);
 	} else {
+		if (skb_linearize(newskb)) {
+			XFRM_INC_STATS(xs_net(xtfs->x),
+				       LINUX_MIB_XFRMINBUFFERERROR);
+			goto abandon;
+		}
+
 		/* copy fragment data into newskb */
 		if (skb_copy_seq_read(st, data, skb_put(newskb, copylen),
 				      copylen)) {
-- 
2.51.0



