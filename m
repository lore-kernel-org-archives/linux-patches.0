Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10DB8827;
	Mon, 23 Dec 2024 16:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970644; cv=none; b=fMuEHhROAahRV+B05p4JBuqtqzfpN2GW7KYTZbtMC5MuVaJAf0gPx3HfbVLsxYxBxSgdcYu+Cby7jo1ydmUAv4R1KW/Fpv1gYSY3j+y30Ptxw8pYm1P8Tb+XLVYv0nMGrJjPIWPZVLOE+ed8tmhuEmfaNw4o0wwwWmd+0rpEh4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970644; c=relaxed/simple;
	bh=To04578maZbtL8CdYY/DkuovizB8puuZwE1nBF64qv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAYOWl+SFoHNN21NLvJYskqIW4KNNHLvrE4wfscW5vl2MSuHqz3z2YHuI9TkGg8sM6WwkAYPjY2CkpyuNCRrf0kV0/ULFUVJJI4jjF91DQUNJiYxtDYEudoXwSNs0b4wEoQAuX7JRrDYCs9aNx7VM74wy5ZRVN371T5l++viO10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixzNSUk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixzNSUk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B66C4CED3;
	Mon, 23 Dec 2024 16:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970644;
	bh=To04578maZbtL8CdYY/DkuovizB8puuZwE1nBF64qv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixzNSUk/y9I/DTDsl8mEG5keVhp2d0MK9VQa4TcR1vy31dsYRFYtSnujpf/VP9Gxu
	 v710dtTiJGuD0pGYzpTv/CChsHCtbntrpLDLzeG4pF+b9Cnl5S3axRgZ/nvtnmPg5A
	 2ROz15QWtLON2Y/4462sCBHvQxLIPKvs2DMP9Fjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 26/83] ionic: Fix netdev notifier unregister on failure
Date: Mon, 23 Dec 2024 16:59:05 +0100
Message-ID: <20241223155354.649073993@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 9590d32e090ea2751e131ae5273859ca22f5ac14 ]

If register_netdev() fails, then the driver leaks the netdev notifier.
Fix this by calling ionic_lif_unregister() on register_netdev()
failure. This will also call ionic_lif_unregister_phc() if it has
already been registered.

Fixes: 30b87ab4c0b3 ("ionic: remove lif list concept")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20241212213157.12212-2-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 14865fc245da..b746944bcd2a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -3484,8 +3484,8 @@ int ionic_lif_register(struct ionic_lif *lif)
 	/* only register LIF0 for now */
 	err = register_netdev(lif->netdev);
 	if (err) {
-		dev_err(lif->ionic->dev, "Cannot register net device, aborting\n");
-		ionic_lif_unregister_phc(lif);
+		dev_err(lif->ionic->dev, "Cannot register net device: %d, aborting\n", err);
+		ionic_lif_unregister(lif);
 		return err;
 	}
 
-- 
2.39.5



