Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A8B343893;
	Sat, 12 Sep 2026 12:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214915; cv=none; b=tQKn4bwbU+zOkonOys2kkYYvZxtUxQr0z9m3lzG5APzjx67aZhTTCCxA/eCv0FgroiuIWLskg0hiNHj7CUKYozGENGdkxu41I7J32y0gizecEomqXOky9yDw+mKUNVQFDv9PtmEsMThis8VQCMssXwvgAfhh+GFIMeQBCeviT0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214915; c=relaxed/simple;
	bh=rZm3pqn20/wtFaF1Po/DnV3Qm6oyo+uoSPH3egei1Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4DSR2Yg9zUMyvtWgD17BTf288NkrPAKr/Mw0bULBUsD9V5Uzw2qYJcjD2Yk00vK5mvOEsYBv6Kht+JLjz+255GvlPCfJVl+PtG3IBeaAIaXXHRhHjgT8jzg1Q3Tm9C761UJ38vs9upmG60IVRjhELDZWcgEadzEz7DX24Z6Vl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSBnM8iL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSBnM8iL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257D11F000FF;
	Sat, 12 Sep 2026 12:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214913;
	bh=zSz+cDOyICYQ0kJqSY3LYoZRsVCpQ2jrpqc4Ltk8mEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSBnM8iL/zxugXFwg5v384kvOWpg5uvj2jt/2fJTgGXAwRS4p53qCNFlnWmrCUvkM
	 qHyyT5gZznzUV26JlBKN55m+buGJj5nQNW0ncTzzIdImFl3QkpJISEHrpbP0C9xSZk
	 Fvem9anmKRHXkA+h4U+JieEIo+f687gp+Cr5PwYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Price <gourry@gourry.net>,
	David Hildenbrand <david@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Oscar Salvador <osalvador@suse.de>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0381/1376] mm: add build-time option for hotplug memory default online type
Date: Sat, 12 Sep 2026 08:46:47 +0200
Message-ID: <20260912065616.039376784@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Gregory Price <gourry@gourry.net>

[ Upstream commit 44d46b76c3a4b514a0cc9dab147ed430e5c1d699 ]

Memory hotplug presently auto-onlines memory into a zone the kernel deems
appropriate if CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE=y.

The memhp_default_state boot param enables runtime config, but it's not
possible to do this at build-time.

Remove CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE, and replace it with
CONFIG_MHP_DEFAULT_ONLINE_TYPE_* choices that sync with the boot param.

Selections:
  CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE
    => mhp_default_online_type = "offline"
       Memory will not be onlined automatically.

  CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_AUTO
    => mhp_default_online_type = "online"
       Memory will be onlined automatically in a zone deemed.
       appropriate by the kernel.

  CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_KERNEL
    => mhp_default_online_type = "online_kernel"
       Memory will be onlined automatically.
       The zone may allow kernel data (e.g. ZONE_NORMAL).

  CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_MOVABLE
    => mhp_default_online_type = "online_movable"
       Memory will be onlined automatically.
       The zone will be ZONE_MOVABLE.

Default to CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE to match the existing
default CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE=n behavior.

Existing users of CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE=y should use
CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_AUTO.

[gourry@gourry.net: update KConfig comments]
  Link: https://lkml.kernel.org/r/20241226182918.648799-1-gourry@gourry.net
Link: https://lkml.kernel.org/r/20241220210709.300066-1-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 2ebce860bdd7 ("mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  4 +-
 .../admin-guide/mm/memory-hotplug.rst         |  4 +-
 arch/loongarch/configs/loongson3_defconfig    |  5 +-
 drivers/base/memory.c                         |  4 +-
 include/linux/memory_hotplug.h                |  5 +-
 mm/Kconfig                                    | 57 ++++++++++++++++---
 mm/memory_hotplug.c                           | 33 ++++++++---
 7 files changed, 89 insertions(+), 23 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 811345669be4e..be2957b10d0b0 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3362,8 +3362,8 @@
 			[KNL] Set the initial state for the memory hotplug
 			onlining policy. If not specified, the default value is
 			set according to the
-			CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE kernel config
-			option.
+			CONFIG_MHP_DEFAULT_ONLINE_TYPE kernel config
+			options.
 			See Documentation/admin-guide/mm/memory-hotplug.rst.
 
 	memmap=exactmap	[KNL,X86,EARLY] Enable setting of an exact
diff --git a/Documentation/admin-guide/mm/memory-hotplug.rst b/Documentation/admin-guide/mm/memory-hotplug.rst
index cb2c080f400ce..33c886f3d1983 100644
--- a/Documentation/admin-guide/mm/memory-hotplug.rst
+++ b/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -280,8 +280,8 @@ The following files are currently defined:
 		       blocks; configure auto-onlining.
 
 		       The default value depends on the
-		       CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE kernel configuration
-		       option.
+		       CONFIG_MHP_DEFAULT_ONLINE_TYPE kernel configuration
+		       options.
 
 		       See the ``state`` property of memory blocks for details.
 ``block_size_bytes``   read-only: the size in bytes of a memory block.
diff --git a/arch/loongarch/configs/loongson3_defconfig b/arch/loongarch/configs/loongson3_defconfig
index 75b366407a60a..60424d59a4ec5 100644
--- a/arch/loongarch/configs/loongson3_defconfig
+++ b/arch/loongarch/configs/loongson3_defconfig
@@ -99,7 +99,10 @@ CONFIG_ZBUD=y
 CONFIG_ZSMALLOC=m
 # CONFIG_COMPAT_BRK is not set
 CONFIG_MEMORY_HOTPLUG=y
-CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE=y
+# CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE is not set
+CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_AUTO=y
+# CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_KERNEL is not set
+# CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_MOVABLE is not set
 CONFIG_MEMORY_HOTREMOVE=y
 CONFIG_KSM=y
 CONFIG_TRANSPARENT_HUGEPAGE=y
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 2f7e8bab3d10c..354bf9fd857d4 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -512,7 +512,7 @@ static ssize_t auto_online_blocks_show(struct device *dev,
 				       struct device_attribute *attr, char *buf)
 {
 	return sysfs_emit(buf, "%s\n",
-			  online_type_to_str[mhp_default_online_type]);
+			  online_type_to_str[mhp_get_default_online_type()]);
 }
 
 static ssize_t auto_online_blocks_store(struct device *dev,
@@ -524,7 +524,7 @@ static ssize_t auto_online_blocks_store(struct device *dev,
 	if (online_type < 0)
 		return -EINVAL;
 
-	mhp_default_online_type = online_type;
+	mhp_set_default_online_type(online_type);
 	return count;
 }
 
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 99d6ba41ed290..0cbf14756d129 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -144,8 +144,6 @@ extern u64 max_mem_size;
 
 extern int mhp_online_type_from_str(const char *str);
 
-/* Default online_type (MMOP_*) when new memory blocks are added. */
-extern int mhp_default_online_type;
 /* If movable_node boot option specified */
 extern bool movable_node_enabled;
 static inline bool movable_node_is_enabled(void)
@@ -304,6 +302,9 @@ static inline void __remove_memory(u64 start, u64 size) {}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
+/* Default online_type (MMOP_*) when new memory blocks are added. */
+extern int mhp_get_default_online_type(void);
+extern void mhp_set_default_online_type(int online_type);
 extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
 extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
diff --git a/mm/Kconfig b/mm/Kconfig
index 763a9105ee188..620d33330f795 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -550,20 +550,63 @@ menuconfig MEMORY_HOTPLUG
 
 if MEMORY_HOTPLUG
 
-config MEMORY_HOTPLUG_DEFAULT_ONLINE
-	bool "Online the newly added memory blocks by default"
-	depends on MEMORY_HOTPLUG
+choice
+	prompt "Memory Hotplug Default Online Type"
+	default MHP_DEFAULT_ONLINE_TYPE_OFFLINE
 	help
+	  Default memory type for hotplugged memory.
+
 	  This option sets the default policy setting for memory hotplug
 	  onlining policy (/sys/devices/system/memory/auto_online_blocks) which
 	  determines what happens to newly added memory regions. Policy setting
 	  can always be changed at runtime.
+
+	  The default is 'offline'.
+
+	  Select offline to defer onlining to drivers and user policy.
+	  Select auto to let the kernel choose what zones to utilize.
+	  Select online_kernel to generally allow kernel usage of this memory.
+	  Select online_movable to generally disallow kernel usage of this memory.
+
+	  Example kernel usage would be page structs and page tables.
+
 	  See Documentation/admin-guide/mm/memory-hotplug.rst for more information.
 
-	  Say Y here if you want all hot-plugged memory blocks to appear in
-	  'online' state by default.
-	  Say N here if you want the default policy to keep all hot-plugged
-	  memory blocks in 'offline' state.
+config MHP_DEFAULT_ONLINE_TYPE_OFFLINE
+	bool "offline"
+	help
+	  Hotplugged memory will not be onlined by default.
+	  Choose this for systems with drivers and user policy that
+	  handle onlining of hotplug memory policy.
+
+config MHP_DEFAULT_ONLINE_TYPE_ONLINE_AUTO
+	bool "auto"
+	help
+	  Select this if you want the kernel to automatically online
+	  hotplugged memory into the zone it thinks is reasonable.
+	  This memory may be utilized for kernel data.
+
+config MHP_DEFAULT_ONLINE_TYPE_ONLINE_KERNEL
+	bool "kernel"
+	help
+	  Select this if you want the kernel to automatically online
+	  hotplugged memory into a zone capable of being used for kernel
+	  data. This typically means ZONE_NORMAL.
+
+config MHP_DEFAULT_ONLINE_TYPE_ONLINE_MOVABLE
+	bool "movable"
+	help
+	  Select this if you want the kernel to automatically online
+	  hotplug memory into ZONE_MOVABLE. This memory will generally
+	  not be utilized for kernel data.
+
+	  This should only be used when the admin knows sufficient
+	  ZONE_NORMAL memory is available to describe hotplug memory,
+	  otherwise hotplug memory may fail to online. For example,
+	  sufficient kernel-capable memory (ZONE_NORMAL) must be
+	  available to allocate page structs to describe ZONE_MOVABLE.
+
+endchoice
 
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 9479cb19cecf2..6426be4d82995 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -219,11 +219,30 @@ void put_online_mems(void)
 
 bool movable_node_enabled = false;
 
-#ifndef CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE
-int mhp_default_online_type = MMOP_OFFLINE;
-#else
-int mhp_default_online_type = MMOP_ONLINE;
-#endif
+static int mhp_default_online_type = -1;
+int mhp_get_default_online_type(void)
+{
+	if (mhp_default_online_type >= 0)
+		return mhp_default_online_type;
+
+	if (IS_ENABLED(CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE))
+		mhp_default_online_type = MMOP_OFFLINE;
+	else if (IS_ENABLED(CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_AUTO))
+		mhp_default_online_type = MMOP_ONLINE;
+	else if (IS_ENABLED(CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_KERNEL))
+		mhp_default_online_type = MMOP_ONLINE_KERNEL;
+	else if (IS_ENABLED(CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_MOVABLE))
+		mhp_default_online_type = MMOP_ONLINE_MOVABLE;
+	else
+		mhp_default_online_type = MMOP_OFFLINE;
+
+	return mhp_default_online_type;
+}
+
+void mhp_set_default_online_type(int online_type)
+{
+	mhp_default_online_type = online_type;
+}
 
 static int __init setup_memhp_default_state(char *str)
 {
@@ -1321,7 +1340,7 @@ static int check_hotplug_memory_range(u64 start, u64 size)
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_default_online_type;
+	mem->online_type = mhp_get_default_online_type();
 	return device_online(&mem->dev);
 }
 
@@ -1570,7 +1589,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		merge_system_ram_resource(res);
 
 	/* online pages if requested */
-	if (mhp_default_online_type != MMOP_OFFLINE)
+	if (mhp_get_default_online_type() != MMOP_OFFLINE)
 		walk_memory_blocks(start, size, NULL, online_memory_block);
 
 	return ret;
-- 
2.53.0



