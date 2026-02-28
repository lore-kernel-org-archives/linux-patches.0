Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E583143636C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301200; cv=none; b=Nn4Mv9Gf4HF+aqXyEKw9MS321/HjtwckGOHFeIeL3McQIaccPoXDN4XrF9XjQmLUgwUHmRDPEMjU5QsuYBFvA8ApBgkeuUKojHLV1IGIWyRsYQzBxQki3/2txfM/OnWu346Zf3BD8EwToRKEIBesXZWPLO9QE8uREGJu+fVCsM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301200; c=relaxed/simple;
	bh=jhgAWplexRRfopI0Dnzymy2G+kTx3bOC0pDh+RTNqlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vF1IRlof2OEhoZV5Qv1EgIpc/ck3eCWXYai6qqAzHR5KLtipa0QV+o0JdQIWEU+PWCueJEVlCNIcLs8DGcZuJSnETRnW/4bBXY3llByK0dzn9GAbVOqM61iddxBGdMDEpYoYUXu61iLpJdzCts24BjML0PZRlRRaClSi813hD2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u5dj3wiM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u5dj3wiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53537C19423;
	Sat, 28 Feb 2026 17:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301199;
	bh=jhgAWplexRRfopI0Dnzymy2G+kTx3bOC0pDh+RTNqlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5dj3wiMR6UD21JqE3RRKU1UinBPxmZCZC7jG3FHIz0egrQvD+eNF4sm0aElsLCK/
	 oOuJr7fEalDV2dmPZCMaF0nTp8Jnt+W2Kxt0sSnn2qrxF/Ugr47dE4qeJJ2Bo5Uc6Z
	 DItzAhYCMDjzi8qNVBcZtYBXMkMK1igfaTjOnsnuDF0cK+CmEPGU/halklju3beGjP
	 itcy93cIcrUJEzPHKsez3zihBdTC/I71Ui3xebzwH29Qn95d3tpQFPnqqEZ11iqxFZ
	 vXC3fgBfcvf4ioxnhoS/PXJjyHtZzC8EUhJGxCd+AjalDcWrVvASKtsSgHelOTJO8G
	 GyneHQO8ckrVw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 372/752] mshv: clear eventfd counter on irqfd shutdown
Date: Sat, 28 Feb 2026 12:41:23 -0500
Message-ID: <20260228174750.1542406-372-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Carlos López <clopez@suse.de>

[ Upstream commit 2b4246153e2184e3a3b4edc8cc35337d7a2455a6 ]

While unhooking from the irqfd waitqueue, clear the internal eventfd
counter by using eventfd_ctx_remove_wait_queue() instead of
remove_wait_queue(), preventing potential spurious interrupts. This
removes the need to store a pointer into the workqueue, as the eventfd
already keeps track of it.

This mimicks what other similar subsystems do on their equivalent paths
with their irqfds (KVM, Xen, ACRN support, etc).

Signed-off-by: Carlos López <clopez@suse.de>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_eventfd.c | 5 ++---
 drivers/hv/mshv_eventfd.h | 1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/mshv_eventfd.c b/drivers/hv/mshv_eventfd.c
index 05d643f54f45a..40b7179fee805 100644
--- a/drivers/hv/mshv_eventfd.c
+++ b/drivers/hv/mshv_eventfd.c
@@ -244,12 +244,13 @@ static void mshv_irqfd_shutdown(struct work_struct *work)
 {
 	struct mshv_irqfd *irqfd =
 			container_of(work, struct mshv_irqfd, irqfd_shutdown);
+	u64 cnt;
 
 	/*
 	 * Synchronize with the wait-queue and unhook ourselves to prevent
 	 * further events.
 	 */
-	remove_wait_queue(irqfd->irqfd_wqh, &irqfd->irqfd_wait);
+	eventfd_ctx_remove_wait_queue(irqfd->irqfd_eventfd_ctx, &irqfd->irqfd_wait, &cnt);
 
 	if (irqfd->irqfd_resampler) {
 		mshv_irqfd_resampler_shutdown(irqfd);
@@ -368,8 +369,6 @@ static void mshv_irqfd_queue_proc(struct file *file, wait_queue_head_t *wqh,
 	struct mshv_irqfd *irqfd =
 			container_of(polltbl, struct mshv_irqfd, irqfd_polltbl);
 
-	irqfd->irqfd_wqh = wqh;
-
 	/*
 	 * TODO: Ensure there isn't already an exclusive, priority waiter, e.g.
 	 * that the irqfd isn't already bound to another partition.  Only the
diff --git a/drivers/hv/mshv_eventfd.h b/drivers/hv/mshv_eventfd.h
index 332e7670a3442..464c6b81ab336 100644
--- a/drivers/hv/mshv_eventfd.h
+++ b/drivers/hv/mshv_eventfd.h
@@ -32,7 +32,6 @@ struct mshv_irqfd {
 	struct mshv_lapic_irq		     irqfd_lapic_irq;
 	struct hlist_node		     irqfd_hnode;
 	poll_table			     irqfd_polltbl;
-	wait_queue_head_t		    *irqfd_wqh;
 	wait_queue_entry_t		     irqfd_wait;
 	struct work_struct		     irqfd_shutdown;
 	struct mshv_irqfd_resampler	    *irqfd_resampler;
-- 
2.51.0

