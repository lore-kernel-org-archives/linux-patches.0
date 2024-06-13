Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D086AFAE;
	Thu, 13 Jun 2024 11:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279369; cv=none; b=DkZaSNoAVPAyD8nHH/xBjaRJ7sYRO96dNunZ600YLsDpET03YbHdwUXewuqXlNanZmawXT4LT85PSysmljVfnpX3vBWfOU8FAc/QnK+qUGzfYTr0qtJ+Y4PVpA7aWUt6pElATUlIMxOOpzRhKS3gAulnfIuSxI4Vvuqh71B0BmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279369; c=relaxed/simple;
	bh=0YLwQ6tB+P/pA0v9iRrxGy8elCH4RWzwpAfuWRe9Qfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmmA1inlYga2QoOi9IYhA5bstFGsZE35PBo+vd2HEvgmlzFAlq/Mtr3Mi1Inb/0jsXMWVWk3Ky5CmvmnP7BB+GgMTKVQKUU1CzcBuSnp6QqyQW49E2dm4aR3OyljuY5QTL7lqx8qpsh6xKn5X3c1xcrmtRHl8S5M/i5Ab3i+/CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=beHmHodp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="beHmHodp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B6BC2BBFC;
	Thu, 13 Jun 2024 11:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279369;
	bh=0YLwQ6tB+P/pA0v9iRrxGy8elCH4RWzwpAfuWRe9Qfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=beHmHodptVE2qjt6VwCHGzPO8cg5lVocEgSUlCYw2JNFo5HXHwg2osRToxtc3D8IX
	 3gN35jn9G6CgKCvLQ0Wo/DRb8ObhCdREio+yrZztu3o5nD7zQ2qXFuNNZaS77RzO7V
	 6TX3SONDu2GOyfP3Et56jiNPt0+GN8d1PbScD1sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.9 025/157] wifi: rtw89: pci: correct TX resource checking for PCI DMA channel of firmware command
Date: Thu, 13 Jun 2024 13:32:30 +0200
Message-ID: <20240613113228.386614271@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

commit c6330b129786e267b14129335a08fa7c331c308d upstream.

The DMA channel of firmware command doesn't use TX WD (WiFi descriptor), so
don't need to consider number of TX WD as factor of TX resource. Otherwise,
during pause state (a transient state to switch to/from low power mode)
firmware commands could be dropped and driver throws warnings suddenly:

   rtw89_8852ce 0000:04:00.0: no tx fwcmd resource
   rtw89_8852ce 0000:04:00.0: failed to send h2c

The case we met is that driver sends RSSI strength of firmware command at
RX path that could be running concurrently with switching low power mode.
The missing of this firmware command doesn't affect user experiences,
because the RSSI strength will be updated again after a while.

The DMA descriptors of normal packets has three layers like:

  +-------+
  | TX BD | (*n elements)
  +-------+
      |
      |   +-------+
      +-> | TX WD | (*m elements)
          +-------+
              |
              |   +--------+
              +-> |   SKB  |
                  +--------+

And, firmware command queue (TXCH 12) is a special queue that has only
two layers:

  +-------+
  | TX BD | (*n elements)
  +-------+
      |
      |   +------------------+
      +-> | firmware command |
          +------------------+

Fixes: 4a29213cd775 ("wifi: rtw89: pci: correct TX resource checking in low power mode")
Cc: stable@vger.kernel.org
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/20240410011316.9906-1-pkshih@realtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -1089,7 +1089,8 @@ u32 __rtw89_pci_check_and_reclaim_tx_res
 
 	spin_lock_bh(&rtwpci->trx_lock);
 	cnt = rtw89_pci_get_avail_txbd_num(tx_ring);
-	cnt = min(cnt, wd_ring->curr_num);
+	if (txch != RTW89_TXCH_CH12)
+		cnt = min(cnt, wd_ring->curr_num);
 	spin_unlock_bh(&rtwpci->trx_lock);
 
 	return cnt;


