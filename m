Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26602143888;
	Tue, 23 Apr 2024 21:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908511; cv=none; b=JWyWFS3uhH0vhk8KD8gcBwhQ9587EwvmifynerHTrI2MMraOQEBMTN/OXJ1fipQu1WTpAViVvIoNQrw/bktEGQ/ftZNyiRy4BNpH4jjkbyBQ7GNpRvCevZrLCFQDKmJyADO2ebitLcAPfNwGR9BMIE4GHQTAaBmirDCjzwpi5BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908511; c=relaxed/simple;
	bh=YcE8/FU0jLrIhgoVTxcH+rQbW5BuFMQG80e0NKnIKJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtDYusNW7emF1OElFcXOm3faT+CzatTpI+Lon4CZRQ7laAADzVUd0/RuLXrhwBxSlGIj+fA3d5PkJxyTXEZZpy1MOjAymL9jQnKppwF5M77PYBYeZ4ovxjZ3hAiMy3Jz/OYqISGHfbhgGbHoMZfcvctag+M/Qf4lUeI2fIZFZlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjV/e5Yy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjV/e5Yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B3DC32782;
	Tue, 23 Apr 2024 21:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908510;
	bh=YcE8/FU0jLrIhgoVTxcH+rQbW5BuFMQG80e0NKnIKJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OjV/e5YyomViYt2DNaaB3cdo+TBWCT3UMdyybcJtzeDDf+NGE8rnh/bqL9ov/5zQw
	 N2LZQjy/AxHfbvrUZ23CWDqD8ddc7r5t2oiPmi+hYqvpo8smTp/yMkeziZiLfbTr40
	 rLgWCP1WmnWaCjurcg0EULbxzHqHLDpNbzjTq2+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ricky Wu <ricky_wu@realtek.com>
Subject: [PATCH 6.8 095/158] misc: rtsx: Fix rts5264 driver status incorrect when card removed
Date: Tue, 23 Apr 2024 14:38:37 -0700
Message-ID: <20240423213859.041866863@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricky Wu <ricky_wu@realtek.com>

commit 26ac2df47d4c58f17210b7a59037e40f7eca693e upstream.

rts5264 driver not clean express link error and set EXTRA_CAPS_SD_EXPRESS
capability back when card removed

Fixes: 6a511c9b3a0d ("misc: rtsx: add to support new card reader rts5264")
Cc: stable <stable@kernel.org>
Signed-off-by: Ricky Wu <ricky_wu@realtek.com>
Link: https://lore.kernel.org/r/20240314065113.5962-1-ricky_wu@realtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/cardreader/rtsx_pcr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/cardreader/rtsx_pcr.c b/drivers/misc/cardreader/rtsx_pcr.c
index 1a64364700eb..0ad2ff9065aa 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1002,7 +1002,7 @@ static irqreturn_t rtsx_pci_isr(int irq, void *dev_id)
 		} else {
 			pcr->card_removed |= SD_EXIST;
 			pcr->card_inserted &= ~SD_EXIST;
-			if (PCI_PID(pcr) == PID_5261) {
+			if ((PCI_PID(pcr) == PID_5261) || (PCI_PID(pcr) == PID_5264)) {
 				rtsx_pci_write_register(pcr, RTS5261_FW_STATUS,
 					RTS5261_EXPRESS_LINK_FAIL_MASK, 0);
 				pcr->extra_caps |= EXTRA_CAPS_SD_EXPRESS;
-- 
2.44.0



