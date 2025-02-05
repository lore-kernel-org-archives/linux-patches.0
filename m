Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F01DF59;
	Wed,  5 Feb 2025 15:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767802; cv=none; b=qELV85E5q2xwVgR8vLtNKR8G2lOIrOp5VUab3zCeJEUcFj70pex91glbEmmVZqyNM6azwtZWGgMbTeHhtUm9FK4auOYmTb7LXRd04aVkz2JATbgwVv7y0ESoGxSNmUpYfHWozQ9MXIaMQzOgogMol/BBBOj7hHEgbFkchnbMgnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767802; c=relaxed/simple;
	bh=qgwZbc7uvK0MukDj52mvVMk72MWtfu4MGhYEq9KlokY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgjFk8UturP8x3aUVdTHahlPiqVx9WNROgQkEljT/7uuHV0hI85S6uPnsI7Ww7d3K6o4SIRAe5gaW0C+8XwCLLnFO51EkWEl3HEtnmsFYsHo3SdtOdrstf+P5Wdd18MZhGkdH+r904JmPRQovVzalGetuA6I6dyQcJg8y5yHYdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgGF1JI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgGF1JI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76871C4CED1;
	Wed,  5 Feb 2025 15:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767802;
	bh=qgwZbc7uvK0MukDj52mvVMk72MWtfu4MGhYEq9KlokY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgGF1JI/yc5YKVeSjSGgV1nkPc+Z/HwBgcRvpgfpYTfbVVWxeErcUCvp9GAZaAZ/y
	 2bnGdv1F1KcjwJtKNcCpN1shXGIPoq7O83wc2X35Ut73NijbhYLP1xQwfDcCcNWgjT
	 R2PtHnhVnKu0yLH3o8F2FlvivYBDEBcbFQaiTPos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 511/590] Bluetooth: btnxpuart: Fix glitches seen in dual A2DP streaming
Date: Wed,  5 Feb 2025 14:44:26 +0100
Message-ID: <20250205134514.817827293@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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
index a028984f27829..84a1ad61c4ad5 100644
--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -1336,13 +1336,12 @@ static void btnxpuart_tx_work(struct work_struct *work)
 
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



