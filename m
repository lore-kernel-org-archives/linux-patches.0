Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F108801;
	Tue, 30 Apr 2024 11:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475996; cv=none; b=WCJyJswQgvi3PZNQg6FAeoarheOEcgOaLdpOdnXz2b/czK4DV6TWzFkB0qizSBS1PBSESfpbeTB0tZ1ip+GDH3pOGMAVg5pkUcyQEjGDUHzb1i2+hosYk8X/u+A1dj+ctionf0VV6727MH4p9x/zNBjN1hL2khtjEuzAOm4aQRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475996; c=relaxed/simple;
	bh=NmZYHTZx8w8n1lw7gyt+oORAniyOPErShui0NfHPtuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzAB/Jbk1syRpJGGY46rXLT04OoVo0RLnBg6a4Loqm6WosBzG35LNvd1IV3BPMDw+l1bNBYwkH0l9hC2N3HK8nIvybicG5Pvo69n16gKQ8EvTgNot/kusn31nTRdyF2F9+D1cOWbD6WUT6oyq/TLx7NDbIhfBKgV83qktskNhIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1U6NqIvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1U6NqIvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2F0C2BBFC;
	Tue, 30 Apr 2024 11:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475995;
	bh=NmZYHTZx8w8n1lw7gyt+oORAniyOPErShui0NfHPtuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1U6NqIvP6bANXz9WWfM6+xmhwh3PzrBuk6AO4leB39Tw99zyYcxkhPpUToAz2lh8p
	 27OeWnFbmXjVnxJT52mZLSxxdqFegOng1OAL+ErTcMNRk08Tre7/bml14XEuNcYmKM
	 nkVrTkwLH3JbQt7jUc4Exak6/fWhV2tGygicDl7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoquan He <bhe@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Eric DeVolder <eric_devolder@yahoo.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 73/80] riscv: fix VMALLOC_START definition
Date: Tue, 30 Apr 2024 12:40:45 +0200
Message-ID: <20240430103045.568157871@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baoquan He <bhe@redhat.com>

[ Upstream commit ac88ff6b9d7dea9f0907c86bdae204dde7d5c0e6 ]

When below config items are set, compiler complained:

--------------------
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_CRASH_DUMP=y
......
-----------------------

-------------------------------------------------------------------
arch/riscv/kernel/crash_core.c: In function 'arch_crash_save_vmcoreinfo':
arch/riscv/kernel/crash_core.c:11:58: warning: format '%lx' expects argument of type 'long unsigned int', but argument 2 has type 'int' [-Wformat=]
11 |         vmcoreinfo_append_str("NUMBER(VMALLOC_START)=0x%lx\n", VMALLOC_START);
   |                                                        ~~^
   |                                                          |
   |                                                          long unsigned int
   |                                                        %x
----------------------------------------------------------------------

This is because on riscv macro VMALLOC_START has different type when
CONFIG_MMU is set or unset.

arch/riscv/include/asm/pgtable.h:
--------------------------------------------------

Changing it to _AC(0, UL) in case CONFIG_MMU=n can fix the warning.

Link: https://lkml.kernel.org/r/ZW7OsX4zQRA3mO4+@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>	# build-tested
Cc: Eric DeVolder <eric_devolder@yahoo.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 6065e736f82c ("riscv: Fix TASK_SIZE on 64-bit NOMMU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 9a3d9b68f2ff4..17e22eb76a815 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -676,7 +676,7 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 #define PAGE_KERNEL		__pgprot(0)
 #define swapper_pg_dir		NULL
 #define TASK_SIZE		0xffffffffUL
-#define VMALLOC_START		0
+#define VMALLOC_START		_AC(0, UL)
 #define VMALLOC_END		TASK_SIZE
 
 #endif /* !CONFIG_MMU */
-- 
2.43.0



