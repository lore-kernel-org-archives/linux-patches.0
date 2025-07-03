Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A4B2EA730;
	Thu,  3 Jul 2025 14:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554774; cv=none; b=iGfGjHcaTm4MIWoIF6gnbGJbLljhz9yb7KXizrZecOCayJnYmU+H4hXrGKj8sMe6Y5p0XHFNEbnpav17HmXNoo7eRzUq2AXoJNkLGk/7CNRGKHIcKkTF8TTd5eIPUSYxYnp7xwl8YJ3lX/V/GjGAZ5CqWH3hK/tH8f3w6tLgQCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554774; c=relaxed/simple;
	bh=7pYSgAQHFmEkt5pvYb+2SLSQlufp32+eARxTuKjwXZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGjX1W+74dsRaBA4zBKgtSRV8I4AKGdV2ScZgRM4Omgo+pWkCTDFo08cf1ORhJEzgxJpuy4yBG10F2kVK0Rocto6qBfYpHSMjJmu7FXmqV5h/dnEdz/eyktuHWddcfVjvMHHRgwL9mIu7czqxpAsKK3zS9kVfo0V/z357h5swxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5jKIrT5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5jKIrT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4814C4CEE3;
	Thu,  3 Jul 2025 14:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554774;
	bh=7pYSgAQHFmEkt5pvYb+2SLSQlufp32+eARxTuKjwXZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5jKIrT5XhXSUv6hQNPKxCmd3o3leMZYL6xW3Pe1bZ5t/etWXbN4zn7Izm1NxRtrI
	 NtiMho/jKj954DnEnqk3gysRVRZb/Ugkpu5Yjqrf1iUyIZ+F6m58D5KmOpZheFLd+G
	 P465aKf1y0JrSTtEQTzcBdGFCC1comk80ep2Nj8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Guo <quic_cang@quicinc.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 075/263] scsi: ufs: core: Dont perform UFS clkscaling during host async scan
Date: Thu,  3 Jul 2025 16:39:55 +0200
Message-ID: <20250703144007.313339108@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziqi Chen <quic_ziqichen@quicinc.com>

[ Upstream commit e97633492f5a3eca7b3ff03b4ef6f993017f7955 ]

When preparing for UFS clock scaling, the UFS driver will quiesce all
sdevs queues in the UFS SCSI host tagset list and then unquiesce them in
ufshcd_clock_scaling_unprepare(). If the UFS SCSI host async scan is in
progress at this time, some LUs may be added to the tagset list between
UFS clkscale prepare and unprepare. This can cause two issues:

1. During clock scaling, there may be I/O requests issued through new
added queues that have not been quiesced, leading to task abort issue.

2. These new added queues that have not been quiesced will be unquiesced
as well when UFS clkscale is unprepared, resulting in warning prints.

Therefore, use the mutex lock scan_mutex in
ufshcd_clock_scaling_prepare() and ufshcd_clock_scaling_unprepare() to
protect it.

Co-developed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
Link: https://lore.kernel.org/r/20250522081233.2358565-1-quic_ziqichen@quicinc.com
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 04f769d907a44..ea24080c26e89 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1379,6 +1379,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 	 * make sure that there are no outstanding requests when
 	 * clock scaling is in progress
 	 */
+	mutex_lock(&hba->host->scan_mutex);
 	blk_mq_quiesce_tagset(&hba->host->tag_set);
 	mutex_lock(&hba->wb_mutex);
 	down_write(&hba->clk_scaling_lock);
@@ -1389,6 +1390,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 		up_write(&hba->clk_scaling_lock);
 		mutex_unlock(&hba->wb_mutex);
 		blk_mq_unquiesce_tagset(&hba->host->tag_set);
+		mutex_unlock(&hba->host->scan_mutex);
 		goto out;
 	}
 
@@ -1410,6 +1412,7 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err)
 	mutex_unlock(&hba->wb_mutex);
 
 	blk_mq_unquiesce_tagset(&hba->host->tag_set);
+	mutex_unlock(&hba->host->scan_mutex);
 	ufshcd_release(hba);
 }
 
-- 
2.39.5



