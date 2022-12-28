Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966B21863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFD7C433D2;
	Wed, 28 Dec 2022 15:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241325;
	bh=6xxUo/GEQS0U7SB304rSRPsfHFdtm5YDRp8auUtaHsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRToL6yFWtuxNymt0/Jr/8lZfra1lb1ZghW4jaSEokXDneAFZRJwMyFtDZj28zX6j
	 TvJXIWYgI5b2xN3RoZBnPbShT/1jFh88INZlldvhMyIGKmEBOvRthxwBt6VTiVBlQ0
	 WUAkPE3wn+28kQb2eXI6VxzYNK44ERF4+lrAQUGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Frederic Barrat <fbarrat@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 466/731] misc: ocxl: fix possible name leak in ocxl_file_register_afu()
Date: Wed, 28 Dec 2022 15:39:33 +0100
Message-Id: <20221228144310.056606210@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit a4cb1004aeed2ab893a058fad00a5b41a12c4691 ]

If device_register() returns error in ocxl_file_register_afu(),
the name allocated by dev_set_name() need be freed. As comment
of device_register() says, it should use put_device() to give
up the reference in the error path. So fix this by calling
put_device(), then the name can be freed in kobject_cleanup(),
and info is freed in info_release().

Fixes: 75ca758adbaf ("ocxl: Create a clear delineation between ocxl backend & frontend")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>
Link: https://lore.kernel.org/r/20221111145929.2429271-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ocxl/file.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ocxl/file.c b/drivers/misc/ocxl/file.c
index 134806c2e67e..a199c7ce3f81 100644
--- a/drivers/misc/ocxl/file.c
+++ b/drivers/misc/ocxl/file.c
@@ -543,8 +543,11 @@ int ocxl_file_register_afu(struct ocxl_afu *afu)
 		goto err_put;
 
 	rc = device_register(&info->dev);
-	if (rc)
-		goto err_put;
+	if (rc) {
+		free_minor(info);
+		put_device(&info->dev);
+		return rc;
+	}
 
 	rc = ocxl_sysfs_register_afu(info);
 	if (rc)
-- 
2.35.1



