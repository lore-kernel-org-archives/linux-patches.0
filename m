Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E36248BD0;
	Wed, 15 Jan 2025 10:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938589; cv=none; b=LtfdTqEAHg/5WYcTEcrFYjoKUc3s/0p4LAfwvPHf1TXHY3ssCuj+9dPgW0xGABh27oRa+OZWizXM+kCikFOxugeRnDkCndVywQi6/g/KJWm/6oNdUxn59CbI0PvyT9AcWQzsxbAkLAxjY7OQxlobNd7/PBFlayhTU8b+9fKxifQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938589; c=relaxed/simple;
	bh=+KDXXAJzNXR95v97iEsrX73ZtB7YsFchnFIiNc2wwog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzidVsBv7dPhrmphW4ucv20LFutWuLRxdZPxa0AxhZexzBgfQ76NshXugPOemndf+lOyQHE3zadymGm8s9soGzfVp47usct3URcmw+XfFTSKsgInxFYH/Sy4DiCPgWctBX7zhCQ8g5hDUIHKCL0Xh7+9bE5us9h7J385/U1hnRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYPhq4Gd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYPhq4Gd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DFEC4CEDF;
	Wed, 15 Jan 2025 10:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938589;
	bh=+KDXXAJzNXR95v97iEsrX73ZtB7YsFchnFIiNc2wwog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYPhq4GdALeKofjcWiNft7m3eAVyqRfHt+Fc3RbK6k3pHAaSa2sACUNmwhc4qHJsN
	 stpySXhB+UblO3H+9OklZ9DuSuTM6GNmgly3jVdZhdYXPLlLPQCvK0R8GrxX2/IBU0
	 FSd9tQDgN6Ci2HekA8fbgvnIZ1GE0Rwxe5TvtqKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/129] Bluetooth: btnxpuart: Fix driver sending truncated data
Date: Wed, 15 Jan 2025 11:36:51 +0100
Message-ID: <20250115103555.816741763@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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
index 5ee9a8b8dcfd..e809bb2dbe5e 100644
--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -1280,6 +1280,7 @@ static void btnxpuart_tx_work(struct work_struct *work)
 
 	while ((skb = nxp_dequeue(nxpdev))) {
 		len = serdev_device_write_buf(serdev, skb->data, skb->len);
+		serdev_device_wait_until_sent(serdev, 0);
 		hdev->stat.byte_tx += len;
 
 		skb_pull(skb, len);
-- 
2.39.5



