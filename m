Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999376FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1784FC433F1;
	Mon, 16 Jan 2023 16:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887250;
	bh=1WwnH1dCxYplpChRteElxxx0MqCVuufsw9h2avIfFHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDy01Qcw5dajf5W4WqOuR5KnynrDJxXk+kG5VQmzqEU74Tv93zF3PO+7S9ImnMAp4
	 beXfYbO07+j9STOYYteBHuOPgmjeqFfM552IIY8wGjE/6cLvx5qSiUyMPxQvgESuiR
	 rNqdTOHqclMIB/yc7CcmJ8kemTPOiVUrroLz8y28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 070/521] PM: runtime: Improve path in rpm_idle() when no callback
Date: Mon, 16 Jan 2023 16:45:32 +0100
Message-Id: <20230116154850.342844367@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 5a2bd1b1c64e1ac5627db3767ac465f18606315c ]

When pm_runtime_no_callbacks() has been called for a struct device to set
the dev->power.no_callbacks flag for it, it enables rpm_idle() to take a
slightly quicker path by assuming that a ->runtime_idle() callback would
have returned 0 to indicate success.

A device that does not have the dev->power.no_callbacks flag set for it,
may still be missing a corresponding ->runtime_idle() callback, in which
case the slower path in rpm_idle() is taken. Let's improve the behaviour
for this case, by aligning code to the quicker path.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: bc80c2e438dc ("PM: runtime: Do not call __rpm_callback() from rpm_idle()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/runtime.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index eaae4adf9ce4..8a018e6d7976 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -403,7 +403,10 @@ static int rpm_idle(struct device *dev, int rpmflags)
 	/* Pending requests need to be canceled. */
 	dev->power.request = RPM_REQ_NONE;
 
-	if (dev->power.no_callbacks)
+	callback = RPM_GET_CALLBACK(dev, runtime_idle);
+
+	/* If no callback assume success. */
+	if (!callback || dev->power.no_callbacks)
 		goto out;
 
 	/* Carry out an asynchronous or a synchronous idle notification. */
@@ -419,10 +422,7 @@ static int rpm_idle(struct device *dev, int rpmflags)
 
 	dev->power.idle_notification = true;
 
-	callback = RPM_GET_CALLBACK(dev, runtime_idle);
-
-	if (callback)
-		retval = __rpm_callback(callback, dev);
+	retval = __rpm_callback(callback, dev);
 
 	dev->power.idle_notification = false;
 	wake_up_all(&dev->power.wait_queue);
-- 
2.35.1



