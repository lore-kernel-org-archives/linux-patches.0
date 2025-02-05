Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C308151988;
	Wed,  5 Feb 2025 14:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766214; cv=none; b=mvDpQpKZou12Ai9C7DCVIAZBA2A7FhW+cT3MxXNnjStdAxnA1uK58lVgOh1YBfF24RvEBchsGI9Ex+40mB5N98fDYCA36a8jVJtn6gDPMVzCtAHjYSbLvU3+q90wnoT5qgqS/UK8Itu+fdlcFbPi1wWhu363o3mKJ+EHxJ1rabo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766214; c=relaxed/simple;
	bh=eU3ZvbkVE2Hd51EQmz+pdqPnxsxUFaoWsDl6hAzZebg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QceHO7MV4VD2lsysDiUtIijtEJ9luVGkaQCSW7lExAi9bzkukoHEAI72XDW0ngia3kONbI59HTfRCeFr4lcXNTY5lR+ZZPv4xp1aZYZcLm2OQjcFvaPSsLg+UzxNOk5PF4uKwrFpNtNU/FyQjXfMC1c8oIGlrcOzdEi03OGsIeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7TJwIBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7TJwIBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D911C4CED1;
	Wed,  5 Feb 2025 14:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766213;
	bh=eU3ZvbkVE2Hd51EQmz+pdqPnxsxUFaoWsDl6hAzZebg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7TJwIBqLziA2OTGbBJbF9FA2EFErQ84eqk6Nxf6QP7s8ni1LUwR6rE6B4dxH/4wF
	 IFL9tPEEKj4Eh4LfX54pDZ5PDS8ny7umDBAvSByoVVgu6bfVSYv5vZ/eBnCoRcY1Ly
	 zjCAyyiM7uovCkvPq5btF9j5SWxZQA1sfvtPCye0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 340/393] Bluetooth: btnxpuart: Fix glitches seen in dual A2DP streaming
Date: Wed,  5 Feb 2025 14:44:19 +0100
Message-ID: <20250205134433.320181044@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>

[ Upstream commit 7de119bb79a63f6a1959b83117a98734914fb0b0 ]

This fixes a regression caused by previous commit for fixing truncated
ACL data, which is causing some intermittent glitches when running two
A2DP streams.

serdev_device_write_buf() is the root cause of the glitch, which is
reverted, and the TX work will continue to write until the queue is empty.

This change fixes both issues. No A2DP streaming glitches or truncated
ACL data issue observed.

Fixes: 8023dd220425 ("Bluetooth: btnxpuart: Fix driver sending truncated data")
Fixes: 689ca16e5232 ("Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets")
Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btnxpuart.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
index e809bb2dbe5e0..a4274d8c7faaf 100644
--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -1280,13 +1280,12 @@ static void btnxpuart_tx_work(struct work_struct *work)
 
 	while ((skb = nxp_dequeue(nxpdev))) {
 		len = serdev_device_write_buf(serdev, skb->data, skb->len);
-		serdev_device_wait_until_sent(serdev, 0);
 		hdev->stat.byte_tx += len;
 
 		skb_pull(skb, len);
 		if (skb->len > 0) {
 			skb_queue_head(&nxpdev->txq, skb);
-			break;
+			continue;
 		}
 
 		switch (hci_skb_pkt_type(skb)) {
-- 
2.39.5



