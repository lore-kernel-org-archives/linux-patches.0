Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFAF20897E;
	Tue,  8 Apr 2025 11:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110947; cv=none; b=E4ZtGWYbThHOCR3Gm+1uYFPA+UHTdG+vV+kxs9nYmyExcM/oD15tJOzvhPaJ1P38DGmKlpMFcI+LvKmuFVULHog5vV9plAwMc5mHRW/1X2+qBibDVRoxuRffszIphCV2Vmsuw2aVw1t/CQHdDQWmCWaI+NGuJyzvyKJXGl0ma6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110947; c=relaxed/simple;
	bh=r7F0REHPnn02teg+QEJ+gcH+ZD3OeHbaFSfqYXMI2cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9t8HNzRhpUpZnBqrRIc4cHpN+R3OkjqlWbuS5xzEJ85Qw38xLluOSH3ePrHuOveklhZ5Ew1F8ZXSueBGrEGoPjJiiV3zq4hZbBF7ylkOo9IPVd1Vb6Y5JGt87SvNSvsN8CHr4SkoMxk6QgcAD2S0TIUAZ+4RbJ8AsxUy9hYuRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpkGdfvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpkGdfvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12870C4CEEB;
	Tue,  8 Apr 2025 11:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110946;
	bh=r7F0REHPnn02teg+QEJ+gcH+ZD3OeHbaFSfqYXMI2cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpkGdfvSaIDMLFCMfKrUcxX0cKAG0pBKduujOUeL02d7ROOTa1f9knv30B5AKmzPv
	 2g10FcEQUqV1LERhV/SgDT7unOugH5bDPendZqvE+GKXbBRkVldjMxXZlbaMd9QX1Z
	 5Wv7s31gElwGxa+nX8HZ3Pr/OrwH85JbnXwfhy+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Wang Liang <wangliang74@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 251/731] net: fix NULL pointer dereference in l3mdev_l3_rcv
Date: Tue,  8 Apr 2025 12:42:28 +0200
Message-ID: <20250408104920.123810388@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit 0032c99e83b9ce6d5995d65900aa4b6ffb501cce ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_l3s.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ipvlan/ipvlan_l3s.c b/drivers/net/ipvlan/ipvlan_l3s.c
index b4ef386bdb1ba..7c017fe35522a 100644
--- a/drivers/net/ipvlan/ipvlan_l3s.c
+++ b/drivers/net/ipvlan/ipvlan_l3s.c
@@ -226,5 +226,4 @@ void ipvlan_l3s_unregister(struct ipvl_port *port)
 
 	dev->priv_flags &= ~IFF_L3MDEV_RX_HANDLER;
 	ipvlan_unregister_nf_hook(read_pnet(&port->pnet));
-	dev->l3mdev_ops = NULL;
 }
-- 
2.39.5



