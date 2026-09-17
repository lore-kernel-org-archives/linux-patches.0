Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BCD4E4C35;
	Thu, 17 Sep 2026 16:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661198; cv=none; b=bvJYfPtMgBVGd/IOnVCjvNcWPXk52xBSH3cxPfL35YaUUlS0rnOybpKsMQx8lXCcABZohzC6OC4RGby9Edd56I1tf5UgpMOg9G7KOYIBnIXneUj6V46Hh6PSps/i8QYM9bifG5arv59zct5/YmyArNn6PBI6YXBzGvfD7GqG2uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661198; c=relaxed/simple;
	bh=z+nxGoBiFiw9IwEH5F2YsuC/+KhsEY+KMy13xHEdYlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dab+i3ATfjurMAtEPF2Ogewvkj4V7JwruKVcNtNx9SPz+k0kLEH9o2DWp5VljL8ytuuD5muTZbxhnoyU8f6diYSYj55bOSrWkJ6I3+bU0v7BEHFzdTjbcZr4EkI1co/0V0KzJMSShiK4CXnDzSbNImuUmiowD4Zq1YRFwCC7GCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oz4nBsv6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oz4nBsv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2371F00898;
	Thu, 17 Sep 2026 16:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661197;
	bh=SFgssHAc1NNo6zgZsSt9savOPTzisfjUFUuBkt7k0/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oz4nBsv66faD9efz1mjUBkyaoxQnynPx7wH37pNQxT56wzIYHRBV4zeyROwRXZEtV
	 3nCU3yUESMA3G8xWKgRb2LZ6AvbubF2VwkXgU+kvZHSjSy5ORG+QQ6CsgllMF6O8I2
	 2E1DmgAlcu9wCHa1Vc29rceB3N+NNKT9dVnYsVsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0114/1250] drivers/of: validate live-tree string properties before string use
Date: Thu, 17 Sep 2026 15:58:29 +0100
Message-ID: <20260917151555.103955800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 1e54c31b9cbbb42162e2e4317c18c8a8b350a79d ]

`populate_properties()` stores live-tree property values as raw byte
sequences plus a separate `length`. They are not globally guaranteed to
be NUL-terminated.

`of_prop_next_string()` iterates string-list properties by walking raw
bytes, `__of_node_is_type()` checks `device_type`,
`__of_device_is_status()` checks `status`, and
`of_alias_from_compatible()` reads the first `compatible` entry. These
paths must validate that the relevant string fits within the property
bounds before they hand it to C string helpers.

Validate these live-tree string properties within their declared bounds.
In particular, make `of_prop_next_string()` reject malformed entries
before returning them, keep the `device_type` check inside the existing
no-lock helper path, and add unit coverage for malformed first and
trailing string-list entries.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260507081812.91838-1-pengpeng@iscas.ac.cn
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/base.c     | 43 ++++++++++++++++++++++++++-----------------
 drivers/of/property.c | 27 +++++++++++++++++++++------
 drivers/of/unittest.c | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+), 23 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 25529235c1a6a..ffd1d51dff38b 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -82,9 +82,17 @@ EXPORT_SYMBOL(of_node_name_prefix);
 
 static bool __of_node_is_type(const struct device_node *np, const char *type)
 {
-	const char *match = __of_get_property(np, "device_type", NULL);
+	const char *match;
+	int len;
+
+	if (!np || !type)
+		return false;
+
+	match = __of_get_property(np, "device_type", &len);
+	if (!match || len <= 0 || strnlen(match, len) >= len)
+		return false;
 
-	return np && match && type && !strcmp(match, type);
+	return !strcmp(match, type);
 }
 
 #define EXCLUDED_DEFAULT_CELLS_PLATFORMS ( \
@@ -444,22 +452,22 @@ static bool __of_device_is_status(const struct device_node *device,
 		return false;
 
 	status = __of_get_property(device, "status", &statlen);
-	if (status == NULL)
+	if (!status || statlen <= 0)
+		return false;
+	if (strnlen(status, statlen) >= statlen)
 		return false;
 
-	if (statlen > 0) {
-		while (*strings) {
-			unsigned int len = strlen(*strings);
+	while (*strings) {
+		unsigned int len = strlen(*strings);
 
-			if ((*strings)[len - 1] == '-') {
-				if (!strncmp(status, *strings, len))
-					return true;
-			} else {
-				if (!strcmp(status, *strings))
-					return true;
-			}
-			strings++;
+		if ((*strings)[len - 1] == '-') {
+			if (!strncmp(status, *strings, len))
+				return true;
+		} else {
+			if (!strcmp(status, *strings))
+				return true;
 		}
+		strings++;
 	}
 
 	return false;
@@ -1170,10 +1178,11 @@ EXPORT_SYMBOL(of_find_matching_node_and_match);
 int of_alias_from_compatible(const struct device_node *node, char *alias, int len)
 {
 	const char *compatible, *p;
-	int cplen;
+	int ret;
 
-	compatible = of_get_property(node, "compatible", &cplen);
-	if (!compatible || strlen(compatible) > cplen)
+	ret = of_property_read_string_index(node, "compatible", 0,
+					    &compatible);
+	if (ret)
 		return -ENODEV;
 	p = strchr(compatible, ',');
 	strscpy(alias, p ? p + 1 : compatible, len);
diff --git a/drivers/of/property.c b/drivers/of/property.c
index c1feb631e3831..71322b5bda267 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -614,16 +614,31 @@ EXPORT_SYMBOL_GPL(of_prop_next_u32);
 
 const char *of_prop_next_string(const struct property *prop, const char *cur)
 {
-	const void *curv = cur;
+	const char *curv;
+	const char *end;
+	size_t len;
 
-	if (!prop)
+	if (!prop || !prop->value || !prop->length)
 		return NULL;
 
-	if (!cur)
-		return prop->value;
+	curv = cur ? cur : prop->value;
+	end = prop->value + prop->length;
 
-	curv += strlen(cur) + 1;
-	if (curv >= prop->value + prop->length)
+	if (curv < (const char *)prop->value || curv >= end)
+		return NULL;
+
+	if (cur) {
+		len = strnlen(curv, end - curv);
+		if (len >= end - curv)
+			return NULL;
+
+		curv += len + 1;
+		if (curv >= end)
+			return NULL;
+	}
+
+	len = strnlen(curv, end - curv);
+	if (len >= end - curv)
 		return NULL;
 
 	return curv;
diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 02b780b6e8e25..729813d54c22d 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -713,6 +713,7 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
 static void __init of_unittest_property_string(void)
 {
 	const char *strings[4];
+	const struct property *prop;
 	struct device_node *np;
 	int rc;
 
@@ -789,6 +790,37 @@ static void __init of_unittest_property_string(void)
 	strings[1] = NULL;
 	rc = of_property_read_string_array(np, "phandle-list-names", strings, 1);
 	unittest(rc == 1 && strings[1] == NULL, "Overwrote end of string array; rc=%i, str='%s'\n", rc, strings[1]);
+
+	/* of_prop_next_string() tests */
+	prop = of_find_property(np, "phandle-list-names", NULL);
+	strings[0] = of_prop_next_string(prop, NULL);
+	unittest(strings[0] && !strcmp(strings[0], "first"),
+		 "of_prop_next_string() failure; got '%s'\n", strings[0]);
+	strings[0] = of_prop_next_string(prop, strings[0]);
+	unittest(strings[0] && !strcmp(strings[0], "second"),
+		 "of_prop_next_string() failure; got '%s'\n", strings[0]);
+	strings[0] = of_prop_next_string(prop, strings[0]);
+	unittest(strings[0] && !strcmp(strings[0], "third"),
+		 "of_prop_next_string() failure; got '%s'\n", strings[0]);
+	strings[0] = of_prop_next_string(prop, strings[0]);
+	unittest(!strings[0],
+		 "of_prop_next_string() should return NULL at end of list\n");
+
+	prop = of_find_property(np, "unterminated-string", NULL);
+	strings[0] = of_prop_next_string(prop, NULL);
+	unittest(!strings[0],
+		 "of_prop_next_string() should reject unterminated first string\n");
+
+	prop = of_find_property(np, "unterminated-string-list", NULL);
+	strings[0] = of_prop_next_string(prop, NULL);
+	unittest(strings[0] && !strcmp(strings[0], "first"),
+		 "of_prop_next_string() failure; got '%s'\n", strings[0]);
+	strings[0] = of_prop_next_string(prop, strings[0]);
+	unittest(strings[0] && !strcmp(strings[0], "second"),
+		 "of_prop_next_string() failure; got '%s'\n", strings[0]);
+	strings[0] = of_prop_next_string(prop, strings[0]);
+	unittest(!strings[0],
+		 "of_prop_next_string() should reject unterminated trailing string\n");
 }
 
 #define propcmp(p1, p2) (((p1)->length == (p2)->length) && \
-- 
2.53.0



