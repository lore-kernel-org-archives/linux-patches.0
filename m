Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2958E47CC92;
	Sat, 12 Sep 2026 16:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231543; cv=none; b=U07wIVGv2JALiX4ZSnw8wHZIiWQzsiIBZ1hpD9gqb/MAmoJGXxcSw29QJcM+ChJ0TDpcCFg0+HiVDJCd63BnKJhNZ9lD1B3W7o6ywlYaWQlagLo6LVkFFnoIsIx2SSZs1aI7iU7oJlDT61OD/sCoZZeIOmKtZMMUD+Sr7kATDW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231543; c=relaxed/simple;
	bh=iSEw+mqdxDWSyKBVSV0CKjWnJkruxKym8YzVIhHk6A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXuNW9/diBdJAKG/Ne5Z54fq/6jrqDWR6rIGzY8FChLIwukdpLEtEpDrRnMgZ/XMWCPjyyKW/+JEvtizcyF1xlcJKLFkjoPJcfao9R2friomEBQh0FDlicgAaD/8Os5q63BJMdX8KpG236PHY2EMm2aoT9cFvkvgZyfxZU0RfYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGxFAXbj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGxFAXbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFEF1F00893;
	Sat, 12 Sep 2026 16:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231538;
	bh=04+iM5bOiY1NUucOHDlOcpiovNOPBDIEDGJJMtfMcmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RGxFAXbj7hxTUbiPoCe2LIFNACSt5X+VvR3PdTl/gNvqebyVS6QkTBhgBsbrRUWkp
	 qjelgkJdyRDwW36M8YJAaEai0TSubQsYXMPeJnW31yrsOfaijWevQpZqKkTud+lyEC
	 ox8PkDnLxGJabbp9TyETkD/e/5nM98To68xtv1gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1012/1191] ACPI: scan: fix bus ID cleanup on device_add() failures
Date: Sat, 12 Sep 2026 09:02:20 +0200
Message-ID: <20260912065610.923677868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit a414485ebc2aa50907d0ce97cde2b1a353696897 ]

When device_add() fails after acpi_device_set_name() has allocated an
instance ID and a new acpi_device_bus_id has been linked into
acpi_bus_id_list, the rollback path only removes wakeup_list and
detaches the ACPI handle data.

That leaves the bus-ID bookkeeping behind and keeps the allocated
instance number consumed.

Move the bus-ID cleanup and wakeup-list removal into a single helper.

Use it from both the normal device teardown path and the device_add()
rollback path. The wakeup list node is initialized before registration,
so it can be deleted without checking whether the device is wakeup-
capable like in the original teardown path.

Fixes: d783156ea384 ("ACPI / scan: Define non-empty device removal handler")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
[ rjw: Rename acpi_device_del_list() to acpi_device_cleanup() ]
[ rjw: Subject and changelog edits ]
Link: https://patch.msgid.link/20260808085943.526-1-getshell@seu.edu.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 4aaf8c974f79b..12c3a5984bf18 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -455,12 +455,10 @@ static void acpi_device_release(struct device *dev)
 	kfree(acpi_dev);
 }
 
-static void acpi_device_del(struct acpi_device *device)
+static void acpi_device_cleanup(struct acpi_device *device)
 {
 	struct acpi_device_bus_id *acpi_device_bus_id;
 
-	mutex_lock(&acpi_device_lock);
-
 	list_for_each_entry(acpi_device_bus_id, &acpi_bus_id_list, node)
 		if (!strcmp(acpi_device_bus_id->bus_id,
 			    acpi_device_hid(device))) {
@@ -475,6 +473,13 @@ static void acpi_device_del(struct acpi_device *device)
 		}
 
 	list_del(&device->wakeup_list);
+}
+
+static void acpi_device_del(struct acpi_device *device)
+{
+	mutex_lock(&acpi_device_lock);
+
+	acpi_device_cleanup(device);
 
 	mutex_unlock(&acpi_device_lock);
 
@@ -740,7 +745,7 @@ int acpi_device_add(struct acpi_device *device)
 err:
 	mutex_lock(&acpi_device_lock);
 
-	list_del(&device->wakeup_list);
+	acpi_device_cleanup(device);
 
 err_unlock:
 	mutex_unlock(&acpi_device_lock);
-- 
2.53.0



