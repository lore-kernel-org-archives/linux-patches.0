Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549A71B96D;
	Thu, 18 Jan 2024 10:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575143; cv=none; b=IGeNC1+tQene8vgdO7n19guZOcUjGGbCP2VHO3byhAuebcyHWu6IbZjd62NLWsOZ/fxlMIlDG+z3TLVpnMxPDzKqD0agyZrlXEkm7eZ13mxHESPqOXkYHS8N+2X6SUuSWzawF02RyVEM99lqheMeZhgmQSEEzVdf0yaWcoK+rlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575143; c=relaxed/simple;
	bh=99ihF+f7X521OL/4XCri4hwSthDXHrM3u2QBOBaE0Dc=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=R/9slaivA1H1x1b/xs0P7A6uGpmil2KNd0HuNt+StCJZg5BCbxmJ7wjrah5SrTtvYXWdFu8bWVfsmgW9b0/su7fLAPcwZvlt/COwm76nBn6Sy3AkUsWO9gBUkfnd4RDbKHXMSHgBHPJ/qVPSn9oSlb/qy6aYf9dBX963AhNarko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXSHUy/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXSHUy/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAE5C433C7;
	Thu, 18 Jan 2024 10:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575143;
	bh=99ihF+f7X521OL/4XCri4hwSthDXHrM3u2QBOBaE0Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXSHUy/NA26GTP8P3Wbph26AKRN4umKPr4HfjyFewLW2IpQdix3k1PBU9MpBDcnCG
	 2SH4PRJvoySHlurloYPv0yDcmkaJB+oM9zHRPyD2KXE/1l5h6vqnNrZlVzz6tHsuCP
	 U7vuJtY40PugrBYR7cpAuSUzWIOYwk0SKbMXpZmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/150] hwtracing: hisi_ptt: Handle the interrupt in hardirq context
Date: Thu, 18 Jan 2024 11:47:28 +0100
Message-ID: <20240118104321.283055369@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit e0dd27ad8af00f147ac3c9de88e0687986afc3ea ]

Handle the trace interrupt in the hardirq context, make sure the irq
core won't threaded it by declaring IRQF_NO_THREAD and userspace won't
balance it by declaring IRQF_NOBALANCING. Otherwise we may violate the
synchronization requirements of the perf core, referenced to the
change of arm-ccn PMU
  commit 0811ef7e2f54 ("bus: arm-ccn: fix PMU interrupt flags").

In the interrupt handler we mainly doing 2 things:
- Copy the data from the local DMA buffer to the AUX buffer
- Commit the data in the AUX buffer

Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[ Fixed commit description to suppress checkpatch warning ]
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20231010084731.30450-3-yangyicong@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/ptt/hisi_ptt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwtracing/ptt/hisi_ptt.c b/drivers/hwtracing/ptt/hisi_ptt.c
index 3045d1894b81..dbed4fd4e296 100644
--- a/drivers/hwtracing/ptt/hisi_ptt.c
+++ b/drivers/hwtracing/ptt/hisi_ptt.c
@@ -342,9 +342,9 @@ static int hisi_ptt_register_irq(struct hisi_ptt *hisi_ptt)
 		return ret;
 
 	hisi_ptt->trace_irq = pci_irq_vector(pdev, HISI_PTT_TRACE_DMA_IRQ);
-	ret = devm_request_threaded_irq(&pdev->dev, hisi_ptt->trace_irq,
-					NULL, hisi_ptt_isr, 0,
-					DRV_NAME, hisi_ptt);
+	ret = devm_request_irq(&pdev->dev, hisi_ptt->trace_irq, hisi_ptt_isr,
+				IRQF_NOBALANCING | IRQF_NO_THREAD, DRV_NAME,
+				hisi_ptt);
 	if (ret) {
 		pci_err(pdev, "failed to request irq %d, ret = %d\n",
 			hisi_ptt->trace_irq, ret);
-- 
2.43.0



