Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727F330E0FB;
	Wed, 30 Sep 2026 18:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794047; cv=none; b=aRS5o53WDM56kCiiaXuL0CaIkJCfB2WFm9RXpnrldIHXChu7cMxHGPqRENZ3xaoVW8OqDlfgSM/gvFKR/gC2fScFZBKveYJ/KpQcniMsjoIWcBMd7IFFglKxY6ndxe/k0QpkFheL70nfzast4rjWBNrNjcayaedtKh0+aHko1dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794047; c=relaxed/simple;
	bh=Wrxkd1Uca0JeZMnkXqdNijPsXBeoNom5umF2NHAM51A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ax52sZkILAVkJZV3P7y1oO1BFeWQd4T7xdgtVBebQZ7cO/Rw3+qlLO/IL7VQtJ//t4+LjtLBS+YeuhvqueySxe2343J3eYISNRCOIlR3SLDqNhQD8fyrP7Ue/WQmiR0SnFh9k7ysHM5Thv7jYIwxKFDQIo8oqv0sMtdPqHk4GCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sIgUSRtr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sIgUSRtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA741F000FF;
	Wed, 30 Sep 2026 18:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794046;
	bh=9MbQcA6UgVujTZ3vNUMOLAWaACueWeGnWRJSKtjNXoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sIgUSRtri0ejXG2IBNaWQ4Svbe0hDKRsDpU7s1RV9pA7PDuTd78T5Ejtakat9oOWD
	 E9nkzGpd/fLYUYL2WR9cco35+rhzXTi0XAh5cVMmrZY9PTSMT2vw1bTNptTfD3hqeJ
	 gBMe+jFr/PFuTcv4xXn+dTMvAky2NwHIdPWNALBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0073/1193] firmware: arm_scmi: Validate BASE_ERROR_EVENT payload size
Date: Wed, 30 Sep 2026 17:12:37 +0200
Message-ID: <20260930152435.886464804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 56e7e64cdd0e7209a58c8ec66028d63387402919 ]

BASE_ERROR_EVENT carries a variable number of message reports,
with the count encoded in error_status. The notification parser used
that count without checking whether the received payload contained all
reported entries.

Reject truncated payloads before copying the report array.

Link: https://patch.msgid.link/20260517-scmi_fixes-v1-2-d86daec4defd@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/base.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/base.c b/drivers/firmware/arm_scmi/base.c
index a52f084a6a87b..f455165a81bcd 100644
--- a/drivers/firmware/arm_scmi/base.c
+++ b/drivers/firmware/arm_scmi/base.c
@@ -324,6 +324,8 @@ static void *scmi_base_fill_custom_report(const struct scmi_protocol_handle *ph,
 					  void *report, u32 *src_id)
 {
 	int i;
+	u32 error_status;
+	size_t expected_sz;
 	const struct scmi_base_error_notify_payld *p = payld;
 	struct scmi_base_error_report *r = report;
 
@@ -337,10 +339,19 @@ static void *scmi_base_fill_custom_report(const struct scmi_protocol_handle *ph,
 	if (evt_id != SCMI_EVENT_BASE_ERROR_EVENT || sizeof(*p) < payld_sz)
 		return NULL;
 
+	expected_sz = offsetof(typeof(*p), msg_reports);
+	if (payld_sz < expected_sz)
+		return NULL;
+
 	r->timestamp = timestamp;
 	r->agent_id = le32_to_cpu(p->agent_id);
-	r->fatal = IS_FATAL_ERROR(le32_to_cpu(p->error_status));
-	r->cmd_count = ERROR_CMD_COUNT(le32_to_cpu(p->error_status));
+	error_status = le32_to_cpu(p->error_status);
+	r->fatal = IS_FATAL_ERROR(error_status);
+	r->cmd_count = ERROR_CMD_COUNT(error_status);
+	expected_sz += r->cmd_count * sizeof(p->msg_reports[0]);
+	if (payld_sz < expected_sz)
+		return NULL;
+
 	for (i = 0; i < r->cmd_count; i++)
 		r->reports[i] = le64_to_cpu(p->msg_reports[i]);
 	*src_id = 0;
-- 
2.53.0



