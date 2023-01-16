Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F7633F0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3764C433F0;
	Mon, 16 Jan 2023 16:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886075;
	bh=R6yTPwpBsO8+EctjvMjDDr9lv8BYBR5gIDh0hZvoGPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWuD14EbjQ7A88DhqDvFUoYEbXM5YA6aCe2HCO4z8kci3+p3uFPJAMeg4c4wdIaCO
	 1KTAIDvPuurKN4dJB2tDIZ2qChIiCMuF5rhjONg6FODsvAy4f+oLn82a7Xx/uLm4OE
	 yFnZpn4lHbqi/byL75OQGqCWKoOshE2kWUXBEwQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Frederic Barrat <fbarrat@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 293/658] misc: ocxl: fix possible name leak in ocxl_file_register_afu()
Date: Mon, 16 Jan 2023 16:46:21 +0100
Message-Id: <20230116154923.002413248@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index e094809b54ff..524ded87964d 100644
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



