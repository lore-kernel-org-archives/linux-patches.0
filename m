Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4294A8F5D
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 11:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B371FC433C8;
	Thu, 31 Aug 2023 11:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693480288;
	bh=YJ8kmI3PEOs+rJqt8eCIH+aCvZ8c7XhH2r5TcnX3HCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1HX3fWZt1FANML0ftaamN1FL7dEnd5nAvnntNoBebXND7YH2NHmLi60cq+M6lUIRQ
	 J/vW7WrgHxZA+YOtxD7dRrUqz7BXQ2VwU3A0Sc5prP+O5KukGJ4WzJwx2yrVRS/CdX
	 +XdRRYn99860XNbO7EgaCRIIdmnmA2IQFSk2GaN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Johnston <adam.johnston@arm.com>,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 6.5 3/8] arm64: module: Use module_init_layout_section() to spot init sections
Date: Thu, 31 Aug 2023 13:10:30 +0200
Message-ID: <20230831110830.930595467@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230831110830.817738361@linuxfoundation.org>
References: <20230831110830.817738361@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

commit f928f8b1a2496e7af95b860f9acf553f20f68f16 upstream.

Today module_frob_arch_sections() spots init sections from their
'init' prefix, and uses this to keep the init PLTs separate from the rest.

module_emit_plt_entry() uses within_module_init() to determine if a
location is in the init text or not, but this depends on whether
core code thought this was an init section.

Naturally the logic is different.

module_init_layout_section() groups the init and exit text together if
module unloading is disabled, as the exit code will never run. The result
is kernels with this configuration can't load all their modules because
there are not enough PLTs for the combined init+exit section.

This results in the following:
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

A previous patch exposed module_init_layout_section(), use that so the
logic is the same.

Reported-by: Adam Johnston <adam.johnston@arm.com>
Tested-by: Adam Johnston <adam.johnston@arm.com>
Fixes: 055f23b74b20 ("module: check for exit sections in layout_sections() instead of module_init_section()")
Cc: <stable@vger.kernel.org> # 5.15.x: 60a0aab7463ee69 arm64: module-plts: inline linux/moduleloader.h
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: James Morse <james.morse@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/module-plts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/module-plts.c
+++ b/arch/arm64/kernel/module-plts.c
@@ -339,7 +339,7 @@ int module_frob_arch_sections(Elf_Ehdr *
 		if (nents)
 			sort(rels, nents, sizeof(Elf64_Rela), cmp_rela, NULL);
 
-		if (!str_has_prefix(secstrings + dstsec->sh_name, ".init"))
+		if (!module_init_layout_section(secstrings + dstsec->sh_name))
 			core_plts += count_plts(syms, rels, numrels,
 						sechdrs[i].sh_info, dstsec);
 		else


