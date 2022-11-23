Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FBF1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A71C433D7;
	Wed, 23 Nov 2022 09:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195610;
	bh=iHtYXJUW5kF5M8kJ0vGoQn8upBt80fEQeivL6K3pozs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyiZezmnsZNdvLURekPGxifEVc0v+J5zWkUgfxjQPKM9qSdAYuBlwOgBV7LEyShN3
	 8LvNgX37YqYXiRYuJv9PATDUqwpEoXhmMNWkNbQNd/Oc22tioLqlPgfyCMjtPLDXT2
	 cKyO50GddOHNSrPsh2IkU0dJRKe1r5zGTf9NRjxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Douglas Gilbert <dgilbert@interlog.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/149] scsi: scsi_debug: Fix possible UAF in sdebug_add_host_helper()
Date: Wed, 23 Nov 2022 09:51:57 +0100
Message-Id: <20221123084602.746806291@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit e208a1d795a08d1ac0398c79ad9c58106531bcc5 ]

If device_register() fails in sdebug_add_host_helper(), it will goto clean
and sdbg_host will be freed, but sdbg_host->host_list will not be removed
from sdebug_host_list, then list traversal may cause UAF. Fix it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221117084421.58918-1-yuancan@huawei.com
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5eb959b5f701..261b915835b4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7079,8 +7079,12 @@ static int sdebug_add_host_helper(int per_host_idx)
 	dev_set_name(&sdbg_host->dev, "adapter%d", sdebug_num_hosts);
 
 	error = device_register(&sdbg_host->dev);
-	if (error)
+	if (error) {
+		spin_lock(&sdebug_host_list_lock);
+		list_del(&sdbg_host->host_list);
+		spin_unlock(&sdebug_host_list_lock);
 		goto clean;
+	}
 
 	++sdebug_num_hosts;
 	return 0;
-- 
2.35.1



