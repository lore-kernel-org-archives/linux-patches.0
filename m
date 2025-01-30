Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1201E6DCF;
	Thu, 30 Jan 2025 14:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246788; cv=none; b=i39Yicj483caN5XjRgRggsnPvKH6uizh5yfd8JyDVHwwSNAUpBSuKcNvN16O8vxDDX3dCmIgTPvdSdSgToAYYGuPTkDLImx0T0By9aZlBkn19q7mawNsMrCfI3Qky6AFg0K4vEJEQuCq+fnJvk3PM3oqCQuBrjV3v4S9UIwwa1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246788; c=relaxed/simple;
	bh=5YdR6zKwD/jEPly6kycGuTUJn0oHnc+2CMpc2+ma0Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQVHU0rYzga7373rjRDHKBQMkTBd61AvTMVKrwh+PuH8gybdc8Pc1n4x38Zr3h1G/S4zSwiGimEakzrZc3nn6dXuvyQ9ZZoNCg5dBHB1xvB5aOjT4qrDQnT7Wq+qbxktKJe4mdU3lDWnrm0Rn49sMS+amWS/o+6/RwhZpjOnBr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OqmJylLK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OqmJylLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1412C4CED2;
	Thu, 30 Jan 2025 14:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246788;
	bh=5YdR6zKwD/jEPly6kycGuTUJn0oHnc+2CMpc2+ma0Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OqmJylLKkcViVKwFrO8+GFmPAHYQo8vcib1CJmXgF/w4xIaSqUVb671ei25fVbd5M
	 JLriJvf8uOsRMzVf9bPfAINjoDy22kWwZOh/O49fnw0cwh6o72lUgVlXQGb0H558md
	 KCzVSGG1ZFv18gUpDh9nm3owFisp1LdKdfvxZOOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 67/91] nvmet: propagate npwg topology
Date: Thu, 30 Jan 2025 15:01:26 +0100
Message-ID: <20250130140136.367383202@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit b579d6fdc3a9149bb4d2b3133cc0767130ed13e6 ]

Ensure we propagate npwg to the target as well instead
of assuming its the same logical blocks per physical block.

This ensures devices with large IUs information properly
propagated on the target.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-bdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 32008d85172bc..40afe3d0599d5 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -36,7 +36,7 @@ void nvmet_bdev_set_limits(struct block_device *bdev, struct nvme_id_ns *id)
 	 */
 	id->nsfeat |= 1 << 4;
 	/* NPWG = Namespace Preferred Write Granularity. 0's based */
-	id->npwg = lpp0b;
+	id->npwg = to0based(bdev_io_min(bdev) / bdev_logical_block_size(bdev));
 	/* NPWA = Namespace Preferred Write Alignment. 0's based */
 	id->npwa = id->npwg;
 	/* NPDG = Namespace Preferred Deallocate Granularity. 0's based */
-- 
2.39.5



