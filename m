Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48C12D94BA;
	Fri, 21 Nov 2025 13:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733104; cv=none; b=u4KEAb4/JXnxqU1+vs1wifDaRRkHrhAayodjvWdMpGQNSKrq/+ArHuQIif3JhgKzSjgqXMKLW4szC3llYvUMf25khYFWPEzIKpfKlVY+s5lVLtM57QFtiswGiwJy031Otz3PFryb+sHQ1ysRzkrkicL+tHmgK8jmNqAWUppv2d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733104; c=relaxed/simple;
	bh=uF8zjAAyNRuPSJQTA5pH2TBKAv1Qw4iQJy2Qs0HxEJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bd8Aov7r4z9/r/aQy8hIdgM/RRlEtCsA3RCDFyZtysQpHk8vtZkIOZ1iKINh5pcpH3S9XX8VDg385sRT3T2YAdFcIy1uSeUpv6baJn8fMM626N3PI3D4MzY4PrPpJW+nsAqMPD+Bd4IY/W+tKYYebQu3bqoKS/UeZX+ksG+0D0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzH4Y34b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzH4Y34b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7209DC4CEF1;
	Fri, 21 Nov 2025 13:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733103;
	bh=uF8zjAAyNRuPSJQTA5pH2TBKAv1Qw4iQJy2Qs0HxEJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzH4Y34bezLqK1Zc/XoUmOdgw04n9TrDi9N3AgAUAqFFYcK/cZMqkUle14Iqd2HO0
	 bU3Wlv/RROJ2SKV/m5qROEqU5i3nWuNDSw4kQz2ynTLD1k9xZ3SfctkltO3acI7Zaw
	 Y63URQMcbCN4tKg5pGcMwJFVdDOURqgWD9Xbg1lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 319/529] ACPI: property: Return present device nodes only on fwnode interface
Date: Fri, 21 Nov 2025 14:10:18 +0100
Message-ID: <20251121130242.376504405@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index 5898c3c8c2a7f..d02b332744e64 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1286,6 +1286,28 @@ struct fwnode_handle *acpi_get_next_subnode(const struct fwnode_handle *fwnode,
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
@@ -1629,7 +1651,7 @@ static int acpi_fwnode_irq_get(const struct fwnode_handle *fwnode,
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



