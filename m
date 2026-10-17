Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9CF3921FB;
	Sat, 17 Oct 2026 17:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258726; cv=none; b=ORVkzv/z8HSS2PurnRUkdNc7me4N/xWFWn8xekWC8+n3qPmjlGOieawodOxNSPoYBS36hYhqRKiF1T3netN1j12qCRwQKzjWNildrzbkzEQ7SOQ3+ZvnyP1pGh0jRYoP2k+WLMcDdpvGRVQ10FbZH+PCAkVNk+hR2MKsJdPD88I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258726; c=relaxed/simple;
	bh=eGXqfIg7A5BuJUvmaSbti8bQNhMuUP7PnVDa/JFdeQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+CtGKYaARQRCv9a7i3iiuvcSgRtRgurz/2I68w6AbbGDE1CQP4d0j/bJQpvjQYYl8vpUWWoYXjb1qeFFiZ3XY28CVcuzq02IRrgTGmA49KvL9C3nJy9OK+RAJ681gbNzWO/9cJ4b5hnea+nWZTSSql3tAzpDRvht4akpbCjSmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+G0qE/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+G0qE/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD06B1F000C4;
	Sat, 17 Oct 2026 17:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258725;
	bh=9YXO+cW6XorfpYOEoLIpBowKjHmysrdMUaKnlQ+TJIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+G0qE/xbktESMkJMB8R/G4539EYmNbsZToI38Xn8E76x6hB6d3i6vPL/c3XBp680
	 AJ1BzGw3+/BO1RlhkyLvr/m2SxDyA/NkjAFpIMuzLfzfygnpAUTTYW6OV8ZZbC9HDP
	 LjdLa/QYk//y+dapSLlKECRCNZJheKiTgI+55vfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0972/1674] device property: Add fwnode_property_match_property_string()
Date: Sat, 17 Oct 2026 17:54:04 +0200
Message-ID: <20261017160456.074550848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit fac4a535758851215d23d7d92879aeee5035f51d ]

Sometimes the users want to match the single value string property
against an array of predefined strings. Create a helper for them.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Link: https://lore.kernel.org/r/20230808162800.61651-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: aac0a51b1670 ("iio: frequency: admv1013: fix NULL pointer dereference on str")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/property.c  | 35 +++++++++++++++++++++++++++++++++++
 include/linux/property.h | 12 ++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index b6a70830555ea..a87cbb858d352 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -498,6 +498,41 @@ int fwnode_property_match_string(const struct fwnode_handle *fwnode,
 }
 EXPORT_SYMBOL_GPL(fwnode_property_match_string);
 
+/**
+ * fwnode_property_match_property_string - find a property string value in an array and return index
+ * @fwnode: Firmware node to get the property of
+ * @propname: Name of the property holding the string value
+ * @array: String array to search in
+ * @n: Size of the @array
+ *
+ * Find a property string value in a given @array and if it is found return
+ * the index back.
+ *
+ * Return: index, starting from %0, if the string value was found in the @array (success),
+ *	   %-ENOENT when the string value was not found in the @array,
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO or %-EILSEQ if the property is not a string,
+ *	   %-ENXIO if no suitable firmware interface is present.
+ */
+int fwnode_property_match_property_string(const struct fwnode_handle *fwnode,
+	const char *propname, const char * const *array, size_t n)
+{
+	const char *string;
+	int ret;
+
+	ret = fwnode_property_read_string(fwnode, propname, &string);
+	if (ret)
+		return ret;
+
+	ret = match_string(array, n, string);
+	if (ret < 0)
+		ret = -ENOENT;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fwnode_property_match_property_string);
+
 /**
  * fwnode_property_get_reference_args() - Find a reference with arguments
  * @fwnode:	Firmware node where to look for the reference
diff --git a/include/linux/property.h b/include/linux/property.h
index d32b8052e0863..e91b4d759758e 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -124,6 +124,18 @@ static inline bool device_is_compatible(const struct device *dev, const char *co
 	return fwnode_device_is_compatible(dev_fwnode(dev), compat);
 }
 
+int fwnode_property_match_property_string(const struct fwnode_handle *fwnode,
+					  const char *propname,
+					  const char * const *array, size_t n);
+
+static inline
+int device_property_match_property_string(const struct device *dev,
+					  const char *propname,
+					  const char * const *array, size_t n)
+{
+	return fwnode_property_match_property_string(dev_fwnode(dev), propname, array, n);
+}
+
 int fwnode_property_get_reference_args(const struct fwnode_handle *fwnode,
 				       const char *prop, const char *nargs_prop,
 				       unsigned int nargs, unsigned int index,
-- 
2.53.0



