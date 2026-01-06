Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C060234B41E;
	Tue,  6 Jan 2026 17:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720430; cv=none; b=CHBAU9KAUuqtCIVKQH9ob+0p6QrvfmUdxjiHNxkz63GjyKd+21LNKuQPcVwsk3D7zA5ZwyPqlYbCBfrZBY8YaLhOeb/h6hmcVJSfJaAau0HQzRkCZ82L2Q5vjgGGTVx+P20DT48JEhQ774O8DNgYNI8gkGB8obp4+XhVL9biZdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720430; c=relaxed/simple;
	bh=DWs5oPl3VMppU7a7WtVIjtszQakfbZuJL1dHv66EZ5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVZR7CDKVpBTVav66X+K87uETf7jl4Or8Bkh+hTZjLPgVgL820XHnuWT5iRlVe0+axOGx2AVmhm+oZ4Ij9uooNtxJsSfLN2OQGLt7iWcupTJmVyw3K9L+3tZGb3oFTdKtDI78HJxFLBihcWpiR29uYsX2ZQFPaMIdbwrTwwXbZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4X5V/4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4X5V/4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5B9C116C6;
	Tue,  6 Jan 2026 17:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720430;
	bh=DWs5oPl3VMppU7a7WtVIjtszQakfbZuJL1dHv66EZ5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4X5V/4QpbTMNd27XTRz5tGvZegipqdh22EEacbLvTmGAHMVpZX8EwmSTMPPXswns
	 KfLNFA9oMXGPdP89a1X/499TFDxD2dSgeFjhC/bnQgWKQGYhoTOEIIXalwK8VuFUro
	 JPAQXRb200D0CCP8/lRySR4CtjJni+Woudjq01t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ed Tsai <ed.tsai@mediatek.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 234/567] PM: runtime: Do not clear needs_force_resume with enabled runtime PM
Date: Tue,  6 Jan 2026 18:00:16 +0100
Message-ID: <20260106170459.976543835@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1829,16 +1829,18 @@ void pm_runtime_init(struct device *dev)
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


