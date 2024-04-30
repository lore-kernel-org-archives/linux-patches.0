Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEBD1E50A;
	Tue, 30 Apr 2024 11:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475297; cv=none; b=oJEqhoRva/w9ZBIgS6OKupHFbYkoCt8gEyJNKWZbVyvGWrUoYpOk+MyFgmZY11TohMw0QuWOx88N9amr40CC7lIFrlSEcsTovTBxWO2lOe88GGGhXxKcq2RoSbhpQE6Vs+xqmkF4I/PsnxhrH6fuH9TasWNhV63vehrhMZ1G8BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475297; c=relaxed/simple;
	bh=FsZVI+MU9SdGJesUXDX0nQPEswRAR8IaV+/jVDYv64k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKF5eFEie73zFZKtWkJkKg5IZqPu/Ezii/esV4WjjvBYtexojxi/ZViwKvAzLCsyVTuBHYyh5RInmGGYia+3dfPkb/79FRBl++Z4urFwWI0ziCMMaJ/p1w9claWtzwsdVTjyY2ViRR5B6GRVrKnhsheeT2GyWQT04o8NV5NROII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmiirRMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmiirRMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B451C2BBFC;
	Tue, 30 Apr 2024 11:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475297;
	bh=FsZVI+MU9SdGJesUXDX0nQPEswRAR8IaV+/jVDYv64k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmiirRMyLsM7yTJIsM982IPuqd4UfxFC/42F4ciEDAilemG5b01/X9bIS+WnV1SlS
	 nR1TkurvtUvaIYnsSz22DsgrM8INrGY7kI4UIG5kX3u2t62lCXHzEJlEzRWf3Ms/YY
	 i6YXilOwb1OqF4gvk/YobKBnYJYNIKGHJoYheXrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kwangjin Ko <kwangjin.ko@sk.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/186] cxl/core: Fix potential payload size confusion in cxl_mem_get_poison()
Date: Tue, 30 Apr 2024 12:38:26 +0200
Message-ID: <20240430103059.600144903@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 4b759dd5765503bd466defac7d93aca14c23a15d ]

A recent change to cxl_mem_get_records_log() [1] highlighted a subtle
nuance of looping calls to cxl_internal_send_cmd(), i.e. that
cxl_internal_send_cmd() modifies the 'size_out' member of the @mbox_cmd
argument. That mechanism is useful for communicating underflow, but it
is unwanted when reusing @mbox_cmd for a subsequent submission. It turns
out that cxl_xfer_log() avoids this scenario by always redefining
@mbox_cmd each iteration.

Update cxl_mem_get_records_log() and cxl_mem_get_poison() to follow the
same style as cxl_xfer_log(), i.e. re-define @mbox_cmd each iteration.
The cxl_mem_get_records_log() change is just a style fixup, but the
cxl_mem_get_poison() change is a potential fix, per Alison [2]:

    Poison list retrieval can hit this case if the MORE flag is set and
    a follow on read of the list delivers more records than the previous
    read.  ie. device gives one record, sets the _MORE flag, then gives 5.

Not an urgent fix since this behavior has not been seen in the wild,
but worth tracking as a fix.

Cc: Kwangjin Ko <kwangjin.ko@sk.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Fixes: ed83f7ca398b ("cxl/mbox: Add GET_POISON_LIST mailbox command")
Link: http://lore.kernel.org/r/20240402081404.1106-2-kwangjin.ko@sk.com [1]
Link: http://lore.kernel.org/r/ZhAhAL/GOaWFrauw@aschofie-mobl2 [2]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://lore.kernel.org/r/171235441633.2716581.12330082428680958635.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/mbox.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 4b4c15e943380..fecaa18f4dd20 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -959,25 +959,22 @@ static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
 	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
 	struct device *dev = mds->cxlds.dev;
 	struct cxl_get_event_payload *payload;
-	struct cxl_mbox_cmd mbox_cmd;
 	u8 log_type = type;
 	u16 nr_rec;
 
 	mutex_lock(&mds->event.log_lock);
 	payload = mds->event.buf;
 
-	mbox_cmd = (struct cxl_mbox_cmd) {
-		.opcode = CXL_MBOX_OP_GET_EVENT_RECORD,
-		.payload_in = &log_type,
-		.size_in = sizeof(log_type),
-		.payload_out = payload,
-		.min_out = struct_size(payload, records, 0),
-	};
-
 	do {
 		int rc, i;
-
-		mbox_cmd.size_out = mds->payload_size;
+		struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {
+			.opcode = CXL_MBOX_OP_GET_EVENT_RECORD,
+			.payload_in = &log_type,
+			.size_in = sizeof(log_type),
+			.payload_out = payload,
+			.size_out = mds->payload_size,
+			.min_out = struct_size(payload, records, 0),
+		};
 
 		rc = cxl_internal_send_cmd(mds, &mbox_cmd);
 		if (rc) {
@@ -1311,7 +1308,6 @@ int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
 	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
 	struct cxl_mbox_poison_out *po;
 	struct cxl_mbox_poison_in pi;
-	struct cxl_mbox_cmd mbox_cmd;
 	int nr_records = 0;
 	int rc;
 
@@ -1323,16 +1319,16 @@ int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
 	pi.offset = cpu_to_le64(offset);
 	pi.length = cpu_to_le64(len / CXL_POISON_LEN_MULT);
 
-	mbox_cmd = (struct cxl_mbox_cmd) {
-		.opcode = CXL_MBOX_OP_GET_POISON,
-		.size_in = sizeof(pi),
-		.payload_in = &pi,
-		.size_out = mds->payload_size,
-		.payload_out = po,
-		.min_out = struct_size(po, record, 0),
-	};
-
 	do {
+		struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd){
+			.opcode = CXL_MBOX_OP_GET_POISON,
+			.size_in = sizeof(pi),
+			.payload_in = &pi,
+			.size_out = mds->payload_size,
+			.payload_out = po,
+			.min_out = struct_size(po, record, 0),
+		};
+
 		rc = cxl_internal_send_cmd(mds, &mbox_cmd);
 		if (rc)
 			break;
-- 
2.43.0



