Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74F82D5926;
	Wed,  4 Feb 2026 15:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218948; cv=none; b=ZLxq8GlygnMAFI+Qf6WrRu63HRsxLnLOrloYrWFRCtarVOhW3sI17/gLK51axkV97/ZygoeZfOZp0veUCMnRlxU8eiS80UvgUReTyiV6QCoxMpZ5MRtufXA+4NimZdtnEBFMfBxQRS5fGMKssbhu5DUpH3laeJUhH8mcVAES09k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218948; c=relaxed/simple;
	bh=6/ChFsO9rdI7f98uaUQey9r7Nh0nL2AvqHjc1jLMxro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwSuqaQW6zq9WX5NummnY/4i30SuDKy84uHqKNR2Lv+wSPDxoSNdEINo8sTHVqpnZXDPukEgN0QPS7tBkyXxexPjov1cJNm7QgdsWUK9Pe0CuAhwS5mZVU+u3gBCgdSmdNySCvyoctKpeho6RLLyzaeIs+wjHLad5kzzF0ymylk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kx6izNyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kx6izNyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECCDC4CEF7;
	Wed,  4 Feb 2026 15:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218948;
	bh=6/ChFsO9rdI7f98uaUQey9r7Nh0nL2AvqHjc1jLMxro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kx6izNyLSBFgKAPuO8LDBvnEYozBiMM6jEr2avhtyK8JElUl3d2XDIPqPfs5ySY1T
	 dwjM6tH+OqPtfu6zEOA4yc/mHU7c3LEihltAG46GUP2Pfs7yprCEpyidTsCJDe3mEt
	 fOgmPMN6lr+raxyXPh01R0eWNnSfFDZIv2We/1ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/122] can: at91_can: Fix memory leak in at91_can_probe()
Date: Wed,  4 Feb 2026 15:39:45 +0100
Message-ID: <20260204143851.986205653@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



