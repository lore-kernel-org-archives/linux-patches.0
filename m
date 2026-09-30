Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DF750AC0E;
	Wed, 30 Sep 2026 17:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788833; cv=none; b=CAWEMBzRFNtTVo9YZHy/RtTO9QWcAFvu4K6TtdGyli0/wMdYTNnDlV5nJUH+zqa+YIGu/4p6gQ5pM2unWA7P8eewZ7TvsQlXsAWp1yaSFQkF0A8EAEGyuvbQNQo9bAZtQKNex504VIN2MTwgmBb9x/Hheg7wVd3aVqbVbT6tkJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788833; c=relaxed/simple;
	bh=YuMgYZuExcartwuOAsyOmQyEGKTc2i+21gM9P/ATVOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zb6GTEbKLfwFWJw184ibs8/AOptiGjvzXfoiyi4/xO8fkH4GFgU9Lb8peVA5dhtZ2vqq1YuNc3zAEZU25iFOL6b2I4EZ8UwkqZHEuI0NC+D9aDoi7cyo3nDyB2dPBpeHvuPXMqcW1Vj9Zvxkdz8FyaMQTGnraSqHoi2/lzT1RQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+H8e9b2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+H8e9b2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EADD1F000FF;
	Wed, 30 Sep 2026 17:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788832;
	bh=5HjSS39texGcQjdgz1YCQVAnjbJkmKVzHlqgG0Rs6JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+H8e9b2ZP3VLuhgPrjsf8a2++tDkNZ3xAuU2vE6kW+0eScsern6Tp6H+0vKnyG0y
	 l5+r532UL4XG9DsIyiFH3f6Qwy7FAfzUHBqORev3o4/oK0I4Niy/g2s8elIRZiIOCO
	 VaqlHBRg+yfbSiB+NUv7ROrs5cqAcb7DFPsQEF8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 265/877] wifi: wilc1000: fix RX buffer OOB-write in wilc_wlan_handle_isr_ext()
Date: Wed, 30 Sep 2026 17:19:36 +0200
Message-ID: <20260930152420.443248303@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchu Chen <flynnnchen@tencent.com>

commit c1ba7f7f18465e259cf1b4d9c73fc73853d7f790 upstream.

wilc_wlan_handle_isr_ext() takes the RX transfer size from the
device-reported interrupt status register (a 15-bit field shifted left by 2,
up to 131068 bytes) and reads that many bytes from the device into
rx_buffer, which is only WILC_RX_BUFF_SIZE (96K) large. The wrap
check only handles the current offset; the size itself is never
compared against the buffer, so a bogus SDIO device can make the driver
OOB-write rx_buffer by up to ~32K with data it controls.

The oversized transfer also leaves rx_buffer_offset past the end of
the buffer, after which the unsigned wrap check stops working and
the overflow can repeat.

Drop any transfer whose size exceeds the RX buffer, acknowledging
the data interrupt and re-arming the RX engine so the bogus frame is
discarded and reception can continue. This also restores the
rx_buffer_offset <= WILC_RX_BUFF_SIZE invariant the wrap check
relies on.

This is not expected to change driver behavior in most cases:
without this check, an oversized transfer would most likely
corrupt neighboring kernel memory instead of completing anyway, and
the drop path performs the same interrupt acknowledgment and RX
engine re-arming as the normal path, so subsequent transfers are
received unaffected.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Link: https://patch.msgid.link/7c971924c6bdccf6c2f75704a5a746e9303aaf64@linux.dev
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -1035,6 +1035,15 @@ static void wilc_wlan_handle_isr_ext(str
 	if (size <= 0)
 		return;
 
+	/* A size exceeding the RX buffer is bogus; drop the transfer
+	 * instead of overflowing the buffer.
+	 */
+	if (size > WILC_RX_BUFF_SIZE) {
+		wilc->hif_func->hif_clear_int_ext(wilc,
+						  DATA_INT_CLR | ENABLE_RX_VMM);
+		return;
+	}
+
 	if (WILC_RX_BUFF_SIZE - offset < size)
 		offset = 0;
 


