Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7A133F37D;
	Tue, 11 Nov 2025 01:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825342; cv=none; b=btzM2V12Ds3AzKLiIXGAYQRicqNzjzKhPIZv6nPQ18xdtVqnXRpswunY15ZMmkQNiYGBSchACA2/ELN4SChAcNXMrTEpGo3ta67RqPuoWgkaxLs7tLdnsoEdxnxSkN2EmJS2XoBQGTjHRQu6zA8wwVPFpmhFcokJzc6n0CrSJss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825342; c=relaxed/simple;
	bh=pI4WSoSuI9MwOJx2fCnuM5Ghh7KTO+A/hJqmMoWOkK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqzhZ2GaNbStpRURIdnYF2vUW3yGq2VKW0TA1RU6ZSCZOVMQrDGYwtzwypDc74RPN9K2SQ41UeF1s7gmZhEqzzj8m/7Wa862OFQan3zLxK9hRCRQFkN6faLLmxrmtUynOsyeaRTHf/Cn1u9q3oo9DMl8fhnh+GgngmA47sooJis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TiQk5PPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiQk5PPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82786C16AAE;
	Tue, 11 Nov 2025 01:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825340;
	bh=pI4WSoSuI9MwOJx2fCnuM5Ghh7KTO+A/hJqmMoWOkK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiQk5PPSqxWaSDdqwrdw9HG6L90ztoKD/WM2kcjssys14LrcSwSqTpGoD/uzERZFT
	 NsZXEHQJYKvy/pBQywYUwObUqd4xdVma9IYl7kfrXcDXy4EqhqbI8eM2N69r7RnXX4
	 byXauCvYslwQu6vjlovOVQFY1c2if7/ucp4Fj0p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 718/849] ACPI: property: Return present device nodes only on fwnode interface
Date: Tue, 11 Nov 2025 09:44:48 +0900
Message-ID: <20251111004553.791027632@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
index c086786fe84cb..d74678f0ba4af 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1357,6 +1357,28 @@ struct fwnode_handle *acpi_get_next_subnode(const struct fwnode_handle *fwnode,
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
@@ -1701,7 +1723,7 @@ static int acpi_fwnode_irq_get(const struct fwnode_handle *fwnode,
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



