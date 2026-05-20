Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AF83FE352;
	Wed, 20 May 2026 18:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302444; cv=none; b=KZnatYSas0SNPFQq1nKabwSIbfhXX9FIeagc5JgO1xl5y41mBimvNPR28qGS/jUBv2YA0bGcFT68Vgbbg2f9QOpYwGpD3cVSE+bjy9zbV6bOp+CqUj8lc4nSPqRh5cjXBRkrPjcyEFwkKtDyU1KuG5vrzlTdgjOesqy8MCRlDOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302444; c=relaxed/simple;
	bh=DUvAy8uZ5rvon1ZQ9YnyoVRWhmGG/cWnCMR8odBDmGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XroFcpCy9ZwLfJ+/pVhSGIib7w77sOfJnTajBaD6mhaBuVKtYNtmU8MMooqmynMt2I4Ntolunjs3ZlVxpLKMjEIya1ILPtFTADjrxVopDN9hfgBW0vWqLdZUOG6JqHm8cMOuXBaUVB5IdnGAhMajL12TdulfBWVZ5+6iG3Ec2y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3UI0ZEW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3UI0ZEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C411F000E9;
	Wed, 20 May 2026 18:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302443;
	bh=xvAtnBigW7+tyY7yjSfsnn/RaFqtaEeXF/msv2NaknA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d3UI0ZEW7khIFXcnTKSMJdy/ryyLLbGvju+nb7+blUoEhLtRT/aRM/dpwf+iKteaj
	 x5AX6jgv90QipC8k79doSzl1DkF1bYbeG1rSjSDpSGl14kmYQaQFYKnPKysoWc6wvz
	 HIRU/s4OIrzxJiIcdzz7fPx7T1gfdhN1fvFuoo9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 270/508] platform/x86: dell-wmi-sysman: bound enumeration string aggregation
Date: Wed, 20 May 2026 18:21:33 +0200
Message-ID: <20260520162104.495941797@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 3c34471c26abc52a37f5ad90949e2e4b8027eb14 ]

populate_enum_data() aggregates firmware-provided value-modifier
and possible-value strings into fixed 512-byte struct members.
The current code bounds each individual source string but then
appends every string and separator with raw strcat() and no
remaining-space check.

Switch the aggregation loops to a bounded append helper and
reject enumeration packages whose combined strings do not fit
in the destination buffers.

Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260408084501.1-dell-wmi-sysman-v2-pengpeng@iscas.ac.cn
[ij: add include]
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dell/dell-wmi-sysman/enum-attributes.c    | 34 +++++++++++++++----
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-sysman/enum-attributes.c b/drivers/platform/x86/dell/dell-wmi-sysman/enum-attributes.c
index fc2f58b4cbc6e..7e44ba3015627 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/enum-attributes.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/enum-attributes.c
@@ -6,10 +6,32 @@
  *  Copyright (c) 2020 Dell Inc.
  */
 
+#include <linux/bug.h>
+
 #include "dell-wmi-sysman.h"
 
 get_instance_id(enumeration);
 
+static int append_enum_string(char *dest, const char *src)
+{
+	size_t dest_len = strlen(dest);
+	ssize_t copied;
+
+	if (WARN_ON_ONCE(dest_len >= MAX_BUFF))
+		return -EINVAL;
+
+	copied = strscpy(dest + dest_len, src, MAX_BUFF - dest_len);
+	if (copied < 0)
+		return -EINVAL;
+
+	dest_len += copied;
+	copied = strscpy(dest + dest_len, ";", MAX_BUFF - dest_len);
+	if (copied < 0)
+		return -EINVAL;
+
+	return 0;
+}
+
 static ssize_t current_value_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
 	int instance_id = get_enumeration_instance_id(kobj);
@@ -176,9 +198,9 @@ int populate_enum_data(union acpi_object *enumeration_obj, int instance_id,
 			return -EINVAL;
 		if (check_property_type(enumeration, next_obj, ACPI_TYPE_STRING))
 			return -EINVAL;
-		strcat(wmi_priv.enumeration_data[instance_id].dell_value_modifier,
-			enumeration_obj[next_obj++].string.pointer);
-		strcat(wmi_priv.enumeration_data[instance_id].dell_value_modifier, ";");
+		if (append_enum_string(wmi_priv.enumeration_data[instance_id].dell_value_modifier,
+				       enumeration_obj[next_obj++].string.pointer))
+			return -EINVAL;
 	}
 
 	if (next_obj >= enum_property_count)
@@ -193,9 +215,9 @@ int populate_enum_data(union acpi_object *enumeration_obj, int instance_id,
 			return -EINVAL;
 		if (check_property_type(enumeration, next_obj, ACPI_TYPE_STRING))
 			return -EINVAL;
-		strcat(wmi_priv.enumeration_data[instance_id].possible_values,
-			enumeration_obj[next_obj++].string.pointer);
-		strcat(wmi_priv.enumeration_data[instance_id].possible_values, ";");
+		if (append_enum_string(wmi_priv.enumeration_data[instance_id].possible_values,
+				       enumeration_obj[next_obj++].string.pointer))
+			return -EINVAL;
 	}
 
 	return sysfs_create_group(attr_name_kobj, &enumeration_attr_group);
-- 
2.53.0



