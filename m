Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F57272E53;
	Thu, 20 Aug 2026 16:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244094; cv=none; b=nqI9B9aX4expv+Iw8jFlhzWXbI9INMKJxlnpoySydzkCsLMb9kVRmVYb6PudSEz7HN8jRXEU9JTbCa+ItZ3DZ31pK7uWVWFpMTngNc9dub4WxG01zT8TDp6LYk4AWUJ0RJw1F3Nsy4rVnG6UnZOFxRiM+4tB5RbScbg9FBVwQ/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244094; c=relaxed/simple;
	bh=2pcy8BTdntxqSr+HLf8r/dspqiZFqhUlFCpaPYfkhV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkBsGF1+Ma+h6cv5w1lVdXCH95buwpFohdOD1EVn/yI6ChBzLlRe+QgXIOn3BSd99i2QvIYpLBZ1YjnfV9Ls3hIlCHy4g/58hMI6eOvGrpa8VJnoOTwwZW4OHyVjHoHBWYhioahF16C3bQUdqhoBsDbI2zy4V53533gXR7qV+QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZMulusC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZMulusC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298111F00A3D;
	Thu, 20 Aug 2026 16:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244093;
	bh=BU/Vk41UZjEeJ0V/nHFccwtQdpJdS01efNyxFdSzwgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VZMulusCcfctGoW3VzSNkIcbmz5lUjgfRGdd5e+vEE/jlgjo7CVea10cWVkRgKWsV
	 US8w1kKPEPGGo98yWNlT9PVnhgHjrwtQg9fosDZY0bh9q2ks9S1hMI8gd+mlfQkYsc
	 ez7sNFkqEZl36skuh4teYerEt48tSYxynH0WYwhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/235] device property: Add fwnode_irq_get_byname
Date: Thu, 20 Aug 2026 16:54:44 +0200
Message-ID: <20260820145217.890747689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit ca0acb511c21738b32386ce0f85c284b351d919e ]

Add fwnode_irq_get_byname() to get an interrupt by name from either
ACPI table or Device Tree, whichever is used for enumeration.

In the ACPI case, this allow us to use 'interrupt-names' in
_DSD which can be mapped to Interrupt() resource by index.
The implementation is similar to 'interrupt-names' in the
Device Tree.

Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 158efa411c57 ("i2c: core: fix adapter probe deferral loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/property.c  |   29 +++++++++++++++++++++++++++++
 include/linux/property.h |    1 +
 2 files changed, 30 insertions(+)

--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -1043,6 +1043,35 @@ int fwnode_irq_get(const struct fwnode_h
 EXPORT_SYMBOL(fwnode_irq_get);
 
 /**
+ * fwnode_irq_get_byname - Get IRQ from a fwnode using its name
+ * @fwnode:	Pointer to the firmware node
+ * @name:	IRQ name
+ *
+ * Description:
+ * Find a match to the string @name in the 'interrupt-names' string array
+ * in _DSD for ACPI, or of_node for Device Tree. Then get the Linux IRQ
+ * number of the IRQ resource corresponding to the index of the matched
+ * string.
+ *
+ * Return:
+ * Linux IRQ number on success, or negative errno otherwise.
+ */
+int fwnode_irq_get_byname(const struct fwnode_handle *fwnode, const char *name)
+{
+	int index;
+
+	if (!name)
+		return -EINVAL;
+
+	index = fwnode_property_match_string(fwnode, "interrupt-names",  name);
+	if (index < 0)
+		return index;
+
+	return fwnode_irq_get(fwnode, index);
+}
+EXPORT_SYMBOL(fwnode_irq_get_byname);
+
+/**
  * fwnode_graph_get_next_endpoint - Get next endpoint firmware node
  * @fwnode: Pointer to the parent firmware node
  * @prev: Previous endpoint node or %NULL to get the first
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -120,6 +120,7 @@ struct fwnode_handle *fwnode_handle_get(
 void fwnode_handle_put(struct fwnode_handle *fwnode);
 
 int fwnode_irq_get(const struct fwnode_handle *fwnode, unsigned int index);
+int fwnode_irq_get_byname(const struct fwnode_handle *fwnode, const char *name);
 
 unsigned int device_get_child_node_count(struct device *dev);
 


