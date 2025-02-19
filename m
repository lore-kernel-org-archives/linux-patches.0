Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6181E0DDF;
	Wed, 19 Feb 2025 09:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956583; cv=none; b=H3uPnfRvvitkM9ruqqUt3waO66ochealxhZWNeW9lzvw5ePl7zBMXVNsTPnC+kljOp7qBPHiLMUpQj7IfZu918WsxRVzIz6gQovjvJBPMiWF/+OSLWbYA25P0yjaB6hO0h2Q3D1KsJ5XrinzU09s3z7AF0uI59/sCV9Bo5JcsZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956583; c=relaxed/simple;
	bh=ISGSWjs56/s854FXRyQ/ofnmMQkeMljXGk0G/QDGffc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bHlpcrONBlrEUaFydJTxF+hJzwXtI2ASDudIjHAg/I9MxkT9Qnd6+kEyRFtNSLBoPwp9zfB21qVzEvKo98OuzT1K1rtqEZmrwU5tkSIb/Yte7qSVfDqMajvtZEQgeNdql2BJhAS/mPgp7VlFwPhYe7GTppEJrVZzGA04SfiQXVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2rQsCef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2rQsCef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEE2C4CEE7;
	Wed, 19 Feb 2025 09:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956583;
	bh=ISGSWjs56/s854FXRyQ/ofnmMQkeMljXGk0G/QDGffc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K2rQsCefjmYLR10PCW6nDOoSkQl/HyEGuz0jgW2GP1FeFtylT0lJbY6zWa0ccCqeW
	 j3bse+3K7IFtubaSG54UZgbnGB7zixEwTQQXq0ZNAMmOLw87FHCFN6gs3DzhKleDJS
	 o4vKLoPMfdOy5ZSo1lzaEQVHyHj6ajIYlOqwLRv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 229/578] net: sh_eth: Fix missing rtnl lock in suspend/resume path
Date: Wed, 19 Feb 2025 09:23:53 +0100
Message-ID: <20250219082702.055585760@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit b95102215a8d0987789715ce11c0d4ec031cbfbe ]

Fix the suspend/resume path by ensuring the rtnl lock is held where
required. Calls to sh_eth_close, sh_eth_open and wol operations must be
performed under the rtnl lock to prevent conflicts with ongoing ndo
operations.

Fixes: b71af04676e9 ("sh_eth: add more PM methods")
Tested-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 14dc5833c465c..5f4297e83aafe 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3473,10 +3473,12 @@ static int sh_eth_suspend(struct device *dev)
 
 	netif_device_detach(ndev);
 
+	rtnl_lock();
 	if (mdp->wol_enabled)
 		ret = sh_eth_wol_setup(ndev);
 	else
 		ret = sh_eth_close(ndev);
+	rtnl_unlock();
 
 	return ret;
 }
@@ -3490,10 +3492,12 @@ static int sh_eth_resume(struct device *dev)
 	if (!netif_running(ndev))
 		return 0;
 
+	rtnl_lock();
 	if (mdp->wol_enabled)
 		ret = sh_eth_wol_restore(ndev);
 	else
 		ret = sh_eth_open(ndev);
+	rtnl_unlock();
 
 	if (ret < 0)
 		return ret;
-- 
2.39.5



