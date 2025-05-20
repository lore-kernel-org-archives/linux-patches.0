Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541E2EEDE;
	Tue, 20 May 2025 14:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749755; cv=none; b=I2lFCcs9hNFyZ2jQhEXoW6yGPfOKYe/PrBXBU2GKnMHJRYa3e96bUsTUxCJCfseRkTNdfJAnBejrQy8nEtjBIYlqMwXYfLIP8EvB1yfFeRuDswDpQNomGO5MdJ6g3L7/6uhBXL1PejfM83xmWREV1AdrCZvABvgGxQrjMBVQtBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749755; c=relaxed/simple;
	bh=d9yfU9pOl4WNcwyfiJGZfMJlxfxBiNKOCBXlGYjv6Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hp/N51SORVf1+pEgx657IC7hHXeCYMvUZ+OfFfHX6F47RDkll0iup02gpbbMLYm2HGJZ9lFn2Nn8vVI4cGehXQaGizFQJHvpYHFAH9YUYOl/GjTDBLRqWG10dsRP5VG8r4N2FteBRoo43CVPy6r2b0uh78FTW40TUkndiMpjs7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gp1HRgd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gp1HRgd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7B2C4CEE9;
	Tue, 20 May 2025 14:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749755;
	bh=d9yfU9pOl4WNcwyfiJGZfMJlxfxBiNKOCBXlGYjv6Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gp1HRgd4xzir1sVQrzkljEsu2ToVsIYMYsn/yNTpjsYA5eI+JEsJG3RWc2jMTYMRP
	 LWwaa/WzaRMrA9NphFAwAG90jo/HV/0ongzoaTbE/gavyGImLB6rE1UotkYIQPoBkk
	 ZcspKhWJjPeLJUwGavwUmo4fFiagh3ICDOXvoKeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huangjie <huangjie1663@phytium.com.cn>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/117] firmware: arm_scmi: Fix timeout checks on polling path
Date: Tue, 20 May 2025 15:49:44 +0200
Message-ID: <20250520125804.743533476@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit c23c03bf1faa1e76be1eba35bad6da6a2a7c95ee ]

Polling mode transactions wait for a reply busy-looping without holding a
spinlock, but currently the timeout checks are based only on elapsed time:
as a result we could hit a false positive whenever our busy-looping thread
is pre-empted and scheduled out for a time greater than the polling
timeout.

Change the checks at the end of the busy-loop to make sure that the polling
wasn't indeed successful or an out-of-order reply caused the polling to be
forcibly terminated.

Fixes: 31d2f803c19c ("firmware: arm_scmi: Add sync_cmds_completed_on_ret transport flag")
Reported-by: Huangjie <huangjie1663@phytium.com.cn>
Closes: https://lore.kernel.org/arm-scmi/20250123083323.2363749-1-jackhuang021@gmail.com/
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Cc: stable@vger.kernel.org # 5.18.x
Message-Id: <20250310175800.1444293-1-cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 09aaad6dce043..65d1e66a347d7 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -1075,7 +1075,8 @@ static void xfer_put(const struct scmi_protocol_handle *ph,
 }
 
 static bool scmi_xfer_done_no_timeout(struct scmi_chan_info *cinfo,
-				      struct scmi_xfer *xfer, ktime_t stop)
+				      struct scmi_xfer *xfer, ktime_t stop,
+				      bool *ooo)
 {
 	struct scmi_info *info = handle_to_scmi_info(cinfo->handle);
 
@@ -1084,7 +1085,7 @@ static bool scmi_xfer_done_no_timeout(struct scmi_chan_info *cinfo,
 	 * in case of out-of-order receptions of delayed responses
 	 */
 	return info->desc->ops->poll_done(cinfo, xfer) ||
-	       try_wait_for_completion(&xfer->done) ||
+	       (*ooo = try_wait_for_completion(&xfer->done)) ||
 	       ktime_after(ktime_get(), stop);
 }
 
@@ -1101,15 +1102,17 @@ static int scmi_wait_for_reply(struct device *dev, const struct scmi_desc *desc,
 		 * itself to support synchronous commands replies.
 		 */
 		if (!desc->sync_cmds_completed_on_ret) {
+			bool ooo = false;
+
 			/*
 			 * Poll on xfer using transport provided .poll_done();
 			 * assumes no completion interrupt was available.
 			 */
 			ktime_t stop = ktime_add_ms(ktime_get(), timeout_ms);
 
-			spin_until_cond(scmi_xfer_done_no_timeout(cinfo,
-								  xfer, stop));
-			if (ktime_after(ktime_get(), stop)) {
+			spin_until_cond(scmi_xfer_done_no_timeout(cinfo, xfer,
+								  stop, &ooo));
+			if (!ooo && !info->desc->ops->poll_done(cinfo, xfer)) {
 				dev_err(dev,
 					"timed out in resp(caller: %pS) - polling\n",
 					(void *)_RET_IP_);
-- 
2.39.5



