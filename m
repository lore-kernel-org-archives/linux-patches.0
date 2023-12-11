Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A1FFBE1;
	Mon, 11 Dec 2023 18:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTUDTIWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE550C433C8;
	Mon, 11 Dec 2023 18:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319796;
	bh=iBnSiHaPK0kQzYz1Oqgiay8I4ygWnWuqZyn6ktNb3Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTUDTIWggyIp8Y3fS3fcvdLFbBpkXPflomKomn/K0jucjOdqAP+SjWLo2ZbfK8tS4
	 +q7QNKVGGTVFlDE8ClEdIDVr0+u3DmcBwa6c5RFP+LIVxT4bJSIwAf06bKO9p6Pj7c
	 LBbOfJhF2vXxwRwoL91anKUmU+sukLJbUGTednLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Bo Gan <bo.gan@broadcom.com>,
	Ashwin Dayanand Kamat <ashwin.kamat@broadcom.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 206/244] x86/sev: Fix kernel crash due to late update to read-only ghcb_version
Date: Mon, 11 Dec 2023 19:21:39 +0100
Message-ID: <20231211182055.193449907@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Ashwin Dayanand Kamat <ashwin.kamat@broadcom.com>

[ Upstream commit 27d25348d42161837be08fc63b04a2559d2e781c ]

A write-access violation page fault kernel crash was observed while running
cpuhotplug LTP testcases on SEV-ES enabled systems. The crash was
observed during hotplug, after the CPU was offlined and the process
was migrated to different CPU. setup_ghcb() is called again which
tries to update ghcb_version in sev_es_negotiate_protocol(). Ideally this
is a read_only variable which is initialised during booting.

Trying to write it results in a pagefault:

  BUG: unable to handle page fault for address: ffffffffba556e70
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0003) - permissions violation
  [ ...]
  Call Trace:
   <TASK>
   ? __die_body.cold+0x1a/0x1f
   ? __die+0x2a/0x35
   ? page_fault_oops+0x10c/0x270
   ? setup_ghcb+0x71/0x100
   ? __x86_return_thunk+0x5/0x6
   ? search_exception_tables+0x60/0x70
   ? __x86_return_thunk+0x5/0x6
   ? fixup_exception+0x27/0x320
   ? kernelmode_fixup_or_oops+0xa2/0x120
   ? __bad_area_nosemaphore+0x16a/0x1b0
   ? kernel_exc_vmm_communication+0x60/0xb0
   ? bad_area_nosemaphore+0x16/0x20
   ? do_kern_addr_fault+0x7a/0x90
   ? exc_page_fault+0xbd/0x160
   ? asm_exc_page_fault+0x27/0x30
   ? setup_ghcb+0x71/0x100
   ? setup_ghcb+0xe/0x100
   cpu_init_exception_handling+0x1b9/0x1f0

The fix is to call sev_es_negotiate_protocol() only in the BSP boot phase,
and it only needs to be done once in any case.

[ mingo: Refined the changelog. ]

Fixes: 95d33bfaa3e1 ("x86/sev: Register GHCB memory when SEV-SNP is active")
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Co-developed-by: Bo Gan <bo.gan@broadcom.com>
Signed-off-by: Bo Gan <bo.gan@broadcom.com>
Signed-off-by: Ashwin Dayanand Kamat <ashwin.kamat@broadcom.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/1701254429-18250-1-git-send-email-kashwindayan@vmware.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/sev.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 6395bfd87b68b..d87c6ff1f5136 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1234,10 +1234,6 @@ void setup_ghcb(void)
 	if (!cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
 		return;
 
-	/* First make sure the hypervisor talks a supported protocol. */
-	if (!sev_es_negotiate_protocol())
-		sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SEV_ES_GEN_REQ);
-
 	/*
 	 * Check whether the runtime #VC exception handler is active. It uses
 	 * the per-CPU GHCB page which is set up by sev_es_init_vc_handling().
@@ -1254,6 +1250,13 @@ void setup_ghcb(void)
 		return;
 	}
 
+	/*
+	 * Make sure the hypervisor talks a supported protocol.
+	 * This gets called only in the BSP boot phase.
+	 */
+	if (!sev_es_negotiate_protocol())
+		sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SEV_ES_GEN_REQ);
+
 	/*
 	 * Clear the boot_ghcb. The first exception comes in before the bss
 	 * section is cleared.
-- 
2.42.0



