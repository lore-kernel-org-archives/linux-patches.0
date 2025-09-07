Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A9015C158;
	Sun,  7 Sep 2025 20:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277101; cv=none; b=umEIhDTiXGD4Ob3DPygaoyJXCxyqWyuDOKWxOMgFsANdNADgkw/wGsmLEikR70o08viI/HytrSIVqXI49/PnAovUAr2yIagEmUXvN4HkHsIv1F2XeSTLU9htJU1whgSkAKJ7ZQBUHbyeyOwIQN8xo2WHhToAR4Ey++6URbfTofE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277101; c=relaxed/simple;
	bh=BKyt8ME2G1VzO2GB5YTnD3RUPgfBr1yONHjoYc5w/fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmuchtWe/UCIEJPFyHa3uSM8E2v4btc0jWJEVI9nIbRWpCi2M9EbfOPWDBsRuW5NuNzX2F5CqttZOJRW53zjfGcYdyT1A9oqIFizr687V9QdOOpGh8wPd4MTdp4narYnstU+RnFZssEFviMCIA9dpIZYc5Z4FwiMaHC66Obz8IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCapFbn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCapFbn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36ED5C4CEF0;
	Sun,  7 Sep 2025 20:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277101;
	bh=BKyt8ME2G1VzO2GB5YTnD3RUPgfBr1yONHjoYc5w/fI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCapFbn91KE8PNw2snTW2l1FL1exn7GtupPG/jM3w+kSoXEwrw6Z13nDg6/WxRrsG
	 QxwC/uz6QbU9Zr4DWTuFziAgD+J24sdeqTo1lXNIxE1e5ht+DZe1aM3n2mhXVIFDyN
	 VaW/pe/PtKaWCGO2gOB0+uP3t1pjZbkSQ9shME3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Wang Liang <wangliang74@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/175] netfilter: br_netfilter: do not check confirmed bit in br_nf_local_in() after confirm
Date: Sun,  7 Sep 2025 21:57:14 +0200
Message-ID: <20250907195615.781250759@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit 479a54ab92087318514c82428a87af2d7af1a576 ]

When send a broadcast packet to a tap device, which was added to a bridge,
br_nf_local_in() is called to confirm the conntrack. If another conntrack
with the same hash value is added to the hash table, which can be
triggered by a normal packet to a non-bridge device, the below warning
may happen.

  ------------[ cut here ]------------
  WARNING: CPU: 1 PID: 96 at net/bridge/br_netfilter_hooks.c:632 br_nf_local_in+0x168/0x200
  CPU: 1 UID: 0 PID: 96 Comm: tap_send Not tainted 6.17.0-rc2-dirty #44 PREEMPT(voluntary)
  RIP: 0010:br_nf_local_in+0x168/0x200
  Call Trace:
   <TASK>
   nf_hook_slow+0x3e/0xf0
   br_pass_frame_up+0x103/0x180
   br_handle_frame_finish+0x2de/0x5b0
   br_nf_hook_thresh+0xc0/0x120
   br_nf_pre_routing_finish+0x168/0x3a0
   br_nf_pre_routing+0x237/0x5e0
   br_handle_frame+0x1ec/0x3c0
   __netif_receive_skb_core+0x225/0x1210
   __netif_receive_skb_one_core+0x37/0xa0
   netif_receive_skb+0x36/0x160
   tun_get_user+0xa54/0x10c0
   tun_chr_write_iter+0x65/0xb0
   vfs_write+0x305/0x410
   ksys_write+0x60/0xd0
   do_syscall_64+0xa4/0x260
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  ---[ end trace 0000000000000000 ]---

To solve the hash conflict, nf_ct_resolve_clash() try to merge the
conntracks, and update skb->_nfct. However, br_nf_local_in() still use the
old ct from local variable 'nfct' after confirm(), which leads to this
warning.

If confirm() does not insert the conntrack entry and return NF_DROP, the
warning may also occur. There is no need to reserve the WARN_ON_ONCE, just
remove it.

Link: https://lore.kernel.org/netdev/20250820043329.2902014-1-wangliang74@huawei.com/
Fixes: 62e7151ae3eb ("netfilter: bridge: confirm multicast packets before passing them up the stack")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netfilter_hooks.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 17a5f5923d615..5ad3f3ef4ca75 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -653,9 +653,6 @@ static unsigned int br_nf_local_in(void *priv,
 		break;
 	}
 
-	ct = container_of(nfct, struct nf_conn, ct_general);
-	WARN_ON_ONCE(!nf_ct_is_confirmed(ct));
-
 	return ret;
 }
 #endif
-- 
2.50.1



