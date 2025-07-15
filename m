Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609952397BF;
	Tue, 15 Jul 2025 13:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586330; cv=none; b=BSwThrrmOff/KuzO1CV5adlEe/dKVIwG0JS6qUSDdvSB4d4vnAIyjfDxR7AtShEFZuldE55eEEvsOewEuoY4BkXjn8jm+CCQ7iNUJP+OIFOG9M035oWCTOiebyM9z9hr/I1kHAKSIoxKE9ORiuYC0LVLvcstyVzfKCB13QpPMhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586330; c=relaxed/simple;
	bh=JUplEYcHD6SKLpZYPnsrmHEpbz96d+1evEHhFlJAqns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htGZ5a2LW1K1XqOGABYCsQ9RwMhIdhLyK1PKEZhP3u+eK+oQULq/Z/HiKagk47VAT31IqnwRn/5rAzGtSaU3GHy9nJaNwaCPVVcgIXrsSPADSBXUB+eMQQS+h9+qZmOLzsFVtE+4tiyEsFqDTrutimEAUKU+hbgJuhUrUbahDhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2SimdhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2SimdhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1FFC4CEE3;
	Tue, 15 Jul 2025 13:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586329;
	bh=JUplEYcHD6SKLpZYPnsrmHEpbz96d+1evEHhFlJAqns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2SimdhX8e+X2Ul+bM4nP1xlExZbONEcfilozlnYtJz4wzBiISSp0pfy7ihTLsYMb
	 Z/7kqkfG9Eiy0FPN7SKfZgZ4H1dzhZYKnGPYm5W4M5mSc6mA8poxlBrFKm1i7jmUD2
	 aXmmHqfpz/huWLVo/VXSHwchHYFTHXcT/vTsUO/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <michael@walle.cc>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/148] of: property: define of_property_read_u{8,16,32,64}_array() unconditionally
Date: Tue, 15 Jul 2025 15:12:26 +0200
Message-ID: <20250715130801.285412534@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <michael@walle.cc>

[ Upstream commit 2ca42c3ad9ed875b136065b010753a4caaaa1d38 ]

We can get rid of all the empty stubs because all these functions call
of_property_read_variable_u{8,16,32,64}_array() which already have an
empty stub if CONFIG_OF is not defined.

Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220118173504.2867523-3-michael@walle.cc
Stable-dep-of: 171eb6f71e9e ("ASoC: meson: meson-card-utils: use of_property_present() for DT parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/of.h | 274 ++++++++++++++++++++-------------------------
 1 file changed, 124 insertions(+), 150 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 8681277af9c6f..ec6b8a1af73cf 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -415,130 +415,6 @@ extern int of_detach_node(struct device_node *);
 
 #define of_match_ptr(_ptr)	(_ptr)
 
-/**
- * of_property_read_u8_array - Find and read an array of u8 from a property.
- *
- * @np:		device node from which the property value is to be read.
- * @propname:	name of the property to be searched.
- * @out_values:	pointer to return value, modified only if return value is 0.
- * @sz:		number of array elements to read
- *
- * Search for a property in a device node and read 8-bit value(s) from
- * it.
- *
- * dts entry of array should be like:
- *  ``property = /bits/ 8 <0x50 0x60 0x70>;``
- *
- * Return: 0 on success, -EINVAL if the property does not exist,
- * -ENODATA if property does not have a value, and -EOVERFLOW if the
- * property data isn't large enough.
- *
- * The out_values is modified only if a valid u8 value can be decoded.
- */
-static inline int of_property_read_u8_array(const struct device_node *np,
-					    const char *propname,
-					    u8 *out_values, size_t sz)
-{
-	int ret = of_property_read_variable_u8_array(np, propname, out_values,
-						     sz, 0);
-	if (ret >= 0)
-		return 0;
-	else
-		return ret;
-}
-
-/**
- * of_property_read_u16_array - Find and read an array of u16 from a property.
- *
- * @np:		device node from which the property value is to be read.
- * @propname:	name of the property to be searched.
- * @out_values:	pointer to return value, modified only if return value is 0.
- * @sz:		number of array elements to read
- *
- * Search for a property in a device node and read 16-bit value(s) from
- * it.
- *
- * dts entry of array should be like:
- *  ``property = /bits/ 16 <0x5000 0x6000 0x7000>;``
- *
- * Return: 0 on success, -EINVAL if the property does not exist,
- * -ENODATA if property does not have a value, and -EOVERFLOW if the
- * property data isn't large enough.
- *
- * The out_values is modified only if a valid u16 value can be decoded.
- */
-static inline int of_property_read_u16_array(const struct device_node *np,
-					     const char *propname,
-					     u16 *out_values, size_t sz)
-{
-	int ret = of_property_read_variable_u16_array(np, propname, out_values,
-						      sz, 0);
-	if (ret >= 0)
-		return 0;
-	else
-		return ret;
-}
-
-/**
- * of_property_read_u32_array - Find and read an array of 32 bit integers
- * from a property.
- *
- * @np:		device node from which the property value is to be read.
- * @propname:	name of the property to be searched.
- * @out_values:	pointer to return value, modified only if return value is 0.
- * @sz:		number of array elements to read
- *
- * Search for a property in a device node and read 32-bit value(s) from
- * it.
- *
- * Return: 0 on success, -EINVAL if the property does not exist,
- * -ENODATA if property does not have a value, and -EOVERFLOW if the
- * property data isn't large enough.
- *
- * The out_values is modified only if a valid u32 value can be decoded.
- */
-static inline int of_property_read_u32_array(const struct device_node *np,
-					     const char *propname,
-					     u32 *out_values, size_t sz)
-{
-	int ret = of_property_read_variable_u32_array(np, propname, out_values,
-						      sz, 0);
-	if (ret >= 0)
-		return 0;
-	else
-		return ret;
-}
-
-/**
- * of_property_read_u64_array - Find and read an array of 64 bit integers
- * from a property.
- *
- * @np:		device node from which the property value is to be read.
- * @propname:	name of the property to be searched.
- * @out_values:	pointer to return value, modified only if return value is 0.
- * @sz:		number of array elements to read
- *
- * Search for a property in a device node and read 64-bit value(s) from
- * it.
- *
- * Return: 0 on success, -EINVAL if the property does not exist,
- * -ENODATA if property does not have a value, and -EOVERFLOW if the
- * property data isn't large enough.
- *
- * The out_values is modified only if a valid u64 value can be decoded.
- */
-static inline int of_property_read_u64_array(const struct device_node *np,
-					     const char *propname,
-					     u64 *out_values, size_t sz)
-{
-	int ret = of_property_read_variable_u64_array(np, propname, out_values,
-						      sz, 0);
-	if (ret >= 0)
-		return 0;
-	else
-		return ret;
-}
-
 /*
  * struct property *prop;
  * const __be32 *p;
@@ -719,32 +595,6 @@ static inline int of_property_count_elems_of_size(const struct device_node *np,
 	return -ENOSYS;
 }
 
-static inline int of_property_read_u8_array(const struct device_node *np,
-			const char *propname, u8 *out_values, size_t sz)
-{
-	return -ENOSYS;
-}
-
-static inline int of_property_read_u16_array(const struct device_node *np,
-			const char *propname, u16 *out_values, size_t sz)
-{
-	return -ENOSYS;
-}
-
-static inline int of_property_read_u32_array(const struct device_node *np,
-					     const char *propname,
-					     u32 *out_values, size_t sz)
-{
-	return -ENOSYS;
-}
-
-static inline int of_property_read_u64_array(const struct device_node *np,
-					     const char *propname,
-					     u64 *out_values, size_t sz)
-{
-	return -ENOSYS;
-}
-
 static inline int of_property_read_u32_index(const struct device_node *np,
 			const char *propname, u32 index, u32 *out_value)
 {
@@ -1206,6 +1056,130 @@ static inline bool of_property_read_bool(const struct device_node *np,
 	return prop ? true : false;
 }
 
+/**
+ * of_property_read_u8_array - Find and read an array of u8 from a property.
+ *
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ * @out_values:	pointer to return value, modified only if return value is 0.
+ * @sz:		number of array elements to read
+ *
+ * Search for a property in a device node and read 8-bit value(s) from
+ * it.
+ *
+ * dts entry of array should be like:
+ *  ``property = /bits/ 8 <0x50 0x60 0x70>;``
+ *
+ * Return: 0 on success, -EINVAL if the property does not exist,
+ * -ENODATA if property does not have a value, and -EOVERFLOW if the
+ * property data isn't large enough.
+ *
+ * The out_values is modified only if a valid u8 value can be decoded.
+ */
+static inline int of_property_read_u8_array(const struct device_node *np,
+					    const char *propname,
+					    u8 *out_values, size_t sz)
+{
+	int ret = of_property_read_variable_u8_array(np, propname, out_values,
+						     sz, 0);
+	if (ret >= 0)
+		return 0;
+	else
+		return ret;
+}
+
+/**
+ * of_property_read_u16_array - Find and read an array of u16 from a property.
+ *
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ * @out_values:	pointer to return value, modified only if return value is 0.
+ * @sz:		number of array elements to read
+ *
+ * Search for a property in a device node and read 16-bit value(s) from
+ * it.
+ *
+ * dts entry of array should be like:
+ *  ``property = /bits/ 16 <0x5000 0x6000 0x7000>;``
+ *
+ * Return: 0 on success, -EINVAL if the property does not exist,
+ * -ENODATA if property does not have a value, and -EOVERFLOW if the
+ * property data isn't large enough.
+ *
+ * The out_values is modified only if a valid u16 value can be decoded.
+ */
+static inline int of_property_read_u16_array(const struct device_node *np,
+					     const char *propname,
+					     u16 *out_values, size_t sz)
+{
+	int ret = of_property_read_variable_u16_array(np, propname, out_values,
+						      sz, 0);
+	if (ret >= 0)
+		return 0;
+	else
+		return ret;
+}
+
+/**
+ * of_property_read_u32_array - Find and read an array of 32 bit integers
+ * from a property.
+ *
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ * @out_values:	pointer to return value, modified only if return value is 0.
+ * @sz:		number of array elements to read
+ *
+ * Search for a property in a device node and read 32-bit value(s) from
+ * it.
+ *
+ * Return: 0 on success, -EINVAL if the property does not exist,
+ * -ENODATA if property does not have a value, and -EOVERFLOW if the
+ * property data isn't large enough.
+ *
+ * The out_values is modified only if a valid u32 value can be decoded.
+ */
+static inline int of_property_read_u32_array(const struct device_node *np,
+					     const char *propname,
+					     u32 *out_values, size_t sz)
+{
+	int ret = of_property_read_variable_u32_array(np, propname, out_values,
+						      sz, 0);
+	if (ret >= 0)
+		return 0;
+	else
+		return ret;
+}
+
+/**
+ * of_property_read_u64_array - Find and read an array of 64 bit integers
+ * from a property.
+ *
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ * @out_values:	pointer to return value, modified only if return value is 0.
+ * @sz:		number of array elements to read
+ *
+ * Search for a property in a device node and read 64-bit value(s) from
+ * it.
+ *
+ * Return: 0 on success, -EINVAL if the property does not exist,
+ * -ENODATA if property does not have a value, and -EOVERFLOW if the
+ * property data isn't large enough.
+ *
+ * The out_values is modified only if a valid u64 value can be decoded.
+ */
+static inline int of_property_read_u64_array(const struct device_node *np,
+					     const char *propname,
+					     u64 *out_values, size_t sz)
+{
+	int ret = of_property_read_variable_u64_array(np, propname, out_values,
+						      sz, 0);
+	if (ret >= 0)
+		return 0;
+	else
+		return ret;
+}
+
 static inline int of_property_read_u8(const struct device_node *np,
 				       const char *propname,
 				       u8 *out_value)
-- 
2.39.5



