Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5158F225397;
	Mon,  2 Jun 2025 14:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872989; cv=none; b=c4sbpmDZQYA2grkI2fapmDRAPnaLqYil9e85Kt+PYxJ8PL4AZBt/mN6KaYrlRji6DmmvoW7xXIcf+LcPiAFFQHwtp4w3Tfyy9qxHNEIJO/bUy7koBuZbCRiPlV5Dr4xMK14C6D6GlZh6O1rb9wjO6aEYgAq4ohc9aUh6OfisP9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872989; c=relaxed/simple;
	bh=dDbmBUd1280z1vNEuLqgy93/RkCvNX7g6ZghN9dPipo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6hstEgiVh3YA8lm4r+xIS4oH1LAWr+PJrVfOcRG1fSpfWLOifosbU4hA+fZxdZMsbXDKTQaqttDQ60TBB+Bs+Y3rk5P6wlwLVM55PGRBrczfZukwki9YmKjQELDM7P13APGnP5zouQiEdxDjfM2W/0pmGqmt+oVCX4ZxZGz7Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynqX7OtD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynqX7OtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF6CC4CEEE;
	Mon,  2 Jun 2025 14:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872988;
	bh=dDbmBUd1280z1vNEuLqgy93/RkCvNX7g6ZghN9dPipo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ynqX7OtD/UE5t7dACHJf6K0RBlIVHDRPIeD9I4D1TJdUZdcuQllA7e9VK40yK/kIN
	 X2+j/6H45m4eMlVIupoGU4Bdpqvmuy5sS0/AVlTAKhLaQZt0ccfKX+xVcGGVUeKOGA
	 GxLVEx9w55S5DgRXPTn2FRrty+tbsi6qlAd+C5s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 31/55] perf/arm-cmn: Initialise cmn->cpu earlier
Date: Mon,  2 Jun 2025 15:47:48 +0200
Message-ID: <20250602134239.507981739@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


