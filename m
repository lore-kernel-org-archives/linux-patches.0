Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4E4129A6F;
	Mon,  8 Apr 2024 13:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583410; cv=none; b=Wq7YdFQrZeCWYi/smNsJlG8ZbgQexsK9x3vaUqXxs9n+Isw2jx5CP7m/E2D++ICO3J0N9KDitDlqnaHupuvXdtdH8JOV/w4tF1hp7ZZMDpRSEZ/wLld/1c5vj2oyK1L/gguYXUXLEJOsYuM2SqMT8iJTe6pzbIjK6dyNrkPO2uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583410; c=relaxed/simple;
	bh=Uq6n3sSoPL6pasuksPUidvG3KTQXu8sKSzRX0r89jb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gc4WxhIROL0r67MRElN7FLYCjPsAGDty8ecwM2DbKSlrAgri9V+2IYcM/r0HINQsSUHYu04zrR4snrXiuPUoGYxBPV0y6KKqa74q7jycj39oAJVdQCisPe9jDRB6CJ+vZDqOwQU1/icdDfLASdSvnJLGfuImZwfzBTzBCIEaYF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0vSutPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0vSutPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0047EC433C7;
	Mon,  8 Apr 2024 13:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583410;
	bh=Uq6n3sSoPL6pasuksPUidvG3KTQXu8sKSzRX0r89jb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0vSutPQkOT/seHgNIAjTIrM3dE8WC+Av7ZMa3QGaajXycs/ai+LypP344iRQuPzA
	 O+Bot0e7TrG+Prh72JNZRSlxFCpu/96yCcqfLcnBIT9DbQ1dPYpsLcGyfob6BIcfqZ
	 aqhbVQmoVjCY9mWJ3uU7MUIaBtHtTg9pD3ya+2QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Yu Kuai <yukuai3@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 176/273] scsi: sd: Unregister device if device_add_disk() failed in sd_probe()
Date: Mon,  8 Apr 2024 14:57:31 +0200
Message-ID: <20240408125314.732039222@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

[ Upstream commit 0296bea01cfa6526be6bd2d16dc83b4e7f1af91f ]

"if device_add() succeeds, you should call device_del() when you want to
get rid of it."

In sd_probe(), device_add_disk() fails when device_add() has already
succeeded, so change put_device() to device_unregister() to ensure device
resources are released.

Fixes: 2a7a891f4c40 ("scsi: sd: Add error handling support for add_disk()")
Signed-off-by: Li Nan <linan122@huawei.com>
Link: https://lore.kernel.org/r/20231208082335.1754205-1-linan666@huaweicloud.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d5d3eea006c13..35200a7a73553 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3757,7 +3757,7 @@ static int sd_probe(struct device *dev)
 
 	error = device_add_disk(dev, gd, NULL);
 	if (error) {
-		put_device(&sdkp->disk_dev);
+		device_unregister(&sdkp->disk_dev);
 		put_disk(gd);
 		goto out;
 	}
-- 
2.43.0



