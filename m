Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C1843E4BA;
	Tue, 16 Jun 2026 15:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623425; cv=none; b=Y9/+xKP5swfbAuYE6svQKqNZ+pfFP8/ysVcFI8ov6vTrOE0VewiiphrDri/Yh8cPoNDV1fbyq759R8B9SQcKxZmJ1hJy5OjWc/jYzg1XiHtE/EHywrI3ADxQIxMSvcwWEdygGbk/f/gtY6lFLygnyWji+21wrmfhW2xl7tPcVHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623425; c=relaxed/simple;
	bh=WFppll+nsE6hAAl5IQ2QHKk0l8cP1Yxun2OZ2w4UA08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHRAFExENBaSb23F1O342WWsumaK0UaUbQPJT1wmBAqRdMj+MW3uzd9+rDYRA5IDW3f1aWJRj4Zf1npQlOOxYYAa2ifqEyokytltdNW+3Oq/iWodKBxZJLc5qBEawoUprqzFy8pAO2915GdXC51JEIodQQooeHTzUDB0nW+fszY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysN6yvYI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysN6yvYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF641F000E9;
	Tue, 16 Jun 2026 15:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623423;
	bh=ZZMTRhx6oN1xWT1VvFPWvsc4kEkq9O0qqRH7Z0Q82z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysN6yvYI+dvFQZi4eHc3rJSc6G7ITDISZVz48REPEtav2D/r3GaM6EZmIkITtUzje
	 AOX6soa8b0GbDrByliOZcG4kWtsGJ5Y7rGc//b+WlYx9emJrZh7Ye6YIG+djGg21Ax
	 iBETUXjHfTLTvmN9Ipjab9I0JV1SjxHk5z96wveM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 112/378] net: ibm: emac: Fix use-after-free during device removal
Date: Tue, 16 Jun 2026 20:25:43 +0530
Message-ID: <20260616145116.265907035@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit a0130d682222ae21afc395aead7cd2d87e1a8358 ]

The driver was using devm_register_netdev() which causes unregister_netdev()
to be deferred until the devres cleanup phase, which runs after emac_remove()
returns. This creates a use-after-free window where:

1. emac_remove() is called, which tears down hardware (cancels work, detaches
   modules, unregisters from MAL)
2. emac_remove() returns
3. devres cleanup runs and finally calls unregister_netdev()

During step 3, the network stack might still process packets, triggering
emac_irq(), emac_poll(), or other handlers that access now-freed hardware
resources (dev->emacp, dev->mal, etc.).

Fix this by replacing devm_register_netdev() with manual register_netdev()
and calling unregister_netdev() at the beginning of emac_remove(), before
any hardware teardown. This ensures the network device is fully stopped and
unregistered before hardware resources are released.

The change is safe because:
- dev->ndev is assigned very early in probe (before any error paths that
  could bypass emac_remove)
- platform_set_drvdata() is only called after successful registration, so
  emac_remove() only runs for fully registered devices
- unregister_netdev() is idempotent and safe to call on any registered device

Fixes: a4dd8535a527 ("net: ibm: emac: use devm for register_netdev")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/emac/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 417dfa18daae3a..4e503b3d0d2d34 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3144,7 +3144,7 @@ static int emac_probe(struct platform_device *ofdev)
 
 	netif_carrier_off(ndev);
 
-	err = devm_register_netdev(&ofdev->dev, ndev);
+	err = register_netdev(ndev);
 	if (err) {
 		printk(KERN_ERR "%pOF: failed to register net device (%d)!\n",
 		       np, err);
@@ -3197,6 +3197,13 @@ static void emac_remove(struct platform_device *ofdev)
 
 	DBG(dev, "remove" NL);
 
+	/* Unregister network device before tearing down hardware
+	 * to prevent use-after-free during deferred cleanup. This ensures
+	 * the network stack stops all operations before hardware resources
+	 * are released.
+	 */
+	unregister_netdev(dev->ndev);
+
 	cancel_work_sync(&dev->reset_work);
 
 	if (emac_has_feature(dev, EMAC_FTR_HAS_TAH))
-- 
2.53.0



