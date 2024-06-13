Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6DF13C805;
	Thu, 13 Jun 2024 12:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280377; cv=none; b=Iu0HdzM/Btb6bk9buL4nxDeF/5KzL4gDOLnLRrHnQzqfIGYgJM/QRISvXp1K3fBvq6j2DQ+91Al1EcpPpmnhWRZ8MaBs0UTBKH5uauFn2mRdFQM/YP47SYCbsiB4DxfDIccYwJoAYjR5nRjzRHLBNAXjohvGWAi5hpTnxjt0m4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280377; c=relaxed/simple;
	bh=BrsRyavnK0XSgNUnJVBRxmyPJlfPuKWxaLdu/UfBF5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUHyluP6rtsrTXPDQRMhfJESH5YB/ahySca1MLeC778H9vL6qpwAXmS3KuxI/Z1nKIEX/FJBKz6k2DeraVBR+GVdAaXKvyvR0PXoYHO5RKhXnPFyn90ukvs/E+w5oSP06l8lJpLx9QU+jPAeosDTGqiFGNXaR7FApTuVy6k4ioE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PuCnnhs5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PuCnnhs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544ABC2BBFC;
	Thu, 13 Jun 2024 12:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280376;
	bh=BrsRyavnK0XSgNUnJVBRxmyPJlfPuKWxaLdu/UfBF5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuCnnhs5h/S5QzIwboFHSx0uLKmgIscYJI9dj5+Zv3tBnbDUY3276OZatCpKE055+
	 ek8Fj/ssawIQAbFTfoaf+YVeEsT2T6HRlYEd8ha4+IX+eYbi97Xvvxf/2nikA5o1TS
	 wsmge5yMw578YVavQ4Uj3UbtT0O2cWHuextC+02o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.6 032/137] wifi: rtw89: pci: correct TX resource checking for PCI DMA channel of firmware command
Date: Thu, 13 Jun 2024 13:33:32 +0200
Message-ID: <20240613113224.537016601@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -958,7 +958,8 @@ u32 __rtw89_pci_check_and_reclaim_tx_res
 
 	spin_lock_bh(&rtwpci->trx_lock);
 	cnt = rtw89_pci_get_avail_txbd_num(tx_ring);
-	cnt = min(cnt, wd_ring->curr_num);
+	if (txch != RTW89_TXCH_CH12)
+		cnt = min(cnt, wd_ring->curr_num);
 	spin_unlock_bh(&rtwpci->trx_lock);
 
 	return cnt;


