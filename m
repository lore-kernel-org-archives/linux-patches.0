Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1343793BF;
	Mon,  9 Feb 2026 14:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648244; cv=none; b=Vpm1HmnczZwZYKg5lRV4FV2thCTpyzlkSfN75tGDaebRFTaecO7Bmeu0aK4Yc3KePWs1guchhXDiqCUtrxvraWJH2+lUH+bo+Lg1Wfru3fGV17Vdn5OUidNQDDX3vXnAOS+lep7o/CNTE2KERMpLfV4NmLiFTzbQJnc2GY/2n9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648244; c=relaxed/simple;
	bh=ZbryV2NngdVfJo7fMO/Suo1yi4Sn4SVEDz4moKcb8d8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmZFewT7rSHgUBA1zV7pMEFcOybHDgAxLeYRh7o6upbSMZSpTUZYl2oooJolmmRsjc/hKRjAeFY3Wt4kGKmQEOJ4bUAMVqPuavS1bV+jSLF81v5l/gIlTKdd4Bn4UeI3EcFHADTzLJjDP30X7904ip49UIRUq+RP+/JC9VbGsG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5jGHdT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5jGHdT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFDAC116C6;
	Mon,  9 Feb 2026 14:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648244;
	bh=ZbryV2NngdVfJo7fMO/Suo1yi4Sn4SVEDz4moKcb8d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5jGHdT3bkD8wUE0hBeQpo3YKI1jZa3oEaKcq05j8XllH40kA10mFwn07BRMyy9gu
	 y6L4fOK4Zb8qZRyz9FKxfRYc7yuAT112GInax5dyGDOU2EOei023ZT8dYBXBNMDffD
	 23anpWb0rDzfIzU8JgrRtVW/7H2N9tPocyUuw/aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Zilin Guan <zilin@seu.edu.cn>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 50/69] net: liquidio: Fix off-by-one error in PF setup_nic_devices() cleanup
Date: Mon,  9 Feb 2026 15:24:18 +0100
Message-ID: <20260209142303.723611050@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 8558aef4e8a1a83049ab906d21d391093cfa7e7f ]

In setup_nic_devices(), the initialization loop jumps to the label
setup_nic_dev_free on failure. The current cleanup loop while(i--)
skip the failing index i, causing a memory leak.

Fix this by changing the loop to iterate from the current index i
down to 0.

Also, decrement i in the devlink_alloc failure path to point to the
last successfully allocated index.

Compile tested only. Issue found using code review.

Fixes: f21fb3ed364b ("Add support of Cavium Liquidio ethernet adapters")
Suggested-by: Simon Horman <horms@kernel.org>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20260128154440.278369-3-zilin@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/lio_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index f27393c84ba48..131996fd5406f 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3770,6 +3770,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 	if (!devlink) {
 		device_unlock(&octeon_dev->pci_dev->dev);
 		dev_err(&octeon_dev->pci_dev->dev, "devlink alloc failed\n");
+		i--;
 		goto setup_nic_dev_free;
 	}
 
@@ -3785,11 +3786,11 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 setup_nic_dev_free:
 
-	while (i--) {
+	do {
 		dev_err(&octeon_dev->pci_dev->dev,
 			"NIC ifidx:%d Setup failed\n", i);
 		liquidio_destroy_nic_device(octeon_dev, i);
-	}
+	} while (i--);
 
 setup_nic_dev_done:
 
-- 
2.51.0



