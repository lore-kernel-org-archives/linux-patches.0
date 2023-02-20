Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1E363B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74410C433EF;
	Mon, 20 Feb 2023 13:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901301;
	bh=TgrcLEEAM0LNBd3HLA83vIVo4F5wBCN0KIqBHlgVPcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8wzHpZJUjRQwlWMlrVKtpn56Smv9rq6JTMsIsYm1EJDlM8WT0pPwjvGAab+U8ADh
	 DeZF9vqTHB84lvcR+RU32pK5QEtRqNwTG0oSsj1nSuoPL9iYDoXlb+sORC+dvzEO74
	 p+zmvr9/g5Ou9ISpqQBWRN3zFecSHVOV75od/XjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/57] nvmem: core: fix registration vs use race
Date: Mon, 20 Feb 2023 14:36:23 +0100
Message-Id: <20230220133549.911775396@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit ab3428cfd9aa2f3463ee4b2909b5bb2193bd0c4a ]

The i.MX6 CPU frequency driver sometimes fails to register at boot time
due to nvmem_cell_read_u32() sporadically returning -ENOENT.

This happens because there is a window where __nvmem_device_get() in
of_nvmem_cell_get() is able to return the nvmem device, but as cells
have been setup, nvmem_find_cell_entry_by_node() returns NULL.

The occurs because the nvmem core registration code violates one of the
fundamental principles of kernel programming: do not publish data
structures before their setup is complete.

Fix this by making nvmem core code conform with this principle.

Fixes: eace75cfdcf7 ("nvmem: Add a simple NVMEM framework for nvmem providers")
Cc: stable@vger.kernel.org
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-7-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index de356cdde4ce8..0ef7b95348b1b 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -682,16 +682,10 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 	nvmem->dev.groups = nvmem_dev_groups;
 #endif
 
-	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
-
-	rval = device_add(&nvmem->dev);
-	if (rval)
-		goto err_put_device;
-
 	if (config->compat) {
 		rval = nvmem_sysfs_setup_compat(nvmem, config);
 		if (rval)
-			goto err_device_del;
+			goto err_put_device;
 	}
 
 	if (config->cells) {
@@ -708,6 +702,12 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 	if (rval)
 		goto err_remove_cells;
 
+	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
+
+	rval = device_add(&nvmem->dev);
+	if (rval)
+		goto err_remove_cells;
+
 	blocking_notifier_call_chain(&nvmem_notifier, NVMEM_ADD, nvmem);
 
 	return nvmem;
@@ -716,8 +716,6 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 	nvmem_device_remove_all_cells(nvmem);
 	if (config->compat)
 		nvmem_sysfs_remove_compat(nvmem, config);
-err_device_del:
-	device_del(&nvmem->dev);
 err_put_device:
 	put_device(&nvmem->dev);
 
-- 
2.39.0



