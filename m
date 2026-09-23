Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E75753162E;
	Wed, 23 Sep 2026 14:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173903; cv=none; b=FB4DSxKK8qNf/YmmgAifCH6gpGStV5TOuxU1WlPhlmcKZAF3nCIboLa1bhe6b4Wbmx1BZypes6umZ2kswVhgrOpUKbjBXx8udCF0aI2ioxl9d9up8erKgpzFOTI4R02w6OQ+6HPmNZ29IIjp1pAIkyv4cfAT+nnOkv++HuVLt30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173903; c=relaxed/simple;
	bh=CUkBTWRQSjvX61fhlmEF3cEtc2L+TssZ/SS6Ar4Jqws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PV+o64+nN+KnZ8u6s5mANrvgMK3vxscliR4Z4txoBXiFSBTqfsgC93sJE1UI76dqvO604nIJ0UIQy2mgF3VdtU6tf5YtLYxggJHfYKveqnOBzOB3zFbUC762wpQEqYOvBYaZqe19uug+Ucqb71fZzbp/qzLP0spj157OzM7aWxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=He6FaukY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="He6FaukY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24C71F000FF;
	Wed, 23 Sep 2026 14:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173902;
	bh=Lya0s/yariUWE5QAyh64/7t5VV0MTWIbghoHfoSw7yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=He6FaukYgz7jzAPK3kFpUiRHjQTfRTIc8srhfTHNZQHoRge03sJCL1ek21fI5RMgw
	 P18vyjrdBPChttUXKcWcAx9WtNuo1Wm/MVvw4VZjGrV97stUOgzlA68Wg1eUxODBH1
	 iXlIyDdwuvWKAzQOw2g5/h+B78BwqxflZylkQXTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 381/438] watchdog: starfive-wdt: Fix runtime PM leak in starfive_wdt_pm_start()
Date: Wed, 23 Sep 2026 16:06:42 +0200
Message-ID: <20260923140654.743424914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -371,7 +371,7 @@ static void starfive_wdt_stop(struct sta
 static int starfive_wdt_pm_start(struct watchdog_device *wdd)
 {
 	struct starfive_wdt *wdt = watchdog_get_drvdata(wdd);
-	int ret = pm_runtime_get_sync(wdd->parent);
+	int ret = pm_runtime_resume_and_get(wdd->parent);
 
 	if (ret < 0)
 		return ret;


