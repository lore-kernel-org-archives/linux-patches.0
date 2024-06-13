Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E93144317;
	Thu, 13 Jun 2024 12:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282890; cv=none; b=l1ZlSZxXD+3PRxghaTRt2eQ1DAVcPU74aH5id74NqD7CBbMPv0797bc6/rc1A1sTNgoAzD0SFGx7HWUHAbiw9JB2tvXwL3NJSj2rgEqYPQcN0Ayb0GrmQ604ZiS6Pl3vP/IxzQJXVGZLWPug0Pm/OlLoT5KayJkKY6ca0h3bUak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282890; c=relaxed/simple;
	bh=pPUWSj+jRIxy9bM+6P2grkTOAghUiLbWBHlsyotA3hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R90m1MMB58J72f4t/qLnGxIuCGVeuKJSkukbdTyVklHdqHUFPugS9PUF59HBuRHuiS6rkQSLWmeOtu+gmXB3CIRDnzbSzlj1wCilxWVJAbA7zlRMwW682QGRzkfWgg+fnsuBS+xEgNJZLpiLpEJjOgQr7Lc5LnSQMPyh14SLVEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SvmGY1Vv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SvmGY1Vv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFC2C32786;
	Thu, 13 Jun 2024 12:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282890;
	bh=pPUWSj+jRIxy9bM+6P2grkTOAghUiLbWBHlsyotA3hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvmGY1Vv306EkBeLeIv9atzQJ1Xx4lNojzP4Tx/4mqrXvexPo1LHY5syEwPEGjQI4
	 pXupYgtCeqoYhUiwLc5eKioIKsVpp29xGebAYqAoOvscI0PERDoBGYLR5KD3O4d7bp
	 QWlRnUXoSe4WrJLDY6UKrX3PAF3fc3uPtq/SV4dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.1 28/85] wifi: rtw89: pci: correct TX resource checking for PCI DMA channel of firmware command
Date: Thu, 13 Jun 2024 13:35:26 +0200
Message-ID: <20240613113215.229217874@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -948,7 +948,8 @@ u32 __rtw89_pci_check_and_reclaim_tx_res
 
 	spin_lock_bh(&rtwpci->trx_lock);
 	cnt = rtw89_pci_get_avail_txbd_num(tx_ring);
-	cnt = min(cnt, wd_ring->curr_num);
+	if (txch != RTW89_TXCH_CH12)
+		cnt = min(cnt, wd_ring->curr_num);
 	spin_unlock_bh(&rtwpci->trx_lock);
 
 	return cnt;


