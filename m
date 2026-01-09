Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73E833BBBD;
	Fri,  9 Jan 2026 12:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960638; cv=none; b=WaTCKxlg60uRRNANbb4aLlkWZs5/gi+8NHGlYK1o4aDHQpc4u4+GHlQQLYRLmiEhApy8PBHmfopSHxKOHK5Bl8M202F9QGucgCJT+p6dg0JzwOEX1+NWo7uhdUHSHrXW5nYzopM+pFSyTKAgoHratKhp00bw1aNDK4JKKlybX3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960638; c=relaxed/simple;
	bh=xmVoVDfB23OJ5ZuaXeKu4Ibxj2cMt+V/M8T8aExnYQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/iwXGJ/g8KDyY/cI4YIls7LKMDnbRGjjItVcgEtNYrV88CcA/ARsXLrhabzOo0E+gV5eUenpAJ/z1OzcNFHpvQbcVu7jJY5WLz0dn4eRHR2n80tXP7ZdAqz7REqMi7tjk7PwteQTLpLWqp5sDYk9xJfFKLSq4T+ADMOij+ZgCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XYjtiGi5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XYjtiGi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694E5C16AAE;
	Fri,  9 Jan 2026 12:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960637;
	bh=xmVoVDfB23OJ5ZuaXeKu4Ibxj2cMt+V/M8T8aExnYQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYjtiGi5aVSrIZ3umn7LJoPewqtPv0jSzZImuNoLmmMgQlTfxOH9XaBEp6rSIpqaF
	 NBEo/4gjj3yT8NbB4gKxro4LxIQG333XE7GYrcYQn/Ew+4nCjaLOAiF0Eb8WBQJgOn
	 1TnGixL87XzVzGOubV3eEWIChxy415rXFuW6H2ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ed Tsai <ed.tsai@mediatek.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 473/737] PM: runtime: Do not clear needs_force_resume with enabled runtime PM
Date: Fri,  9 Jan 2026 12:40:12 +0100
Message-ID: <20260109112151.779660534@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -1827,16 +1827,18 @@ void pm_runtime_init(struct device *dev)
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


