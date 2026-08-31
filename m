Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8843147ACE6;
	Mon, 31 Aug 2026 13:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184540; cv=none; b=mCZ984aC7bxMn9xELw2F0qRUI6VPPEZu0XsCmb1aDzDnHh69VcfQCymVtQMY644W6FdnjPP2fzUNWqKaNQ3h7fzaf3xNSOHnYjA/KA4BBXQDiLKirR7PEU3bpmL7kMG3/pP+RBDDzi0insHsCO0fUbmdpXia0k3SCKkwhl9DTGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184540; c=relaxed/simple;
	bh=bNTcEzX3PR1rmDRyiHm8of/vMdaV0G7zzyX8e0Z2Fa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HE64Qpizv4Jxjhz6Ku3PgAI5O2OEmDqFvM/kJZq4un7ToQd/PqxnFNSXO7mJcRdYbwkghrpl6x672wFRD1dzJt9IrDJTAQW30htxi4h9omY4aYMMFzCY2s+gpj8tVvkM1+RJp7fgj5jerd18Rt9m1R+5xluvXSyb+lhBi0f4zcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GTNbugC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GTNbugC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C511F000E9;
	Mon, 31 Aug 2026 13:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184539;
	bh=XvuejDd9XfAPUjE0sqeYCRgsdMyrBkAVHnNDyL8jVek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0GTNbugCzApTQZhV/XT8kTmpNn6GiUkp/Vp6pcOmvrEDue3o3oWABa0eBJX7hGeWR
	 cHfbF7QlUTEgqt+XCe3kRBjDKO0XkXpeWNmcMndiJzA1l2UsPufOWBPGOKtLKzqGi9
	 GzkV+LApNjKo1cfgTzKYEbtiQHxEDWQBNpvnlCQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 26/91] Revert "PM: sleep: Use complete() in device_pm_sleep_init()"
Date: Mon, 31 Aug 2026 15:34:14 +0200
Message-ID: <20260831133401.030002438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

This reverts commit 59096e2aa0f66008fab21a3ebf8e097bc026c060.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index dc3d30860ef32..ef5157fc8dcc5 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -101,7 +101,7 @@ void device_pm_sleep_init(struct device *dev)
 	dev->power.is_noirq_suspended = false;
 	dev->power.is_late_suspended = false;
 	init_completion(&dev->power.completion);
-	complete(&dev->power.completion);
+	complete_all(&dev->power.completion);
 	dev->power.wakeup = NULL;
 	INIT_LIST_HEAD(&dev->power.entry);
 }
@@ -238,10 +238,6 @@ static void dpm_wait(struct device *dev, bool async)
 	if (!dev)
 		return;
 
-	/* Devices with no PM support don't use the completion. */
-	if (dev->power.no_pm)
-		return;
-
 	if (async || (pm_async_enabled && dev->power.async_suspend))
 		wait_for_completion(&dev->power.completion);
 }
-- 
2.53.0



