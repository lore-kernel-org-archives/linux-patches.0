Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCC313AD11;
	Wed,  6 Nov 2024 13:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898944; cv=none; b=dUAw1/HAo5cC7dvhr1lT/7AxJDGb0Gv3lffdoH3UlqMNyBuzhxvmy2RGA4YlC05kIiNxjgNGfJNBmxNyrt47V3ZqvSoLtfQ/imPaQHL7t2hyBJNJ4Muh7a0VQ8aFSEUTOoguIamHAOCrIE0tqXH1bNSn4WJ18Ic9BLomEpbfzC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898944; c=relaxed/simple;
	bh=914iGohhaNqac4wz4q02EVLq88qNIGdb0PqfiCDvDKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QczBmBt3lB3NcsQN8htOmx3EXYFHmuJ7rYjGenPyXUuq8JK+UHd0e6e4jNKCgbALGEx9Ou/pYS4ZXBIhJBk7ruXfITcwuxRkYOGwBaYQb/qWffgiPvaNLc9MSkgq0tDZlvjlESmBSvbhFPsJg8Wog7Wswy9/7C8T3CtFNDEjoC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZkH9thPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZkH9thPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF83FC4CECD;
	Wed,  6 Nov 2024 13:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898944;
	bh=914iGohhaNqac4wz4q02EVLq88qNIGdb0PqfiCDvDKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkH9thPfeYiiSpUZIAwcwz6APagzI0e/RvNTaq4q+zsDhQgg8/8XRFOshbmX1Ucjg
	 lKi+EmUrzzw84aZNlGZATPlEh/X9jAPErU3CHeRzJSIcRB0JUi0B2LT25rRTB+3A42
	 TdzNHF+aepP6fj/IgRWl24du5iVbIcFekZxjwHVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 408/462] net/sun3_82586: fix potential memory leak in sun3_82586_send_packet()
Date: Wed,  6 Nov 2024 13:05:01 +0100
Message-ID: <20241106120341.601146164@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 2cb3f56e827abb22c4168ad0c1bbbf401bb2f3b8 ]

The sun3_82586_send_packet() returns NETDEV_TX_OK without freeing skb
in case of skb->len being too long, add dev_kfree_skb() to fix it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Message-ID: <20241015144148.7918-1-wanghai38@huawei.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/i825xx/sun3_82586.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/i825xx/sun3_82586.c b/drivers/net/ethernet/i825xx/sun3_82586.c
index e0c9fee4e1e65..7948d59b96282 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.c
+++ b/drivers/net/ethernet/i825xx/sun3_82586.c
@@ -1015,6 +1015,7 @@ sun3_82586_send_packet(struct sk_buff *skb, struct net_device *dev)
 	if(skb->len > XMIT_BUFF_SIZE)
 	{
 		printk("%s: Sorry, max. framelength is %d bytes. The length of your frame is %d bytes.\n",dev->name,XMIT_BUFF_SIZE,skb->len);
+		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
 
-- 
2.43.0



