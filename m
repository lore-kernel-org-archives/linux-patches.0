Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9EE1FB3;
	Tue, 27 May 2025 17:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367975; cv=none; b=pMmQfKHAfltAsvfFnwzvNheAI9V9fU08roIfKAYn+T2B8p6D5o41P4jvG/YzFks4SDHq73JrBbE2FADbbCpcY8hysg2zCAX1p0ZwvkbAdxo7pgRVJp6FaEPN3mtpxRw5I4/rgkj4Iaai5cQqP5LYf0KKJf30J+5oqM/TpJDxG0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367975; c=relaxed/simple;
	bh=FD3AHGzWoFwB4vU4RCPxxoV5wExgUMwJNanenJOy/oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CD3bmKZFEqqRPl8A2d3nJE606c+7K9f80z+4DRqf2KGMMhgGX3U0Hjjp89BHSnhA1x7AMeepDh0fZe98hIFywA+2jedyy2DEWsHm59StB6KYc0mZKgdKMErpgm8HWEp3EOGIGW/JSLO5zWp8GXKvJ84tmfZeL65cn/BbyqckKdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eE4AATM9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eE4AATM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6675CC4CEE9;
	Tue, 27 May 2025 17:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367974;
	bh=FD3AHGzWoFwB4vU4RCPxxoV5wExgUMwJNanenJOy/oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eE4AATM9Jb93Qp3xqcgUsPdtGW36+Bbvoe0veJOX6TxZ+e3cA6P6HIiwcoLpBfWeu
	 B9ulIm3kDeSBLtVpicMJRcqQ1K+Sw2PcqaVdtDtb6/Ozh6j9jf7A4NtBKIrB7yuDTC
	 DDreSMVZv6A71b4E0J8mQFUGJ7gVyT8HfglMQ5AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@meta.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 559/783] eth: fbnic: set IFF_UNICAST_FLT to avoid enabling promiscuous mode when adding unicast addrs
Date: Tue, 27 May 2025 18:25:56 +0200
Message-ID: <20250527162535.911645468@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Alexander Duyck <alexanderduyck@meta.com>

[ Upstream commit 09717c28b76c30b1dc8c261c855ffb2406abab2e ]

I realized when we were adding unicast addresses we were enabling
promiscuous mode. I did a bit of digging and realized we had overlooked
setting the driver private flag to indicate we supported unicast filtering.

Example below shows the table with 00deadbeef01 as the main NIC address,
and 5 additional addresses in the 00deadbeefX0 format.

  # cat $dbgfs/mac_addr
  Idx S TCAM Bitmap       Addr/Mask
  ----------------------------------
  00  0 00000000,00000000 000000000000
                          000000000000
  01  0 00000000,00000000 000000000000
                          000000000000
  02  0 00000000,00000000 000000000000
                          000000000000
  ...
  24  0 00000000,00000000 000000000000
                          000000000000
  25  1 00100000,00000000 00deadbeef50
                          000000000000
  26  1 00100000,00000000 00deadbeef40
                          000000000000
  27  1 00100000,00000000 00deadbeef30
                          000000000000
  28  1 00100000,00000000 00deadbeef20
                          000000000000
  29  1 00100000,00000000 00deadbeef10
                          000000000000
  30  1 00100000,00000000 00deadbeef01
                          000000000000
  31  0 00000000,00000000 000000000000
                          000000000000

Before rule 31 would be active. With this change it correctly sticks
to just the unicast filters.

Signed-off-by: Alexander Duyck <alexanderduyck@meta.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250204010038.1404268-2-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
index 7a96b6ee773f3..1db57c42333ef 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
@@ -628,6 +628,8 @@ struct net_device *fbnic_netdev_alloc(struct fbnic_dev *fbd)
 	fbnic_rss_key_fill(fbn->rss_key);
 	fbnic_rss_init_en_mask(fbn);
 
+	netdev->priv_flags |= IFF_UNICAST_FLT;
+
 	netdev->features |=
 		NETIF_F_RXHASH |
 		NETIF_F_SG |
-- 
2.39.5



