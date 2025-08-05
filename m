Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FE2273D73;
	Tue,  5 Aug 2025 13:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399405; cv=none; b=Y8tepjYhWBT7uN7M+pEKNdgKbpW++DgP/8dU2TRo/BO23lu33WnKG1guP7fYFEBMtQGKaMkIasfdFRncrO3yMe8Jlpee8sGtzeykN8qd41Cl3j2x/bfPN6Eiygo9vE810GTEvTMVCpoJzrUksxg6XUvceJOCzW9+sbX5eWk5KdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399405; c=relaxed/simple;
	bh=2QzGg5eGZSoxkyagSZYkTDZKCbtQQT2cOhvRCRD2NH4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p+CAnZ1HAgVbJqu4Cxo/q9h6Hav8LKG/TJQy8SxwjQXw00lAW3XlelhyCYI3i1aioP6f9GU4Mhzo8Rg/9b1vipuv5f5NvCki1PZ33HZjHVIzg7y6T9gtLRhBswSVa96GGMHQ10iIac2ps5Ykp0YAWmbZJudc7Bmczx5YGSbM7hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X2E5P7Hx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X2E5P7Hx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C27C4CEF7;
	Tue,  5 Aug 2025 13:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399404;
	bh=2QzGg5eGZSoxkyagSZYkTDZKCbtQQT2cOhvRCRD2NH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2E5P7HxhrVUCq5aijb1hLbF1quz8a4Q1mtga8Yqjf7fOl5jKse1dzhd0vwBOPmhK
	 cvs65bTok+u/PASL4WQDyOBYxRJdXWoWVgKk+J/hGJQwZ6HiCVlcEafqc4sxHRRZMZ
	 EjHtwCSWM948ojemKopzXIpFAqBhmRS84nWPuByYPsjpPj7p2e4KmUM20lz6zYVc6Y
	 WIQakhJJHo5EpnRKwYs32/kgwskjMWHhmYrnvOqvyUlT12OIrT9VE/qFjGkTEfXANm
	 IyAH+LbORbTCVK1LUY2UJfnMwgRjDUFWYLJeCR7pGH0lXAiDL0/xoeZOC1NFvYW24/
	 jcqVkWG9+aO4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	yung-chuan.liao@linux.intel.com,
	linux-sound@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-6.6] soundwire: Move handle_nested_irq outside of sdw_dev_lock
Date: Tue,  5 Aug 2025 09:08:43 -0400
Message-Id: <20250805130945.471732-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Bug Fix Nature
The commit fixes a **real deadlock/mutex inversion issue** that affects
production systems. The code changes show that `handle_nested_irq()` is
moved outside the `sdw_dev_lock` mutex protection (lines 1756-1757 moved
before line 1759), which resolves a lock ordering problem:
- **Lock order A**: ALSA/ASoC locks → sdw_dev_lock (during normal audio
  operations)
- **Lock order B**: sdw_dev_lock → ALSA/ASoC locks (during IRQ handling)

This ABBA deadlock pattern can cause system hangs in real-world usage.

## Small and Contained Fix
The actual code change is minimal - just **moving 2 lines of code** (the
`handle_nested_irq()` call) from inside the mutex-protected region to
outside it. This is a surgical fix that:
- Only affects the IRQ handling path in `sdw_handle_slave_alerts()`
- Doesn't change any logic or add new features
- Has clear boundaries within the SoundWire subsystem

## Safe to Move Outside Lock
The commit message explains why this is safe: The IRQ framework ensures
handlers are unregistered during device removal **before** the driver is
unbound. This means:
1. The IRQ handler registration happens in probe
2. The IRQ handler unregistration happens in remove
3. The `sdw_dev_lock` protects the `probed` flag and driver callbacks
4. Since the IRQ framework guarantees the handler is gone before remove
   completes, there's no race condition

## History Shows Lock Issues are Common
The git history reveals multiple mutex/deadlock fixes in SoundWire:
- `a4857d1afdd1`: Fixed deadlock with ordered master_list
- `bd29c00edd0a`: Major rework of locking for bind/unbind (the commit
  that introduced sdw_dev_lock)
- Multiple other lock-related fixes

This indicates the locking in SoundWire has been problematic and fixes
are important for stability.

## Follows Stable Rules
✓ Fixes a real bug (deadlock)
✓ Minimal change (2 lines moved)
✓ No new features
✓ Low regression risk
✓ Clear explanation of why it's safe
✓ Fixes an issue introduced by earlier changes (when IRQ framework
support was added in commit `12a95123bfe1`)

The commit is a textbook example of a stable-appropriate fix: it
resolves a real deadlock issue with minimal code changes and clear
safety justification.

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

