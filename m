Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD9733E34E;
	Sat, 12 Sep 2026 15:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225567; cv=none; b=J+lSmLVudErWcstE77kT0BzCWLLPNuMj+bO/+hCMf/0mov1mV0KNxp7coXzbSIsphox6bTmV8cG9baOfET8WHYM9OpCMDxfS6y4dhNcM7kQ8m0dLBjBKvDFZf0tdLEo15pmYmGXQH8rBOOn4s/2dCYmDihZhIjgHwUQC5WMhIQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225567; c=relaxed/simple;
	bh=CZMTKGjfVq4Iv+bNHxYkN9/0p2TVinbgpyuq/GCF9sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrtdkqDJEtzC1txhP0auUzAE9Mh+lGMScr/+EgguHWc9e87LXOynDe/0+bR2WKEje8J7fAO3FYjb6akjV9geRqHjjn0rnHqDObzkq0E9S2g0T0/M6lm5FRzf3wc0MA6RD3Bh1dFA4ZljgloOHia7g9vum2otPI9vcpS2rshRnq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCh0xlWp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCh0xlWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4AB1F000FF;
	Sat, 12 Sep 2026 15:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225563;
	bh=y7zMkBDt2yX8Q0eK2u3OIGp5VzEeCCPVA0Q+tQ5BZ2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XCh0xlWpC21Tw9o5MKV2Y7CxyAyH418yen4VN7bVZRryfRrZzMtP/Z0EYOH5oVQ6Q
	 iGSJl1ylv0q62Bs1kRcG8hxNe/0W/vdw3WkaTyORyBClik2J4oTPBT2ZgSkJwvyoJe
	 Qd3nm8XqqSeRLTcWrRCJnlnWuYf6YlCHJWI9UleU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1222/1424] ACPI: scan: fix bus ID cleanup on device_add() failures
Date: Sat, 12 Sep 2026 09:00:54 +0200
Message-ID: <20260912065634.651729206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 2892219c7afd1..b2bb9b34fb8af 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -454,12 +454,10 @@ static void acpi_device_release(struct device *dev)
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
@@ -474,6 +472,13 @@ static void acpi_device_del(struct acpi_device *device)
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
 
@@ -739,7 +744,7 @@ int acpi_device_add(struct acpi_device *device)
 err:
 	mutex_lock(&acpi_device_lock);
 
-	list_del(&device->wakeup_list);
+	acpi_device_cleanup(device);
 
 err_unlock:
 	mutex_unlock(&acpi_device_lock);
-- 
2.53.0



