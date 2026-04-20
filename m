Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BB02E11C7;
	Mon, 20 Apr 2026 15:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700096; cv=none; b=TXhK/5UQQhLG4xLo/32Pw1ofAni+dtMXAdl7xbHNPe6ja/77YA3Warht46a9Qfs0sdMEgHsSh2ArvC+z+Enmx2eLJrz14FU/KwSUpHZoEdC0XjCBsNn9XdC3qyns+iv2fodfU69PgGPhgdcVq5yuXpKY47s5GM/cuwu2zdLdJM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700096; c=relaxed/simple;
	bh=2BUIsnyKXKRk7C3mYksgIMbhO7rLCzUwhSWoHmsWLB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kw7nIGeLi6e5I8ItaWteJjI+U/+fi1Xn5CXpZ2/VuGGZ6ctpCIJcJ/N9wCjt7HtoNFOukCrGmozkFN6cFfqCbxV6X1E4GZpc/7x3BQZL0TzwzDZQl/46BNsAYGQoJoLc2eQL5uxzgx39w4J8nS3JEYcE+4/dnA/Qu7cHnwpvhJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tvn4wHre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tvn4wHre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C3DC2BCB4;
	Mon, 20 Apr 2026 15:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700096;
	bh=2BUIsnyKXKRk7C3mYksgIMbhO7rLCzUwhSWoHmsWLB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tvn4wHre15kvLvqbHhlanE5wTVbIp6NR6Fe6tzPrcgxpboi7enzTNI9dxAHi8kxyG
	 NgyOhfdjFT4cIYldBJfPoo0LZ58BINRTtPbmEdSdRiwXMwo82tPTEXNh2ucd9xkDOE
	 a0M6GQ0V6lH+vVwXynY7wwYZw+We5Emm3v0rV5JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 001/220] dmaengine: idxd: Fix lockdep warnings when calling idxd_device_config()
Date: Mon, 20 Apr 2026 17:39:02 +0200
Message-ID: <20260420153934.070783845@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit caf91cdf2de8b7134749d32cd4ae5520b108abb7 ]

Move the check for IDXD_FLAG_CONFIGURABLE and the locking to "inside"
idxd_device_config(), as this is common to all callers, and the one
that wasn't holding the lock was an error (that was causing the
lockdep warning).

Suggested-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://patch.msgid.link/20260121-idxd-fix-flr-on-kernel-queues-v3-v3-1-7ed70658a9d1@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 17 +++++++----------
 drivers/dma/idxd/init.c   | 10 ++++------
 2 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 4013f970cb3b2..f4b134c865163 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -1121,7 +1121,11 @@ int idxd_device_config(struct idxd_device *idxd)
 {
 	int rc;
 
-	lockdep_assert_held(&idxd->dev_lock);
+	guard(spinlock)(&idxd->dev_lock);
+
+	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
+		return 0;
+
 	rc = idxd_wqs_setup(idxd);
 	if (rc < 0)
 		return rc;
@@ -1448,11 +1452,7 @@ int idxd_drv_enable_wq(struct idxd_wq *wq)
 		}
 	}
 
-	rc = 0;
-	spin_lock(&idxd->dev_lock);
-	if (test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
-		rc = idxd_device_config(idxd);
-	spin_unlock(&idxd->dev_lock);
+	rc = idxd_device_config(idxd);
 	if (rc < 0) {
 		dev_dbg(dev, "Writing wq %d config failed: %d\n", wq->id, rc);
 		goto err;
@@ -1547,10 +1547,7 @@ int idxd_device_drv_probe(struct idxd_dev *idxd_dev)
 	}
 
 	/* Device configuration */
-	spin_lock(&idxd->dev_lock);
-	if (test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
-		rc = idxd_device_config(idxd);
-	spin_unlock(&idxd->dev_lock);
+	rc = idxd_device_config(idxd);
 	if (rc < 0)
 		return -ENXIO;
 
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index f2b37c63a964c..afba88f9c3e43 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -1094,12 +1094,10 @@ static void idxd_reset_done(struct pci_dev *pdev)
 	idxd_device_config_restore(idxd, idxd->idxd_saved);
 
 	/* Re-configure IDXD device if allowed. */
-	if (test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags)) {
-		rc = idxd_device_config(idxd);
-		if (rc < 0) {
-			dev_err(dev, "HALT: %s config fails\n", idxd_name);
-			goto out;
-		}
+	rc = idxd_device_config(idxd);
+	if (rc < 0) {
+		dev_err(dev, "HALT: %s config fails\n", idxd_name);
+		goto out;
 	}
 
 	/* Bind IDXD device to driver. */
-- 
2.53.0



