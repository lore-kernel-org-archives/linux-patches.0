Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBF932A3E1;
	Mon, 27 Oct 2025 18:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591128; cv=none; b=SHoPeP+gEHVhna6xzrw83P32EQw66XbkL29EfV9i8U1u5yKX6t4lTNOyKpwXBeAjBP9gngA1tXYmI7jjpD6oaws+r4DRrrfzBEbODHRJ1rlCjWoWbCU+TTWK4yHyUoWnwgoFxqZWGbCqqjfsV85PnpanYfGyEZUffC2eX+y6Bi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591128; c=relaxed/simple;
	bh=412YTRPzIYp5q3UZYS0yWXHe9j7T68A8xOW8sL6R7f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0P1m2yg6gurwqvVg5JK7jWMej6bf0mV678lwVjSGXybD7jlPjuwaM/ePI0TnC6nzhAwH8wHpvOp8fdry+C74SXxnmmnwrnr/3E8ZlZIBfE0edpTU+pmpHZL4MT9AW/MurmsS19DDqMh/g1n6fSeXEOSMySaFsEcHiyTLuyB2KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sht2T+p1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sht2T+p1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49D5C4CEF1;
	Mon, 27 Oct 2025 18:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591128;
	bh=412YTRPzIYp5q3UZYS0yWXHe9j7T68A8xOW8sL6R7f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sht2T+p12XFKa4+jn8NHUFeRrYMcDsH2Z/8gmaczMJ+xyJuNn/rYUvqfAXY35HMLG
	 S67yllBn4y0UlIvY20Wo4+rr71NiSwHx8vcwudK4C5IejnO6CWZ/diyaxWQ947+9C3
	 3LM6qPr+rY/R2/5IBSafT7ZFtLaZ6nrg2LEP/EZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/332] PM: sleep: core: Clear power.must_resume in noirq suspend error path
Date: Mon, 27 Oct 2025 19:31:24 +0100
Message-ID: <20251027183525.442646213@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit be82483d1b60baf6747884bd74cb7de484deaf76 ]

If system suspend is aborted in the "noirq" phase (for instance, due to
an error returned by one of the device callbacks), power.is_noirq_suspended
will not be set for some devices and device_resume_noirq() will return
early for them.  Consequently, noirq resume callbacks will not run for
them at all because the noirq suspend callbacks have not run for them
yet.

If any of them has power.must_resume set and late suspend has been
skipped for it (due to power.smart_suspend), early resume should be
skipped for it either, or its state may become inconsistent (for
instance, if the early resume assumes that it will always follow
noirq resume).

Make that happen by clearing power.must_resume in device_resume_noirq()
for devices with power.is_noirq_suspended clear that have been left in
suspend by device_suspend_late(), which will subsequently cause
device_resume_early() to leave the device in suspend and avoid
changing its state.

Fixes: 0d4b54c6fee8 ("PM / core: Add LEAVE_SUSPENDED driver flag")
Link: https://lore.kernel.org/linux-pm/5d692b81-6f58-4e86-9cb0-ede69a09d799@rowland.harvard.edu/
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://patch.msgid.link/3381776.aeNJFYEL58@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 5600ceb9212d9..964573e30d691 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -604,8 +604,20 @@ static void __device_resume_noirq(struct device *dev, pm_message_t state, bool a
 	if (dev->power.syscore || dev->power.direct_complete)
 		goto Out;
 
-	if (!dev->power.is_noirq_suspended)
+	if (!dev->power.is_noirq_suspended) {
+		/*
+		 * This means that system suspend has been aborted in the noirq
+		 * phase before invoking the noirq suspend callback for the
+		 * device, so if device_suspend_late() has left it in suspend,
+		 * device_resume_early() should leave it in suspend either in
+		 * case the early resume of it depends on the noirq resume that
+		 * has not run.
+		 */
+		if (dev_pm_skip_suspend(dev))
+			dev->power.must_resume = false;
+
 		goto Out;
+	}
 
 	if (!dpm_wait_for_superior(dev, async))
 		goto Out;
-- 
2.51.0



