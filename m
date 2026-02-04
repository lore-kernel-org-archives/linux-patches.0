Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88E94218BF;
	Wed,  4 Feb 2026 15:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218612; cv=none; b=swaXwcW9E2FMXxpv0Qkuqu0U3tcmF4OYZYRnSQM/KfYRQIKhuqqUm5j8EHJok6t8rscP5j+aWpUdon+Pq63640JrFRr5vGGiRp/w8RtZ0r4Dp05JyO9jCw3ZGhVCDLFG4XR9x36nadw385SDypooAii5wFFsXxKtdbJgSfzCzK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218612; c=relaxed/simple;
	bh=6E9gsXtv0OklGAfHHJWmO06Yl18G+IIiLO/0eKIPlDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stX/Lfz8rkJvUsuOW4M1CroCLBQqQgHAimeQ0fq9QUGtHUVf03ZXFgX7fnOsmcumg4fP7DRmvJ2eUoiZDSyXCXGkMIrvD2fuudAjXNgdslSmbaX9QB281lsuOjtpfREQod+TYUPBFVzdwClZrvKoiJL2fkxf1yJ+U4t4QNbjJfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8Lq8/dU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8Lq8/dU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AECC4CEF7;
	Wed,  4 Feb 2026 15:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218612;
	bh=6E9gsXtv0OklGAfHHJWmO06Yl18G+IIiLO/0eKIPlDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8Lq8/dU8sjIL51vQY4EKwbiCQ5EtgtkGsW87DMF2FtamJyK1RBKbgICD1JwVMoOj
	 4G5y7LbQNPnxT/FKthuvQiOQFTlXhcp4g2NP8iwFKuxO7j+xEIRIBACbkca0i53YwA
	 1RTi3SqDKXlG8fB4Sx5Jfb3vK+t6CSLnOHWx2WKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 01/87] can: at91_can: Fix memory leak in at91_can_probe()
Date: Wed,  4 Feb 2026 15:39:59 +0100
Message-ID: <20260204143846.963034595@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 0baa4d3170d72a2a8dc93bf729d6d04ad113dc72 ]

In at91_can_probe(), the dev structure is allocated via alloc_candev().
However, if the subsequent call to devm_phy_optional_get() fails, the
code jumps directly to exit_iounmap, missing the call to free_candev().
This results in a memory leak of the allocated net_device structure.

Fix this by jumping to the exit_free label instead, which ensures that
free_candev() is called to properly release the memory.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 3ecc09856afb ("can: at91_can: add CAN transceiver support")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://patch.msgid.link/20260122114128.643752-1-zilin@seu.edu.cn
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/at91_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 191707d7e3dac..d6dcb2be56342 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -1100,7 +1100,7 @@ static int at91_can_probe(struct platform_device *pdev)
 	if (IS_ERR(transceiver)) {
 		err = PTR_ERR(transceiver);
 		dev_err_probe(&pdev->dev, err, "failed to get phy\n");
-		goto exit_iounmap;
+		goto exit_free;
 	}
 
 	dev->netdev_ops	= &at91_netdev_ops;
-- 
2.51.0



