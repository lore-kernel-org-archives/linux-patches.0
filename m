Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365A72ECE9F;
	Tue, 15 Jul 2025 13:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587174; cv=none; b=p4qmBayvlkheBOXhOwOYqAzdH8olND4jY/2pcA4LK37nkqYO/95IHBdRBhXka7lVecq90eb0lkXuABI69RIBREUOEaOCa8UMAEfpJbQ0cH6dsbcjTQ0qvs0qCwAqHAvyg3qByLVUsHR1oE79xx6//jvys6M1ZRZNLbR6h06AeLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587174; c=relaxed/simple;
	bh=HjmddSVkdxvF0yQjFRCPA7xuPDMNFpyw8xJ7Kyoc+hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pca2FJRAH/FBT3W5jsFJgDWERlNNLK0aYFvQ+Lj6E7hViaL6FLwOjCbyIw5RU7nzDqPFMuZNb7gWv9/VBjCwIlDfExZLwydzTAfE58Efox+3YyFMTNmHCEGHD+3ylQ4Iobx0mvU3ohd0QNe46lCTTUCWCRwt5YY8bDgv9Q48k8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13PhUPZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13PhUPZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEAC9C4CEF7;
	Tue, 15 Jul 2025 13:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587174;
	bh=HjmddSVkdxvF0yQjFRCPA7xuPDMNFpyw8xJ7Kyoc+hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13PhUPZRCtsp3G8ONkEBmRPZZskIZifVJSvKvF8mnkqHFzLMoi6Q6gHvmGS0cRoM3
	 4I1jmGcWAdE130TfKsPoA06hSIVm2kVEw18z6CEqc2eTnDqf6ETEQL0n9MDoOUMkQA
	 3uKLesysnTfOMktNSJM1/ZhQP8cBiMQvzLJQYZeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 163/192] net: ll_temac: Fix missing tx_pending check in ethtools_set_ringparam()
Date: Tue, 15 Jul 2025 15:14:18 +0200
Message-ID: <20250715130821.457664873@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit e81750b4e3826fedce7362dad839cb40384d60ae ]

The function ll_temac_ethtools_set_ringparam() incorrectly checked
rx_pending twice, once correctly for RX and once mistakenly in place
of tx_pending. This caused tx_pending to be left unchecked against
TX_BD_NUM_MAX.
As a result, invalid TX ring sizes may have been accepted or valid
ones wrongly rejected based on the RX limit, leading to potential
misconfiguration or unexpected results.

This patch corrects the condition to properly validate tx_pending.

Fixes: f7b261bfc35e ("net: ll_temac: Make RX/TX ring sizes configurable")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250710180621.2383000-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index edb36ff07a0c6..6f82203a414cd 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1309,7 +1309,7 @@ ll_temac_ethtools_set_ringparam(struct net_device *ndev,
 	if (ering->rx_pending > RX_BD_NUM_MAX ||
 	    ering->rx_mini_pending ||
 	    ering->rx_jumbo_pending ||
-	    ering->rx_pending > TX_BD_NUM_MAX)
+	    ering->tx_pending > TX_BD_NUM_MAX)
 		return -EINVAL;
 
 	if (netif_running(ndev))
-- 
2.39.5



