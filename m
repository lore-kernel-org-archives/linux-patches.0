Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D61339EF12;
	Wed, 23 Sep 2026 14:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173936; cv=none; b=La7OHUmAhz+Kg3NtVn+MWSvltdV3iE8KxM0I6PGFB02Wxu2Km+yhLwEYLEJD0rIOH7+zrKW7PfKKb/gm8pSgooZ6l+q9nKTQ3g2HavOt3IqywG5NHMCJZpyyxa5QqDE7cVCCR9DyZLgUeD/tj+Jk6HHSNss2NPP7fZyaLFzb9PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173936; c=relaxed/simple;
	bh=OHSg8mzZB7hPmXKvHYxQlOSgfEn/3OQIjVZnV4NVqqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSBy9H/rGiDoRNMZX/W6uTgMz8Q7BH4jAdNbklZYOLSswdlH9yUYQu/hPKgzLz6e7iyWmO9Eggt+LgeKabqtIGRjal8jcbC8gRn6rbKRP3XfIiMgWIpChRnNmrg7+jqQ0o2FXXvxNjjdH2E3zJetQ/BizMRl/g1FvHnP38xHD2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjamORqp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjamORqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B58B1F000FF;
	Wed, 23 Sep 2026 14:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173934;
	bh=iKj7SVfkROjZ6Fj60FogvD38XmcW+MYy2ughk67Ea3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jjamORqpE3XR8exnYtZQpbd8JbN5rS8tp4PnJLwwVG6iVytSHMZ6blFZ432JPQJdW
	 mra75l+ntR1lKYtIb9sisBycpRKlN5IqumB9W9UVmYzoCU95EIgCAL0fInyd6niVAN
	 bgQhipLtrHNOus5i4T8lNzaYtFCmemdB57DseqOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.2 390/438] wifi: wilc1000: fix RX buffer OOB-write in wilc_wlan_handle_isr_ext()
Date: Wed, 23 Sep 2026 16:06:51 +0200
Message-ID: <20260923140654.988276699@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1197,6 +1197,15 @@ static void wilc_wlan_handle_isr_ext(str
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
 


