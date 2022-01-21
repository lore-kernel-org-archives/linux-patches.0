Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210372CA7
	for <patches@lists.linux.dev>; Fri, 21 Jan 2022 17:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642787289; x=1674323289;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/1OJfXy/I18emCF3o7qdCGUx0GFDwkCLNiIUahp4qos=;
  b=OSUdCzjzklHKs/Ra9AujBCehR5wrxmnEzz+eQ+1nJ06voM806NoE8MQK
   Ul1eRoHMkXNll3B3iBWQB5oXbBHKg7OsZ88CmbJ4aPAikOGd1fetoW/5A
   tHqzRp/0DT7obTulen1FCE2Uzk+VtShxf4mjM7KdR4lTzmOuofe0Iib5U
   prACTB5GAOB2t7Rl5Az4sQUW9U9Jbo66Zf9cXEsTrLFMm8cuSb8xg5tRn
   8a2jNKWDa0vWacAlb6/ta8skpryVA4WZDlEylJeh93rdvTB7nDsyWvdC5
   8SQSmC7N3y1q0IK/3HziUu7QheVzzEuzokmjrj7kV0n4wvVOj7uVFDm0z
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10234"; a="225694174"
X-IronPort-AV: E=Sophos;i="5.88,306,1635231600"; 
   d="scan'208";a="225694174"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 09:47:52 -0800
X-IronPort-AV: E=Sophos;i="5.88,306,1635231600"; 
   d="scan'208";a="623394801"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 09:47:52 -0800
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Smita Koralahalli Channabasappa <smita.koralahallichannabasappa@amd.com>,
	Wei Huang <wei.huang2@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 5/6] topology/sysfs: Add format parameter to macro defining "show" functions for proc
Date: Fri, 21 Jan 2022 09:47:42 -0800
Message-Id: <20220121174743.1875294-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220121174743.1875294-1-tony.luck@intel.com>
References: <20220107225442.1690165-1-tony.luck@intel.com>
 <20220121174743.1875294-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All the simple (non-mask and non-list files in
/sys/devices/system/cpu/cpu0/topology/ are currently printed as decimal
integers.

Refactor the macro that generates the "show" functions to take a format
parameter to allow future files to display in other formats.

No functional change.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/base/topology.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index fc24e89f9592..044f3664f8f2 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -14,11 +14,11 @@
 #include <linux/hardirq.h>
 #include <linux/topology.h>
 
-#define define_id_show_func(name)					\
+#define define_id_show_func(name, fmt)					\
 static ssize_t name##_show(struct device *dev,				\
 			   struct device_attribute *attr, char *buf)	\
 {									\
-	return sysfs_emit(buf, "%d\n", topology_##name(dev->id));	\
+	return sysfs_emit(buf, fmt "\n", topology_##name(dev->id));	\
 }
 
 #define define_siblings_read_func(name, mask)					\
@@ -42,20 +42,20 @@ static ssize_t name##_list_read(struct file *file, struct kobject *kobj,	\
 					off, count);				\
 }
 
-define_id_show_func(physical_package_id);
+define_id_show_func(physical_package_id, "%d");
 static DEVICE_ATTR_RO(physical_package_id);
 
 #ifdef TOPOLOGY_DIE_SYSFS
-define_id_show_func(die_id);
+define_id_show_func(die_id, "%d");
 static DEVICE_ATTR_RO(die_id);
 #endif
 
 #ifdef TOPOLOGY_CLUSTER_SYSFS
-define_id_show_func(cluster_id);
+define_id_show_func(cluster_id, "%d");
 static DEVICE_ATTR_RO(cluster_id);
 #endif
 
-define_id_show_func(core_id);
+define_id_show_func(core_id, "%d");
 static DEVICE_ATTR_RO(core_id);
 
 define_siblings_read_func(thread_siblings, sibling_cpumask);
@@ -87,7 +87,7 @@ static BIN_ATTR_RO(package_cpus, 0);
 static BIN_ATTR_RO(package_cpus_list, 0);
 
 #ifdef TOPOLOGY_BOOK_SYSFS
-define_id_show_func(book_id);
+define_id_show_func(book_id, "%d");
 static DEVICE_ATTR_RO(book_id);
 define_siblings_read_func(book_siblings, book_cpumask);
 static BIN_ATTR_RO(book_siblings, 0);
@@ -95,7 +95,7 @@ static BIN_ATTR_RO(book_siblings_list, 0);
 #endif
 
 #ifdef TOPOLOGY_DRAWER_SYSFS
-define_id_show_func(drawer_id);
+define_id_show_func(drawer_id, "%d");
 static DEVICE_ATTR_RO(drawer_id);
 define_siblings_read_func(drawer_siblings, drawer_cpumask);
 static BIN_ATTR_RO(drawer_siblings, 0);
-- 
2.31.1

