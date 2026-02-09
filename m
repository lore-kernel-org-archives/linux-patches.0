Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517DE37756D;
	Mon,  9 Feb 2026 14:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648900; cv=none; b=qYM5/I7ORg1jCFfvND5F+yMqnpmrn5TdXcvPn0EZDE3jVDEaIBslBJ7pDGj8o0V0ORlyzPPHbfoYtF6vwEEIzyG7udGGbdh1CeX9H0VwiCDMC4KUiRh+SReUzWpc7kimCvuNju9DoHE9kXMrUac02p5ur/oVUHeKQS6X+sFr7/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648900; c=relaxed/simple;
	bh=HoZ/iEfjC0gq167xO13tmysaTAdmf6ggpT++RegJ5AY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZsKbPr8tGu6qnD95Nko6O7onjO7W7bwYqr6apuYNWFJ+KCCOh0szv9KP/gaFCNVCDtCfYJ3rY9yyZgoEphqtCMeQbrAzmjiVoetRcomZKCAdmYo5MkSTUCHSpBzzfL6KwzkMLY2z2xXVwHZ/AqPy1Julka2ruJ8qQWfjyL4P4F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fL+9pkZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fL+9pkZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E1AC116C6;
	Mon,  9 Feb 2026 14:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648900;
	bh=HoZ/iEfjC0gq167xO13tmysaTAdmf6ggpT++RegJ5AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fL+9pkZE+ilqd65V+6DryhicSBK3MqB6TDtxz+bC8/K/RxTBHRF74v4Y9tgHL48FJ
	 +tpSIOxsrJx0TTQERnDMtj5MQSJ6VgIiBdbrwsLcN1TqXmym/xFdbl4J284O+H4Gvf
	 c3W+ne+bS/3ql4Ky3RDFPcMije2DIKmVrajSylfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Zilin Guan <zilin@seu.edu.cn>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 48/75] net: liquidio: Fix off-by-one error in PF setup_nic_devices() cleanup
Date: Mon,  9 Feb 2026 15:24:45 +0100
Message-ID: <20260209142303.575090577@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 296e372f36f17..08326eca68bca 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3772,6 +3772,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 				&octeon_dev->pci_dev->dev);
 	if (!devlink) {
 		dev_err(&octeon_dev->pci_dev->dev, "devlink alloc failed\n");
+		i--;
 		goto setup_nic_dev_free;
 	}
 
@@ -3792,11 +3793,11 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
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



