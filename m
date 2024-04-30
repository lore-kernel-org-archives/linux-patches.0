Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4737512B176;
	Tue, 30 Apr 2024 10:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474234; cv=none; b=QJZ+9l6AxJY4lvKg/0bYJ7MCUwffTtaY9FwAR+S28eIu7s+e+se31TWx5tpEbF5CqdNyoUckViL1wewoWujdAKMoyyYrU6iXb1jlXLMNYsBbSm9KGjmC+NJIgJFaFF5wnlLNZ3ClUymK5DpvudDXPKCliqlCon/HViwgn/RicFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474234; c=relaxed/simple;
	bh=9uL6tDCODBLvxCnL1h4zmD8m2GfjJcqpsk0TMOWeeiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSWkKqceeEPS15LFA05HpBxmSkRHbm7by8qyHqI9j78Ex4EkGCoEh3U493c3Qc42SoNiRY7FojVOjZmnWXGDa3bVJXKxXdHxd2Z5ZkG8ln3aGz1Suomd8ZEmga0DrMAd2O+DIQPs0LW8Tvml9pBU5YysZZI6lKQSJcN5PJqvNpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVw1j11U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVw1j11U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBABC4AF1A;
	Tue, 30 Apr 2024 10:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474234;
	bh=9uL6tDCODBLvxCnL1h4zmD8m2GfjJcqpsk0TMOWeeiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVw1j11UHUTWJp1nmutmtqREWrkdZurVL2lHmM+8b2Ab+dQSVGDECOFRQ69i014ys
	 aaSm1fU16DByGEPF1cIBbgSqHPhx1GYXZdXMt9rMZAwMslRhGfJ3OYq3L0xa4dN387
	 5IR6SqAq7Lmxh+RiAe6mU50d9sCj39sMuo7Ay43E=
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
Subject: [PATCH 6.8 060/228] cxl/core: Fix potential payload size confusion in cxl_mem_get_poison()
Date: Tue, 30 Apr 2024 12:37:18 +0200
Message-ID: <20240430103105.540845976@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index f0f54aeccc872..65185c9fa0013 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -946,25 +946,22 @@ static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
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
@@ -1297,7 +1294,6 @@ int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
 	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
 	struct cxl_mbox_poison_out *po;
 	struct cxl_mbox_poison_in pi;
-	struct cxl_mbox_cmd mbox_cmd;
 	int nr_records = 0;
 	int rc;
 
@@ -1309,16 +1305,16 @@ int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
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



