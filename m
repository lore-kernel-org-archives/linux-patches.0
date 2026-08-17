Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7920C442118;
	Mon, 17 Aug 2026 14:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977010; cv=none; b=Hq92mA0dmb6ow/p7W5Cf7o3Uwr+hjo7tJEmfPM9yTVaR4ctXFdkVhn8qQr2FhF3X89X++NeOpH9NcvMOB52DrCROoGMG8UTTaeZDA9lRIkz9QJK7vo8oHI9SerfhC5w3B7Y5HVh6npG6aSBTULtsm+gr52JIBBcqQ8VLwmxmCfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977010; c=relaxed/simple;
	bh=OaFbI96z5bYRKB9A2KWR7pfJdiUP7+qPhuc+GalKbl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFp7k2RoK59xXFSlO/OtIRLrcLNvQum1AKkXQ/mtf1YsSkBKqnQEM8WafL8hCqjH2SGbl9WbTR20rWwZU4R0CRSUi2jQW6dn3XX+GZMeDgoXjWJq3eOFSDwkl4n7eSsVRRZW2x79sshT+2+RUJk6pRnvqXBEo7PJBSKd/+JXAUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYSseyyH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYSseyyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B396F1F00A3D;
	Mon, 17 Aug 2026 14:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977009;
	bh=VozOojdl2ArPdxhCrRLaBZ5GjRpqzJ5POpqXfdQP32g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYSseyyHdqg1hb0rsJ7H+L+nsZR6a0ukp4fnF+8YZM/VTPJz3rIJaq49krAGFX3nG
	 HkcANy07VtRfQ3hDJqZYi5iSgtfVEkubmfcBuWQurMDIku2FaTEMuvEaD7U/goxbru
	 oupHsGGIPnRzwuOArHac2rPPyeodvRIFdwJHgCeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huihui Huang <hhhuang@smu.edu.sg>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 180/456] wifi: wilc1000: validate assoc response length before subtracting header
Date: Mon, 17 Aug 2026 15:29:30 +0200
Message-ID: <20260817132547.169550554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
@@ -582,6 +582,11 @@ static s32 wilc_parse_assoc_resp_info(u8
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


