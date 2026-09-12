Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DF31DC198;
	Sat, 12 Sep 2026 08:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202138; cv=none; b=BzBsNcQD11pq+05bGZmh3+jae7CGzVsP+ylCmKbe2VBMGHfmS36phkPwucGyo4qEGRRr8KU2yQwJwNf0MM5+Q5PAAXJiztdnAZHb41fCT6cFOnTzLvyvZh3jWff20DRZo4dPjGXx7aBkrYZQg6L1jgrzfSrNr9NK75vV2rcJXnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202138; c=relaxed/simple;
	bh=v1eC9iOhqsuw6ugrdX9Se348Lw8PDoaRaz68/163vrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYXqsKjyb5y670m2C9lvHKUYA5ofwaDpLT70MWwRQwtBY+kq01k763nCsl7Npofz3O9e3EgUVNnBw8+XmG8DCcyWO2FpdXtYL5fj5xFkbZssKFvOLrnaE2W2uZaLfR63rAlm5COAY/Se4k+EmsQL92o95ETz+sK29OZd28YApzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVUiLo0W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVUiLo0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD49A1F000FF;
	Sat, 12 Sep 2026 08:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202137;
	bh=AvnZTfL/4JLQTv6g8xJWsOtcDxTAW1ish2w6gxpghQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVUiLo0WQF7mUd+fW5DbhJVXATiKXF8gmAghLvUxyrV6lzLtI4fGfNhmKdwrPdAx4
	 zRrmvHk61PC+pvqP4jSTREeyOKHH4Q8BLPHTD4ja4U2oHoXiW81vj3tM/bU8w0UEK0
	 MZGwBgGKNlTogb+XF5GR9SuTE8nQA/Nh7/Rxtcao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1139/1815] cpufreq: imx6q: fix devres accumulation across driver rebind
Date: Sat, 12 Sep 2026 08:48:09 +0200
Message-ID: <20260912065715.758136588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index e93697d3edfd9..8110c95059e0e 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -400,7 +400,7 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 	}
 
 	/* Make imx6_soc_volt array's size same as arm opp number */
-	imx6_soc_volt = devm_kcalloc(cpu_dev, num, sizeof(*imx6_soc_volt),
+	imx6_soc_volt = devm_kcalloc(&pdev->dev, num, sizeof(*imx6_soc_volt),
 				     GFP_KERNEL);
 	if (imx6_soc_volt == NULL) {
 		ret = -ENOMEM;
@@ -485,6 +485,7 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 	return 0;
 
 free_freq_table:
+	imx6_soc_volt = NULL;
 	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
 out_free_opp:
 	dev_pm_opp_of_remove_table(cpu_dev);
@@ -506,6 +507,7 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 static void imx6q_cpufreq_remove(struct platform_device *pdev)
 {
 	cpufreq_unregister_driver(&imx6q_cpufreq_driver);
+	imx6_soc_volt = NULL;
 	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
 	dev_pm_opp_of_remove_table(cpu_dev);
 	regulator_put(arm_reg);
-- 
2.53.0



