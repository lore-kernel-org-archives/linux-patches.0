Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F83321F5C;
	Mon, 18 Aug 2025 13:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524175; cv=none; b=je0B6tSN6c1N1174ZR7X2kf97YROxxBpJMtpKlOb1YOizm6jwKiGi+ODhZZRzhj8UHSwrYKyyV2xC0vmPhrwZfVpltqXOg7JGPemWiH6vl2nVfpGfWJD8ly0m2DdDMsiFogJAnyfeW61BD++XOmj3g+DlA1SAzrsscHRYN9NRbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524175; c=relaxed/simple;
	bh=1mOcYS8+7O3dGC8WgwIm3Fz1AJ4ZLfl5hpRTXsNho/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxL9+uWeqKCLeKhf26/aeRKeJHCdJLWnSN11JqpV2OlMg4KF8pFB+8M11CR7KMAaCpYuEjXCWTXP5ossMcdV64+/ZZXf+59XzruNBId8mHLuX3YEFoXUrtHSLv0qD6T2Hk75G434ELtG4A354hgZDGQ3UsG58oyNQ7p9WvPBYVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYQZTZPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYQZTZPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316FAC4CEEB;
	Mon, 18 Aug 2025 13:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524175;
	bh=1mOcYS8+7O3dGC8WgwIm3Fz1AJ4ZLfl5hpRTXsNho/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYQZTZPMtgmDbqRtI54Q6IvgXr86d8tLHfuX6Bec+acEotK5C5SYaHoO4+hrvvyWM
	 BrtN7fiQoSRZwCovxzLwhsoRvloILmJldAz2YUTDn+aJzTBRp45H055X6V5VVl9L7S
	 3YAAlRxYysiuhSc8QPJdzGdDxRhO7Zs/QiqW0fks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 389/515] soundwire: Move handle_nested_irq outside of sdw_dev_lock
Date: Mon, 18 Aug 2025 14:46:15 +0200
Message-ID: <20250818124513.392242486@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 39aecd34c641..1a70f80c2514 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -1756,15 +1756,15 @@ static int sdw_handle_slave_alerts(struct sdw_slave *slave)
 
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



