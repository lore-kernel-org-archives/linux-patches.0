Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6846D156C5E;
	Wed,  5 Feb 2025 15:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768398; cv=none; b=O/Hzb8cNLq6tESYxeWsIuvIgr0bF+j+5WBnJFy7AzZx6Q5HoVUvy9itaZKzbf/GMUnQ2f99lcqMXjUB8iWSEhvgOkBgkJcQDHeYYWd9mZelMzpvUVWmhj35N4CqVzNx7iIkGGBdp0SQhSP5QqUebFIGsUAnI/fINY2+E2KaOwKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768398; c=relaxed/simple;
	bh=SQPTs65JFDwS8ZzZw3eB1VOyQm2vw0wRPtf39v+ymKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4MNmEKhdXct30NOqDsqmFDDhBQvYiYNPtVC++zuvaAvcmFez7zSwcDq4UunhZBjI4X15X02c31mRyoCcmdgeO6i8FbJ0+peGyazxe8xydqbUDGQTW1YKUX7Pll9/ayCI5ZAJ801J53ZQpAsp+qIexRAa2Ma7gdsOnWkCZyQYjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y86P5Laj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y86P5Laj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F07C4CEDD;
	Wed,  5 Feb 2025 15:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768397;
	bh=SQPTs65JFDwS8ZzZw3eB1VOyQm2vw0wRPtf39v+ymKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y86P5Laj1OPQdYjtCaXd0CvrcFOniwIh0Y0OVxEgyEfucXxSlHDu57c6ZHBJ39d/H
	 TB5R1m5QQdN0cIVJ2ZQYgTl4U4U77N844cnZrhkJuNfSB9unkEum5H53p8uWm+jxCR
	 wiH/1ZrZl39Q6dCjMpoRyNyfHh0JoyCmg7KR25HE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 543/623] Bluetooth: btnxpuart: Fix glitches seen in dual A2DP streaming
Date: Wed,  5 Feb 2025 14:44:45 +0100
Message-ID: <20250205134516.996101028@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 1230045d78a5f..aa5ec1d444a9d 100644
--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -1381,13 +1381,12 @@ static void btnxpuart_tx_work(struct work_struct *work)
 
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



