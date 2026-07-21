Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB94471252;
	Tue, 21 Jul 2026 19:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660821; cv=none; b=pOuAZQGjte4Kwf9sM9m2ysaYi1lNXExGDcwwkgeg5xN5xD8yQw+1TTWZ4Xkf55lBGXwbLPjr3AiQ16zNNHo2c3lK/B9g2r5uHSTiMwut7TQIxZG2elMpF+TVDPRDP3Ld31ol90uQnpY+IuPVHAUjtFsaVJQo0Fr7Xrr9XQH/Fh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660821; c=relaxed/simple;
	bh=8Grzw7aYO+H96xs1xRraSYBrwcLe4FzgPOtp4nhDJKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lxSpYnlVM01o4TqJ6hkiDCT+baycAmcfWYpvLf3Nls9RmoZ/wqfdnr3v+ZQ/0vIrFcRWQ524BiIrhJllY9UfUdNpQ4hvYEQ6UyLJYVHHfM01UFBguf8EaSyfpuV2sxNrXfiW6to+fhiKbFAvLVZ70WHvzQzZ9iQ+E4anpQLp5/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2+6p1aw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2+6p1aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F182B1F000E9;
	Tue, 21 Jul 2026 19:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660819;
	bh=y2XxAoY8uvMFiWhVbuU0HqSFM/sNCdms+vnv/2MdtuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T2+6p1awMX9mZpjk7MyOK3n5N9CaRUax4+y9IkAi8RqZhb+FkzsL3qZrPwSxyFsIe
	 lTOANvkC62Z2v4q+PKoX4r9vai/hc5PzxqHbVczS0jDQZ76MadsN/VpYnvO41W50Yg
	 qgruG9+zHE16xBm5aolmAeeDxB3IN03L99XFzmmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Raczylo <lukasz@raczylo.com>,
	Steffen Jaeckel <sjaeckel@suse.de>,
	Andrea della Porta <andrea.porta@suse.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1124/2077] net: macb: add TX stall timeout callback to recover from lost TSTART write
Date: Tue, 21 Jul 2026 17:13:17 +0200
Message-ID: <20260721152619.331589579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Raczylo <lukasz@raczylo.com>

[ Upstream commit e438ec3e9e95cd3f49a8120e5f63ae3f9606e6fa ]

The MACB found in the Raspberry Pi RP1 suffers from sporadic stalls on
the TX queue.
While the exact root cause is not yet fully understood, it is likely
related to a hardware issue where a TSTART write to the NCR register
is missed, preventing the transmission from being kicked off.

Implement a timeout callback to handle TX queue stalls, triggering the
existing restart mechanism to recover.

Link: https://lore.kernel.org/all/20260514215459.36109-1-lukasz@raczylo.com/
Fixes: dc110d1b23564 ("net: cadence: macb: Add support for Raspberry Pi RP1 ethernet controller")
Signed-off-by: Lukasz Raczylo <lukasz@raczylo.com>
Co-developed-by: Steffen Jaeckel <sjaeckel@suse.de>
Signed-off-by: Steffen Jaeckel <sjaeckel@suse.de>
Co-developed-by: Andrea della Porta <andrea.porta@suse.com>
Signed-off-by: Andrea della Porta <andrea.porta@suse.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Théo Lebrun <theo.lebrun@bootlin.com>
Link: https://patch.msgid.link/468f480454a314303bac6a54780b153f689f2267.1781598350.git.andrea.porta@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a12aa21244e83b..fd282a1700fb98 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4522,6 +4522,13 @@ static int macb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	}
 }
 
+static void macb_tx_timeout(struct net_device *dev, unsigned int q)
+{
+	struct macb *bp = netdev_priv(dev);
+
+	macb_tx_restart(&bp->queues[q]);
+}
+
 static const struct net_device_ops macb_netdev_ops = {
 	.ndo_open		= macb_open,
 	.ndo_stop		= macb_close,
@@ -4540,6 +4547,7 @@ static const struct net_device_ops macb_netdev_ops = {
 	.ndo_hwtstamp_set	= macb_hwtstamp_set,
 	.ndo_hwtstamp_get	= macb_hwtstamp_get,
 	.ndo_setup_tc		= macb_setup_tc,
+	.ndo_tx_timeout		= macb_tx_timeout,
 };
 
 /* Configure peripheral capabilities according to device tree
-- 
2.53.0



