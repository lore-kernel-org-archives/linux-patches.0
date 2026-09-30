Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B71503BF7;
	Wed, 30 Sep 2026 15:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782410; cv=none; b=DCPNFopjubBPqPAxQlVlbHrAtlM+gtaVlQy/WgSCOE6GvBz/VvhG3/Az42O3eqaOWcx/N0IXvAGqgVyiAu/BYUrDthTA1KkbQdQWCB76SbUtj8hFgxNH3rbCrkHTvigfThB/F5ZByGdOOnyYKpNSXULSppdOwWskePuJwfdb7b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782410; c=relaxed/simple;
	bh=LyHXrXzQxKwIzc7rYB3KPXxm2XrXTMkcYX4pidGAoy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHZAEN2AYNtR91tt5omLHznQauuGhpPH1b0MAGknMUPzKQQRsEiQRHYkU35s3WGLstFadJ7/GpxZAYTzabwpKfnvgmRGHL7POysZ9gH9aY/V5swZ4ftMVO5sl5A8Cg7K2J6D+Kjn688s/dyp5WKFGI/N+0mdhX5upglFrMJBZLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdPfjZyY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdPfjZyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B2A1F000FF;
	Wed, 30 Sep 2026 15:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782399;
	bh=l5OLZvawuv8/SVKWyY/ui4uhyX3BOwS6WqoptvYBg1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VdPfjZyYHodNdvQ9zt3jb8cE8yK6eTLZR1OQ0lqnjJpX5BYmyomVp/uOJYB6Mz5mU
	 /dRMp3mGxPW9Sdeb06iFzZxGCI3Kw7IT83deNeoauYu5kXpJUraqTUsbZkTxjlKeTa
	 4+aTKEIU0nai8fvXuJZcUWjJknncmYs5xlhvFslA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/595] firmware: arm_scmi: Validate BASE_ERROR_EVENT payload size
Date: Wed, 30 Sep 2026 17:18:47 +0200
Message-ID: <20260930152348.460921454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e51d28ba2833d..9cb95ebda50eb 100644
--- a/drivers/firmware/arm_scmi/base.c
+++ b/drivers/firmware/arm_scmi/base.c
@@ -280,6 +280,8 @@ static void *scmi_base_fill_custom_report(const struct scmi_handle *handle,
 					  void *report, u32 *src_id)
 {
 	int i;
+	u32 error_status;
+	size_t expected_sz;
 	const struct scmi_base_error_notify_payld *p = payld;
 	struct scmi_base_error_report *r = report;
 
@@ -293,10 +295,19 @@ static void *scmi_base_fill_custom_report(const struct scmi_handle *handle,
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



