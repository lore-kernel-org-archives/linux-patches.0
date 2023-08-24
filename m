Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71CC1119B
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270C0C4163C;
	Thu, 24 Aug 2023 14:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888876;
	bh=IT8kB5BnyrDfvarCDq+u4PXJSeWtUWSd8zd3heqFeuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iuagVFtDto6A2beafWwShGWyk3GcJLT1wO2WtBed75bUC3dM38JbhDK9FxWegxaaa
	 07oqaOn1EPzZBfz6VcC59y0Cf92uRGr67SGiJy7zYBON3asDyYLZ6cJ/3OEPx3/Z4G
	 KJ5hRGho/Qge3CMa2BX5+N9S9XrT67QTr9gtXnRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Kees Cook <keescook@chromium.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 073/139] powerpc/rtas_flash: allow user copy to flash block cache objects
Date: Thu, 24 Aug 2023 16:49:56 +0200
Message-ID: <20230824145026.848011744@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Lynch <nathanl@linux.ibm.com>

commit 4f3175979e62de3b929bfa54a0db4b87d36257a7 upstream.

With hardened usercopy enabled (CONFIG_HARDENED_USERCOPY=y), using the
/proc/powerpc/rtas/firmware_update interface to prepare a system
firmware update yields a BUG():

  kernel BUG at mm/usercopy.c:102!
  Oops: Exception in kernel mode, sig: 5 [#1]
  LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
  Modules linked in:
  CPU: 0 PID: 2232 Comm: dd Not tainted 6.5.0-rc3+ #2
  Hardware name: IBM,8408-E8E POWER8E (raw) 0x4b0201 0xf000004 of:IBM,FW860.50 (SV860_146) hv:phyp pSeries
  NIP:  c0000000005991d0 LR: c0000000005991cc CTR: 0000000000000000
  REGS: c0000000148c76a0 TRAP: 0700   Not tainted  (6.5.0-rc3+)
  MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24002242  XER: 0000000c
  CFAR: c0000000001fbd34 IRQMASK: 0
  [ ... GPRs omitted ... ]
  NIP usercopy_abort+0xa0/0xb0
  LR  usercopy_abort+0x9c/0xb0
  Call Trace:
    usercopy_abort+0x9c/0xb0 (unreliable)
    __check_heap_object+0x1b4/0x1d0
    __check_object_size+0x2d0/0x380
    rtas_flash_write+0xe4/0x250
    proc_reg_write+0xfc/0x160
    vfs_write+0xfc/0x4e0
    ksys_write+0x90/0x160
    system_call_exception+0x178/0x320
    system_call_common+0x160/0x2c4

The blocks of the firmware image are copied directly from user memory
to objects allocated from flash_block_cache, so flash_block_cache must
be created using kmem_cache_create_usercopy() to mark it safe for user
access.

Fixes: 6d07d1cd300f ("usercopy: Restrict non-usercopy caches to size 0")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
[mpe: Trim and indent oops]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230810-rtas-flash-vs-hardened-usercopy-v2-1-dcf63793a938@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/rtas_flash.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@ -710,9 +710,9 @@ static int __init rtas_flash_init(void)
 	if (!rtas_validate_flash_data.buf)
 		return -ENOMEM;
 
-	flash_block_cache = kmem_cache_create("rtas_flash_cache",
-					      RTAS_BLK_SIZE, RTAS_BLK_SIZE, 0,
-					      NULL);
+	flash_block_cache = kmem_cache_create_usercopy("rtas_flash_cache",
+						       RTAS_BLK_SIZE, RTAS_BLK_SIZE,
+						       0, 0, RTAS_BLK_SIZE, NULL);
 	if (!flash_block_cache) {
 		printk(KERN_ERR "%s: failed to create block cache\n",
 				__func__);


