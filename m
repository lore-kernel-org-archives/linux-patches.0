Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BAE3A1D05;
	Wed,  3 Dec 2025 16:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779559; cv=none; b=NzMY6wjTRwGdda3EFhEGpvH6rRMm9qEs4KU/AfuJ8clotyInrpFCrQCsG5FZ5sVlZdkty44xuse92taUiA2x1zyrKZSA4zluDsSTtAwbfbtn5dQUeA73pB/RK1N4ocG5pPhMCmPwWWp0Qlb8ptXr5gWNjLupOGTQojoslNx1A2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779559; c=relaxed/simple;
	bh=XPHdjiAcROzHoUq3ZrEtD832vpwFDo5NSxRWX1iCZLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrZrOGe7CfdbJrWsMBJdmwOdPjzTHMLV5dxTTwh+Opn8YH/IQZkeGS7/Up0mQeTcRpSrh0midYb4Wpud+BJ+6762tZUzaLj+PBz726I6XHZcxPFLBIiSLqh7pFsh0/M39vz1LddrsLnfdGsRtmvaqKWQ1QY5MDNxfcphZtOUALo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YoDLADK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YoDLADK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714D9C4CEF5;
	Wed,  3 Dec 2025 16:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779558;
	bh=XPHdjiAcROzHoUq3ZrEtD832vpwFDo5NSxRWX1iCZLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YoDLADK1wx4Uqvblkl1ogimgVcTFhhzB7qNY/ynC6fLOtk/5JZ5GkoBBD713zEDgy
	 rTjBVj/WiKR5VDxIsu1deY/DTLHjCGtR8pe6PbG9CSJqb9Kcys0iTbzJt4HVCXTmyk
	 olO5aGTU6ooA0EGsnokxJPHQciuvnhUuaCoJpxu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 294/568] ACPI: property: Return present device nodes only on fwnode interface
Date: Wed,  3 Dec 2025 16:24:56 +0100
Message-ID: <20251203152451.470212359@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit d9f866b2bb3eec38b3734f1fed325ec7c55ccdfa ]

fwnode_graph_get_next_subnode() may return fwnode backed by ACPI
device nodes and there has been no check these devices are present
in the system, unlike there has been on fwnode OF backend.

In order to provide consistent behaviour towards callers,
add a check for device presence by introducing
a new function acpi_get_next_present_subnode(), used as the
get_next_child_node() fwnode operation that also checks device
node presence.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://patch.msgid.link/20251001102636.1272722-2-sakari.ailus@linux.intel.com
[ rjw: Kerneldoc comment and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/property.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
index 46003b642b597..9f7880cc2bd8c 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1298,6 +1298,28 @@ struct fwnode_handle *acpi_get_next_subnode(const struct fwnode_handle *fwnode,
 	return NULL;
 }
 
+/*
+ * acpi_get_next_present_subnode - Return the next present child node handle
+ * @fwnode: Firmware node to find the next child node for.
+ * @child: Handle to one of the device's child nodes or a null handle.
+ *
+ * Like acpi_get_next_subnode(), but the device nodes returned by
+ * acpi_get_next_present_subnode() are guaranteed to be present.
+ *
+ * Returns: The fwnode handle of the next present sub-node.
+ */
+static struct fwnode_handle *
+acpi_get_next_present_subnode(const struct fwnode_handle *fwnode,
+			      struct fwnode_handle *child)
+{
+	do {
+		child = acpi_get_next_subnode(fwnode, child);
+	} while (is_acpi_device_node(child) &&
+		 !acpi_device_is_present(to_acpi_device_node(child)));
+
+	return child;
+}
+
 /**
  * acpi_node_get_parent - Return parent fwnode of this fwnode
  * @fwnode: Firmware node whose parent to get
@@ -1641,7 +1663,7 @@ static int acpi_fwnode_irq_get(const struct fwnode_handle *fwnode,
 		.property_read_string_array =				\
 			acpi_fwnode_property_read_string_array,		\
 		.get_parent = acpi_node_get_parent,			\
-		.get_next_child_node = acpi_get_next_subnode,		\
+		.get_next_child_node = acpi_get_next_present_subnode,	\
 		.get_named_child_node = acpi_fwnode_get_named_child_node, \
 		.get_name = acpi_fwnode_get_name,			\
 		.get_name_prefix = acpi_fwnode_get_name_prefix,		\
-- 
2.51.0



