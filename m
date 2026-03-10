Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC4E387363;
	Tue, 10 Mar 2026 11:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140798; cv=none; b=RzpBxDkS0llr9doRUdBX2B9WzrbygZlq0crO9XPy0yCwlcU+zckn/nyl6eGpGNKNUwn9Fx9IJI1vj0n3s9Y3lXZvnV14rZo+eLlbumvxRNjNcm0+laD1AL8/Sk9aLLmnVQCBBk9zGzESF0U9F/mP0xyi+OzWThbRaePgwvNhysk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140798; c=relaxed/simple;
	bh=jWnBND+6D5QpQubebMKkOE++HbdQ9NfOFI7+Xj84SOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbpHWbw3OZgFYg3itTW6ubDVZWWYIF7s76HwqoOGmLR/q/q/tAHkDu4WPhxlPJdgi6pC+Ou9aM2skB7kpBRMpQz3KfBXB/kSxyLqiN7TLq0PdCQz2BKlGqZT6C3MDv8333W+i0LIXAowEq7sxrg29fDIDY+FR/nZReJhS/BXF00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hybhiZK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hybhiZK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BD0C19423;
	Tue, 10 Mar 2026 11:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140798;
	bh=jWnBND+6D5QpQubebMKkOE++HbdQ9NfOFI7+Xj84SOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hybhiZK0RPm3qqbOlDrnzDPRzX5kBtBomSIlIWSuAyO51zMdHOPpa8gDpAPc7T85F
	 yKvVf6W3+C7kFfxMPCf9n2tlW5jc5FVMAaloVlHypPVhJgBm9OyDTkKSEZo+i8QNoS
	 KDixvC/Z3Qnei+luXSWqhcG1pZuCRxYM97tdwAAU3PAO6RfjF+urfGKNmFFBupgLnn
	 ZqbyhkUH38T9+4HQlv3cDCzKisqW+Gdc5unFDSkuNPVvHzGUZ1AbaI2ePZk6ed2VHo
	 XWEZdqRM18zkfF7Iwb+TMGUdg7jOawx/mY+h791aY4DSjv2CqhxbTQImdKsHn8R3+G
	 jj8zyTx19V3VA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 035/311] accel/amdxdna: Reduce log noise during process termination
Date: Tue, 10 Mar 2026 07:01:22 -0400
Message-ID: <fc7f156b600ad6718e8c8dc291456861673bfa8c.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 57aa3917a3b3bd805a3679371f97a1ceda3c5510 ]

During process termination, several error messages are logged that are
not actual errors but expected conditions when a process is killed or
interrupted. This creates unnecessary noise in the kernel log.

The specific scenarios are:

1. HMM invalidation returns -ERESTARTSYS when the wait is interrupted by
   a signal during process cleanup. This is expected when a process is
   being terminated and should not be logged as an error.

2. Context destruction returns -ENODEV when the firmware or device has
   already stopped, which commonly occurs during cleanup if the device
   was already torn down. This is also an expected condition during
   orderly shutdown.

Downgrade these expected error conditions from error level to debug level
to reduce log noise while still keeping genuine errors visible.

Fixes: 97f27573837e ("accel/amdxdna: Fix potential NULL pointer dereference in context cleanup")
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260210164521.1094274-3-mario.limonciello@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c     | 6 ++++--
 drivers/accel/amdxdna/aie2_message.c | 4 +++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 6378a0bc7b6ea..a3bb37543f73d 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -497,7 +497,7 @@ static void aie2_release_resource(struct amdxdna_hwctx *hwctx)
 
 	if (AIE2_FEATURE_ON(xdna->dev_handle, AIE2_TEMPORAL_ONLY)) {
 		ret = aie2_destroy_context(xdna->dev_handle, hwctx);
-		if (ret)
+		if (ret && ret != -ENODEV)
 			XDNA_ERR(xdna, "Destroy temporal only context failed, ret %d", ret);
 	} else {
 		ret = xrs_release_resource(xdna->xrs_hdl, (uintptr_t)hwctx);
@@ -1070,6 +1070,8 @@ void aie2_hmm_invalidate(struct amdxdna_gem_obj *abo,
 
 	ret = dma_resv_wait_timeout(gobj->resv, DMA_RESV_USAGE_BOOKKEEP,
 				    true, MAX_SCHEDULE_TIMEOUT);
-	if (!ret || ret == -ERESTARTSYS)
+	if (!ret)
 		XDNA_ERR(xdna, "Failed to wait for bo, ret %ld", ret);
+	else if (ret == -ERESTARTSYS)
+		XDNA_DBG(xdna, "Wait for bo interrupted by signal");
 }
diff --git a/drivers/accel/amdxdna/aie2_message.c b/drivers/accel/amdxdna/aie2_message.c
index 43657203d22b7..d69d3afcfb748 100644
--- a/drivers/accel/amdxdna/aie2_message.c
+++ b/drivers/accel/amdxdna/aie2_message.c
@@ -193,8 +193,10 @@ static int aie2_destroy_context_req(struct amdxdna_dev_hdl *ndev, u32 id)
 
 	req.context_id = id;
 	ret = aie2_send_mgmt_msg_wait(ndev, &msg);
-	if (ret)
+	if (ret && ret != -ENODEV)
 		XDNA_WARN(xdna, "Destroy context failed, ret %d", ret);
+	else if (ret == -ENODEV)
+		XDNA_DBG(xdna, "Destroy context: device already stopped");
 
 	return ret;
 }
-- 
2.51.0

