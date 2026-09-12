Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67506478E36;
	Sat, 12 Sep 2026 12:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217359; cv=none; b=R4FHeuvgnKGFz/g0dFvshYURO18UzY0nfR+nbiSStwX2Slrh179Ba30uhymP0r0w6Xn0Un1/3rnoIhm9cZwZ2RDyDBS9RUKXMbaF3DawJ8J4B+Jsjo10WLlKgW8Oml36gy/gZFbOJ6wglB8+WnRKXySRY7wXJanWlJtdIN8crnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217359; c=relaxed/simple;
	bh=bBZCtN1sYzfGXbgCH/TiOtfQLb1fZ4T1Y3s7qGbnlac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHwCuAYkHb5nnmgo06iHgOgUkpnYJ+Z4xDGjA0SMlgkfZ5WAFraoKzTCW/ikoviLbyqHYiA7KoT3MTLIf/BqSqTnWh4nbrJdHzHApSmxtqqtd31b3BebnfwCvgbkb1vVWnsLY5/7OecGO2CWpICegVeKtPGGkSyLInJ0RMMadi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Awg6AGP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Awg6AGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9421F00893;
	Sat, 12 Sep 2026 12:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217356;
	bh=AyKeLFKFNJ6jIw6+BEX4JJb8moGtk1dsUTG6P9Yswpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Awg6AGPAhDhVCNux63bkWk9Z56p9qO+KaeDgcvKMYIWO1lgjjax+7NVnNXJ2eVOj
	 NDCqm0CkaDmK+Hs5Ut7TvhMHxN0jr+4vsCTzDdqLhU8pg3nEXqY0nWFsJUZJ6wud3w
	 XMRnsr6O/1qRYiQlZN2ro9sDDk8wbJ7Hy3OtOd+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0922/1376] cpufreq: imx6q: fix devres accumulation across driver rebind
Date: Sat, 12 Sep 2026 08:55:48 +0200
Message-ID: <20260912065628.113768822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 22c23c72c3b21fa3ec3db5070dfc0582794e0ef9 ]

imx6_soc_volt is allocated with devm_kcalloc(cpu_dev, ...), where cpu_dev
is the CPU device from get_cpu_device(0). That device is never unbound, so
its devres list is never released, and imx6q_cpufreq_remove() does not free
the array either. Every probe therefore adds an allocation that stays for
the lifetime of the system.

Allocate against the platform device instead. Its devres is released when
the driver is unbound, which is exactly the lifetime the array wants:
imx6q_set_target() reads it, and nothing may reach that after
cpufreq_unregister_driver().

That makes the array actually go away on unbind, so also clear the
file-scope pointer in remove and on the failed-probe path, rather than
leave it pointing at memory devres is about to release.

Tested by rebinding the driver on qemu's mcimx6ul-evk.

Fixes: b4573d1d657a ("cpufreq: imx6q: correct VDDSOC/PU voltage scaling when cpufreq is changed")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/imx6q-cpufreq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 33c1df7f683e4..853534f0fec88 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -401,7 +401,7 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 	}
 
 	/* Make imx6_soc_volt array's size same as arm opp number */
-	imx6_soc_volt = devm_kcalloc(cpu_dev, num, sizeof(*imx6_soc_volt),
+	imx6_soc_volt = devm_kcalloc(&pdev->dev, num, sizeof(*imx6_soc_volt),
 				     GFP_KERNEL);
 	if (imx6_soc_volt == NULL) {
 		ret = -ENOMEM;
@@ -486,6 +486,7 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 	return 0;
 
 free_freq_table:
+	imx6_soc_volt = NULL;
 	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
 out_free_opp:
 	dev_pm_opp_of_remove_table(cpu_dev);
@@ -507,6 +508,7 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 static void imx6q_cpufreq_remove(struct platform_device *pdev)
 {
 	cpufreq_unregister_driver(&imx6q_cpufreq_driver);
+	imx6_soc_volt = NULL;
 	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
 	dev_pm_opp_of_remove_table(cpu_dev);
 	regulator_put(arm_reg);
-- 
2.53.0



