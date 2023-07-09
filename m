Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229A7522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A07C433C8;
	Sun,  9 Jul 2023 11:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901993;
	bh=xFGiy8HkXKZiklmAa5tGGltHHve2Sf6Oc+0wcePUEcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPJBnC5uLI8vAJ6pWmId1reDQtJV0gNt1iWLe+9Cg8bZSgaehQB2a95f5huVEj/AH
	 vKM6nJZWgdpXvRjzsU18BWSDOb/9Mnh5pbbAmDD0E1Zk7KEUUu1JMZgmPpvcYCEj4f
	 zyW/YVQK+GnVhggOWMepKZ3blshtENqcbDY5DRNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 189/431] driver: soc: xilinx: use _safe loop iterator to avoid a use after free
Date: Sun,  9 Jul 2023 13:12:17 +0200
Message-ID: <20230709111455.607975110@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit c58da0ba3e5c86e51e2c1557afaf6f71e00c4533 ]

The hash_for_each_possible() loop dereferences "eve_data" to get the
next item on the list.  However the loop frees eve_data so it leads to
a use after free.  Use hash_for_each_possible_safe() instead.

Fixes: c7fdb2404f66 ("drivers: soc: xilinx: add xilinx event management driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/761e0e4a-4caf-4a71-8f47-1c6ad908a848@kili.mountain
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/xilinx/xlnx_event_manager.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/xilinx/xlnx_event_manager.c b/drivers/soc/xilinx/xlnx_event_manager.c
index c76381899ef49..f9d9b82b562da 100644
--- a/drivers/soc/xilinx/xlnx_event_manager.c
+++ b/drivers/soc/xilinx/xlnx_event_manager.c
@@ -192,11 +192,12 @@ static int xlnx_remove_cb_for_suspend(event_cb_func_t cb_fun)
 	struct registered_event_data *eve_data;
 	struct agent_cb *cb_pos;
 	struct agent_cb *cb_next;
+	struct hlist_node *tmp;
 
 	is_need_to_unregister = false;
 
 	/* Check for existing entry in hash table for given cb_type */
-	hash_for_each_possible(reg_driver_map, eve_data, hentry, PM_INIT_SUSPEND_CB) {
+	hash_for_each_possible_safe(reg_driver_map, eve_data, tmp, hentry, PM_INIT_SUSPEND_CB) {
 		if (eve_data->cb_type == PM_INIT_SUSPEND_CB) {
 			/* Delete the list of callback */
 			list_for_each_entry_safe(cb_pos, cb_next, &eve_data->cb_list_head, list) {
@@ -228,11 +229,12 @@ static int xlnx_remove_cb_for_notify_event(const u32 node_id, const u32 event,
 	u64 key = ((u64)node_id << 32U) | (u64)event;
 	struct agent_cb *cb_pos;
 	struct agent_cb *cb_next;
+	struct hlist_node *tmp;
 
 	is_need_to_unregister = false;
 
 	/* Check for existing entry in hash table for given key id */
-	hash_for_each_possible(reg_driver_map, eve_data, hentry, key) {
+	hash_for_each_possible_safe(reg_driver_map, eve_data, tmp, hentry, key) {
 		if (eve_data->key == key) {
 			/* Delete the list of callback */
 			list_for_each_entry_safe(cb_pos, cb_next, &eve_data->cb_list_head, list) {
-- 
2.39.2



