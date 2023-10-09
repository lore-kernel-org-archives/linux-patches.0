Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C42339B0
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TV2/xNiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EA3C433C8;
	Mon,  9 Oct 2023 13:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859083;
	bh=V3QVcjelJ7IoLVWtLhWjnXvbIYmuEQdrA5s2K1pVGQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TV2/xNiSs5x71tDBR5ln+m3A+nLQcSljsl5wk3zOgMbcxFdjvZysyk0jEPNjTiUyd
	 k3LgQme4HKV5G4PhSPK3GSJAHSoMaEPiO5DKR5FvmPBxiA/9DRIxTj5MCau2IY5I+F
	 eu2xlPnCTR0xH6Murvck95PG8vBBdBa1sc+nq2Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/226] scsi: target: core: Fix deadlock due to recursive locking
Date: Mon,  9 Oct 2023 15:02:35 +0200
Message-ID: <20231009130131.670402880@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxiao Bi <junxiao.bi@oracle.com>

[ Upstream commit a154f5f643c6ecddd44847217a7a3845b4350003 ]

The following call trace shows a deadlock issue due to recursive locking of
mutex "device_mutex". First lock acquire is in target_for_each_device() and
second in target_free_device().

 PID: 148266   TASK: ffff8be21ffb5d00  CPU: 10   COMMAND: "iscsi_ttx"
  #0 [ffffa2bfc9ec3b18] __schedule at ffffffffa8060e7f
  #1 [ffffa2bfc9ec3ba0] schedule at ffffffffa8061224
  #2 [ffffa2bfc9ec3bb8] schedule_preempt_disabled at ffffffffa80615ee
  #3 [ffffa2bfc9ec3bc8] __mutex_lock at ffffffffa8062fd7
  #4 [ffffa2bfc9ec3c40] __mutex_lock_slowpath at ffffffffa80631d3
  #5 [ffffa2bfc9ec3c50] mutex_lock at ffffffffa806320c
  #6 [ffffa2bfc9ec3c68] target_free_device at ffffffffc0935998 [target_core_mod]
  #7 [ffffa2bfc9ec3c90] target_core_dev_release at ffffffffc092f975 [target_core_mod]
  #8 [ffffa2bfc9ec3ca0] config_item_put at ffffffffa79d250f
  #9 [ffffa2bfc9ec3cd0] config_item_put at ffffffffa79d2583
 #10 [ffffa2bfc9ec3ce0] target_devices_idr_iter at ffffffffc0933f3a [target_core_mod]
 #11 [ffffa2bfc9ec3d00] idr_for_each at ffffffffa803f6fc
 #12 [ffffa2bfc9ec3d60] target_for_each_device at ffffffffc0935670 [target_core_mod]
 #13 [ffffa2bfc9ec3d98] transport_deregister_session at ffffffffc0946408 [target_core_mod]
 #14 [ffffa2bfc9ec3dc8] iscsit_close_session at ffffffffc09a44a6 [iscsi_target_mod]
 #15 [ffffa2bfc9ec3df0] iscsit_close_connection at ffffffffc09a4a88 [iscsi_target_mod]
 #16 [ffffa2bfc9ec3df8] finish_task_switch at ffffffffa76e5d07
 #17 [ffffa2bfc9ec3e78] iscsit_take_action_for_connection_exit at ffffffffc0991c23 [iscsi_target_mod]
 #18 [ffffa2bfc9ec3ea0] iscsi_target_tx_thread at ffffffffc09a403b [iscsi_target_mod]
 #19 [ffffa2bfc9ec3f08] kthread at ffffffffa76d8080
 #20 [ffffa2bfc9ec3f50] ret_from_fork at ffffffffa8200364

Fixes: 36d4cb460bcb ("scsi: target: Avoid that EXTENDED COPY commands trigger lock inversion")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Link: https://lore.kernel.org/r/20230918225848.66463-1-junxiao.bi@oracle.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_device.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 4664330fb55dd..9aeedcff7d02e 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -867,7 +867,6 @@ sector_t target_to_linux_sector(struct se_device *dev, sector_t lb)
 EXPORT_SYMBOL(target_to_linux_sector);
 
 struct devices_idr_iter {
-	struct config_item *prev_item;
 	int (*fn)(struct se_device *dev, void *data);
 	void *data;
 };
@@ -877,11 +876,9 @@ static int target_devices_idr_iter(int id, void *p, void *data)
 {
 	struct devices_idr_iter *iter = data;
 	struct se_device *dev = p;
+	struct config_item *item;
 	int ret;
 
-	config_item_put(iter->prev_item);
-	iter->prev_item = NULL;
-
 	/*
 	 * We add the device early to the idr, so it can be used
 	 * by backend modules during configuration. We do not want
@@ -891,12 +888,13 @@ static int target_devices_idr_iter(int id, void *p, void *data)
 	if (!target_dev_configured(dev))
 		return 0;
 
-	iter->prev_item = config_item_get_unless_zero(&dev->dev_group.cg_item);
-	if (!iter->prev_item)
+	item = config_item_get_unless_zero(&dev->dev_group.cg_item);
+	if (!item)
 		return 0;
 	mutex_unlock(&device_mutex);
 
 	ret = iter->fn(dev, iter->data);
+	config_item_put(item);
 
 	mutex_lock(&device_mutex);
 	return ret;
@@ -919,7 +917,6 @@ int target_for_each_device(int (*fn)(struct se_device *dev, void *data),
 	mutex_lock(&device_mutex);
 	ret = idr_for_each(&devices_idr, target_devices_idr_iter, &iter);
 	mutex_unlock(&device_mutex);
-	config_item_put(iter.prev_item);
 	return ret;
 }
 
-- 
2.40.1



