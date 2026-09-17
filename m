Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD13A4DF4B9;
	Thu, 17 Sep 2026 15:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659824; cv=none; b=OjInw4tBuOv0sVbSlZfym75xa6K1Qk4PF5B2m5ph95r3pcD88v6Wpaa0cw6z0NG9UUMiXpppb8u8yNjwfz0szv1RkLG4kOPoFR8ytX5eKog3YVjLSHf/YfjeD+6sjoLbcEiydMy+mqKUacwAq6UqCcCKFL6dh92bWsGXIykuCYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659824; c=relaxed/simple;
	bh=GGlUI7ZJ9uReVtsM89iKmwN2ryfisSypBOGeyqX58YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjmREHSCu4Te7UfTBg/TaCXGhsSCQrJxAKmYt3vs+h2e18g6/OhFTZswynqIhNRDZH7w9RO0KNPZJGc6Jq5Nq+ci1gDxYDGW7IkgMTHxG1kXCZqYKIadbMASnxIPGVCuOxSY49MfUjG4+xVh2r9e9nXwhdVAI9F9x8+uVNqYmNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lu9AHdlH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lu9AHdlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9E41F000FF;
	Thu, 17 Sep 2026 15:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659812;
	bh=seNiyLK63+KxOs4K107xQbZY2cM9nG7+emlSK/PHtkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lu9AHdlH8fi8jFfdX3M5znM80ML94PEOUOVjKO5iOVk6bthh/7aJskX75p9BZyCeY
	 2clxJrk21ivVT0hKA5J0Iakznijajel67tROG1xSvpYRAqfT2FjWkXEzRQYyHZ72Vc
	 G1LlOBdEEmmLN2USWg4Ksro0l4E1nUifTFGFu51w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 383/733] net: mana: Clear RDMA teardown and suspend state in mana_rdma_probe()
Date: Thu, 17 Sep 2026 16:11:31 +0100
Message-ID: <20260917151401.228202188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

[ Upstream commit f6d61fe4c19cf448e5cba6d8767b4e6966f58606 ]

mana_rdma_remove() sets gd->rdma_teardown to stop
mana_rdma_service_handle() from acting on servicing events, but nothing
ever clears it. A hardware service reset (GDMA_EQE_HWC_RESET_REQUEST)
goes through mana_gd_suspend() -> mana_rdma_remove() and mana_gd_resume()
-> mana_rdma_probe(), so from the first reset onwards every
GDMA_EQE_HWC_SOC_SERVICE event returns early and RDMA suspend/resume
servicing is silently dropped for the life of the device.

gd->is_suspended has the same problem: it is set when servicing removes
the adev and is cleared only by a matching resume. A reset while RDMA is
suspended re-adds the adev but leaves is_suspended set, so a later resume
event calls add_adev() on top of a live gd->adev and leaks it. This is
currently masked by the rdma_teardown bug.

Clear both in mana_rdma_probe(). On the reset path mana_rdma_remove()
has closed the gate and drained the service workqueue, so clear
is_suspended first and re-open the gate with smp_store_release(), paired
with smp_load_acquire() in the handler, so the handler cannot observe an
open gate with a stale is_suspended. On the initial probe path the gate
was never closed and both flags are already clear.

This does not order gd->adev, which add_adev() publishes afterwards. A
servicing event arriving in that window is still dropped, as it is in
mainline today on the initial probe path; closing it needs probe and the
handler to be serialized and is left to a separate change.

Fixes: 505cc26bcae0 ("net: mana: Add support for auxiliary device servicing events")
Signed-off-by: Long Li <longli@microsoft.com>
Link: https://patch.msgid.link/20260902175153.3410560-1-longli@microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 92bb55935c1c4..b2a6f6369bc3c 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3728,7 +3728,8 @@ static void mana_rdma_service_handle(struct work_struct *work)
 	struct device *dev = gd->gdma_context->dev;
 	int ret;
 
-	if (READ_ONCE(gd->rdma_teardown))
+	/* Pairs with the smp_store_release() in mana_rdma_probe(). */
+	if (smp_load_acquire(&gd->rdma_teardown))
 		goto out;
 
 	switch (serv_work->event) {
@@ -4024,6 +4025,21 @@ int mana_rdma_probe(struct gdma_dev *gd)
 	if (err)
 		return err;
 
+	/* Clear the state left by a previous mana_rdma_remove() so servicing
+	 * events are handled again after a reset cycle.
+	 */
+	gd->is_suspended = false;
+
+	/* Publish is_suspended before re-opening the gate, so the handler
+	 * cannot observe an open gate with a stale is_suspended.  Pairs
+	 * with the smp_load_acquire() in mana_rdma_service_handle().  This
+	 * matters on the reset path, where mana_rdma_remove() closed the
+	 * gate and drained the workqueue; on the initial probe path the
+	 * gate was never closed and both flags are already clear.  It does
+	 * not order gd->adev, which add_adev() publishes below.
+	 */
+	smp_store_release(&gd->rdma_teardown, false);
+
 	err = add_adev(gd, "rdma");
 	if (err)
 		mana_gd_deregister_device(gd);
-- 
2.53.0



