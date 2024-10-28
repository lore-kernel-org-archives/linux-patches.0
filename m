Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E7C17109B;
	Mon, 28 Oct 2024 06:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098023; cv=none; b=hFQ5Xug5eE/wSka60WikMqyoKSwkMo5/L760k4be++6bjO6p9y7rWyr3F4x0saM7poD2Sc+QPBuHBJjoiEvlGmug59cfnt79MhRqTHuWDjFVTAT3V2kM+tU+jsfq6HYFER2Ace8bPzBB9AVGQdH9eV9NJUGPhL/K9oeM4U5nLgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098023; c=relaxed/simple;
	bh=T0nZRNkCRD2zM4IE7wkCg6eKssd3V4o0xLSOW320ELY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTmVW4DMtTRO+RVqLbnwo0mblNOn2TH8cQIEdOW+G4QsnG/cbSAiaYgJEJ5Fe70jsSOBfcv4Z+YmTh88p1VjIpzsO4sosEVDbtYiin5Hbqhy3642BtXpLkuJ+N3voN0ncov4/jJZQcxXS/Hvhud76s0MmPaOqyEZ3olDRmyN5tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deuJcUve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deuJcUve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9745FC4CECD;
	Mon, 28 Oct 2024 06:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098022;
	bh=T0nZRNkCRD2zM4IE7wkCg6eKssd3V4o0xLSOW320ELY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deuJcUve5s/jBovqZvahwS9y8fOeTSok/zeD5OsLmxqajQCOdIhPPIcSVF7EraGLP
	 DVcW7nPzbMG0Qa7TBHja/s6MejSPYivCIMgFbsmfgta4QK4tH037JP1wyRDVV+oR/2
	 4jiMmNXNofHaBphpmHlJ5e5bLq6ejW3dQ8P+xszQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Chandramohan Akula <chandramohan.akula@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 043/261] RDMA/bnxt_re: Avoid CPU lockups due fifo occupancy check loop
Date: Mon, 28 Oct 2024 07:23:05 +0100
Message-ID: <20241028062313.087449256@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 8be3e5b0c96beeefe9d5486b96575d104d3e7d17 ]

Driver waits indefinitely for the fifo occupancy to go below a threshold
as soon as the pacing interrupt is received. This can cause soft lockup on
one of the processors, if the rate of DB is very high.

Add a loop count for FPGA and exit the __wait_for_fifo_occupancy_below_th
if the loop is taking more time. Pacing will be continuing until the
occupancy is below the threshold. This is ensured by the checks in
bnxt_re_pacing_timer_exp and further scheduling the work for pacing based
on the fifo occupancy.

Fixes: 2ad4e6303a6d ("RDMA/bnxt_re: Implement doorbell pacing algorithm")
Link: https://patch.msgid.link/r/1728373302-19530-7-git-send-email-selvin.xavier@broadcom.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Chandramohan Akula <chandramohan.akula@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index e06adb2dfe6f9..c905a51aabfba 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -518,6 +518,7 @@ static bool is_dbr_fifo_full(struct bnxt_re_dev *rdev)
 static void __wait_for_fifo_occupancy_below_th(struct bnxt_re_dev *rdev)
 {
 	struct bnxt_qplib_db_pacing_data *pacing_data = rdev->qplib_res.pacing_data;
+	u32 retry_fifo_check = 1000;
 	u32 fifo_occup;
 
 	/* loop shouldn't run infintely as the occupancy usually goes
@@ -531,6 +532,14 @@ static void __wait_for_fifo_occupancy_below_th(struct bnxt_re_dev *rdev)
 
 		if (fifo_occup < pacing_data->pacing_th)
 			break;
+		if (!retry_fifo_check--) {
+			dev_info_once(rdev_to_dev(rdev),
+				      "%s: fifo_occup = 0x%xfifo_max_depth = 0x%x pacing_th = 0x%x\n",
+				      __func__, fifo_occup, pacing_data->fifo_max_depth,
+					pacing_data->pacing_th);
+			break;
+		}
+
 	}
 }
 
-- 
2.43.0



