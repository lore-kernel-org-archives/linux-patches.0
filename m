Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9A833063;
	Fri, 24 Nov 2023 18:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOD9MCh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAAEC433C8;
	Fri, 24 Nov 2023 18:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849898;
	bh=1GJFaYuBH2lZha6rNYUwAMzmix2hPcxJ4RnJT7EId9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oOD9MCh9vHLtxGJPZVA1EKvdpMuzEvarrxICgVTTUS6zLjr93pPc2G8YMqF0MQ6Dy
	 7FQhyDDfkHdQ314bBtfr+SdcFe8bBJbaBEglNU1IfcuYq4gglTgaNRBmhOWxHo7A/x
	 K8P8eIQWCnOGK6GjVS629nyTwbpD2eEIIOkanR/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Wolsieffer <ben.wolsieffer@hefring.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 365/530] scripts/gdb/vmalloc: disable on no-MMU
Date: Fri, 24 Nov 2023 17:48:51 +0000
Message-ID: <20231124172039.127207493@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Wolsieffer <ben.wolsieffer@hefring.com>

commit 6620999f0d41e4fd6f047727936a964c3399d249 upstream.

vmap_area does not exist on no-MMU, therefore the GDB scripts fail to
load:

Traceback (most recent call last):
  File "<...>/vmlinux-gdb.py", line 51, in <module>
    import linux.vmalloc
  File "<...>/scripts/gdb/linux/vmalloc.py", line 14, in <module>
    vmap_area_ptr_type = vmap_area_type.get_type().pointer()
                         ^^^^^^^^^^^^^^^^^^^^^^^^^
  File "<...>/scripts/gdb/linux/utils.py", line 28, in get_type
    self._type = gdb.lookup_type(self._name)
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^
gdb.error: No struct type named vmap_area.

To fix this, disable the command and add an informative error message if
CONFIG_MMU is not defined, following the example of lx-slabinfo.

Link: https://lkml.kernel.org/r/20231031202235.2655333-2-ben.wolsieffer@hefring.com
Fixes: 852622bf3616 ("scripts/gdb/vmalloc: add vmallocinfo support")
Signed-off-by: Ben Wolsieffer <ben.wolsieffer@hefring.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gdb/linux/constants.py.in | 1 +
 scripts/gdb/linux/vmalloc.py      | 8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/scripts/gdb/linux/constants.py.in b/scripts/gdb/linux/constants.py.in
index 04c87b570aab..e810e0c27ff1 100644
--- a/scripts/gdb/linux/constants.py.in
+++ b/scripts/gdb/linux/constants.py.in
@@ -158,3 +158,4 @@ LX_CONFIG(CONFIG_STACKDEPOT)
 LX_CONFIG(CONFIG_PAGE_OWNER)
 LX_CONFIG(CONFIG_SLUB_DEBUG)
 LX_CONFIG(CONFIG_SLAB_FREELIST_HARDENED)
+LX_CONFIG(CONFIG_MMU)
diff --git a/scripts/gdb/linux/vmalloc.py b/scripts/gdb/linux/vmalloc.py
index 48e4a4fae7bb..d3c8a0274d1e 100644
--- a/scripts/gdb/linux/vmalloc.py
+++ b/scripts/gdb/linux/vmalloc.py
@@ -10,8 +10,9 @@ import gdb
 import re
 from linux import lists, utils, stackdepot, constants, mm
 
-vmap_area_type = utils.CachedType('struct vmap_area')
-vmap_area_ptr_type = vmap_area_type.get_type().pointer()
+if constants.LX_CONFIG_MMU:
+    vmap_area_type = utils.CachedType('struct vmap_area')
+    vmap_area_ptr_type = vmap_area_type.get_type().pointer()
 
 def is_vmalloc_addr(x):
     pg_ops = mm.page_ops().ops
@@ -25,6 +26,9 @@ class LxVmallocInfo(gdb.Command):
         super(LxVmallocInfo, self).__init__("lx-vmallocinfo", gdb.COMMAND_DATA)
 
     def invoke(self, arg, from_tty):
+        if not constants.LX_CONFIG_MMU:
+            raise gdb.GdbError("Requires MMU support")
+
         vmap_area_list = gdb.parse_and_eval('vmap_area_list')
         for vmap_area in lists.list_for_each_entry(vmap_area_list, vmap_area_ptr_type, "list"):
             if not vmap_area['vm']:
-- 
2.43.0



