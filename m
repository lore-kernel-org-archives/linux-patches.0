Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790091EABD1;
	Tue, 15 Oct 2024 12:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993970; cv=none; b=cMWHek+ocgkvButhdRXloGeO/HL2aEthQx8k86pQQ0AoFQJPtZezHe1BNh3YGfafS8AtkMx2hi1KP92a1cHeO94VOWdLx82NMRo2tN5ut5IiuvRJ2PNRuFR+Zxlz+wQg9efHXLc+DrDvcVqcaDTazVh4gy1lH7t0hIA9Q2N51IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993970; c=relaxed/simple;
	bh=qW6PPshGWkhpT9q9N4oTGOeZLv7XhbJgHMNamp8dcW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BogWovgKqeE6W8i4qWx8ijOLbb/Ervcn9Sasr2kdifRN0EG1m4YfaTO3D1wye+tNEnmaaODIlCJKgiO3PTk7WLEJUcnT0tU/DSb4K3OlU7BBDBQjLbzMWenaywr2FRV3zSV6EwBddJxLvNHY01og6Fdko/vyFukmJY9U2xPg4lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fskWQB12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fskWQB12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF5EC4CEC6;
	Tue, 15 Oct 2024 12:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993970;
	bh=qW6PPshGWkhpT9q9N4oTGOeZLv7XhbJgHMNamp8dcW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fskWQB126LXtItQdl3v1VVLLEq8/cWd6fOOJWdSdQKK/PdfSvZ+aGT/QNsJzGfYBx
	 Qa7ZQJX3o/HyHAsCYCg1PSiKt102LT7FXiO+4VtDgi227Yb+MRK4RL1bPzotb5sZlP
	 xeJskkZpc945L3ossU00HDSLUpNTPGBAzBILsk44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 551/691] device property: Add fwnode_irq_get_byname
Date: Tue, 15 Oct 2024 13:28:19 +0200
Message-ID: <20241015112502.211332147@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 8d3cefaf6592 ("i2c: core: Lock address during client device instantiation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/property.c  | 29 +++++++++++++++++++++++++++++
 include/linux/property.h |  1 +
 2 files changed, 30 insertions(+)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 87bb97e12749e..ff1be3e311eeb 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -1066,6 +1066,35 @@ void __iomem *fwnode_iomap(struct fwnode_handle *fwnode, int index)
 }
 EXPORT_SYMBOL(fwnode_iomap);
 
+/**
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
 /**
  * fwnode_graph_get_next_endpoint - Get next endpoint firmware node
  * @fwnode: Pointer to the parent firmware node
diff --git a/include/linux/property.h b/include/linux/property.h
index 032262e3d9991..840f0545d4f9d 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -125,6 +125,7 @@ struct fwnode_handle *fwnode_handle_get(struct fwnode_handle *fwnode);
 void fwnode_handle_put(struct fwnode_handle *fwnode);
 
 int fwnode_irq_get(const struct fwnode_handle *fwnode, unsigned int index);
+int fwnode_irq_get_byname(const struct fwnode_handle *fwnode, const char *name);
 
 void __iomem *fwnode_iomap(struct fwnode_handle *fwnode, int index);
 
-- 
2.43.0



