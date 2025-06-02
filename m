Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8369227EAE;
	Mon,  2 Jun 2025 14:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874312; cv=none; b=ge2LBhdxRXmChboXZTZ5cdWKtaSjEaKVLHwJV2XRM1lGewBLVMVLsTehzJBoWog7vIB7hURvk75SOT37oUNKXmhYfsxQioMpATg3AWzhzsuB0qx5Lf7DRkBIqVh5Z1W+9C8RZ+mk83rdY+22aqBcB/t3WZ1GBW8YNtabL+fLU/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874312; c=relaxed/simple;
	bh=ReZ0c26bDKqNXsbs3K5puNg07W/ctmtT40MEsEwaSVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQJ8iVSo5eyounUz2c8y3/m7EiBja+PLGuxg9RH2JVNllu7mAsgbl/YFboIISHIwHV9vf4N0qSdw1q7qsMo9b1Eq+1nAetF+TWywLuiXvYZm63iAIWbF6+xhiXkBGLqE+kWCLVfNe8Z1NzecLHf5Njf7MPAsx76Z3/HbZ2SX+lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lqx6kphq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lqx6kphq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F93C4CEEB;
	Mon,  2 Jun 2025 14:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874312;
	bh=ReZ0c26bDKqNXsbs3K5puNg07W/ctmtT40MEsEwaSVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lqx6kphqkS5WNxO7rjtyMAnwhREUQqm03gBKgJs1rhTzol9HoePrg/TYRQecnMPTE
	 ng8W/Z5xwvr0D2JGo274XSWTbW/18UtYl6eRKOi6jM9tYAJ8iqJQSVuduzXjb2Ia/g
	 +53tm7d1I3iG6mcfb4pS/WY72c+55+CdGuZP3Tuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 428/444] perf/arm-cmn: Initialise cmn->cpu earlier
Date: Mon,  2 Jun 2025 15:48:12 +0200
Message-ID: <20250602134358.312650575@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2443,6 +2443,7 @@ static int arm_cmn_probe(struct platform
 
 	cmn->dev = &pdev->dev;
 	cmn->part = (unsigned long)device_get_match_data(cmn->dev);
+	cmn->cpu = cpumask_local_spread(0, dev_to_node(cmn->dev));
 	platform_set_drvdata(pdev, cmn);
 
 	if (cmn->part == PART_CMN600 && has_acpi_companion(cmn->dev)) {
@@ -2470,7 +2471,6 @@ static int arm_cmn_probe(struct platform
 	if (err)
 		return err;
 
-	cmn->cpu = cpumask_local_spread(0, dev_to_node(cmn->dev));
 	cmn->pmu = (struct pmu) {
 		.module = THIS_MODULE,
 		.attr_groups = arm_cmn_attr_groups,


