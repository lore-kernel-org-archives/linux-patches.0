Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA02D70831;
	Tue, 27 May 2025 17:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365702; cv=none; b=Yssbdd0tR3MDM9Cd0kSQdOxP1htGLjVlUhWY064xWJzcwgEEm2OVV6yENg49jziYOocv+fY5tDGMTmI3dInvFEKoGThVjaPj/pxE1lYCSIjW+F3fQIyBrzNmtintQjzBsZ7t3VatvEEk9O/Dme3O/P8o5ckVRyYi7vV4q9yW2HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365702; c=relaxed/simple;
	bh=tCOMhEVpFbOFGikGsgB+4pewJ0MhJOJ1F7j7O/lr2kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McqaEYA+K9X43rl+5bOQsTi5TPWEPXgoBa1rUx7AdIP+HzQ7g/LZvU86ke+blBjALig5xSK2+ZglZsyAxnaq5VBpqrk+5FFZBVa4PsslSKSDRIk1RH6uHwULqC4bj55hr4x2y3Fm+fqRF8M94JroDaNRnaWgb1xBt/9JZYMjCIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9OINGIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9OINGIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39625C4CEE9;
	Tue, 27 May 2025 17:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365702;
	bh=tCOMhEVpFbOFGikGsgB+4pewJ0MhJOJ1F7j7O/lr2kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9OINGIsGEdOzik2dD3ydsTEL8IatDaLGGsvjyNo1JWBISk0H8F8RQAfZ/ZDKpUCu
	 rwOl5mFXEvzMsNGnevhlWeQhH/hhcFhgMmN40aApdYIRA17xKhyeM6a9vFYx1Hk7fU
	 Uwr2AjewmmjI344lGsbMGckBQKVOLQ0sFQJYK4ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@meta.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 444/626] eth: fbnic: set IFF_UNICAST_FLT to avoid enabling promiscuous mode when adding unicast addrs
Date: Tue, 27 May 2025 18:25:37 +0200
Message-ID: <20250527162503.039888287@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index a400616a24d41..79e94632533c8 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
@@ -544,6 +544,8 @@ struct net_device *fbnic_netdev_alloc(struct fbnic_dev *fbd)
 	fbnic_rss_key_fill(fbn->rss_key);
 	fbnic_rss_init_en_mask(fbn);
 
+	netdev->priv_flags |= IFF_UNICAST_FLT;
+
 	netdev->features |=
 		NETIF_F_RXHASH |
 		NETIF_F_SG |
-- 
2.39.5



