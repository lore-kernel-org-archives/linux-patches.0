Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF3D315D54;
	Sun,  7 Sep 2025 20:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277398; cv=none; b=jcbMHh/pJh3DGWm9Aw0uRU0CaNiXewpLPetMqL/cx3hzWoW4xFtr0Jp8ma9bdhWHRJFX69g42MN4dGwa8XPae9zrlpgLZqrGMRMT6NlqIcMaA8vq2uGa6TxPT4WNls3aBOPDbIKsPIjkn3AXWWWHOBr8ctWlVwz1uH/SWfD9Vl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277398; c=relaxed/simple;
	bh=awBrJn5koY5FwMwbZ+f9SnqiKS5NhzRpJeYVoTLj27U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYdxWCXZOgoTRf5Yd20BmiPcrxnnjnp7mnCy5vrWTuPVms+YrUu+8g9Zh6SVdg2K+O8FjFUrZr7kDKiQX1JMay5xW369sBwiSVjtZ7DTwQT4NpUNnACtmuu90/JpN2Ad3Tu+r6iPU9hcb0tL+7Lh35QmnvIw3+W3EeyHc++Xq9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hfEiMjC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hfEiMjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944ABC4CEF0;
	Sun,  7 Sep 2025 20:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277398;
	bh=awBrJn5koY5FwMwbZ+f9SnqiKS5NhzRpJeYVoTLj27U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hfEiMjCIXtjH7jQPgu5GFqznsHA1p1hiawCNUJVYqBjxONN0KmNskZlShzgCrimm
	 zWAfeOauq/NSXzycu66V7epsZzN9M5UQ4d+prtHgxt9c5kLjEArWILU6XTP3riu9Kv
	 JSiJW6dS/jT1OdWnRbJa+IIBc3dq/wromHQtJUTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Wang Liang <wangliang74@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 135/175] net: fix NULL pointer dereference in l3mdev_l3_rcv
Date: Sun,  7 Sep 2025 21:58:50 +0200
Message-ID: <20250907195618.044360141@linuxfoundation.org>
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

commit 0032c99e83b9ce6d5995d65900aa4b6ffb501cce upstream.

When delete l3s ipvlan:

    ip link del link eth0 ipvlan1 type ipvlan mode l3s

This may cause a null pointer dereference:

    Call trace:
     ip_rcv_finish+0x48/0xd0
     ip_rcv+0x5c/0x100
     __netif_receive_skb_one_core+0x64/0xb0
     __netif_receive_skb+0x20/0x80
     process_backlog+0xb4/0x204
     napi_poll+0xe8/0x294
     net_rx_action+0xd8/0x22c
     __do_softirq+0x12c/0x354

This is because l3mdev_l3_rcv() visit dev->l3mdev_ops after
ipvlan_l3s_unregister() assign the dev->l3mdev_ops to NULL. The process
like this:

    (CPU1)                     | (CPU2)
    l3mdev_l3_rcv()            |
      check dev->priv_flags:   |
        master = skb->dev;     |
                               |
                               | ipvlan_l3s_unregister()
                               |   set dev->priv_flags
                               |   dev->l3mdev_ops = NULL;
                               |
      visit master->l3mdev_ops |

To avoid this by do not set dev->l3mdev_ops when unregister l3s ipvlan.

Suggested-by: David Ahern <dsahern@kernel.org>
Fixes: c675e06a98a4 ("ipvlan: decouple l3s mode dependencies from other modes")
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250321090353.1170545-1-wangliang74@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipvlan/ipvlan_l3s.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/ipvlan/ipvlan_l3s.c
+++ b/drivers/net/ipvlan/ipvlan_l3s.c
@@ -224,5 +224,4 @@ void ipvlan_l3s_unregister(struct ipvl_p
 
 	dev->priv_flags &= ~IFF_L3MDEV_RX_HANDLER;
 	ipvlan_unregister_nf_hook(read_pnet(&port->pnet));
-	dev->l3mdev_ops = NULL;
 }


