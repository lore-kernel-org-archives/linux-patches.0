Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F054BEE24;
	Sat, 12 Sep 2026 14:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225096; cv=none; b=n1OGAVtXWItjxP/tsUz+rY0wwaqoZ46FxEwgupFRQcP+qYKwiV4WWdyloIFtpI4fpyDfiXkHf0W/Em3WRd6noRB2S2NJ8emLtXAdyqfPYr9K83o67rCP2UrTvd4TWzaz/gHfAZmvPtXSAodsTtXUeOpT9yEqjqti7L1QyOkyoLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225096; c=relaxed/simple;
	bh=XzkceJtUA1UMUrU7/0eilrg9Q2zOqOU0oyXw5aeHTT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eghglazWvkPh+1oCxHkn2hOFeuaIoQLSh35YFOHg7T4CbvV9ujUYLSjEGvkWbdbgnS/05jxuSvNDygfs5eSO6+0p5DDX+tLmX8P8d9X4X+VF1dRystdqWyJxVcBMcaWLoaJ0UYarw1lxdIwb/nxrdFARONwip2XUmyHrqS/lZwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCcyPj75; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCcyPj75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425821F000FF;
	Sat, 12 Sep 2026 14:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225095;
	bh=u2qpZplxHra6SI7Y8xk5cdJRhGf7Z4DDP6TVaNkBu1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCcyPj75/Jm3aqIFCeYYdajkbMflLSQSzH+jB97+PDz/yy+HMdNkzs2JMPiEpGXlR
	 boHtlvC7T6og8iqjThYJ1sL5ymCpq88fTi4vBkcrjUdCeItI8A8OEGzoeCzHs57Sgu
	 YrVtxaJP/egN1GngwQxRmwrqKqs8mXUcd68gu5Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1127/1424] Bluetooth: btintel: Fix diagnostics event detection
Date: Sat, 12 Sep 2026 08:59:19 +0200
Message-ID: <20260912065632.537773009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 4784da07dd8a1..43ddde0a4d48c 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2983,7 +2983,7 @@ int btintel_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
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



