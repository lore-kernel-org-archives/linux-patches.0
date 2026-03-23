Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB43926D4F9;
	Mon, 23 Mar 2026 14:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277422; cv=none; b=UpVEE57aEYQryvSUPT3CaDc+mz8PLUUMFbqZXp4oomCy5sunbjtVO97N2zN3vPc+hMa6WN7HRB2VRpQyC026XLuB55Um8VFEaP8+OlPq5YVmhQlLI0ysihTucLp8i1ttgc9o7G6tS8gvECCQ5scsMMOy8AFA7VRm9+CheIXxOCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277422; c=relaxed/simple;
	bh=aT3d9HVxZFT2k1POyW5s2zlY9smWBYNQk6OlUxdeimU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ym/udwNjNCOsyWH8NELQzwwR20xpc/IjCOL5gdbyEHdq3WWBFFQA7e5wzltCqRoI4qnS8EwUbCT2cyIUdtEyqwcjuRebfblHz1mcc0UHTt2ckxBeJZpD1lDNkrpZmcHqvc04ohYp7/peWvHMZeI63PLqs3MQHpeLgP0Ybv4ixRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m13NMrBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m13NMrBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBBFC4CEF7;
	Mon, 23 Mar 2026 14:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277421;
	bh=aT3d9HVxZFT2k1POyW5s2zlY9smWBYNQk6OlUxdeimU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m13NMrBq1/T73skTfpz6gBUlfmZANbwUmocoXNGDfb/sJCMD2J5G3yVo8wpsXdWA3
	 nHLpjwrZnrM8JzFEAHN5pvg13cM0bXDxJLBtj8wtmAwXHFpmhLTqm3rxrQ3zovxWA/
	 EsRo4fmoOTgvCJhMok9Rq0UjJ9PjKNPeRjg3GHNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 379/460] firmware: arm_scpi: Fix device_node reference leak in probe path
Date: Mon, 23 Mar 2026 14:46:15 +0100
Message-ID: <20260323134535.882101054@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 879c001afbac3df94160334fe5117c0c83b2cf48 ]

A device_node reference obtained from the device tree is not released
on all error paths in the arm_scpi probe path. Specifically, a node
returned by of_parse_phandle() could be leaked when the probe failed
after the node was acquired. The probe function returns early and
the shmem reference is not released.

Use __free(device_node) scope-based cleanup to automatically release
the reference when the variable goes out of scope.

Fixes: ed7ecb883901 ("firmware: arm_scpi: Add compatibility checks for shmem node")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Message-Id: <20260121-arm_scpi_2-v2-1-702d7fa84acb@gmail.com>
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scpi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scpi.c b/drivers/firmware/arm_scpi.c
index f4d47577f83ee..2d33771917bb4 100644
--- a/drivers/firmware/arm_scpi.c
+++ b/drivers/firmware/arm_scpi.c
@@ -18,6 +18,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/bitfield.h>
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/export.h>
@@ -940,13 +941,13 @@ static int scpi_probe(struct platform_device *pdev)
 		int idx = scpi_drvinfo->num_chans;
 		struct scpi_chan *pchan = scpi_drvinfo->channels + idx;
 		struct mbox_client *cl = &pchan->cl;
-		struct device_node *shmem = of_parse_phandle(np, "shmem", idx);
+		struct device_node *shmem __free(device_node) =
+			of_parse_phandle(np, "shmem", idx);
 
 		if (!of_match_node(shmem_of_match, shmem))
 			return -ENXIO;
 
 		ret = of_address_to_resource(shmem, 0, &res);
-		of_node_put(shmem);
 		if (ret) {
 			dev_err(dev, "failed to get SCPI payload mem resource\n");
 			return ret;
-- 
2.51.0



