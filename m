Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D637B3AFD15;
	Sat, 12 Sep 2026 09:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203705; cv=none; b=cD+ddR3sfYacKV9VcTgod+4ug+XeVF1V6ga7lhMdZLQwumkPdnvSceB5VTHylGHTY+fMSID7FgMi0H9fiUtX7Razl1JJQ2gW8HwWQ7Dd/kkEDJVAez7zNhasjch7N95h/HqvtvJwHhpZaFK1rRAnrgwc+ECYZn7fxMehdkuR1Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203705; c=relaxed/simple;
	bh=4Sjzi4EkIRpzE/1jeV7OY/JSw3r7/bwDCqfZdjpoifQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsnGy6vNO1OxZ2KlgL6NrRNBAsz/yQ9s7M70P2BS7TWp4/9QJFNgaIa3Ucj6BVJKR7JuECARg/u/YI7HoIB3VY5ofk/EY9R81V5oCVGaYLZSTKitI7Tv/UEJ3XoXccpdDSa+dPHadIpYhjx2Lu44qnUOaiC4riLrHMRaDCySaAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwgTdQXz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwgTdQXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5171F000FF;
	Sat, 12 Sep 2026 09:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203703;
	bh=C4rAbykO1Oh+/a+9fzo9ehsGkZS85nJM4JDPh0ZNBic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lwgTdQXzLy6qwtAeZdllKTq94aQ82gxpJZsfCPMd46pMh2mvpvjmmxFeF2arzcJdW
	 MpxvPc6ohh4/NPysQeRS02ktrfrUj1tT3bnfNO1bLCVGtTQbd6lQ2stqXc2iFOAJQD
	 9qQWBBVV56nSdR5aTiSD4z4uurWV+R/ilblrzNRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1460/1815] ACPI: bus: Introduce acpi_bus_get_primary_device()
Date: Sat, 12 Sep 2026 08:53:30 +0200
Message-ID: <20260912065723.287456401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: a9ba4dd2f18b ("ACPI: platform: Use acpi_bus_get_primary_device()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c      | 54 +++++++++++++++++++++++++++++------------
 include/acpi/acpi_bus.h |  6 +++++
 2 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 8614b8140ef71..7a2458b00a661 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -809,30 +809,52 @@ static int __init acpi_setup_sb_notify_handler(void)
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
+/**
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
 /**
- * acpi_get_first_physical_node - Get first physical node of an ACPI device
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
index 714d111d80530..61782dfdfe5a5 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -686,6 +686,7 @@ void acpi_bus_unregister_driver(struct acpi_driver *driver);
 int acpi_bus_scan(acpi_handle handle);
 void acpi_bus_trim(struct acpi_device *start);
 acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
+struct device *acpi_bus_get_primary_device(struct acpi_device *adev);
 int acpi_match_device_ids(struct acpi_device *device,
 			  const struct acpi_device_id *ids);
 void acpi_set_modalias(struct acpi_device *adev, const char *default_id,
@@ -1000,6 +1001,11 @@ int acpi_scan_add_dep(acpi_handle handle, struct acpi_handle_list *dep_devices);
 u32 arch_acpi_add_auto_dep(acpi_handle handle);
 #else	/* CONFIG_ACPI */
 
+static inline struct device *acpi_bus_get_primary_device(struct acpi_device *adev)
+{
+	return NULL;
+}
+
 static inline bool acpi_of_match_device(const struct acpi_device *adev,
 					const struct of_device_id *of_match_table,
 					const struct of_device_id **of_id)
-- 
2.53.0



