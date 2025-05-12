Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45EC1E505;
	Mon, 12 May 2025 17:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072705; cv=none; b=iABmvkGtBaTYamdCPi8fp66ioo0TudDSwE4QsIXXc32CTYh94vfozSFT8Co49OyrjYxUozj6iKnISUfimJJRYxg4SGhjbVET6odFqELI/2nmWYTWjXSAfZYtg8giiq+rdWv5WjXQ/UXME7u/cFfawDZv45bINIFNpsTOEhz6e2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072705; c=relaxed/simple;
	bh=rartuj76I+4pkS+EOBFeEwH9voDtJFFYXnRMZBYXYQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYvQYddH7XAQE4bqIc/WGClR5jlD5RU6daM/i60Qw67hp/iTGzOp/TfczqObzNF2boCwRWNBhXvGi6lF64qXbhzkM6vNF0vJ1cpgaChmxVGRDR1D5lrHuYHk/dJrssVIfKPFMmmHv5fcogrpMlQCpxGe8krwxIKRIBNf09ssrtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBQugAu9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBQugAu9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FF3C4CEE7;
	Mon, 12 May 2025 17:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072705;
	bh=rartuj76I+4pkS+EOBFeEwH9voDtJFFYXnRMZBYXYQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBQugAu9tJIXfvMOOqoDruAbfMYi5G1qj15Y1o8fBBGCBkGQRyOfC5OodPqR9bjoK
	 ihZZYvQsr7cDL5Rf+ltSBzrrRxSlVd4AojxgLzC1pL5v1Y5pBtiKPE+drj3lnqEgHs
	 wvNew4t6lHuHocjwKHesOYtq4yUgao/MJQyFVJcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huangjie <huangjie1663@phytium.com.cn>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.12 005/184] firmware: arm_scmi: Fix timeout checks on polling path
Date: Mon, 12 May 2025 19:43:26 +0200
Message-ID: <20250512172041.866067117@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Marussi <cristian.marussi@arm.com>

commit c23c03bf1faa1e76be1eba35bad6da6a2a7c95ee upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/driver.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -1219,7 +1219,8 @@ static void xfer_put(const struct scmi_p
 }
 
 static bool scmi_xfer_done_no_timeout(struct scmi_chan_info *cinfo,
-				      struct scmi_xfer *xfer, ktime_t stop)
+				      struct scmi_xfer *xfer, ktime_t stop,
+				      bool *ooo)
 {
 	struct scmi_info *info = handle_to_scmi_info(cinfo->handle);
 
@@ -1228,7 +1229,7 @@ static bool scmi_xfer_done_no_timeout(st
 	 * in case of out-of-order receptions of delayed responses
 	 */
 	return info->desc->ops->poll_done(cinfo, xfer) ||
-	       try_wait_for_completion(&xfer->done) ||
+	       (*ooo = try_wait_for_completion(&xfer->done)) ||
 	       ktime_after(ktime_get(), stop);
 }
 
@@ -1245,15 +1246,17 @@ static int scmi_wait_for_reply(struct de
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


