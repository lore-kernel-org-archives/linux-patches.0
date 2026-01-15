Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351B63D3D0F;
	Thu, 15 Jan 2026 17:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499531; cv=none; b=p54z/zgGnlg2+Obzq9kHejzVpJR8F0x51BdOchXc0RLP4nZOvbIt+hLZq8Ih+jFtuMv7MCs6Np9YT23HSVUqshTGOfenihyZ0NdxuFwkRcfoFQk36sL4RuIeUmG+yjt+6cqwiy3swBeKLnY6zjedanJRUnra2xgQ3TXTpJlE2To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499531; c=relaxed/simple;
	bh=M3jtCnV2zXpxkdo4PLXbX1hm/L+n3UricRcILvEb3XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gsf8GUr/PJJ/9I2ENGNXSJAt6RzQ5lHkF2wfSqujs3d8Ce5Js4e+t0mGZP2dGLxC++Vtm+cdiea/VVsvuAOmk414wm+Kpq/JvWU+AJVQ8ef6HIDIePMA+mcN8cJjwL89uDH1De7EXHc1fR8MfL+9pP8dVHazvfgCHQ2zbonWjqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNlzwm2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNlzwm2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A06C116D0;
	Thu, 15 Jan 2026 17:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499530;
	bh=M3jtCnV2zXpxkdo4PLXbX1hm/L+n3UricRcILvEb3XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNlzwm2biVzPRi/kprgPa7AGvzd5e/H2yys1JVfZd6hasNy4rPrz0h3PBaiAhCl1s
	 HoL9AHmVU9di3CWFd3LJ5YgLCDoILcYTUgCs17LnVj7Z5q1UjAVdIp+PRkDrmcjbuZ
	 vvDh6qv23GSy8Frq0YYMq/BXxpFhXscSzG4kjKBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ed Tsai <ed.tsai@mediatek.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 259/451] PM: runtime: Do not clear needs_force_resume with enabled runtime PM
Date: Thu, 15 Jan 2026 17:47:40 +0100
Message-ID: <20260115164240.256447985@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
@@ -1749,16 +1749,18 @@ void pm_runtime_init(struct device *dev)
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


