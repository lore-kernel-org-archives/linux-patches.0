Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111BD8F4B
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 11:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80625C433C7;
	Thu, 31 Aug 2023 11:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693480218;
	bh=k/665bObea8zz87Af+kyQSGm2sJ22nnSd7McNkvqtIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEaji+GiYAohRsYooeS9az3wpsE4Q7ww5Dn0CvVv2kGNr6BxjndDlTXM5wq2RXpi2
	 aBiRujFa7V9euCUEvtXm1NqVNHzKG15Juzu7j6o1Xdr2Vv8dZLNrWlyR4gqw5aO/Sm
	 I+KKWJqiV41TlVzrYHBDlSJ1cThMI6ej5Ha+bK0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Johnston <adam.johnston@arm.com>,
	James Morse <james.morse@arm.com>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 5.10 01/11] module: Expose module_init_layout_section()
Date: Thu, 31 Aug 2023 13:09:53 +0200
Message-ID: <20230831110830.510315541@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230831110830.455765526@linuxfoundation.org>
References: <20230831110830.455765526@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

commit 2abcc4b5a64a65a2d2287ba0be5c2871c1552416 upstream.

module_init_layout_section() choses whether the core module loader
considers a section as init or not. This affects the placement of the
exit section when module unloading is disabled. This code will never run,
so it can be free()d once the module has been initialised.

arm and arm64 need to count the number of PLTs they need before applying
relocations based on the section name. The init PLTs are stored separately
so they can be free()d. arm and arm64 both use within_module_init() to
decide which list of PLTs to use when applying the relocation.

Because within_module_init()'s behaviour changes when module unloading
is disabled, both architecture would need to take this into account when
counting the PLTs.

Today neither architecture does this, meaning when module unloading is
disabled there are insufficient PLTs in the init section to load some
modules, resulting in warnings:
| WARNING: CPU: 2 PID: 51 at arch/arm64/kernel/module-plts.c:99 module_emit_plt_entry+0x184/0x1cc
| Modules linked in: crct10dif_common
| CPU: 2 PID: 51 Comm: modprobe Not tainted 6.5.0-rc4-yocto-standard-dirty #15208
| Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
| pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
| pc : module_emit_plt_entry+0x184/0x1cc
| lr : module_emit_plt_entry+0x94/0x1cc
| sp : ffffffc0803bba60
[...]
| Call trace:
|  module_emit_plt_entry+0x184/0x1cc
|  apply_relocate_add+0x2bc/0x8e4
|  load_module+0xe34/0x1bd4
|  init_module_from_file+0x84/0xc0
|  __arm64_sys_finit_module+0x1b8/0x27c
|  invoke_syscall.constprop.0+0x5c/0x104
|  do_el0_svc+0x58/0x160
|  el0_svc+0x38/0x110
|  el0t_64_sync_handler+0xc0/0xc4
|  el0t_64_sync+0x190/0x194

Instead of duplicating module_init_layout_section()s logic, expose it.

Reported-by: Adam Johnston <adam.johnston@arm.com>
Fixes: 055f23b74b20 ("module: check for exit sections in layout_sections() instead of module_init_section()")
Cc: stable@vger.kernel.org
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/moduleloader.h |    5 +++++
 kernel/module.c              |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/moduleloader.h
+++ b/include/linux/moduleloader.h
@@ -39,6 +39,11 @@ bool module_init_section(const char *nam
  */
 bool module_exit_section(const char *name);
 
+/* Describes whether within_module_init() will consider this an init section
+ * or not. This behaviour changes with CONFIG_MODULE_UNLOAD.
+ */
+bool module_init_layout_section(const char *sname);
+
 /*
  * Apply the given relocation to the (simplified) ELF.  Return -error
  * or 0.
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2280,7 +2280,7 @@ void *__symbol_get(const char *symbol)
 }
 EXPORT_SYMBOL_GPL(__symbol_get);
 
-static bool module_init_layout_section(const char *sname)
+bool module_init_layout_section(const char *sname)
 {
 #ifndef CONFIG_MODULE_UNLOAD
 	if (module_exit_section(sname))


