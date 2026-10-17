Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90A235E93B;
	Sat, 17 Oct 2026 18:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260334; cv=none; b=KudtJL7mLFYSUSuMk6LEpKr12k7p86yuM0H0OdgaZ78naKugdBGVQ9ACulbhvyBTQqyuB+rv4zWgyhYkp5rUpV8crpPOlFvOxVFtK/wHVgAoueTCB928ldJa1OpRQ1emnfsG27qZr76qHyirqZ6scwv+EAo+Ed1iGPjCbcLtOCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260334; c=relaxed/simple;
	bh=QRZoO7/OO3TYgEyQPS/ephvMvfHSz4s9Ul54tXi5iJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCN/sTJIcbaBMBbd/Z33tYgpf78D1ggJdgWMgWgfZxEztDnJiiO0VJnJ5ysFYGo23OeedKfjSlJDcHp+7g0SglZ50f3IlOY9J9yi3iBCRJhgPCucb0lxp97eFycfX6B5czq9wTI4j4kuBONcdLKHtI3oS+vpV4O9wQPLiOc9lr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHyd1Hrp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHyd1Hrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0BF1F000C4;
	Sat, 17 Oct 2026 18:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260332;
	bh=Ih8qo/22f3AzUDey8QArJBSFRaQyLQkUeZLGhK5EVG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHyd1HrpfGN7GHuPscmPayRj/zSn8LncSQo0D8UUQdIVMWrin6yxV0adZzxl5jZWs
	 BxUJMuPnGTnb0F83kyE1KyhMpVnVDAVTA51X9yA0JyQ53VM6XvoEObDfUFi51PQw8b
	 VBFmmnU1A+gtV/iwWgug5wZxCcyUXWmTaVZxzZ7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1511/1674] ACPI: bus: Introduce acpi_bus_get_primary_device()
Date: Sat, 17 Oct 2026 18:03:03 +0200
Message-ID: <20261017160509.911243681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 72530e1f72b0515a73fd88292254d04fecf03649 ]

The function used for obtaining the first "physical" device for which
the given ACPI one is the ACPI companion, acpi_get_first_physical_node(),
may return a stale device pointer (mostly in theory) because
acpi_unbind_one() may run as a whole after dropping the ACPI device's
physical_node_lock in acpi_get_first_physical_node() and before it
returns.  The last reference to the "physical" device may be dropped
then before the pointer to it is returned to the caller.

If that happens and the acpi_get_first_physical_node() caller invokes
get_device() on the pointer obtained from it, which is done by the
majority of its callers, a use-after-free will occur.

To prepare for addressing this problem, introduce a new function for
getting the first "physical" device associated with the given ACPI one
(the "primary physical device") that will also reference count the
device in question before returning a pointer to it.

Make that new function and acpi_get_first_physical_node() share the
physical node list lookup code.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/2843318.mvXUDI8C0e@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c      | 54 +++++++++++++++++++++++++++++------------
 include/acpi/acpi_bus.h |  6 +++++
 2 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 9d2301b75898a..a21bc540d8368 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -703,30 +703,52 @@ static int __init acpi_setup_sb_notify_handler(void)
                              Device Matching
    -------------------------------------------------------------------------- */
 
+
+static struct device *primary_physical_device(struct acpi_device *adev)
+{
+	struct acpi_device_physical_node *pn;
+
+	pn = list_first_entry_or_null(&adev->physical_node_list,
+				      struct acpi_device_physical_node, node);
+	if (pn)
+		return pn->dev;
+
+	return NULL;
+}
+
 /**
- * acpi_get_first_physical_node - Get first physical node of an ACPI device
+ * acpi_bus_get_primary_device - Get first physical device for a given ACPI one
+ * @adev: ACPI device to get the first physical device for.
+ *
+ * Find the first physical device for which @adev is the ACPI companion and
+ * reference count it if present.
+ *
+ * Return: Pointer to the first physical counterpart of @adev or NULL if there
+ * are none.  Callers are responsible for invoking put_device() on the returned
+ * device.
+ */
+struct device *acpi_bus_get_primary_device(struct acpi_device *adev)
+{
+	if (!adev)
+		return NULL;
+
+	guard(mutex)(&adev->physical_node_lock);
+
+	return get_device(primary_physical_device(adev));
+}
+EXPORT_SYMBOL_GPL(acpi_bus_get_primary_device);
+
+/**
+ * acpi_get_first_physical_node - Find first physical node of an ACPI device
  * @adev:	ACPI device in question
  *
  * Return: First physical node of ACPI device @adev
  */
 struct device *acpi_get_first_physical_node(struct acpi_device *adev)
 {
-	struct mutex *physical_node_lock = &adev->physical_node_lock;
-	struct device *phys_dev;
-
-	mutex_lock(physical_node_lock);
-	if (list_empty(&adev->physical_node_list)) {
-		phys_dev = NULL;
-	} else {
-		const struct acpi_device_physical_node *node;
+	guard(mutex)(&adev->physical_node_lock);
 
-		node = list_first_entry(&adev->physical_node_list,
-					struct acpi_device_physical_node, node);
-
-		phys_dev = node->dev;
-	}
-	mutex_unlock(physical_node_lock);
-	return phys_dev;
+	return primary_physical_device(adev);
 }
 EXPORT_SYMBOL_GPL(acpi_get_first_physical_node);
 
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index fea9ff235f074..36d5a61d04e98 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -568,6 +568,7 @@ void acpi_bus_unregister_driver(struct acpi_driver *driver);
 int acpi_bus_scan(acpi_handle handle);
 void acpi_bus_trim(struct acpi_device *start);
 acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
+struct device *acpi_bus_get_primary_device(struct acpi_device *adev);
 int acpi_match_device_ids(struct acpi_device *device,
 			  const struct acpi_device_id *ids);
 void acpi_set_modalias(struct acpi_device *adev, const char *default_id,
@@ -821,6 +822,11 @@ static inline void acpi_put_acpi_dev(struct acpi_device *adev)
 }
 #else	/* CONFIG_ACPI */
 
+static inline struct device *acpi_bus_get_primary_device(struct acpi_device *adev)
+{
+	return NULL;
+}
+
 static inline int register_acpi_bus_type(void *bus) { return 0; }
 static inline int unregister_acpi_bus_type(void *bus) { return 0; }
 
-- 
2.53.0



