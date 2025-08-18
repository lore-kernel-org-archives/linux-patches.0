Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA2621B199;
	Mon, 18 Aug 2025 13:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522530; cv=none; b=ZlDHgP9uWbUY+36EGhu2H6lA3NVTBLGFnBe4gj4xnUCqaqS47raXYnK1kb258Zqk+7S4GYYjrRQsqrvLCPLM2Ao3rwz0TQEoRPdeTyIrg9P/05Z1ATaIiXm7OGIE+7StjTCa6NddlvmOtMOdHmbScGZ5jB1hX/GVm1zuxbxUAog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522530; c=relaxed/simple;
	bh=soXJ5f2uwh7ft7fui84pQmuGzFZLybv4TyLmuQ+qLGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwVc2YknzIHCInSvnncgqIp5bVRmxz9PMHPG+O8OeE89TS4CAJDJauZjSDq6nfDr+k7Q+jKm4mhQtOxMZO7xaGond//Xo/ykzUObew8BSsFQy7Q5+/44LsOyKvhGQK2MS4VeO6T5PeOvNK/tVlsu8gjdpMXJ5yZB4BQXWdn79AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHnAJvl9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHnAJvl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7ECC4CEEB;
	Mon, 18 Aug 2025 13:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522530;
	bh=soXJ5f2uwh7ft7fui84pQmuGzFZLybv4TyLmuQ+qLGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHnAJvl9Ea4Kkmg6YKsjdd7YWsGrmVBWlp/Qozbuq+cfYTtOACY/4c587xDjc8Lei
	 zdO4X7j1b42foa/6D8h0lTfbIWdhUfZohrdi170EJXIyIcGjrYVGdHzY+tPyj9quQj
	 3OCPaeyk/Kt88Q3nTbDYffGYLS9kB14/R+vsDN90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 326/444] soundwire: Move handle_nested_irq outside of sdw_dev_lock
Date: Mon, 18 Aug 2025 14:45:52 +0200
Message-ID: <20250818124501.161884549@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6ca06cce41d3..6c7989e2079e 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -1732,15 +1732,15 @@ static int sdw_handle_slave_alerts(struct sdw_slave *slave)
 
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



