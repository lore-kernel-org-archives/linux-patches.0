Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB4A4F96D9;
	Tue, 13 Oct 2026 12:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894197; cv=none; b=P9V1HLAmSxQmFwR1OOjjpl9ZhASDp5IiOmlPqvoA4wdX5h9GZZlJCFkEMY+UigFHRgkwEgaiei3P6gkvnrxOn1ZYWYIrKzV1jX9B49C8cyRhPDEvV0FQiNP2sCzt/xA+m3vwz+UWQAuzYpADoKvWSiRBpNFEFLefqZLMDTzuWHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894197; c=relaxed/simple;
	bh=8cpmfMCsYqeSpqytr1pHl+XUImKPrdBO/3DGKxTepsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dibPhOkApEzJwUpr376vfNBg8DeeMWszDi1m4ygw/zD7ZAVK/yXm5ipA9x50RcViP65vsWnmr6qen/wXVGMtNvsXqteKw0leKGYFsmoqc4BW32aqqsH0cx9KFzcqHxR/VlCEwW9QM96anUv1wFQzQ+7lV17iqWALSby4yH55px0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qm0JOGCl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qm0JOGCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE031F000FF;
	Tue, 13 Oct 2026 12:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894195;
	bh=f4GsKIj+gvy49dUjGNVUvwzxB/bnN3ma43xpTAiG8Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qm0JOGCl2S5NOhMpgdnRpalkmH7jSyWwyJfg65GyHx7zu2njGAMCFlNC7WxFgXRo/
	 43hv7+3LJW0rXPR8VsqrSU/CBW68pvu4ey6CZrZq9oXRmD82bjBrRX4RmZz+hjFPEC
	 fvUPecrmsNuKaKCBT1dTorpv0KAkcZTVkjn+hWa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 477/621] cxl/features: Serialize multi-part Get/Set Feature transfers
Date: Tue, 13 Oct 2026 13:37:52 +0200
Message-ID: <20261013112932.154230065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 77b814c1832fde018c30357b4ec3fcdaa91a1c10 ]

A Get or Set Feature payload larger than the mailbox payload size is
split into several mailbox commands. mbox_mutex only serializes
individual mailbox commands and is dropped between iterations of these
loops. Nothing serializes the multi-part transfer as a whole.
cxl_get_feature() and cxl_set_feature() are reachable concurrently
from fwctl (per-fd RPCs run under a read-held registration lock) and
from the EDAC scrub/ECS/repair paths, so two transfers to the same
mailbox can interleave their parts and corrupt the device's transfer
context.

Add a per-mailbox feat_mutex and hold it across the whole transfer in
both functions. It nests outside mbox_mutex (which is taken inside
cxl_internal_send_cmd()), and is taken nowhere else, so no lock-ordering
inversion is introduced.

Link: https://sashiko.dev/#/patchset/20260702090849.47501-1-icheng@nvidia.com?part=1
Fixes: 5e5ac21f629d ("cxl/mbox: Add GET_FEATURE mailbox command")
Fixes: 14d502cc2718 ("cxl/mbox: Add SET_FEATURE mailbox command")
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Link: https://patch.msgid.link/20260709155841.1895915-1-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/features.c | 3 +++
 drivers/cxl/core/mbox.c     | 1 +
 include/cxl/mailbox.h       | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/cxl/core/features.c b/drivers/cxl/core/features.c
index 6e25223d3409b..bb73f205f16cf 100644
--- a/drivers/cxl/core/features.c
+++ b/drivers/cxl/core/features.c
@@ -239,6 +239,8 @@ size_t cxl_get_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
 
 	uuid_copy(&pi.uuid, feat_uuid);
 	pi.selection = selection;
+
+	guard(mutex)(&cxl_mbox->feat_mutex);
 	do {
 		data_to_rd_size = min(feat_out_size - data_rcvd_size,
 				      cxl_mbox->payload_size);
@@ -313,6 +315,7 @@ int cxl_set_feature(struct cxl_mailbox *cxl_mbox,
 		data_in_size = cxl_mbox->payload_size - hdr_size;
 	}
 
+	guard(mutex)(&cxl_mbox->feat_mutex);
 	do {
 		int rc;
 
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index e1c23aae2a2ed..76731576ebfcc 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1515,6 +1515,7 @@ int cxl_mailbox_init(struct cxl_mailbox *cxl_mbox, struct device *host)
 
 	cxl_mbox->host = host;
 	mutex_init(&cxl_mbox->mbox_mutex);
+	mutex_init(&cxl_mbox->feat_mutex);
 	rcuwait_init(&cxl_mbox->mbox_wait);
 
 	return 0;
diff --git a/include/cxl/mailbox.h b/include/cxl/mailbox.h
index c4e99e2e3a9d4..d008b9db07aa6 100644
--- a/include/cxl/mailbox.h
+++ b/include/cxl/mailbox.h
@@ -50,6 +50,7 @@ struct cxl_mbox_cmd {
  * @payload_size: Size of space for payload
  *                (CXL 3.1 8.2.8.4.3 Mailbox Capabilities Register)
  * @mbox_mutex: mutex protects device mailbox and firmware
+ * @feat_mutex: serializes multi-part Get/Set Feature transfers
  * @mbox_wait: rcuwait for mailbox
  * @mbox_send: @dev specific transport for transmitting mailbox commands
  * @feat_cap: Features capability
@@ -60,6 +61,7 @@ struct cxl_mailbox {
 	DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
 	size_t payload_size;
 	struct mutex mbox_mutex; /* lock to protect mailbox context */
+	struct mutex feat_mutex;
 	struct rcuwait mbox_wait;
 	int (*mbox_send)(struct cxl_mailbox *cxl_mbox, struct cxl_mbox_cmd *cmd);
 	enum cxl_features_capability feat_cap;
-- 
2.53.0



