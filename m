Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952F67F7F2;
	Mon, 15 Apr 2024 14:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191291; cv=none; b=UPwQP3HyBTcHvHSraIxFi1ebbpUQQPfVzRYJ4GLnKOq5hTvLBfwRr9NQsXRyKH6sMvWS+Vldntpx+k0lnf00MTtIONU7DNnLgqJXA+b6oAg7oznWTK5KHIUkuhjG8Zktx3jbm2nGRJ5c9HSnMhCaOyVy9moQAldoceU7cVnWwWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191291; c=relaxed/simple;
	bh=IsxswYLEozXVsyjrg6y/hsdDVPdMglmKtH+z8Ygnw7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyczL76j+91Guqu2LbfKKZFauOVA5Je9Q2TJ2fvmRU9QqdpmNe4mOUYTcGyI5rVQwn0Bf6vW9uTpmule9qnHtcJizEybjEDHfKNOlEDWEfzekqijqIyc6yyyyM4JpigdoeY6KBtwZ4Wprwoxtlj/3CcEq6zaw/7xgFvE7tO0LgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCVn7Vm4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCVn7Vm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F22C113CC;
	Mon, 15 Apr 2024 14:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191291;
	bh=IsxswYLEozXVsyjrg6y/hsdDVPdMglmKtH+z8Ygnw7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCVn7Vm41US/7AM5YpzdnnMV7pp3dPwhslthyNCqK28n+bil+W83Ea41K7pHsOqrV
	 eYg3/dQkipxMC+pab1egyb7EW5sEOtriwZxqnHUPuKK2O9vfLTYuBfdIcCXJgCsLn+
	 MBiLPYRzGvnkT7LBIoKgc9ehqHqDhwYvsc43r4iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 057/172] ACPI: HMAT / cxl: Add retrieval of generic port coordinates for both access classes
Date: Mon, 15 Apr 2024 16:19:16 +0200
Message-ID: <20240415142002.155243463@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit bd98cbbbf82a3086423865816e1b5ab4bb4b6c60 ]

Update acpi_get_genport_coordinates() to allow retrieval of both access
classes of the 'struct access_coordinate' for a generic target. The update
will allow CXL code to compute access coordinates for both access class.

Cc: Rafael J. Wysocki <rafael@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20240308220055.2172956-5-dave.jiang@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 592780b8391f ("cxl: Fix retrieving of access_coordinates in PCIe path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/numa/hmat.c | 8 ++++++--
 drivers/cxl/acpi.c       | 8 +++++---
 drivers/cxl/core/port.c  | 2 +-
 drivers/cxl/cxl.h        | 2 +-
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index a1257888a6dfd..75e9aac43228a 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -126,7 +126,8 @@ static struct memory_target *acpi_find_genport_target(u32 uid)
 /**
  * acpi_get_genport_coordinates - Retrieve the access coordinates for a generic port
  * @uid: ACPI unique id
- * @coord: The access coordinates written back out for the generic port
+ * @coord: The access coordinates written back out for the generic port.
+ *	   Expect 2 levels array.
  *
  * Return: 0 on success. Errno on failure.
  *
@@ -142,7 +143,10 @@ int acpi_get_genport_coordinates(u32 uid,
 	if (!target)
 		return -ENOENT;
 
-	*coord = target->coord[NODE_ACCESS_CLASS_GENPORT_SINK_LOCAL];
+	coord[ACCESS_COORDINATE_LOCAL] =
+		target->coord[NODE_ACCESS_CLASS_GENPORT_SINK_LOCAL];
+	coord[ACCESS_COORDINATE_CPU] =
+		target->coord[NODE_ACCESS_CLASS_GENPORT_SINK_CPU];
 
 	return 0;
 }
diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 1a3e6aafbdcc3..af5cb818f84d6 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -530,13 +530,15 @@ static int get_genport_coordinates(struct device *dev, struct cxl_dport *dport)
 	if (kstrtou32(acpi_device_uid(hb), 0, &uid))
 		return -EINVAL;
 
-	rc = acpi_get_genport_coordinates(uid, &dport->hb_coord);
+	rc = acpi_get_genport_coordinates(uid, dport->hb_coord);
 	if (rc < 0)
 		return rc;
 
 	/* Adjust back to picoseconds from nanoseconds */
-	dport->hb_coord.read_latency *= 1000;
-	dport->hb_coord.write_latency *= 1000;
+	for (int i = 0; i < ACCESS_COORDINATE_MAX; i++) {
+		dport->hb_coord[i].read_latency *= 1000;
+		dport->hb_coord[i].write_latency *= 1000;
+	}
 
 	return 0;
 }
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index e59d9d37aa650..612bf7e1e8474 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -2152,7 +2152,7 @@ int cxl_endpoint_get_perf_coordinates(struct cxl_port *port,
 	}
 
 	/* Augment with the generic port (host bridge) perf data */
-	combine_coordinates(&c, &dport->hb_coord);
+	combine_coordinates(&c, &dport->hb_coord[ACCESS_COORDINATE_LOCAL]);
 
 	/* Get the calculated PCI paths bandwidth */
 	pdev = to_pci_dev(port->uport_dev->parent);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 003feebab79b5..fe7448f2745e1 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -671,7 +671,7 @@ struct cxl_dport {
 	struct cxl_port *port;
 	struct cxl_regs regs;
 	struct access_coordinate sw_coord;
-	struct access_coordinate hb_coord;
+	struct access_coordinate hb_coord[ACCESS_COORDINATE_MAX];
 	long link_latency;
 };
 
-- 
2.43.0



