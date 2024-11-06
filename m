Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002971DF26B;
	Wed,  6 Nov 2024 12:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895677; cv=none; b=XexfOCsFlfWxp3+2LkXVcg7b4XYPbURnGwiXllhUZtXF7gLxHux1N7nAsJUNzBFfZtDPoIUcAa4UmTdXCW4DAaMNCSnY8N+cCKdTugI8LSf7Ewb+qu4NlN1D9NmsERR0Rkb8he1+7Lll/wfdHkF7vDIkK91pwC6C+7KDuBsxbyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895677; c=relaxed/simple;
	bh=hHRDggXq1b3euCUuuIozaOmvkN05MVJVfmIQ5T0zy+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUSvwZJ6H4ZR+V/CZom+y/GJWxUNM+5IWyHuZRDoV7UTbTH5+vaChUxGtHHkI1KWMw2G7740H2DmPwaJ+gBFhboU+5f/fLr+i5GuhiyiDucldkzIPVnvC69z5BVhdVVedMCgyYZMPDc5Uj9LnbJSryVPDAegNfQZZbyh9CSMpG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0p/9wkH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0p/9wkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A127C4CECD;
	Wed,  6 Nov 2024 12:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895676;
	bh=hHRDggXq1b3euCUuuIozaOmvkN05MVJVfmIQ5T0zy+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0p/9wkHPa0MnccOUBPHrtqPVu5qnJlQ4kohfvooh+dOXi5/Z6wAhGkN88BppTaES
	 WyEEDzA7t7Yc+x1AbLt6eD34KIdh7jv3P3nv2cfA1h/EgKRtHyf8Gsn5OZn/OjRRi7
	 EaTljBJ7jxjSWcfUy3Sq7QnxWTYNlYTGTP1vV0bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 299/350] net: systemport: fix potential memory leak in bcm_sysport_xmit()
Date: Wed,  6 Nov 2024 13:03:47 +0100
Message-ID: <20241106120328.191659261@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit c401ed1c709948e57945485088413e1bb5e94bd1 ]

The bcm_sysport_xmit() returns NETDEV_TX_OK without freeing skb
in case of dma_map_single() fails, add dev_kfree_skb() to fix it.

Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Link: https://patch.msgid.link/20241014145115.44977-1-wanghai38@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index b3fc8745b5807..55b869f5c8255 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1319,6 +1319,7 @@ static netdev_tx_t bcm_sysport_xmit(struct sk_buff *skb,
 		netif_err(priv, tx_err, dev, "DMA map failed at %p (len=%d)\n",
 			  skb->data, skb_len);
 		ret = NETDEV_TX_OK;
+		dev_kfree_skb_any(skb);
 		goto out;
 	}
 
-- 
2.43.0



