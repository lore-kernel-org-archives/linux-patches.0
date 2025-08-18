Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD10320CBC;
	Mon, 18 Aug 2025 14:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525974; cv=none; b=L2dpgfv7LBGmmhjg4KH9hOblIyPcUrkNT6zsIvDJL/069+HJ9sMpfvp3k86+03Oqpdp+USwOezScF1h94G9hBzu8VuXAECUEbPCdPT/pMnKQvO4kdL7MKdveRQ+ldt6cxnqKFSp+kHlsAr62TWy1Hw55k3Ij7lcdDiyxW+eD01k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525974; c=relaxed/simple;
	bh=XKSCo2VTat5NsCWwjJriu2x3WiwVTqGyfe40u6AOOkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuOE8vxzS5LWeGOETJWibZrTuYmeBMIa1uNX3N9YNsYFRyvGb0E2OHVdvNT90VbEhqzPff9S9dzAXApIL4iF34+nDl06lSisOVxu/gVaguWuzuOuKeb5Hxft5Rg5DeHsTrLLRiUfq2o3tWsM33sHJ2tfl0JE40AEcUCE8gyuQU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9R/J3nf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9R/J3nf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D68C4CEEB;
	Mon, 18 Aug 2025 14:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525974;
	bh=XKSCo2VTat5NsCWwjJriu2x3WiwVTqGyfe40u6AOOkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9R/J3nfBi/H57KsxL71/Zpfy9Sr5VHLsaO2hYquc2d885z1IJQcgL0x/2mgtZFlH
	 WdnRPSbnmUGIz5Ous2fDFEZrpT10PxfsH0LQECaTYubzSqCd1iTF/d6kbuu7uX1tOD
	 7ShWHeRpoB3P/mOCx5MuJU+B86nc28t696QoVrr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 422/570] soundwire: Move handle_nested_irq outside of sdw_dev_lock
Date: Mon, 18 Aug 2025 14:46:49 +0200
Message-ID: <20250818124522.094685024@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit ccb7bb13c00bcc3178d270da052635c56148bc16 ]

The sdw_dev_lock protects the SoundWire driver callbacks against
the probed flag, which is used to skip the callbacks if the
driver gets removed. For more information see commit bd29c00edd0a
("soundwire: revisit driver bind/unbind and callbacks").

However, this lock is a frequent source of mutex inversions.
Many audio operations eventually hit the hardware resulting in a
SoundWire callback, this means that typically the driver has the
locking order ALSA/ASoC locks -> sdw_dev_lock. Conversely, the IRQ
comes in directly from the SoundWire hardware, but then will often
want to access ALSA/ASoC, such as updating something in DAPM or
an ALSA control. This gives the other lock order sdw_dev_lock ->
ALSA/ASoC locks.

When the IRQ handling was initially added to SoundWire this was
through a callback mechanism. As such it required being covered by
the lock because the callbacks are part of the sdw_driver structure
and are thus present regardless of if the driver is currently
probed.

Since then a newer mechanism using the IRQ framework has been
added, which is currently covered by the same lock but this isn't
actually required. Handlers for the IRQ framework are registered in
probe and should by released during remove, thus the IRQ framework
will have already unbound the IRQ before the slave driver is
removed. Avoid the aforementioned mutex inversion by moving the
handle_nested_irq call outside of the sdw_dev_lock.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20250609143041.495049-3-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index 68db4b67a86f..4fd5cac799c5 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -1753,15 +1753,15 @@ static int sdw_handle_slave_alerts(struct sdw_slave *slave)
 
 		/* Update the Slave driver */
 		if (slave_notify) {
+			if (slave->prop.use_domain_irq && slave->irq)
+				handle_nested_irq(slave->irq);
+
 			mutex_lock(&slave->sdw_dev_lock);
 
 			if (slave->probed) {
 				struct device *dev = &slave->dev;
 				struct sdw_driver *drv = drv_to_sdw_driver(dev->driver);
 
-				if (slave->prop.use_domain_irq && slave->irq)
-					handle_nested_irq(slave->irq);
-
 				if (drv->ops && drv->ops->interrupt_callback) {
 					slave_intr.sdca_cascade = sdca_cascade;
 					slave_intr.control_port = clear;
-- 
2.39.5



