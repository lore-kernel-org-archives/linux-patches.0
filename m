Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C8F14430E;
	Thu, 13 Jun 2024 11:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279266; cv=none; b=HQMKHUqf1SBybNw81EtAsyUbBou+4IymliDGLTndwJwMDLQtIbinRpFWKxUAc4vRyCLrF1MIAhMbBdZ85ttpbWZDAZAu/ZAfBcgdXGT2WgjtuTQps6TJ9TzaDC7E4g0TxovUhgcgClkthUKKS0LB7LRBIG9yIIT19yEl5SU+xNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279266; c=relaxed/simple;
	bh=vcQOQbXAj6MtgHf5FV0jFm9rA4KsgajSjYQ9myglI0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjgERyofvIibb7wgnrU/jVEJQ7G5OzIMpnIPfH+5FpBsGmZLhlpkG70Lzu2sFkAGsblOS+EyiLrlx0eIunSqFqGQT5e7BZR+9U6WY1PphLcN1Gno/Wih6wY0stJLzz6qdPlY/lAAF+pk9j7Aw7MT1x3z28LVtNIbbTpxYZTwfDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SS0gMCb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SS0gMCb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17A5C2BBFC;
	Thu, 13 Jun 2024 11:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279266;
	bh=vcQOQbXAj6MtgHf5FV0jFm9rA4KsgajSjYQ9myglI0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SS0gMCb6UUw1Hd5+qYeJjtE9vS3kFBsDE8K6VkLi9s0H+/pzjyXwbGQpG0NnMq96H
	 GkVxMOiMFLrAj3uQDQyBCkb+nQa4y05Lo2HmIwUKdho65A0/9ogEE16YCha3m3ifN+
	 Bby/nv/sWizeX61qE2bqM3UiBxeNLzIX1k3AR9/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lalith Rajendran <lalithkraj@chromium.org>,
	chrome-platform@lists.linux.dev,
	Karthikeyan Ramasubramanian <kramasub@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.9 018/157] platform/chrome: cros_ec: Handle events during suspend after resume completion
Date: Thu, 13 Jun 2024 13:32:23 +0200
Message-ID: <20240613113228.111203523@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthikeyan Ramasubramanian <kramasub@chromium.org>

commit 2fbe479c0024e1c6b992184a799055e19932aa48 upstream.

Commit 47ea0ddb1f56 ("platform/chrome: cros_ec_lpc: Separate host
command and irq disable") re-ordered the resume sequence. Before that
change, cros_ec resume sequence is:
1) Enable IRQ
2) Send resume event
3) Handle events during suspend

After commit 47ea0ddb1f56 ("platform/chrome: cros_ec_lpc: Separate host
command and irq disable"), cros_ec resume sequence is:
1) Enable IRQ
2) Handle events during suspend
3) Send resume event.

This re-ordering leads to delayed handling of any events queued between
items 2) and 3) with the updated sequence. Also in certain platforms, EC
skips triggering interrupt for certain events eg. mkbp events until the
resume event is received. Such events are stuck in the host event queue
indefinitely. This change puts back the original order to avoid any
delay in handling the pending events.

Fixes: 47ea0ddb1f56 ("platform/chrome: cros_ec_lpc: Separate host command and irq disable")
Cc: <stable@vger.kernel.org>
Cc: Lalith Rajendran <lalithkraj@chromium.org>
Cc: <chrome-platform@lists.linux.dev>
Signed-off-by: Karthikeyan Ramasubramanian <kramasub@chromium.org>
Link: https://lore.kernel.org/r/20240429121343.v2.1.If2e0cef959f1f6df9f4d1ab53a97c54aa54208af@changeid
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/platform/chrome/cros_ec.c
+++ b/drivers/platform/chrome/cros_ec.c
@@ -432,6 +432,12 @@ static void cros_ec_send_resume_event(st
 void cros_ec_resume_complete(struct cros_ec_device *ec_dev)
 {
 	cros_ec_send_resume_event(ec_dev);
+
+	/*
+	 * Let the mfd devices know about events that occur during
+	 * suspend. This way the clients know what to do with them.
+	 */
+	cros_ec_report_events_during_suspend(ec_dev);
 }
 EXPORT_SYMBOL(cros_ec_resume_complete);
 
@@ -442,12 +448,6 @@ static void cros_ec_enable_irq(struct cr
 
 	if (ec_dev->wake_enabled)
 		disable_irq_wake(ec_dev->irq);
-
-	/*
-	 * Let the mfd devices know about events that occur during
-	 * suspend. This way the clients know what to do with them.
-	 */
-	cros_ec_report_events_during_suspend(ec_dev);
 }
 
 /**
@@ -475,8 +475,8 @@ EXPORT_SYMBOL(cros_ec_resume_early);
  */
 int cros_ec_resume(struct cros_ec_device *ec_dev)
 {
-	cros_ec_enable_irq(ec_dev);
-	cros_ec_send_resume_event(ec_dev);
+	cros_ec_resume_early(ec_dev);
+	cros_ec_resume_complete(ec_dev);
 	return 0;
 }
 EXPORT_SYMBOL(cros_ec_resume);


