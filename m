Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFF1BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93933C433D2;
	Tue,  7 Mar 2023 17:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210491;
	bh=ioQ4OXnLMYg0Q6kyleOzRK0onhEe8RavH2BtK4xtyOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1zOYwgNxOq85xgXaDOuLBifahspESX/Lkhs+zBeYl2I+0iToDE1wGAynhzd+M7AZa
	 uFQAI3OAmXetO/eR8//Uy8Qm9SQ3ReiT1pgBzOyZVEoUSaMub+M43i95HbHZ4PB1Wt
	 gUYe8Otj7EBPLJtSiWzvDuTfakWezSNIDp6fl57A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0528/1001] firmware: dmi-sysfs: Fix null-ptr-deref in dmi_sysfs_register_handle
Date: Tue,  7 Mar 2023 17:55:00 +0100
Message-Id: <20230307170044.365325474@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 18e126e97c961f7a93823795c879d7c085fe5098 ]

KASAN reported a null-ptr-deref error:

KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 1373 Comm: modprobe
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
RIP: 0010:dmi_sysfs_entry_release
...
Call Trace:
 <TASK>
 kobject_put
 dmi_sysfs_register_handle (drivers/firmware/dmi-sysfs.c:540) dmi_sysfs
 dmi_decode_table (drivers/firmware/dmi_scan.c:133)
 dmi_walk (drivers/firmware/dmi_scan.c:1115)
 dmi_sysfs_init (drivers/firmware/dmi-sysfs.c:149) dmi_sysfs
 do_one_initcall (init/main.c:1296)
 ...
Kernel panic - not syncing: Fatal exception
Kernel Offset: 0x4000000 from 0xffffffff81000000
---[ end Kernel panic - not syncing: Fatal exception ]---

It is because previous patch added kobject_put() to release the memory
which will call  dmi_sysfs_entry_release() and list_del().

However, list_add_tail(entry->list) is called after the error block,
so the list_head is uninitialized and cannot be deleted.

Move error handling to after list_add_tail to fix this.

Fixes: 660ba678f999 ("firmware: dmi-sysfs: Fix memory leak in dmi_sysfs_register_handle")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Link: https://lore.kernel.org/r/20221111015326.251650-2-chenzhongjin@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/dmi-sysfs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index 66727ad3361b9..402217c570333 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -603,16 +603,16 @@ static void __init dmi_sysfs_register_handle(const struct dmi_header *dh,
 	*ret = kobject_init_and_add(&entry->kobj, &dmi_sysfs_entry_ktype, NULL,
 				    "%d-%d", dh->type, entry->instance);
 
-	if (*ret) {
-		kobject_put(&entry->kobj);
-		return;
-	}
-
 	/* Thread on the global list for cleanup */
 	spin_lock(&entry_list_lock);
 	list_add_tail(&entry->list, &entry_list);
 	spin_unlock(&entry_list_lock);
 
+	if (*ret) {
+		kobject_put(&entry->kobj);
+		return;
+	}
+
 	/* Handle specializations by type */
 	switch (dh->type) {
 	case DMI_ENTRY_SYSTEM_EVENT_LOG:
-- 
2.39.2



