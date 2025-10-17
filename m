Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8818A2F12BB;
	Fri, 17 Oct 2025 15:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715004; cv=none; b=LZ9UVa1gv8Bqq2o1CWbC4JcQxFBGSDCUFlq9ZPbtHMmKnjYokhCEwo5g46f/Bm+8WavFF8SEBcYKnZs4P9SU+7IpVDKVuluRH1VB4yxzP/HcQibyQZXiVGzCO8ZyJHVdEPpy8lYRHSyQ2UGTdoN0DNorhwIRz97j3j6wwO/4Ql8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715004; c=relaxed/simple;
	bh=dVxbcjnJzA7d/tntgS14H5imO4owwALwE1Sb5duitcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzbBqlTPXXXmPAnTUeWBTwpjpqwVHYS5bJC5xQIVeNe2UZnCPsIbzlM/qRpRgpMK91xjsy3B+pLDhLtcIf0dVEtas55l+ubX0Jr/Lj/BP4VyBPp9qgF6iNzB6EpZt7YeBi7r9R1NVLCDxiAwmTY3eaUiLX8CHfO8l7GNSIdmMOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/6iL+R9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/6iL+R9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E58C4CEE7;
	Fri, 17 Oct 2025 15:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715004;
	bh=dVxbcjnJzA7d/tntgS14H5imO4owwALwE1Sb5duitcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/6iL+R9uS//An1OT8nJANAtILJRDzV2Bh0n8bgy2T2kj83Mxjp8lHb2P0Fape7Gi
	 b8gdvdf62gWAHtWOo1oSUkkSdIpzawUD932zju+lKRKauuoybeR1qk8qCgVqFiBfy3
	 80UhbCSbbQKbeUmGv4ow9EwuJe+8XgTrTxL/VQSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 065/371] PM: core: Add two macros for walking device links
Date: Fri, 17 Oct 2025 16:50:40 +0200
Message-ID: <20251017145204.152294812@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 3ce3f569991347d2085925041f4932232da43bcf ]

Add separate macros for walking links to suppliers and consumers of a
device to help device links users to avoid exposing the internals of
struct dev_links_info in their code and possible coding mistakes related
to that.

Accordingly, use the new macros to replace open-coded device links list
walks in the core power management code.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/1944671.tdWV9SEqCh@rafael.j.wysocki
Stable-dep-of: 632d31067be2 ("PM: sleep: Do not wait on SYNC_STATE_ONLY device links")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/base.h          |  8 ++++++++
 drivers/base/power/main.c    | 18 +++++++-----------
 drivers/base/power/runtime.c |  3 +--
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 123031a757d91..700aecd22fd34 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -251,6 +251,14 @@ void device_links_unbind_consumers(struct device *dev);
 void fw_devlink_drivers_done(void);
 void fw_devlink_probing_done(void);
 
+#define dev_for_each_link_to_supplier(__link, __dev)	\
+	list_for_each_entry_srcu(__link, &(__dev)->links.suppliers, c_node, \
+				 device_links_read_lock_held())
+
+#define dev_for_each_link_to_consumer(__link, __dev)	\
+	list_for_each_entry_srcu(__link, &(__dev)->links.consumers, s_node, \
+				 device_links_read_lock_held())
+
 /* device pm support */
 void device_pm_move_to_tail(struct device *dev);
 
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index b6ab41265d7a3..b9a34c3425ecf 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -40,10 +40,6 @@
 
 typedef int (*pm_callback_t)(struct device *);
 
-#define list_for_each_entry_srcu_locked(pos, head, member) \
-	list_for_each_entry_srcu(pos, head, member, \
-			device_links_read_lock_held())
-
 /*
  * The entries in the dpm_list list are in a depth first order, simply
  * because children are guaranteed to be discovered after parents, and
@@ -281,7 +277,7 @@ static void dpm_wait_for_suppliers(struct device *dev, bool async)
 	 * callbacks freeing the link objects for the links in the list we're
 	 * walking.
 	 */
-	list_for_each_entry_srcu_locked(link, &dev->links.suppliers, c_node)
+	dev_for_each_link_to_supplier(link, dev)
 		if (READ_ONCE(link->status) != DL_STATE_DORMANT)
 			dpm_wait(link->supplier, async);
 
@@ -338,7 +334,7 @@ static void dpm_wait_for_consumers(struct device *dev, bool async)
 	 * continue instead of trying to continue in parallel with its
 	 * unregistration).
 	 */
-	list_for_each_entry_srcu_locked(link, &dev->links.consumers, s_node)
+	dev_for_each_link_to_consumer(link, dev)
 		if (READ_ONCE(link->status) != DL_STATE_DORMANT)
 			dpm_wait(link->consumer, async);
 
@@ -675,7 +671,7 @@ static void dpm_async_resume_subordinate(struct device *dev, async_func_t func)
 	idx = device_links_read_lock();
 
 	/* Start processing the device's "async" consumers. */
-	list_for_each_entry_srcu_locked(link, &dev->links.consumers, s_node)
+	dev_for_each_link_to_consumer(link, dev)
 		if (READ_ONCE(link->status) != DL_STATE_DORMANT)
 			dpm_async_with_cleanup(link->consumer, func);
 
@@ -1342,7 +1338,7 @@ static void dpm_async_suspend_superior(struct device *dev, async_func_t func)
 	idx = device_links_read_lock();
 
 	/* Start processing the device's "async" suppliers. */
-	list_for_each_entry_srcu_locked(link, &dev->links.suppliers, c_node)
+	dev_for_each_link_to_supplier(link, dev)
 		if (READ_ONCE(link->status) != DL_STATE_DORMANT)
 			dpm_async_with_cleanup(link->supplier, func);
 
@@ -1396,7 +1392,7 @@ static void dpm_superior_set_must_resume(struct device *dev)
 
 	idx = device_links_read_lock();
 
-	list_for_each_entry_srcu_locked(link, &dev->links.suppliers, c_node)
+	dev_for_each_link_to_supplier(link, dev)
 		link->supplier->power.must_resume = true;
 
 	device_links_read_unlock(idx);
@@ -1825,7 +1821,7 @@ static void dpm_clear_superiors_direct_complete(struct device *dev)
 
 	idx = device_links_read_lock();
 
-	list_for_each_entry_srcu_locked(link, &dev->links.suppliers, c_node) {
+	dev_for_each_link_to_supplier(link, dev) {
 		spin_lock_irq(&link->supplier->power.lock);
 		link->supplier->power.direct_complete = false;
 		spin_unlock_irq(&link->supplier->power.lock);
@@ -2077,7 +2073,7 @@ static bool device_prepare_smart_suspend(struct device *dev)
 
 	idx = device_links_read_lock();
 
-	list_for_each_entry_srcu_locked(link, &dev->links.suppliers, c_node) {
+	dev_for_each_link_to_supplier(link, dev) {
 		if (!device_link_test(link, DL_FLAG_PM_RUNTIME))
 			continue;
 
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 8c23a11e80176..7420b9851fe0f 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1903,8 +1903,7 @@ void pm_runtime_get_suppliers(struct device *dev)
 
 	idx = device_links_read_lock();
 
-	list_for_each_entry_srcu(link, &dev->links.suppliers, c_node,
-				 device_links_read_lock_held())
+	dev_for_each_link_to_supplier(link, dev)
 		if (device_link_test(link, DL_FLAG_PM_RUNTIME)) {
 			link->supplier_preactivated = true;
 			pm_runtime_get_sync(link->supplier);
-- 
2.51.0



