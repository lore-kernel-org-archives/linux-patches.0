Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31CE3BD22C;
	Wed, 30 Sep 2026 19:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796466; cv=none; b=LWUywcK1hYnOypOtt/crq/ORUthi07Gd+GL18n8pNze8fGuh8ouq1TIRV7YY33QjisUVkPjOjtOJ4ejj+GcGSTI/8R4dXhQXA1kLnVNWQG+GJOsSvkVH3Pr1KWGbRtVM2M0VMxPgWdQOo2vlxSRZlKw/BbuGvANyzSqge0ag/+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796466; c=relaxed/simple;
	bh=Bj25Yy8D1Y3D38lSJagQIZjlZexjWsmTctIUznL8lCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IU6yB65uvoH0rEAL0QQLDf0xMDiAyjCWu+W4mjZQMBMywTCX/Yo9vWhVK8YLD1q/3GrchYrG49zrHGP3O0pr2P3/kYEoYlMRPWxdeQHV+APF8zgJifLKOvf7FrNuimwAWaeDm9KHTAqWMbgHZHXWaxsbb9N04cJh85bKHw52vaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oIgDt8Nl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oIgDt8Nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025321F000FF;
	Wed, 30 Sep 2026 19:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796465;
	bh=IhvEjzlxOyzoD7jTzJFP51CYuTp2TGWgRBTzNuDPZGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oIgDt8NlNvDUQIjXFw3nQyWd3cRGKGP4tvsyBwbMdXhyKFqtAs2Ntok45H0znlVXq
	 m1a6rF0QZL4fNLfqZcaf8KfsJ6ISIzEKPFdEPnDYJYd8H/pwHk5VtttSQlHYhpPSGT
	 0TL+NN7RKGpzUpvTKzjH2nj65jnnScGXlQwj0LWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 0923/1193] wifi: wilc1000: fix RX buffer OOB-write in wilc_wlan_handle_isr_ext()
Date: Wed, 30 Sep 2026 17:26:47 +0200
Message-ID: <20260930152454.749098774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -1040,6 +1040,15 @@ static void wilc_wlan_handle_isr_ext(str
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
 


