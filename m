Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5A52E1F06;
	Tue, 21 Jul 2026 16:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649642; cv=none; b=nlh1kmkUsQCthshDpbrzZwQZLEeT+Ov93TDdLIsaw+GUTWldDHJktw2bXcPgNwokPEGi/uTV3ueRBG32wD26V+ISwblzNkGtW7ejEXbGuX+7EFhCpP4xeSoDKLiHTT8yL2Tj1CxLO05fGzeTk7cUtJtYCgHQF72t+ajE+NdfWtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649642; c=relaxed/simple;
	bh=4QASfoXbdIhS+l5hZ3KsJbBufH8AWpqBUe5lnnZi3DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZJahTouaOtXGAglSeBUs97JrUSFznwBACt4PfVPhcFxAWUAWFJBU3rl8izssPsHi42ikhUJtsNeTd/vJCI3AsiPcuZ1tBPy+c7RgFBB8hZvyDFwWZw8MHAzPAa8sHEYzlvXZjlNvrlVu6m+3k503ufZdBnfi0/OqzyJyMfU2o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWKccllw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWKccllw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B811F00A3A;
	Tue, 21 Jul 2026 16:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649641;
	bh=eNg/DfRWrVDpka9ITUcT9cTchhgVlroDrgao4sWFCAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWKccllwmhdfll+ZEWpTXoiWXZW7BpgrHNwoO4ddeQcy5waMC20Th31jIdJInAFOI
	 wId12enCkEtxLiqcGbKLFE9l6idcWh/UrLKui+jwj6xddQpCaTOUbbJccOHgfPJacj
	 J03AAaieubmO7uW6JPsiFDK6k234loea8I3MQb/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0655/2077] cxl/test: Verify cmd->size_in before accessing payload
Date: Tue, 21 Jul 2026 17:05:28 +0200
Message-ID: <20260721152608.254445296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 71a1def165267bc0947d4236f7336f490739c379 ]

Several mock mailbox handlers access input payload fields before
verifying that cmd->size_in is large enough for the corresponding
structure.

To ensure invalid commands are rejected before any payload data is
consumed, add missing size checks and move existing checks ahead of
the first payload field access.

[dj: Updated commit log per Alison's comments. ]

Fixes: 7d3eb23c4ccf ("tools/testing/cxl: Introduce a mock memory device + driver")
Fixes: d1dca858f058 ("cxl/test: Add generic mock events")
Fixes: f6448cb5f2f3 ("tools/testing/cxl: add firmware update emulation to CXL memdevs")
Fixes: e77e9c107978 ("cxl/test: Add Get Feature support to cxl_test")
Link: https://lore.kernel.org/linux-cxl/20260605143748.235271F00893@smtp.kernel.org/
Suggested-by: sashiko-bot
Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/mem.c | 39 +++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 271c7ad8cc32c9..2e9a5f151e983d 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -312,12 +312,17 @@ static int mock_get_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 
 static int mock_clear_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 {
-	struct cxl_mbox_clear_event_payload *pl = cmd->payload_in;
+	struct cxl_mbox_clear_event_payload *pl;
 	struct mock_event_log *log;
-	u8 log_type = pl->event_log;
+	u8 log_type;
 	u16 handle;
 	int nr;
 
+	if (cmd->size_in < sizeof(*pl))
+		return -EINVAL;
+
+	pl = cmd->payload_in;
+	log_type = pl->event_log;
 	if (log_type >= CXL_EVENT_TYPE_MAX)
 		return -EINVAL;
 
@@ -574,14 +579,19 @@ static int mock_gsl(struct cxl_mbox_cmd *cmd)
 static int mock_get_log(struct cxl_memdev_state *mds, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
-	struct cxl_mbox_get_log *gl = cmd->payload_in;
-	u32 offset = le32_to_cpu(gl->offset);
-	u32 length = le32_to_cpu(gl->length);
 	uuid_t uuid = DEFINE_CXL_CEL_UUID;
+	struct cxl_mbox_get_log *gl;
 	void *data = &mock_cel;
+	u32 offset;
+	u32 length;
 
 	if (cmd->size_in < sizeof(*gl))
 		return -EINVAL;
+
+	gl = cmd->payload_in;
+	offset = le32_to_cpu(gl->offset);
+	length = le32_to_cpu(gl->length);
+
 	if (length > cxl_mbox->payload_size)
 		return -EINVAL;
 	if (offset + length > sizeof(mock_cel))
@@ -1336,10 +1346,14 @@ static int mock_fw_info(struct cxl_mockmem_data *mdata,
 static int mock_transfer_fw(struct cxl_mockmem_data *mdata,
 			    struct cxl_mbox_cmd *cmd)
 {
-	struct cxl_mbox_transfer_fw *transfer = cmd->payload_in;
+	struct cxl_mbox_transfer_fw *transfer;
 	void *fw = mdata->fw;
 	size_t offset, length;
 
+	if (cmd->size_in < sizeof(*transfer))
+		return -EINVAL;
+
+	transfer = cmd->payload_in;
 	offset = le32_to_cpu(transfer->offset) * CXL_FW_TRANSFER_ALIGNMENT;
 	length = cmd->size_in - sizeof(*transfer);
 	if (offset + length > FW_SIZE)
@@ -1415,11 +1429,18 @@ static int mock_get_test_feature(struct cxl_mockmem_data *mdata,
 				 struct cxl_mbox_cmd *cmd)
 {
 	struct vendor_test_feat *output = cmd->payload_out;
-	struct cxl_mbox_get_feat_in *input = cmd->payload_in;
-	u16 offset = le16_to_cpu(input->offset);
-	u16 count = le16_to_cpu(input->count);
+	struct cxl_mbox_get_feat_in *input;
+	u16 offset;
+	u16 count;
 	u8 *ptr;
 
+	if (cmd->size_in < sizeof(*input))
+		return -EINVAL;
+
+	input = cmd->payload_in;
+	offset = le16_to_cpu(input->offset);
+	count = le16_to_cpu(input->count);
+
 	if (offset > sizeof(*output)) {
 		cmd->return_code = CXL_MBOX_CMD_RC_INPUT;
 		return -EINVAL;
-- 
2.53.0



