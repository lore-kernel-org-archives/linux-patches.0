Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3484C30D401;
	Wed, 30 Sep 2026 19:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796444; cv=none; b=f98HYMNJJnJSsvB+ozX9+MSH/z8AgUSz1xXcHjh/R++Cm3aWNIlKFxJhJ+e0NNAFT10oDJLnql0He4E8yEhadMmU2uZOWTfc4rtOvQYZFAX0CKi567mE+5NK4U1/LiBGm96MPoW/vyJEmsU6/GePmWBunNnw/HXSoUDbQZcqUEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796444; c=relaxed/simple;
	bh=VlczKa1b/NyIpJ+SR7JNuPNgQ9+Y927RNGw1M5BRIwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usdcj579F9DoTIpbV2RkSkouyGjbZEIzHfBt440vq2Kr2jRRusfXINw3zTYz0/AgTTZt0Ti5CJPhkUI5UmCmfc6bRRi6UELpaebqwY+cgqMXPsU/NlPYbNlM6+cLEvq27SILCIVzP0Nu3i40zz4EI1nKc7ObVg4RJDSscpdwFbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSkqZMWk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSkqZMWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429B71F000FF;
	Wed, 30 Sep 2026 19:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796442;
	bh=O1JdjwsrI+Ytewnzfd4kbl/JlbA0nOQ72c1pnnznsaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uSkqZMWkBvCXq4GLp9P+Mgs+d/ZzLBvbbbbEaApRkyru3mH/1fBkMvp7wqga7RR4e
	 6PzIuf8fEDAuw2aAw5vVokY2U3aEsKlDKExiR5aowFzuUvfxoxL9w5T1C9v7H+vCum
	 ca4tJRgulghQ5I+Su6d2V4se34+lEGVJWCJH7JBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 0916/1193] watchdog: starfive-wdt: Fix runtime PM leak in starfive_wdt_pm_start()
Date: Wed, 30 Sep 2026 17:26:40 +0200
Message-ID: <20260930152454.591859890@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 8f0ca55016a7647109ae2bc91bcb346fc8b13785 upstream.

starfive_wdt_pm_start() takes a runtime PM reference with
pm_runtime_get_sync(), which increments the usage counter even when it
fails, and returns the error without dropping it again.  The watchdog
core does not invoke the stop callback when start fails, so the
reference taken on the error path is leaked.

Use pm_runtime_resume_and_get() instead, which keeps the usage counter
balanced when the resume fails.

Fixes: db728ea9c7be ("drivers: watchdog: Add StarFive Watchdog driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916170704.2086331-1-vulab@iscas.ac.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/starfive-wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/watchdog/starfive-wdt.c
+++ b/drivers/watchdog/starfive-wdt.c
@@ -369,7 +369,7 @@ static void starfive_wdt_stop(struct sta
 static int starfive_wdt_pm_start(struct watchdog_device *wdd)
 {
 	struct starfive_wdt *wdt = watchdog_get_drvdata(wdd);
-	int ret = pm_runtime_get_sync(wdd->parent);
+	int ret = pm_runtime_resume_and_get(wdd->parent);
 
 	if (ret < 0)
 		return ret;


