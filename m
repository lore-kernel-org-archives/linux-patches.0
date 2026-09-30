Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E15502D5A;
	Wed, 30 Sep 2026 18:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792215; cv=none; b=NZai9aCxFsTuc6aiBnaWMk78CrvIkHpFIDPQU0IpWc0uIQzlD9nB6tLjtkykqI2lRN5m2qWYOQopdnNZYBsCSa+Ei0GYyNDrMveGAp4jjA9BWN5g5zYDjoGTrisiBs6CgB6GeClaSIF/0SXFtJg7lLyof2MMl5+bTrd+TSO8+SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792215; c=relaxed/simple;
	bh=Zp0SwaaSnzdginsRY9OK6POBTwcbTMjOxe+9ENandkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkSbRRAoGnKNt539yR5h4FjueBlJnp71kIbk2zz2sFpYv3fkJpYj2TYWhxsFNJ8VqGe9n+2GdDwNkBEmeB3MnMbMLP/wAhki7w8sPXjAjH0iMgxNkJ9l6PjZ79NFe47dzPvEKR7n1/CBAyGmH2+CluBtjWQcQsdOZg/etcxpW24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ueLMPkQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ueLMPkQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE13A1F000FF;
	Wed, 30 Sep 2026 18:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792214;
	bh=B/Q+pq0jWp7byrwnYkYVBvAQNaAJPmlJFo4obKfqT4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ueLMPkQZp6fe/ADYs+Na6jqCGogTQ53u5gzLLRKYHoa8NPxT3L26jjuR7m2UddrOP
	 OlYxIDrWHzoVcZLjK5ijjgQhFlctGh8wgotTgDbqpFpu/jAsx1wphsay+DoLyrsM/0
	 wXbqWpXW8jrDX+S+rOPUBKLZX8vVZT5QWn5pVO78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 576/752] wifi: wilc1000: fix RX buffer OOB-write in wilc_wlan_handle_isr_ext()
Date: Wed, 30 Sep 2026 17:27:26 +0200
Message-ID: <20260930152410.758627614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1025,6 +1025,15 @@ static void wilc_wlan_handle_isr_ext(str
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
 


