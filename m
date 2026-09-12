Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ADD35AC3E;
	Sat, 12 Sep 2026 09:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206351; cv=none; b=m7x8skYNMmMqIW+uvRAzKnwa2TrOXkNFdztPrk5v6aDBUt7RePHFUCJwo4S86chlyC98RRFjSpY+LpLernSj5Zz6IVD0MDJRVL2kGVi9sw3SX18FQLDIlVLTBRp3R4aGqTI3uwVjbNNKTZaMn7BZ8v71FM4uZL5f4V0y0fpUEgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206351; c=relaxed/simple;
	bh=4S6MT+MJeyRYfsSFquZylXDSd2mRpzmbfpFnekF5gJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrmGSQmjaQrEvzxOHUDasyzSANP42or5C+o8aJVuWtR9Sx7AWDUSjSxzUH1xLXXo/B7WHiQsSnq7BAbkha3H6D7opWj19W2AdDnUTVlX3vJZoOMJpMbRyLa0jz3grbX7kX0QnEhg0rjQBBsggXi2BjPkXMRHufyf9+wdEnSYBns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lz3Ykvsy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lz3Ykvsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A601F000FF;
	Sat, 12 Sep 2026 09:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206350;
	bh=2gKjcMlTknTtMqUCXggXHVRYZqxS064HITX0kPuAaS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lz3YkvsySguJL/SYY3rn3DWeXPw8MBZv9AjHOA6MGraoOnSidDm7c27dkuhKYBgPW
	 UEDg6u52DMYXVvDrw8DZYQ9SVPjgYgZRnSP4yC9vC/wlLC+1zbE2y9Av3xJehrXaK+
	 3DXbFVv+PszaH/whu1WZUpTPrigfDosy2qnvA00s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Golla Nagendra <nagendra.golla@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0182/1518] dmaengine: zynqmp_dma: fix race between runtime PM and device removal
Date: Sat, 12 Sep 2026 08:39:11 +0200
Message-ID: <20260912065627.606158029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Golla Nagendra <nagendra.golla@amd.com>

[ Upstream commit 516ba2d8b7aac4238f9fcbd58579c43c71b9b695 ]

In zynqmp_dma_remove(), runtime PM was disabled only after checking
state and doing a manual suspend. This can race with runtime PM in the
remove/unbind (rmmod) path.

Disable runtime PM first, then suspend only if the device is not already
suspended. To prevent any further runtime PM transitions.

Fixes: 72dd8b2914b5 ("dmaengine: zynqmp_dma: Add shutdown operation support")
Co-developed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Signed-off-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Signed-off-by: Golla Nagendra <nagendra.golla@amd.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/20260630064844.705173-2-nagendra.golla@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/zynqmp_dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index f7e584de4335e..23e07d72a5225 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -1173,9 +1173,9 @@ static void zynqmp_dma_remove(struct platform_device *pdev)
 	dma_async_device_unregister(&zdev->common);
 
 	zynqmp_dma_chan_remove(zdev->chan);
-	if (pm_runtime_active(zdev->dev))
-		zynqmp_dma_runtime_suspend(zdev->dev);
 	pm_runtime_disable(zdev->dev);
+	if (!pm_runtime_status_suspended(zdev->dev))
+		zynqmp_dma_runtime_suspend(zdev->dev);
 }
 
 static const struct of_device_id zynqmp_dma_of_match[] = {
-- 
2.53.0



