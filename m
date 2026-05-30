Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65903C1406;
	Sat, 30 May 2026 18:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164366; cv=none; b=B5cQIDPrQCcqMI79W0jTv0oxaAn4lvPfco87UXm2ZKRhZAm6HplbyxTJEgAOkrR/rL3WiblSlP6SALLfqlYzQDT6up3DrPghbyl47tExqQrkXWduOhNKhqFE07E72PVTgr2Y3/CGmE3WWrqxlX/6oRp65JnKyS2qtxqm7nNNlLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164366; c=relaxed/simple;
	bh=PPA8iy6i1VLqUCskBOR0SscW2ga40EJQS7T9YW1aoHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BQPlfuDlGe2jRpoFYDbqP9G8jPcWccjj27IQmNt9k3VZ9DtP+9jnNdByhEZvErl+L/zi0STB/Q+rAMyBaF91l3KX2rDkxIpd3Cf71kYU1b0yS8npzZDgSz36N37N0K4ZVJZN+qGiI5eWpcFmgfGekzq4gymmpQvorBx80e06u68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bD4aTfR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bD4aTfR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88A31F00893;
	Sat, 30 May 2026 18:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164363;
	bh=qNQGoGYd26PUWC6yN3n2GBn/4YWO47d6yPpQvh/EM1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bD4aTfR/IHRHdB3Jmz+T9U63hl6M/LLFt/LtpAbDzarSw4j94xTo9sIDEBFq0MI1Z
	 LWu2pmqNRC4/8hzGCROIwaQZYN0mDuTMPkUjVVYK8IchKzngtciH3Hz1eQQUnXoaaK
	 0KIoj6vBX5wTYbl2VeHAxVWA/Dpe78nWfhZwxEDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 533/776] platform/x86: dell-wmi-sysman: bound enumeration string aggregation
Date: Sat, 30 May 2026 18:04:07 +0200
Message-ID: <20260530160253.976944574@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



