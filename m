Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8FD29A31C;
	Mon, 23 Mar 2026 13:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274233; cv=none; b=V67ksTfDj3kWywtVSCVvqiTM0510VVzqEV6ikqOHQHGsRojRDplbsyO6FT2L659G/nYfn8sjUfLGzv1U5nn1EocFKHHkeFRrhZjpkyl9r27t1IwZHYag1Polagsqeb8GOeXyZCfFDdSwkRAksvE8gecXxhfhEXWfF57iO2Z6kYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274233; c=relaxed/simple;
	bh=xT+W8LNa+SmZxjNYfi52eV9AQ/cA4Mz1GtY3SZgrXBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGqsu9azqfJwqYTPsQ+ep+E/FLWHVdDDPbB98mImAcQotuS98VD1b/hkAkIB8yAXCGBko7U86E4zz9dOPAKKqe3Rmi/mivTPTaBDjZap2sbmO4y3tJ4yWOkDd31OREGSfHJ9lcm50ZbIQHh6Y6TS+FpwNTxPotfYxjyLlGXdshU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d11MMBDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d11MMBDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265F2C4CEF7;
	Mon, 23 Mar 2026 13:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274233;
	bh=xT+W8LNa+SmZxjNYfi52eV9AQ/cA4Mz1GtY3SZgrXBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d11MMBDG8UvkcZMxkGCZ1L2nhKULhvFmChKrZ0/a7/CQoUUVyAgHvahFHnUzHy/YL
	 owocaterJpmcDEuMCBhgX972g98Ai5WxQQXa/8+s+l46vwYVT4jA69yOY0kQadAMvV
	 pX6RsS+op9nORbRDOkJX86mybbicKf5/3s6tc9WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 151/220] net: airoha: Remove airoha_dev_stop() in airoha_remove()
Date: Mon, 23 Mar 2026 14:45:28 +0100
Message-ID: <20260323134509.354791512@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit d4a533ad249e9fbdc2d0633f2ddd60a5b3a9a4ca ]

Do not run airoha_dev_stop routine explicitly in airoha_remove()
since ndo_stop() callback is already executed by unregister_netdev() in
__dev_close_many routine if necessary and, doing so, we will end up causing
an underflow in the qdma users atomic counters. Rely on networking subsystem
to stop the device removing the airoha_eth module.

Fixes: 23020f0493270 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260313-airoha-remove-ndo_stop-remove-net-v2-1-67542c3ceeca@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 315d97036ac1d..c37a1b86180f3 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -3080,7 +3080,6 @@ static void airoha_remove(struct platform_device *pdev)
 		if (!port)
 			continue;
 
-		airoha_dev_stop(port->dev);
 		unregister_netdev(port->dev);
 		airoha_metadata_dst_free(port);
 	}
-- 
2.51.0



