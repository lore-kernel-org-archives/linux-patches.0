Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E822368D47;
	Sat, 12 Sep 2026 15:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228746; cv=none; b=WJuWi9sbrQkTbMFdCdfNiU/uAIBZmtG0lbxnxtSWD67Iy3RS5Dewc2CoGfTF00EAl475GefpnrS6kKzXBXNyfqmq+JqzSMM9rS87dyevbHdqVt5OTBbaFvR/opshx24otFg0u2Wk7F0UPim6wS93cbAkEchz8AGK42Wo+ux/wRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228746; c=relaxed/simple;
	bh=vQlnhfGcyJYXy+mVXaxTm+qhLx6gThChnnDKlR562RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzhozYnlfO57D3f4cfN+IsMqTkBVFRQYiXpFIGnhcrx5Q1B1TO87fc23yc8rGFHIRQCAXVt/bZoxdLfGb8TY71GDqA4jobGVvZYcS7XjCRcvJrYE2lnNNgsBRPS4HJVzSTtbGVidslGaHxegXINUYKpeX+Tt194dWIDCbpVajpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEt84R+f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEt84R+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7A81F000FF;
	Sat, 12 Sep 2026 15:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228745;
	bh=PW+lgOqD6iS+++wnuKGVDwyGpjSprLK7j/PN7SfixHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZEt84R+fgkE/ltzsgBWiZBBbM6eStjQatZ22KukS+W7nrS17t4nyMgSt0wB1wkpuh
	 5O5gPz1TXzG2qRb2/Idpv1kou+VMveqLytjOZTuLymUBO2jVjys926bwHGVnVme3OU
	 yvd2N8eoKhhaE3NwzzMZUgZkXy/K82hvz9p0T4Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Wang Liang <wangliang74@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0447/1191] net: fix NULL pointer dereference in l3mdev_l3_rcv
Date: Sat, 12 Sep 2026 08:52:55 +0200
Message-ID: <20260912065558.271066876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index d5b05e8032199..ca35a50bb6405 100644
--- a/drivers/net/ipvlan/ipvlan_l3s.c
+++ b/drivers/net/ipvlan/ipvlan_l3s.c
@@ -224,5 +224,4 @@ void ipvlan_l3s_unregister(struct ipvl_port *port)
 
 	dev->priv_flags &= ~IFF_L3MDEV_RX_HANDLER;
 	ipvlan_unregister_nf_hook(read_pnet(&port->pnet));
-	dev->l3mdev_ops = NULL;
 }
-- 
2.53.0



