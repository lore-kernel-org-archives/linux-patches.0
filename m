Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F86775818;
	Mon, 15 Apr 2024 14:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191288; cv=none; b=JDj9vSyjxY42AnuRb6/JbYUypthO2dbDrL5YJFjccMukQrfbaC/WKboAC9x2EOfCuH7yzr5n/5WKF5nOTET7pyIoQE3rBrwVK9UAaaBzzzLD1aI44N5MOOQELNE4MDTM07PVbTo5W7Y91iPLzk9VmNl0Oj7ldmFYy3or/aIy9oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191288; c=relaxed/simple;
	bh=3mGdyeSj5ZHiWVRCdig4JLNvP6CxHCpdfSy2g9zT5Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hB75fE0YpRb5K52kQX/XhgP8C0s/reOK+hlbpifVzJQhgWXxwM4wqgjzdvYHMDzTrZb+3v0j9ast3GWGjQ80x9XFCXGWHCetvW8vK3/L1zKMB2qEPB4ZmH/gkyiJ3GHVaiBMltNAeYASxZnQgPKtY39zFqZhmNQic1ipfNJlugQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDPVSN1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDPVSN1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C34C113CC;
	Mon, 15 Apr 2024 14:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191288;
	bh=3mGdyeSj5ZHiWVRCdig4JLNvP6CxHCpdfSy2g9zT5Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDPVSN1XrOnMeXJipYiiwlJWkjHcei818qBhnp7p2Qj88Saq3VMg3NZVaEQWDKP6e
	 HdNCRvO0sC/z1r2Hgr5hO7cfU2eibmWdfkru8006SfUgZpPlfPSjuPexYtIwwDjzPr
	 mficuRt6F2aW1LLeuhHIL3val28bxV18M03eyOrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 056/172] ACPI: HMAT: Introduce 2 levels of generic port access class
Date: Mon, 15 Apr 2024 16:19:15 +0200
Message-ID: <20240415142002.125844004@linuxfoundation.org>
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

[ Upstream commit 1745a7b364dfd339ab2696b7d51d7ed950ed2598 ]

In order to compute access0 and access1 classes for CXL memory, 2 levels
of generic port information must be stored. Access0 will indicate the
generic port access coordinates to the closest initiator and access1
will indicate the generic port access coordinates to the cloest CPU.

Cc: Rafael J. Wysocki <rafael@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20240308220055.2172956-4-dave.jiang@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 592780b8391f ("cxl: Fix retrieving of access_coordinates in PCIe path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/numa/hmat.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index e0144cfbf1f31..a1257888a6dfd 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -59,7 +59,8 @@ struct target_cache {
 };
 
 enum {
-	NODE_ACCESS_CLASS_GENPORT_SINK = ACCESS_COORDINATE_MAX,
+	NODE_ACCESS_CLASS_GENPORT_SINK_LOCAL = ACCESS_COORDINATE_MAX,
+	NODE_ACCESS_CLASS_GENPORT_SINK_CPU,
 	NODE_ACCESS_CLASS_MAX,
 };
 
@@ -141,7 +142,7 @@ int acpi_get_genport_coordinates(u32 uid,
 	if (!target)
 		return -ENOENT;
 
-	*coord = target->coord[NODE_ACCESS_CLASS_GENPORT_SINK];
+	*coord = target->coord[NODE_ACCESS_CLASS_GENPORT_SINK_LOCAL];
 
 	return 0;
 }
@@ -695,7 +696,8 @@ static void hmat_update_target_attrs(struct memory_target *target,
 	int i;
 
 	/* Don't update for generic port if there's no device handle */
-	if (access == NODE_ACCESS_CLASS_GENPORT_SINK &&
+	if ((access == NODE_ACCESS_CLASS_GENPORT_SINK_LOCAL ||
+	     access == NODE_ACCESS_CLASS_GENPORT_SINK_CPU) &&
 	    !(*(u16 *)target->gen_port_device_handle))
 		return;
 
@@ -736,7 +738,8 @@ static void hmat_update_target_attrs(struct memory_target *target,
 		list_for_each_entry(initiator, &initiators, node) {
 			u32 value;
 
-			if (access == ACCESS_COORDINATE_CPU &&
+			if ((access == ACCESS_COORDINATE_CPU ||
+			     access == NODE_ACCESS_CLASS_GENPORT_SINK_CPU) &&
 			    !initiator->has_cpu) {
 				clear_bit(initiator->processor_pxm, p_nodes);
 				continue;
@@ -775,7 +778,9 @@ static void hmat_update_generic_target(struct memory_target *target)
 	static DECLARE_BITMAP(p_nodes, MAX_NUMNODES);
 
 	hmat_update_target_attrs(target, p_nodes,
-				 NODE_ACCESS_CLASS_GENPORT_SINK);
+				 NODE_ACCESS_CLASS_GENPORT_SINK_LOCAL);
+	hmat_update_target_attrs(target, p_nodes,
+				 NODE_ACCESS_CLASS_GENPORT_SINK_CPU);
 }
 
 static void hmat_register_target_initiators(struct memory_target *target)
-- 
2.43.0



