Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80C04E2F19;
	Thu, 17 Sep 2026 15:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659924; cv=none; b=CijUgPafSpyb3XOd7XjGJbvVWCLLNXaVSDhNF4X+NYLVNZE0AauFqxz8jFnr2SXvUnG8VuX22FcAVZkAkvThsF6CsEslqwBFQGnTNkQG8/OrHLsJskOhbSenQqN5yAoq7XpFvP62YVjUVXqnV0JpFoQZWim4el9K1bc4eU54dxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659924; c=relaxed/simple;
	bh=77BR37E+jyu3XalbZFiz6bURaDlfXWSELF000SpCBoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hin+eqT1/CP5Yt7lCZc7yBtsVcp+SYOBZgyoP/thcG0K2C1aO7dFAzmS4sXmY7y1U7Sy7P0o5yriefX5y5AT3IxuNqwXgQV8zahWHU5OlED0T7gh/+D/gmvPJWd2x9Iauxcer/Fz3Yiti44+9Y3CbA8TlKf5xiic9/cqwAyQMKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzkyASVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzkyASVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B241F0089A;
	Thu, 17 Sep 2026 15:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659914;
	bh=KgFIRXq0RQKmNoYZQlHcCDW67R0jTqnVG1TFlvlxo/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzkyASVwnSifo+GDIbkk4GbMFMaGiBMbnksfyhK1PX8w7G5t3A0xrgV/Udoi2JlME
	 hB3NGbZIqhXxWtJc/s09A0AdGPp7pnW2nfT19blyMlf/9o8Fv104EdnQz22jOCBMSr
	 fQki9faZtZz7C08RheCVJmDtmL94k90hvOvrP2SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 377/733] Bluetooth: btintel_pcie: validate packet_len before skb_put_data
Date: Thu, 17 Sep 2026 16:11:25 +0100
Message-ID: <20260917151401.057874238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 6436e1b5331b1aebf905c13e0880a37032719b75 ]

btintel_pcie_submit_rx_work() reads packet_len from rfh_hdr without
checking if it exceeds the RX buffer size. An oversized packet_len
can lead to an out-of-bounds read in skb_put_data().

Validate packet_len to ensure it is non-zero and does not exceed
BTINTEL_PCIE_BUFFER_SIZE - sizeof(*rfh_hdr), logging an error when
invalid.

This issue was reported by Claude Mythos. It can be simulated either by
using customized firmware configured to return an invalid packet_len or
by modifying rfh_hdr->packet_len in the driver before calling
btintel_pcie_submit_rx_work().

Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 6b6258d03dd84..da46fb39d53ea 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1537,7 +1537,9 @@ static int btintel_pcie_submit_rx_work(struct btintel_pcie_data *data, u8 status
 	rfh_hdr = buf;
 
 	len = rfh_hdr->packet_len;
-	if (len <= 0) {
+	if (len == 0 || len > BTINTEL_PCIE_BUFFER_SIZE - sizeof(*rfh_hdr)) {
+		bt_dev_err(data->hdev, "Invalid packet_len %d (max %zu)", len,
+			   BTINTEL_PCIE_BUFFER_SIZE - sizeof(*rfh_hdr));
 		ret = -EINVAL;
 		goto resubmit;
 	}
-- 
2.53.0



