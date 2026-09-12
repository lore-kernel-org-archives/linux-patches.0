Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9D6202F71;
	Sat, 12 Sep 2026 12:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217662; cv=none; b=KzCXedp6FcYeKQ9JJQ5OL8//Vasy4fL4CaZCzrsmUeEcVhEX81qhsXgs/Ba3jBqywmxCZOC/iQm9HVFIUHWC5SOZzjml2JT1fo34cdJdHSXkWlnE9UbJ45V/etMkReR9R/q44f3cnfDsdpSi/79PqLViwaLIatt5OqpEQQRGUFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217662; c=relaxed/simple;
	bh=/j1HvIFvn2uRHHzWIgvsEJpLn1xUk4k3IuGIQPjkPQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ky04Uav/CBlSvc1403q8g/sXXwyCaVoVo4h4LVHIiu+rxc52DUtmi5aUdxKBd1SzlBpwAbdYcsBPeiPcYg30+SepKW7sb2eGJAWRWU+SDKqdrP9FrleLwrQx3YMzPLB2Sh4DQQ4/WdEsrKN/pYQ3EbEGqPYHTCq1LIOZ12VXKD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xa5vKyuZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xa5vKyuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A20D1F000FF;
	Sat, 12 Sep 2026 12:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217660;
	bh=uVYCNeK58ObM53+nQaG/hE6pO/VbElKbVpX4+wtKG0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xa5vKyuZ7QZd3+TLfRz7aJoL+toatNbHy7Rvh398qYBuy+rNUMXell3vHaUlkHfnF
	 xTmmMse8QC3knVzh8hQKU+GxqL93cuz3s8bc1/FPILY/EATBRAOIyPu6oo+UwlK45B
	 FVPluUJXDTdffMX2bnPX5uvEgFt/CM69ocqBl0h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0986/1376] Bluetooth: btintel: Fix diagnostics event detection
Date: Sat, 12 Sep 2026 08:56:52 +0200
Message-ID: <20260912065629.543048981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit ad0e7ac7da9a9a0095570bd6add3e27f259de104 ]

For a diagnostics VSE, diagnostics_hdr[] sits at the start of the event
payload, skb->data[2], but btintel_recv_event() wrongly guards its
memcmp with @len, which is measured from skb->data[3] for the earlier
INTEL_BOOTLOADER check.

Fix by using (@len + 1) instead, which ==
(skb->len - HCI_EVENT_HDR_SIZE) exactly.

Fixes: af395330abed ("Bluetooth: btintel: Add Intel devcoredump support")
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index cb948423a9bd8..c63246a60c6be 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -3399,7 +3399,7 @@ int btintel_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 		/* Handle all diagnostics events separately. May still call
 		 * hci_recv_frame.
 		 */
-		if (len >= sizeof(diagnostics_hdr) &&
+		if (len + 1 >= sizeof(diagnostics_hdr) &&
 		    memcmp(&skb->data[2], diagnostics_hdr,
 			   sizeof(diagnostics_hdr)) == 0) {
 			return btintel_diagnostics(hdev, skb);
-- 
2.53.0



