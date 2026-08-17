Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6ABB422541;
	Mon, 17 Aug 2026 15:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979428; cv=none; b=Wir1GPvS4gkc70oHfiiXJ2NF7GVotbnSTZfCvZZZwbPV75/2DLXXVhlJ+CceLiiMAUGnq0aywxNCBqjGg6XFCSjMMAUYeyNzXF1c/fJrd4mBCJWKH+hWn0vmZf+9klZsmfArqiIN0S+nU83KMRvB1Wktq+nJ47VGDPIMQLq7LSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979428; c=relaxed/simple;
	bh=qezjCihkedr9OaTbvvjbvTraknOrrQPlDvVG4OGTLGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9JghVA5DgB+yiuySVikI0Gb1CXoLLBE/WrNNmQj6vRsBQdFly8DIFocSXatjUdtEw04+su7dZpU4Ak5dDW4plIH+ATzxXOqfZiP/egp9tXJoObgtppEoHtgX5oqCithjHu3S2Wl5G7g7iSlLtvYKs1UUKnUIxx+GLAbgYC+pwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjs5htRs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjs5htRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA9C1F000E9;
	Mon, 17 Aug 2026 15:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979426;
	bh=w8ZNryHR3HBYt+HdmK3kttV9wu16JSVMj74toeyioNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zjs5htRso+U9tB/vhHdpdGDpw4V0qYUOUXd4TvAVoitsY+Tcacs1CVz43az+TH8k1
	 2RKANMoUxgA/HquFbvWxswDDEwo2uXpnevS0E67WWX71IdShWhWTy6RqQuH4PIi4rC
	 MAcgQE8s18LL0h03mkdY10xo5vSzT+DplbaO9G1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huihui Huang <hhhuang@smu.edu.sg>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 221/609] wifi: wilc1000: validate assoc response length before subtracting header
Date: Mon, 17 Aug 2026 15:28:37 +0200
Message-ID: <20260817132551.485625105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -597,6 +597,11 @@ static s32 wilc_parse_assoc_resp_info(u8
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


