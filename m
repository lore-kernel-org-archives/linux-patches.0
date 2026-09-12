Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A6335F191;
	Sat, 12 Sep 2026 09:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203700; cv=none; b=NPbJTstny5eFL3/SjNVzhqdn9IIY/n6g6pe/Dyy4mPqeSptNI3YX9MuCjuw4T383VGjRMvV0pHqEuSz718weVSPwM2w4ruV70xBrlIXby6wqPdJXMhMvqy1/Z+LV2QO+6+DV43vYWEMzr1uSSK6a2EHAPQ/F5ulln7qLRnlrb6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203700; c=relaxed/simple;
	bh=6dZKMcS69B2zyJDNgrZvucBWI+N7v3TsVIxO8M5Zcos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmHBMdF3O32v6ZBxLd+h9hYwfroV5fO5ZizeV7aYctNqWtvKNLiJXb8hFWBYgMIQVa6nTQp610b7ipIUt/LQFIitJI2I62knL29qRROdYHXPD3rENzEazHEM5JbewoHo75Bfkj/NKS0qM1M/kh4P2CVt4Itt9epnrpML/qyrHYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w71/5nlL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w71/5nlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37D21F000FF;
	Sat, 12 Sep 2026 09:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203698;
	bh=9CuRbXKnd9GKNvNfnz6y5nQfnEjD2vG8iWxQ2++FLyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w71/5nlLSTP7+etDZ7rqxVq7cD3+msF21bRVuxn1V1T7vSiL0G9axsl0NUAB+sfMj
	 aTftuE03yKG+Eia7iIBTVcq6P3DY3K4R5ScgIjbTckrQsANSUVhR+mAGT6zTqT2mD4
	 H66O+XscSKHUpVZ5OoeshNSVlQemfBcSoShp6eIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1459/1815] ACPI: scan: fix bus ID cleanup on device_add() failures
Date: Sat, 12 Sep 2026 08:53:29 +0200
Message-ID: <20260912065723.264601386@linuxfoundation.org>
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
index 9a7ac2eb9ce0b..f8450f7ea097c 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -524,12 +524,10 @@ static void acpi_device_release(struct device *dev)
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
@@ -544,6 +542,13 @@ static void acpi_device_del(struct acpi_device *device)
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
 
@@ -803,7 +808,7 @@ int acpi_device_add(struct acpi_device *device)
 err:
 	mutex_lock(&acpi_device_lock);
 
-	list_del(&device->wakeup_list);
+	acpi_device_cleanup(device);
 
 err_unlock:
 	mutex_unlock(&acpi_device_lock);
-- 
2.53.0



