Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040C527F758;
	Mon, 18 Aug 2025 13:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525580; cv=none; b=NwScQyxWEke4SQSA8w4dXFOFEzi/i+YhgwzG5bnBvM9GhdEwX3cMpKT/KQ/U0sla81FqrKk6/vNM4HDHQLMjmuJKkR9K4/Ws+otYuMbXbguA8YWCUpo5qiwdmR49kAG2YQAcHEbklMlrzQAlJjZzTfWXjKHe8Yi1CWQRDONbQsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525580; c=relaxed/simple;
	bh=c/CLH4pS5Zbvlt8Urv80uz7BsViOfup1yOegJT4y/FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnCq8N/AQ6m78+82s87jFLN7DtEU/3xIByv6nIrBls+yy8yGDD6KyoXRU4DUyGlXCYagWAxCWHC/CznWuPJkjYkCuuRsoX3mCGbidZg+B2bi+XI+4nLGAFwD7+YptvVehbLEwYyzOLWPSUqAsa5A6QnkRDjajtERdjsL5WwE+hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjxcdr5V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjxcdr5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146ECC4CEEB;
	Mon, 18 Aug 2025 13:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525579;
	bh=c/CLH4pS5Zbvlt8Urv80uz7BsViOfup1yOegJT4y/FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjxcdr5VuosGpL2uIG2CyN+PSpFqcXZIxLd8Hyh5eXvCp1SDIcPm+uKyKJa7smSZt
	 v42MvIc+zdpBSdPdDT8IMPHhAhM+JOBwr87s6nnUg6uVZoRSweiPB1+bFkW+ngcMZ1
	 ZiGoazFHLsleY1Gx0yu8UrP06Ed1IlMZnvJhsRq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 274/570] perf/arm: Add missing .suppress_bind_attrs
Date: Mon, 18 Aug 2025 14:44:21 +0200
Message-ID: <20250818124516.409439078@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 860a831de138a7ad6bc86019adaf10eb84c02655 ]

PMU drivers should set .suppress_bind_attrs so that userspace is denied
the opportunity to pull the driver out from underneath an in-use PMU
(with predictably unpleasant consequences). Somehow both the CMN and NI
drivers have managed to miss this; put that right.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Link: https://lore.kernel.org/r/acd48c341b33b96804a3969ee00b355d40c546e2.1751465293.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 1 +
 drivers/perf/arm-ni.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 031d45d0fe3d..d1df2f3adbc5 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -2655,6 +2655,7 @@ static struct platform_driver arm_cmn_driver = {
 		.name = "arm-cmn",
 		.of_match_table = of_match_ptr(arm_cmn_of_match),
 		.acpi_match_table = ACPI_PTR(arm_cmn_acpi_match),
+		.suppress_bind_attrs = true,
 	},
 	.probe = arm_cmn_probe,
 	.remove = arm_cmn_remove,
diff --git a/drivers/perf/arm-ni.c b/drivers/perf/arm-ni.c
index 9396d243415f..c30a67fe2ae3 100644
--- a/drivers/perf/arm-ni.c
+++ b/drivers/perf/arm-ni.c
@@ -709,6 +709,7 @@ static struct platform_driver arm_ni_driver = {
 		.name = "arm-ni",
 		.of_match_table = of_match_ptr(arm_ni_of_match),
 		.acpi_match_table = ACPI_PTR(arm_ni_acpi_match),
+		.suppress_bind_attrs = true,
 	},
 	.probe = arm_ni_probe,
 	.remove = arm_ni_remove,
-- 
2.39.5



