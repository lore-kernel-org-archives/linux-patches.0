Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5084FE2D4;
	Thu, 17 Sep 2026 16:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661340; cv=none; b=bdVnDp24/K6aqnjifemQwstz6I06wv5Mlc8dS5N8PjNy5ZjcnIYxjr0fw7z9iXs613m6PcaYeHVlnHyS/Q9joD3ns7froMSHwEsTFu9rkxjGLirD1zvamOWSMz4BI7Kh86w8g5wqVg8HH++tghKkP8F0P438amq+PRCOWnw0bzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661340; c=relaxed/simple;
	bh=FBbB6dMXM2Nj4XqfMZgiW6WT1V+iW6/sWlfggkeDZLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXkvHhZIQbSjfAcUbibQXaYsLcqYYqK/R1jFvXTUD1IWYsBtHPt0PwcDv8AY5+qjnl8FfDYLCzvkRcQ03Pclz/7NVoN5FJWFnsPLRNFejWsD4Gz+fdlHl2TUbc49qPDGHvl9eg+xWlKtRleA8/jL5S3KmL73dxvJ6T8UlE9AcNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVU/wI8s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVU/wI8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAF21F000FF;
	Thu, 17 Sep 2026 16:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661338;
	bh=wjlOowUmPxl0OqK9JfsjbTcS9gdLwE9WrFfX/rwV0Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xVU/wI8sIiE/dGQLdEI/u0F+XUMKdF4DqS3xxdINMW+JDQcOqnZLPL69aIfnfMPgr
	 kfVdp2SMIypb3Lba32nttsmIAgI7pXtA9FY/vjrpgQpPq5V+KvB3f/g1x2uoK0O1x/
	 qGIRPB3W4uA1UCTKoDHu7whnR/tsxq9VsLwJFwIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0161/1250] firmware: arm_scmi: Validate BASE_ERROR_EVENT payload size
Date: Thu, 17 Sep 2026 15:59:16 +0100
Message-ID: <20260917151556.450757414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 86b376c50a13f..25aa52746bd10 100644
--- a/drivers/firmware/arm_scmi/base.c
+++ b/drivers/firmware/arm_scmi/base.c
@@ -325,6 +325,8 @@ static void *scmi_base_fill_custom_report(const struct scmi_protocol_handle *ph,
 					  void *report, u32 *src_id)
 {
 	int i;
+	u32 error_status;
+	size_t expected_sz;
 	const struct scmi_base_error_notify_payld *p = payld;
 	struct scmi_base_error_report *r = report;
 
@@ -338,10 +340,19 @@ static void *scmi_base_fill_custom_report(const struct scmi_protocol_handle *ph,
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



