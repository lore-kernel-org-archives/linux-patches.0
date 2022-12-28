Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C721863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6795FC433EF;
	Wed, 28 Dec 2022 15:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240555;
	bh=ZLE2dTYV+lTi+iWjawH28UFbuT+bslTSaaoHl5vZ0D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zlh2wv/5kiLtquPYD5wOWEWEcS7+/2JPz+zYZS9BD4UfugWvoDf7de70SNS0gXEgt
	 JXcpeOuhoJ/uf9cwAUWszR2IYcG8a42OMhy/ShmhwsNAepWohbJKBPzejxc/3c/thV
	 aIkpYMIFaV2V0GsInj40eaZxRHUReMWxCkdPMTy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0174/1073] platform/x86: intel_scu_ipc: fix possible name leak in __intel_scu_ipc_register()
Date: Wed, 28 Dec 2022 15:29:22 +0100
Message-Id: <20221228144332.738651913@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 0b3d0cb7c0bed2fd6454f77ed75e7a662c6efd12 ]

In some error paths before device_register(), the names allocated
by dev_set_name() are not freed. Move dev_set_name() front to
device_register(), so the name can be freed while calling
put_device().

Fixes: 54b34aa0a729 ("platform/x86: intel_scu_ipc: Split out SCU IPC functionality from the SCU driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221208151916.2404977-1-yangyingliang@huawei.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_scu_ipc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 7cc9089d1e14..e7a3e3402817 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -583,7 +583,6 @@ __intel_scu_ipc_register(struct device *parent,
 	scu->dev.parent = parent;
 	scu->dev.class = &intel_scu_ipc_class;
 	scu->dev.release = intel_scu_ipc_release;
-	dev_set_name(&scu->dev, "intel_scu_ipc");
 
 	if (!request_mem_region(scu_data->mem.start, resource_size(&scu_data->mem),
 				"intel_scu_ipc")) {
@@ -612,6 +611,7 @@ __intel_scu_ipc_register(struct device *parent,
 	 * After this point intel_scu_ipc_release() takes care of
 	 * releasing the SCU IPC resources once refcount drops to zero.
 	 */
+	dev_set_name(&scu->dev, "intel_scu_ipc");
 	err = device_register(&scu->dev);
 	if (err) {
 		put_device(&scu->dev);
-- 
2.35.1



