Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F15221DA2;
	Mon,  2 Jun 2025 13:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872697; cv=none; b=sEfwUpqILm9SxOZe+DND0tECMOMeZ+I9Cgs47p91ktn0I+ZBVsEUkxv4UjYFaumNkf42XfM/g82cR0MOvicO000ZFBRp3brKHraZ4s1R1Cmhdjzm3omXjSUP2s67L3yA7Nnzk4T8zV140FoUl3eTfU0ZX8xvwROMlA2v6DI+79E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872697; c=relaxed/simple;
	bh=LXZRB7P8LBKDgbFyZZR5S6mLlrerVF953sZgx0el2Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPw8LdOMtbuYhvPWoUGErRXjf5wnENzxYfhNLPPHn/KjxYNjzdmUwUgxilGqK1DclBGUQz20UFcRIDd42pQsj2cGMFWqM/EUGKqnHcErYmhpyd7DW8eOhWHsOQoQn4ECtbXGHpTKA4t6VNsGMiq3g6r+X6zBKDRkrAgwj2iSGJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNI5abqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNI5abqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC662C4CEEB;
	Mon,  2 Jun 2025 13:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872697;
	bh=LXZRB7P8LBKDgbFyZZR5S6mLlrerVF953sZgx0el2Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yNI5abqX1SJJNNcCMDQznE8tOPL3HsLDLk4Wj4kbtzY5jZ58I2X5BgD+0QbvhVnXb
	 cLvB/+DTnm8dpVuKHuHa5vDPSAZM+g2jE4NmHcIYfGlyExg82R4YC3TfF2Xv+zwzWx
	 grLYPnywFNx+tVydz996n6EaE9Q9ntNeiyX+pBk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.14 43/73] perf/arm-cmn: Initialise cmn->cpu earlier
Date: Mon,  2 Jun 2025 15:47:29 +0200
Message-ID: <20250602134243.386923123@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2557,6 +2557,7 @@ static int arm_cmn_probe(struct platform
 
 	cmn->dev = &pdev->dev;
 	cmn->part = (unsigned long)device_get_match_data(cmn->dev);
+	cmn->cpu = cpumask_local_spread(0, dev_to_node(cmn->dev));
 	platform_set_drvdata(pdev, cmn);
 
 	if (cmn->part == PART_CMN600 && has_acpi_companion(cmn->dev)) {
@@ -2584,7 +2585,6 @@ static int arm_cmn_probe(struct platform
 	if (err)
 		return err;
 
-	cmn->cpu = cpumask_local_spread(0, dev_to_node(cmn->dev));
 	cmn->pmu = (struct pmu) {
 		.module = THIS_MODULE,
 		.parent = cmn->dev,


