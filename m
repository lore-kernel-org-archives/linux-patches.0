Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D1D2CA1
	for <patches@lists.linux.dev>; Fri,  7 Jan 2022 22:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641596092; x=1673132092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uPvz7HDFF+nK6rd3cra9vwO1yKtl5eFfnQFtN4S7Jvo=;
  b=CfUvdcmKq0Gx4dnzRivj6sO1qgG/dNR2pMS2jSe0oIwTU+kV0QjeyNHJ
   BmAUC+qqBow/Y6fiwC2esjuBr0vR62Q5FfGVVed4qOoWpmv1GWRB8Txjl
   +P8Y7e9eD5CoM0O+uGYwRu9gAk9LjexZUFnsPzy0Y5hhyJ9IYba3uI/YI
   s8IkVF/x+fd+e9XOG1VZKLC6KnCK0RSdXZ8Vyj1YMJSrVDLracKWYFoxE
   nIXdEoygcbGcf7i7y08/E+NKSPo9ehS3Kb+qhgZRaTw+60C62xLhAPE7i
   qIeNAFE4nBofbNNhSdaUQNRDH6RIxr4T17P3/csH3DEwm7sm+ijcDYN/1
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="242907968"
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="242907968"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 14:54:48 -0800
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="471452465"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 14:54:48 -0800
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
Subject: [PATCH 4/5] x86/sysfs: Add format parameter to macro defining "show" functions for proc
Date: Fri,  7 Jan 2022 14:54:41 -0800
Message-Id: <20220107225442.1690165-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220107225442.1690165-1-tony.luck@intel.com>
References: <20220107225442.1690165-1-tony.luck@intel.com>
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
index 8f2b641d0b8c..793c592e533a 100644
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
@@ -42,16 +42,16 @@ static ssize_t name##_list_read(struct file *file, struct kobject *kobj,	\
 					off, count);				\
 }
 
-define_id_show_func(physical_package_id);
+define_id_show_func(physical_package_id, "%d");
 static DEVICE_ATTR_RO(physical_package_id);
 
-define_id_show_func(die_id);
+define_id_show_func(die_id, "%d");
 static DEVICE_ATTR_RO(die_id);
 
-define_id_show_func(cluster_id);
+define_id_show_func(cluster_id, "%d");
 static DEVICE_ATTR_RO(cluster_id);
 
-define_id_show_func(core_id);
+define_id_show_func(core_id, "%d");
 static DEVICE_ATTR_RO(core_id);
 
 define_siblings_read_func(thread_siblings, sibling_cpumask);
@@ -79,7 +79,7 @@ static BIN_ATTR_RO(package_cpus, 0);
 static BIN_ATTR_RO(package_cpus_list, 0);
 
 #ifdef CONFIG_SCHED_BOOK
-define_id_show_func(book_id);
+define_id_show_func(book_id, "%d");
 static DEVICE_ATTR_RO(book_id);
 define_siblings_read_func(book_siblings, book_cpumask);
 static BIN_ATTR_RO(book_siblings, 0);
@@ -87,7 +87,7 @@ static BIN_ATTR_RO(book_siblings_list, 0);
 #endif
 
 #ifdef CONFIG_SCHED_DRAWER
-define_id_show_func(drawer_id);
+define_id_show_func(drawer_id, "%d");
 static DEVICE_ATTR_RO(drawer_id);
 define_siblings_read_func(drawer_siblings, drawer_cpumask);
 static BIN_ATTR_RO(drawer_siblings, 0);
-- 
2.31.1

