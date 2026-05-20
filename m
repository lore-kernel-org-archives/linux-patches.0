Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F42401484;
	Wed, 20 May 2026 18:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302865; cv=none; b=SAohgr0qxIcTL5SK/JguBDYqCUxHqXFyIe03+PusXiD+aoJJ91y4/8WAqAUXQurrHNXdYi3H/KqxvNP6Oav7RVlg6TL/sL7SHx6Zy7BzfVo0hD4twh6fOFo4C4p241SLX/91jWmHIjVPOxZdICv/nlTvKT9DPAAznyud/czEB0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302865; c=relaxed/simple;
	bh=AXgoMOz53Gn16/PvhuDE9ozd8iXO1QFkUrfVx1CkHjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TujfbkdC/wgIX9Iebm98mSdZ7ZREmyYwTeyuM25vu2vXYYznsj4ULCCq9y41cU95IbTo5WU+/8G98h/cnHTOtZXK42jLRmLMoA+OyqGsicaM1sh5+syRHVXbbWSikaiP3yb9MJliBrTIHnioLEuQZR71dbtrC7iCAUbcVEGd3wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1eNkRje; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1eNkRje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E811F000E9;
	Wed, 20 May 2026 18:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302861;
	bh=y2R3bUvtMIXxXr4DtSneFaFyA8xfVoI+JzphM9NXN6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1eNkRjenryyZNkE6S5jpEaQeorQGN/OfKMjVQR8HqqpaLcggVWfs5mPxagpDUWJ+
	 x/80IYnZ/3TTWGX0f3u9303Rpe47u0ArHaeKVNXwhluzZ/MY291+R7DZJLGrankRk/
	 e+Kt6ndLSjiTnv0l7/JJzG1Clry9pATtzj0c6w18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Morduan Zang <zhangdandan@uniontech.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 391/508] net: usb: rtl8150: free skb on usb_submit_urb() failure in xmit
Date: Wed, 20 May 2026 18:23:34 +0200
Message-ID: <20260520162107.087513897@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Morduan Zang <zhangdandan@uniontech.com>

[ Upstream commit adbe2cdf75461891e50dbe11896ac78e9af1f874 ]

When rtl8150_start_xmit() fails to submit the tx URB, the URB is never
handed to the USB core and write_bulk_callback() will not run.  The
driver returns NETDEV_TX_OK, which tells the networking stack that the
skb has been consumed, but nothing actually frees the skb on this
error path:

  dev->tx_skb = skb;
  ...
  if ((res = usb_submit_urb(dev->tx_urb, GFP_ATOMIC))) {
          ...
          /* no kfree_skb here */
  }
  return NETDEV_TX_OK;

This leaks the skb on every submit failure and also leaves dev->tx_skb
pointing at memory that the driver itself may later free, which is
fragile.

Free the skb with dev_kfree_skb_any() in the error path and clear
dev->tx_skb so no stale pointer is left behind.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Morduan Zang <zhangdandan@uniontech.com>
Link: https://patch.msgid.link/E7D3E1C013C5A859+20260424015517.9574-1-zhangdandan@uniontech.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rtl8150.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 8700ae392b10a..647f28b367b99 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -712,6 +712,13 @@ static netdev_tx_t rtl8150_start_xmit(struct sk_buff *skb,
 			netdev->stats.tx_errors++;
 			netif_start_queue(netdev);
 		}
+		/*
+		 * The URB was not submitted, so write_bulk_callback() will
+		 * never run to free dev->tx_skb.  Drop the skb here and
+		 * clear tx_skb to avoid leaving a stale pointer.
+		 */
+		dev->tx_skb = NULL;
+		dev_kfree_skb_any(skb);
 	} else {
 		netdev->stats.tx_packets++;
 		netdev->stats.tx_bytes += skb_len;
-- 
2.53.0



