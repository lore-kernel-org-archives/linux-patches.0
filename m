Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A1934B40F;
	Wed, 20 May 2026 17:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297103; cv=none; b=Ylp5Tqs1Llo49KgkMsWwWH0Vlt5D3pWprCiPxVO4UfIp2sgHccp1OQk0YUOJxG9EswLa6Ky/MlIjPrQd+gIzowAZoydygxCc+/+lT/HFNjObfsbKdUcoxBhOwfnyyKy7boEblWTY0Jhs/sa0LalodB8iQs+w6lfuyg3W4AL/LIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297103; c=relaxed/simple;
	bh=7zrSTmbiY9UlO3yl0/z4qnsx77Ohlb/h61nz0KsGzrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrDz2aUd1ATG6O5p5cve9Vb8oR3ZA/OWBX/94rh6NsX9/t7uQ/juWZ6HjPt0trFlsPJI1O2pcFuDeCO7fkEy9Sd0IRlMpGFp31lgTEBBS2mKCnDScDPUZS5tJb3OlLRsdjVn10oT6dxuEP4dXSbtyNAXjvCTV3K1cilzMokiJfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5iJXmxy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5iJXmxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9F01F000E9;
	Wed, 20 May 2026 17:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297101;
	bh=ABpe9TkpdAuk7QqXYawYirF0A96GyaukpTissVtpQf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E5iJXmxyR747RS2SDnT2aG8w9kDWTu4mLtPNVqYnD/7sN8Abdr+d783k+F/Q3V+O4
	 ArufY6/awIwmSSUkVcaApSYefXAFkCdJGWP8vwgmpsnSBC+ox+hYP2TMrQzUdrhtem
	 NJKrzsPobjvr+wNmfpT/PWJQh/H+jBAZ0FpQtfqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arthur Kiyanovski <akiyano@amazon.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 1044/1146] net: ena: PHC: Fix potential use-after-free in get_timestamp
Date: Wed, 20 May 2026 18:21:34 +0200
Message-ID: <20260520162211.857844446@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arthur Kiyanovski <akiyano@amazon.com>

commit e42c755582f0960e684298762f0ab927b3778376 upstream.

Move the phc->active check and resp pointer assignment to after
acquiring the spinlock. Previously, phc->active was checked without
holding the lock, and resp was cached from ena_dev->phc.virt_addr
before the lock was acquired.

If ena_com_phc_destroy() runs between the lockless active check and
the lock acquisition, it sets active=false, releases the lock, frees
the DMA memory, and sets virt_addr=NULL. The get_timestamp path would
then read a NULL virt_addr and dereference it.

With both the active check and the pointer read under the lock,
destroy cannot free the memory while get_timestamp is using it.

Fixes: e0ea34158ee8 ("net: ena: Add PHC support in the ENA driver")
Cc: stable@vger.kernel.org
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260508062126.7273-1-akiyano@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1782,20 +1782,23 @@ void ena_com_phc_destroy(struct ena_com_
 
 int ena_com_phc_get_timestamp(struct ena_com_dev *ena_dev, u64 *timestamp)
 {
-	volatile struct ena_admin_phc_resp *resp = ena_dev->phc.virt_addr;
 	const ktime_t zero_system_time = ktime_set(0, 0);
 	struct ena_com_phc_info *phc = &ena_dev->phc;
+	volatile struct ena_admin_phc_resp *resp;
 	ktime_t expire_time;
 	ktime_t block_time;
 	unsigned long flags = 0;
 	int ret = 0;
 
+	spin_lock_irqsave(&phc->lock, flags);
+
 	if (!phc->active) {
+		spin_unlock_irqrestore(&phc->lock, flags);
 		netdev_err(ena_dev->net_device, "PHC feature is not active in the device\n");
 		return -EOPNOTSUPP;
 	}
 
-	spin_lock_irqsave(&phc->lock, flags);
+	resp = ena_dev->phc.virt_addr;
 
 	/* Check if PHC is in blocked state */
 	if (unlikely(ktime_compare(phc->system_time, zero_system_time))) {


