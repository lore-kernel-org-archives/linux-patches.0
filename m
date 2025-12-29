Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549E03321CA;
	Mon, 29 Dec 2025 16:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025851; cv=none; b=m3mCWKMgcfoq+ITN7TN39K7qJuW9ZtyUBrJqyI6yA53+ujgZGIidQsYxR2Ul2WzVzd8MOpbTUi/krCt3EewuhgcIuvlrwJJTALc/0DPunt5j3DYeVW0+iIyw2PdwLEeu6QYcgXn2inkPS93U2KX24TlvqXno7Th6uy9Pski40Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025851; c=relaxed/simple;
	bh=gsRsOpW08vMNAPD1njWvD2II7vLqK1kTsLtCnvALxgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrRvhDYmBmXZGiDgJ7v7QNuvpKXYORryYgXz0LMA3/BvXdhJSzzZiQ4TogIIvcRkf+d+j5erSER47rhlYn2DGEwj/EFLedfPg/A8e8CGGpGiNY71H2AQmIAeI2HgoKtJMft0PtiCWYPFtLqHSs8bRm8AffwCRH/i7GwJFkCpPPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RH5oRYyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RH5oRYyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4783C4CEF7;
	Mon, 29 Dec 2025 16:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025851;
	bh=gsRsOpW08vMNAPD1njWvD2II7vLqK1kTsLtCnvALxgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RH5oRYywlrbXyvbb5vklS+xmlLbkyA8rRBelZoIPkMRRrJRifQ43rs+Gdi4FeSGDX
	 0q9vaBhnEA/woeSCwu73te5tDkD8i8sPgUnEGKnIuWzKAR2PUE4tHYb8F7gAG5GLk0
	 HoqIF6vHlScmxsclX36055lojHpzAmrO9/1VIY0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ed Tsai <ed.tsai@mediatek.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 360/430] PM: runtime: Do not clear needs_force_resume with enabled runtime PM
Date: Mon, 29 Dec 2025 17:12:42 +0100
Message-ID: <20251229160737.576745801@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 359afc8eb02a518fbdd0cbd462c8c2827c6cbec2 upstream.

Commit 89d9cec3b1e9 ("PM: runtime: Clear power.needs_force_resume in
pm_runtime_reinit()") added provisional clearing of power.needs_force_resume
to pm_runtime_reinit(), but it is done unconditionally which is a
mistake because pm_runtime_reinit() may race with driver probing
and removal [1].

To address this, notice that power.needs_force_resume should never
be set when runtime PM is enabled and so it only needs to be cleared
when runtime PM is disabled, and update pm_runtime_init() to only
clear that flag when runtime PM is disabled.

Fixes: 89d9cec3b1e9 ("PM: runtime: Clear power.needs_force_resume in pm_runtime_reinit()")
Reported-by: Ed Tsai <ed.tsai@mediatek.com>
Closes: https://lore.kernel.org/linux-pm/20251215122154.3180001-1-ed.tsai@mediatek.com/ [1]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 6.17+ <stable@vger.kernel.org> # 6.17+
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://patch.msgid.link/12807571.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/runtime.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1869,16 +1869,18 @@ void pm_runtime_init(struct device *dev)
  */
 void pm_runtime_reinit(struct device *dev)
 {
-	if (!pm_runtime_enabled(dev)) {
-		if (dev->power.runtime_status == RPM_ACTIVE)
-			pm_runtime_set_suspended(dev);
-		if (dev->power.irq_safe) {
-			spin_lock_irq(&dev->power.lock);
-			dev->power.irq_safe = 0;
-			spin_unlock_irq(&dev->power.lock);
-			if (dev->parent)
-				pm_runtime_put(dev->parent);
-		}
+	if (pm_runtime_enabled(dev))
+		return;
+
+	if (dev->power.runtime_status == RPM_ACTIVE)
+		pm_runtime_set_suspended(dev);
+
+	if (dev->power.irq_safe) {
+		spin_lock_irq(&dev->power.lock);
+		dev->power.irq_safe = 0;
+		spin_unlock_irq(&dev->power.lock);
+		if (dev->parent)
+			pm_runtime_put(dev->parent);
 	}
 	/*
 	 * Clear power.needs_force_resume in case it has been set by


