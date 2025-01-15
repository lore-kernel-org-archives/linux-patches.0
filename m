Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E091E9914;
	Wed, 15 Jan 2025 10:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937961; cv=none; b=ic5J+vylgwdEAl9GAp15ramOwKDF8KqBN0BNrIN+p8Jj37RpTfYvwbkadhTY74Q7TMw2Kybe2tCJy/20RIeHZXRSqXYnvM9dQnyOHkj07h8C0oCPmgPpnjB72N31WwFgLDDpQ9hgbO93DysLmr2WogRcYK6pufjpRK4dDOmPI5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937961; c=relaxed/simple;
	bh=pKDYZ4qi9ZFh28pXm53S0K3UoARwG+0H28+DJu9v6pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibqmsSx5xCYXW/5yDq3Oztui4qCd8tGxg93Msnz9QAFIetCpW1QhsfLzdejQnPyp9kPpB/j8eGkUmzGBuGm5A//ylJuThkiqwcMNbJEJfW04Jvrq7ubjS6V0si/DUOTD31MtDxLLLn6bfAhl21TvNO17TIl7gd5bDEABwqcGS0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQ8ZLoDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQ8ZLoDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67480C4CEDF;
	Wed, 15 Jan 2025 10:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937960;
	bh=pKDYZ4qi9ZFh28pXm53S0K3UoARwG+0H28+DJu9v6pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQ8ZLoDlpVHzXvkTLKW6mgoGMftB29RFNryIgfB2i56L7kK1+YhZqk3+toizTRYft
	 NiUZDzno+g3CjUq7W5vKcZ9sTUuOfZyQ8bkLsXz1txVOdtyRqS6Gqd42daGauuoCnJ
	 vl/jEqSXPtSlB5nEmbTPW2wrgRPEa2GCZgSe6e5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/189] Bluetooth: btnxpuart: Fix driver sending truncated data
Date: Wed, 15 Jan 2025 11:35:39 +0100
Message-ID: <20250115103608.081219217@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>

[ Upstream commit 8023dd2204254a70887f5ee58d914bf70a060b9d ]

This fixes the apparent controller hang issue seen during stress test
where the host sends a truncated payload, followed by HCI commands. The
controller treats these HCI commands as a part of previously truncated
payload, leading to command timeouts.

Adding a serdev_device_wait_until_sent() call after
serdev_device_write_buf() fixed the issue.

Fixes: 689ca16e5232 ("Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets")
Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btnxpuart.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
index 5ea0d23e88c0..a028984f2782 100644
--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -1336,6 +1336,7 @@ static void btnxpuart_tx_work(struct work_struct *work)
 
 	while ((skb = nxp_dequeue(nxpdev))) {
 		len = serdev_device_write_buf(serdev, skb->data, skb->len);
+		serdev_device_wait_until_sent(serdev, 0);
 		hdev->stat.byte_tx += len;
 
 		skb_pull(skb, len);
-- 
2.39.5



