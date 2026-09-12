Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8581119E7F7;
	Sat, 12 Sep 2026 07:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198461; cv=none; b=LrWMSPer29SLPRNJLFET8xpfVZvxwkRIg48UjwLdFKEFRJOPJKc+T83ULHDmSeXnY7hfIjQ4Wj/l4+ZgLhDvSBpNuyQYNwD1jWvzQ3wGGtMoSpJS6NML7U4YnL52FJ3ECrg2AE/JgCYvbiA4gEFZpDg5H3xrCnT+58msiaGNPO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198461; c=relaxed/simple;
	bh=xOsJTeL8c7+62OeVv9qoSj771JLww/I2hVH51Jr+cCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWxDUOQDvblnj4N4Z1ITD3+YXp4uaSj05cCyWyr2T9Z+lNfg1jQCN1lXlo43lsNhXMvpaGqwYwgI9QKc6M8pZx8Q46PIKSAN2eGD8hHLewzObyjdMvTjWkXH8KEpYrblfRxiuKv4sJtRigFWIAlc/3/0ck1aGTCtyj+6Lidn85w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fk3k7Qpi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fk3k7Qpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC6C1F000FF;
	Sat, 12 Sep 2026 07:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198460;
	bh=j0loU1ucc9Qj1J6+ivJ8OfIjZjNtvOBes+K1RpttEB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fk3k7Qpicf8L+9IeSDHquHx8x54pjEcaQBKT4hgb6DAzkgcokRvP/xq5XXu1EtQNH
	 NUMvHhJ+BmA7PI8+6WTEv1Uvlo3uBgfphVb8OHHXACl55cBzMbvvPIVlSr0TI3f7KJ
	 dWyh3N84w8RAiPlV2ONnXBA7POAOEZ5orUm2oVZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0385/1815] cxl/features: Serialize multi-part Get/Set Feature transfers
Date: Sat, 12 Sep 2026 08:35:35 +0200
Message-ID: <20260912065657.932752949@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 738a89863ee89..8731b95dd0b5e 100644
--- a/drivers/cxl/core/features.c
+++ b/drivers/cxl/core/features.c
@@ -240,6 +240,8 @@ size_t cxl_get_feature(struct cxl_mailbox *cxl_mbox, const uuid_t *feat_uuid,
 	size_out = min(feat_out_size, cxl_mbox->payload_size);
 	uuid_copy(&pi.uuid, feat_uuid);
 	pi.selection = selection;
+
+	guard(mutex)(&cxl_mbox->feat_mutex);
 	do {
 		data_to_rd_size = min(feat_out_size - data_rcvd_size,
 				      cxl_mbox->payload_size);
@@ -314,6 +316,7 @@ int cxl_set_feature(struct cxl_mailbox *cxl_mbox,
 		data_in_size = cxl_mbox->payload_size - hdr_size;
 	}
 
+	guard(mutex)(&cxl_mbox->feat_mutex);
 	do {
 		int rc;
 
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 241526bb9e806..cc479f4322e73 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1516,6 +1516,7 @@ int cxl_mailbox_init(struct cxl_mailbox *cxl_mbox, struct device *host)
 
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



