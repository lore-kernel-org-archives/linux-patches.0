Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDDA36607D;
	Thu, 30 Jul 2026 15:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426236; cv=none; b=hONxDv6lC0oFuRxBpMJrZtX2oEUz463rWH0JZ8LtZgl0Syyq9dcmkxbMlwaJErkm+2ZP6el20BZKoviYnXtuCpe/jWqyBcbZd0ZTm1zvzIJ6MdBzvW6tNf0DSBwfB/rePyPdfz7PiWrbq0uD2TF2S2kSiOUE7XkEwPFnyX9MN9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426236; c=relaxed/simple;
	bh=0Vhlk0P5wD7ibmNM4djzb0/ZE7psqTTXKBfP1Jx37aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLYMuA04YSFm5UWBu/mUorTQ0K9Y3hr7eD5Ri4MJKvIYYkVNu0AWQyascBdCKhRjZpsk2S4g1bfcl+hmv5AB7iEQjjPrvrG1nKz3TAax1AFBVclWrkFLe9X8VhYHFagW+jn7QKwgC8RgcxkXjoyoLQndr7yBRXJVe3k7xTIO0QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6MMIRIl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6MMIRIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9831F000E9;
	Thu, 30 Jul 2026 15:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426235;
	bh=yORcYMdtFCEVkebK+/tGV/VR/t5QUXRyYSiXIHh07r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M6MMIRIl2fJe2/eax3CHBNYK/mqiwfN/xmgIHI8qfY24Ov/k0ps8G289Yuiew9mvr
	 zrIRaWq/Geo7LjjriBxCgePDrMW/PtUyzaEOmBuPOgCWaSpNw1q09fgDQ/x7mYzU8J
	 6zYnIvFUftkMFQ0tzdrzre0W2CSRKMVKZpjraK8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huihui Huang <hhhuang@smu.edu.sg>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 348/602] wifi: wilc1000: validate assoc response length before subtracting header
Date: Thu, 30 Jul 2026 16:12:20 +0200
Message-ID: <20260730141443.272159914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Huihui Huang <hhhuang@smu.edu.sg>

commit 4c4c97b60a5e978121d9ee8cb0ab3916e5d6a8de upstream.

wilc_parse_assoc_resp_info() computes the trailing IE length as

	ies_len = buffer_len - sizeof(*res);

without first checking that buffer_len is at least sizeof(struct
wilc_assoc_resp) (6 bytes). buffer_len is the length reported for a
received association response (host_int_parse_assoc_resp_info() passes
hif_drv->assoc_resp / assoc_resp_info_len straight in) and must be
validated before the driver accesses the fixed header.

For a frame shorter than the 6-byte fixed header, the subtraction wraps.
For a four-byte response the result is truncated to a u16 ies_len of
65534, so kmemdup() then attempts to copy 65534 bytes starting at
buffer + sizeof(*res), beyond the valid association-response data
(CWE-125). A response shorter than four bytes can also cause an
out-of-bounds read of res->status_code at offsets 2 and 3.

Reject frames too short to hold the fixed header before touching the
header or computing ies_len. Also set the connection status to a failure
on this path: the caller falls through to a
"conn_info->status == WLAN_STATUS_SUCCESS" check after the parser
returns, so leaving the status untouched could let a malformed short
response be treated as a successful association.

Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Huihui Huang <hhhuang@smu.edu.sg>
Link: https://patch.msgid.link/20260714091811.3596126-1-hhhuang@smu.edu.sg
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/microchip/wilc1000/hif.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/microchip/wilc1000/hif.c
+++ b/drivers/net/wireless/microchip/wilc1000/hif.c
@@ -600,6 +600,11 @@ static s32 wilc_parse_assoc_resp_info(u8
 	u16 ies_len;
 	struct wilc_assoc_resp *res = (struct wilc_assoc_resp *)buffer;
 
+	if (buffer_len < sizeof(*res)) {
+		ret_conn_info->status = WLAN_STATUS_UNSPECIFIED_FAILURE;
+		return -EINVAL;
+	}
+
 	ret_conn_info->status = le16_to_cpu(res->status_code);
 	if (ret_conn_info->status == WLAN_STATUS_SUCCESS) {
 		ies = &buffer[sizeof(*res)];


