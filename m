Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3B422A7E4;
	Fri, 17 Oct 2025 15:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715001; cv=none; b=D4v8XQm1HKOu1uXYH0MVaRwBFOedW3OkwCn1ZmlBZoPkI26AywVlVauYu56yTxwq+XH4hVE8kkzzix1cu84m2Jqxv4+NQ3InJ7p4VeQcscb5EjiqepaOxc3Gc2igjG61Tmv/DCnT+LPECfdPryfF3s4j2Ng3kW2qFkltSTvdE0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715001; c=relaxed/simple;
	bh=Yy14t1/ZEAYQB0vU7g/w/tmmJk4B+wonItZ9DiY5xjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egpZ1rd3j9p9duR9BCWfYMueBaQhUy0FdZPfuZi1O2VV2w0tPk3NH+nvVHqKpIScD0P+7pgBS56m5J4isaShsjUpozSPCX5uSDPLGtaj7UP7Zp+bN5MeAE71YSJ+tA0VCIlGVnJcGqWginfKR2wcZYp3QcGXhkNkxrnNv+tMkvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLHvaBkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLHvaBkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44888C4CEE7;
	Fri, 17 Oct 2025 15:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715001;
	bh=Yy14t1/ZEAYQB0vU7g/w/tmmJk4B+wonItZ9DiY5xjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLHvaBkvUA0eOSBMVrNdB9SmCF8sbZ92WtXvsD26fEmfWEmv36RfPwtqdnkxbxm/0
	 lTQkw2MFltp2CeVvITknSfyzIxSvaN4jSJIwGoE2U+mkOtL034ZsdjrMD/a45aWoII
	 nbXkuUUgZKnnAnnLDcc0l21J0xK8yrkLnBAaS2Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 064/371] PM: core: Annotate loops walking device links as _srcu
Date: Fri, 17 Oct 2025 16:50:39 +0200
Message-ID: <20251017145204.116186411@linuxfoundation.org>
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

[ Upstream commit fdd9ae23bb989fa9ed1beebba7d3e0c82c7c81ae ]

Since SRCU is used for the protection of device link lists, the loops
over device link lists in multiple places in drivers/base/power/main.c
and in pm_runtime_get_suppliers() should be annotated as _srcu rather
than as _rcu which is the case currently.

Change the annotations accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2393512.ElGaqSPkdT@rafael.j.wysocki
Stable-dep-of: 632d31067be2 ("PM: sleep: Do not wait on SYNC_STATE_ONLY device links")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c    | 18 +++++++++---------
 drivers/base/power/runtime.c |  4 ++--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index c883b01ffbddc..b6ab41265d7a3 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -40,8 +40,8 @@
 
 typedef int (*pm_callback_t)(struct device *);
 
-#define list_for_each_entry_rcu_locked(pos, head, member) \
-	list_for_each_entry_rcu(pos, head, member, \
+#define list_for_each_entry_srcu_locked(pos, head, member) \
+	list_for_each_entry_srcu(pos, head, member, \
 			device_links_read_lock_held())
 
 /*
@@ -281,7 +281,7 @@ static void dpm_wait_for_suppliers(struct device *dev, bool async)
 	 * callbacks freeing the link objects for the links in the list we're
 	 * walking.
 	 */
-	list_for_each_entry_rcu_locked(link, &dev->links.suppliers, c_node)
+	list_for_each_entry_srcu_locked(link, &dev->links.suppliers, c_node)
 		if (READ_ONCE(link->status) != DL_STATE_DORMANT)
 			dpm_wait(link->supplier, async);
 
@@ -338,7 +338,7 @@ static void dpm_wait_for_consumers(struct device *dev, bool async)
 	 * continue instead of trying to continue in parallel with its
 	 * unregistration).
 	 */
-	list_for_each_entry_rcu_locked(link, &dev->links.consumers, s_node)
+	list_for_each_entry_srcu_locked(link, &dev->links.consumers, s_node)
 		if (READ_ONCE(link->status) != DL_STATE_DORMANT)
 			dpm_wait(link->consumer, async);
 
@@ -675,7 +675,7 @@ static void dpm_async_resume_subordinate(struct device *dev, async_func_t func)
 	idx = device_links_read_lock();
 
 	/* Start processing the device's "async" consumers. */
-	list_for_each_entry_rcu_locked(link, &dev->links.consumers, s_node)
+	list_for_each_entry_srcu_locked(link, &dev->links.consumers, s_node)
 		if (READ_ONCE(link->status) != DL_STATE_DORMANT)
 			dpm_async_with_cleanup(link->consumer, func);
 
@@ -1342,7 +1342,7 @@ static void dpm_async_suspend_superior(struct device *dev, async_func_t func)
 	idx = device_links_read_lock();
 
 	/* Start processing the device's "async" suppliers. */
-	list_for_each_entry_rcu_locked(link, &dev->links.suppliers, c_node)
+	list_for_each_entry_srcu_locked(link, &dev->links.suppliers, c_node)
 		if (READ_ONCE(link->status) != DL_STATE_DORMANT)
 			dpm_async_with_cleanup(link->supplier, func);
 
@@ -1396,7 +1396,7 @@ static void dpm_superior_set_must_resume(struct device *dev)
 
 	idx = device_links_read_lock();
 
-	list_for_each_entry_rcu_locked(link, &dev->links.suppliers, c_node)
+	list_for_each_entry_srcu_locked(link, &dev->links.suppliers, c_node)
 		link->supplier->power.must_resume = true;
 
 	device_links_read_unlock(idx);
@@ -1825,7 +1825,7 @@ static void dpm_clear_superiors_direct_complete(struct device *dev)
 
 	idx = device_links_read_lock();
 
-	list_for_each_entry_rcu_locked(link, &dev->links.suppliers, c_node) {
+	list_for_each_entry_srcu_locked(link, &dev->links.suppliers, c_node) {
 		spin_lock_irq(&link->supplier->power.lock);
 		link->supplier->power.direct_complete = false;
 		spin_unlock_irq(&link->supplier->power.lock);
@@ -2077,7 +2077,7 @@ static bool device_prepare_smart_suspend(struct device *dev)
 
 	idx = device_links_read_lock();
 
-	list_for_each_entry_rcu_locked(link, &dev->links.suppliers, c_node) {
+	list_for_each_entry_srcu_locked(link, &dev->links.suppliers, c_node) {
 		if (!device_link_test(link, DL_FLAG_PM_RUNTIME))
 			continue;
 
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 3e84dc4122def..8c23a11e80176 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1903,8 +1903,8 @@ void pm_runtime_get_suppliers(struct device *dev)
 
 	idx = device_links_read_lock();
 
-	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
-				device_links_read_lock_held())
+	list_for_each_entry_srcu(link, &dev->links.suppliers, c_node,
+				 device_links_read_lock_held())
 		if (device_link_test(link, DL_FLAG_PM_RUNTIME)) {
 			link->supplier_preactivated = true;
 			pm_runtime_get_sync(link->supplier);
-- 
2.51.0



