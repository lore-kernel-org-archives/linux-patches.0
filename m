Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E9E1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF027C433D2;
	Wed, 28 Dec 2022 16:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244332;
	bh=qtRNaFWP/S9246Vt70Ya97ShjkPQZHDyDmVB5FtagRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TV8B0Omea9IsuzLKdN8LjrJbR8Ir4gC+Gcoxp47hvUd1M7+5rqY1XFFUh5Xn3j2oG
	 l2P4+N87iz469azOZfi2u96YThmtZ528xyF7j6jFCYS9+XPe/xDR8oekIkIhNirhhe
	 bONHBMHuLHeyNUknDMq97u71rURRzve3GzMr7VIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0652/1146] scsi: scsi_debug: Fix possible name leak in sdebug_add_host_helper()
Date: Wed, 28 Dec 2022 15:36:31 +0100
Message-Id: <20221228144347.868450863@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit e6d773f93a49e0eda88a903a2a6542ca83380eb1 ]

Afer commit 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id
string array"), the name of device is allocated dynamically, it needs be
freed when device_register() returns error.

As comment of device_register() says, one should use put_device() to give
up the reference in the error path. Fix this by calling put_device(), then
the name can be freed in kobject_cleanup(), and sdbg_host is freed in
sdebug_release_adapter().

When the device release is not set, it means the device is not initialized.
We can not call put_device() in this case. Use kfree() to free memory.

Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221112131010.3757845-1-yangyingliang@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 20e64b7d3f7b..b77035ddc944 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7340,7 +7340,10 @@ static int sdebug_add_host_helper(int per_host_idx)
 		kfree(sdbg_devinfo->zstate);
 		kfree(sdbg_devinfo);
 	}
-	kfree(sdbg_host);
+	if (sdbg_host->dev.release)
+		put_device(&sdbg_host->dev);
+	else
+		kfree(sdbg_host);
 	pr_warn("%s: failed, errno=%d\n", __func__, -error);
 	return error;
 }
-- 
2.35.1



