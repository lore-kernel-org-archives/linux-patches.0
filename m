Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC812A1BB;
	Wed,  5 Feb 2025 15:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767856; cv=none; b=vD0nTCgk07Al955PVArHNAq7SJOlS8yl3w5NQJedY5kH4ZIPnGxIL3c0g+vLb/Y07eGYbP6dmD3UIzUuPHYA7ZC6nkqZPQgF64Iq8RUnEvBawe1EPgkeDI1n1ZTE1lfewqQ/HvwAiMnyp2MZn6/Qlz9FxtWLHTDyiPi7VCjiT6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767856; c=relaxed/simple;
	bh=9OyBvEHpjHnH2MkREDS4bfF+IGxh9ETX1vo2dE/PA9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tkvgShkp7kr5/VDgE3poN4FaGhvglA6fRRAelORcby7onymbZy6WI9joGpsXZ48k5qZFv4b9usShtGk3gG3ZvYxfdQ+HthfKeyYelW6DMTGVfk1FWZGDZJqgUe7T+Pp3XwhabTqw57p8A9e7NQil+HDJGAREdZtYBad/tp2DeSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqOWJJlP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqOWJJlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140E5C4CED1;
	Wed,  5 Feb 2025 15:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767856;
	bh=9OyBvEHpjHnH2MkREDS4bfF+IGxh9ETX1vo2dE/PA9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqOWJJlP5vkSR5F8AeqVgK3uhdTJH73co3gEyi/92jPacQ2/JGMtFZ4mZs7A978yO
	 ur6aGv0Mz7KFPyLgQ/PcnNjQlLNEccAzVHG/xfFT18OSycw/gy5JMpqKZ2Ii0M6ybt
	 54AJaMLUr5yoQ/DJxbaTWIIw+tO9qmZto8/t3H/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 518/590] net: sh_eth: Fix missing rtnl lock in suspend/resume path
Date: Wed,  5 Feb 2025 14:44:33 +0100
Message-ID: <20250205134515.082420456@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7a25903e35c30..bc12c0c7347f6 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3494,10 +3494,12 @@ static int sh_eth_suspend(struct device *dev)
 
 	netif_device_detach(ndev);
 
+	rtnl_lock();
 	if (mdp->wol_enabled)
 		ret = sh_eth_wol_setup(ndev);
 	else
 		ret = sh_eth_close(ndev);
+	rtnl_unlock();
 
 	return ret;
 }
@@ -3511,10 +3513,12 @@ static int sh_eth_resume(struct device *dev)
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



