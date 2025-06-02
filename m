Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59B6221F10;
	Mon,  2 Jun 2025 15:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877620; cv=none; b=ey0alV1CSFVXum0o7cYMog+fwgp+Gr7ZQkzEnv3Wi6ovKnCJvFFhlw6rh+yyO5F/rtwQSK2LwmKlIFCpLInnLLkgv1rQ8FaJ3yyIDdKx6JiBZjMqBy5VY/uasQfGPY4C8qWBqd5WHS8YRUKVAh+kkF9a+I0x+VbAmIhd2Ac9/Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877620; c=relaxed/simple;
	bh=ITVR3HMiYg5l6AZK7u7+eOql7sEf/xt3aCyBIPRjeWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KevTU8sePdAQhvs2hW0YCTBBfwYZfD0QwrmikBkQD/ecScg9jCSd9Yom2xtLu/H1QxIT2Nz9PHM6Fk7ks33wmE3/HnNowAqGCwWEU1Xx/uxEHP8NCpw2+88zefp6nfsC7yo7WeapmpIES79p/FJn/J2wAPfK2+ZyRTyPtdwpAEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZxNG7bM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZxNG7bM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6C3C4CEEB;
	Mon,  2 Jun 2025 15:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877615;
	bh=ITVR3HMiYg5l6AZK7u7+eOql7sEf/xt3aCyBIPRjeWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZxNG7bMTBQwp8X5ADhqyzS6LgQt6ms6rGKaGE5Tut6u9Crz++kXcJ5dv3TRXaPpa
	 4FtEgtJtZ2uCzlreG1/jf2rngBZXfWbNQwvZXv8KVRm6gAPKBgxOiSBFLwF1rgHFL/
	 jbIrTRe12O+EZDlFfa2oL/n9hwykE1g0x8Zu3pRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 311/325] perf/arm-cmn: Initialise cmn->cpu earlier
Date: Mon,  2 Jun 2025 15:49:47 +0200
Message-ID: <20250602134332.560430740@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit 597704e201068db3d104de3c7a4d447ff8209127 upstream.

For all the complexity of handling affinity for CPU hotplug, what we've
apparently managed to overlook is that arm_cmn_init_irqs() has in fact
always been setting the *initial* affinity of all IRQs to CPU 0, not the
CPU we subsequently choose for event scheduling. Oh dear.

Cc: stable@vger.kernel.org
Fixes: 0ba64770a2f2 ("perf: Add Arm CMN-600 PMU driver")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Link: https://lore.kernel.org/r/b12fccba6b5b4d2674944f59e4daad91cd63420b.1747069914.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/arm-cmn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -2313,6 +2313,7 @@ static int arm_cmn_probe(struct platform
 
 	cmn->dev = &pdev->dev;
 	cmn->part = (unsigned long)device_get_match_data(cmn->dev);
+	cmn->cpu = cpumask_local_spread(0, dev_to_node(cmn->dev));
 	platform_set_drvdata(pdev, cmn);
 
 	if (cmn->part == PART_CMN600 && has_acpi_companion(cmn->dev)) {
@@ -2340,7 +2341,6 @@ static int arm_cmn_probe(struct platform
 	if (err)
 		return err;
 
-	cmn->cpu = cpumask_local_spread(0, dev_to_node(cmn->dev));
 	cmn->pmu = (struct pmu) {
 		.module = THIS_MODULE,
 		.attr_groups = arm_cmn_attr_groups,


