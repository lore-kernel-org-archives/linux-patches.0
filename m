Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6BF158545;
	Tue, 11 Nov 2025 01:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824622; cv=none; b=U5i7K1DESg0pEhXwin8HzjfHrdzPOWH/u8sQN7cMZ++1C6RT5N18GpIhYSglqJTyGGH420I7SJnyK4k2gibAXfhEkThEUtC/QVROTRDwc1HUNIHpZxQk+TUsaZ78g0fgJ996/jGnynmJbqG+laEQrgHH06W+5x/DOdZF/nX0+bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824622; c=relaxed/simple;
	bh=I0GNZYR5fh89TKfXALsf7WvjibJslnjnC5H8HJWruZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmGcoLZeksyQOSN9ZT6+T/bKi8ymJ0e1kGhkDsf748SyhU6Q5JZMCuebeD8esfKNw1TmKr1a1Fr+F5os5hMSVoqq9HJrFvnTlk6LjuRbkJ9kDEmBmsj7S5ZvYuDFZCiMKc8rfYfOXXAKxGmj79L/3vh2uTKzvrjs5SSCxhcPv24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qT1yCLE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qT1yCLE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9963BC4CEF5;
	Tue, 11 Nov 2025 01:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824621;
	bh=I0GNZYR5fh89TKfXALsf7WvjibJslnjnC5H8HJWruZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qT1yCLE9RGfqb6zwQzw3tLV7ErfcXoR5ZXLhYDpW3ewaBReml6r5ppnNvj/dceteI
	 y5XtZ2XDTkihdsXyZqc1bk8MctslBpTRO1u8LWMngDubw8qO0KsDDzCC7tuZxs2uOa
	 JKDs1f+ymuK+LmI3qTTCl7OeknaanSTR5/qfDrjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 481/565] ACPI: property: Return present device nodes only on fwnode interface
Date: Tue, 11 Nov 2025 09:45:37 +0900
Message-ID: <20251111004537.742653956@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 342e7cef723cc..b51b947b0ca5b 100644
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
@@ -1700,7 +1722,7 @@ static int acpi_fwnode_irq_get(const struct fwnode_handle *fwnode,
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



