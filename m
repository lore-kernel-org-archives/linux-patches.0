Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D5227E7C6;
	Tue, 27 May 2025 16:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364458; cv=none; b=jQl3wNGn7MHHwa3L+xWa077GZhkyqSFMQtuf7+xhVQleRUxYI2YA4LA0uMZVbQmpZJtw3q3euh6rL3JrH8FsG1AcsbKAem2nFbDJO/KYcsvC+IKcVE0BzSE1njbhjXqGvbuIDc9/9X4aA9auQ2c+Eq0WMosCJ4SyMaWx29kPvvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364458; c=relaxed/simple;
	bh=GbxcF1jH1l3rc7t4oJwaZU18hNO4RzKluFlYXFZwNlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJLQdVpDFU8CaaLE4B7VR+B6YJlXrXzehmOzE8rRmf07iKiu8i2kMTaKCDlIp5B7dlMg2RKDgPcGEmZxvNCW66/De+MkG08H7kwKoRKNJKUcjlPULmMEzhl9qoUyIopF31PNY7FpYiCRIA8Yb9RN+t+2YtH67XmK1Y91UATliKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcRqNZ+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcRqNZ+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39E2C4CEE9;
	Tue, 27 May 2025 16:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364458;
	bh=GbxcF1jH1l3rc7t4oJwaZU18hNO4RzKluFlYXFZwNlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcRqNZ+ZCPKztouMjnVS1gB16PwFXtUECPjBp/gt/3SylPxQUUurkXODV6QA5YqJD
	 O8NwG3R389q2yfK2VhJFEsjPpFfpdrHqeaewCb9WjA8jWPfxvZUZWYpsO+u+83xiz3
	 rJoFfqLmGP8Zb7zizfsKF1h/qL0J8wJdx6kIOUV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Pardee <xi.pardee@intel.com>,
	Todd Brandt <todd.e.brandt@intel.com>,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>,
	"Xin Li (Intel)" <xin@zytor.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Brian Gerst <brgerst@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/626] x86/fred: Fix system hang during S4 resume with FRED enabled
Date: Tue, 27 May 2025 18:18:58 +0200
Message-ID: <20250527162446.891209611@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Xin Li (Intel) <xin@zytor.com>

[ Upstream commit e5f1e8af9c9e151ecd665f6d2e36fb25fec3b110 ]

Upon a wakeup from S4, the restore kernel starts and initializes the
FRED MSRs as needed from its perspective.  It then loads a hibernation
image, including the image kernel, and attempts to load image pages
directly into their original page frames used before hibernation unless
those frames are currently in use.  Once all pages are moved to their
original locations, it jumps to a "trampoline" page in the image kernel.

At this point, the image kernel takes control, but the FRED MSRs still
contain values set by the restore kernel, which may differ from those
set by the image kernel before hibernation.  Therefore, the image kernel
must ensure the FRED MSRs have the same values as before hibernation.
Since these values depend only on the location of the kernel text and
data, they can be recomputed from scratch.

Reported-by: Xi Pardee <xi.pardee@intel.com>
Reported-by: Todd Brandt <todd.e.brandt@intel.com>
Tested-by: Todd Brandt <todd.e.brandt@intel.com>
Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20250401075728.3626147-1-xin@zytor.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/power/cpu.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 63230ff8cf4f0..08e76a5ca1553 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -27,6 +27,7 @@
 #include <asm/mmu_context.h>
 #include <asm/cpu_device_id.h>
 #include <asm/microcode.h>
+#include <asm/fred.h>
 
 #ifdef CONFIG_X86_32
 __visible unsigned long saved_context_ebx;
@@ -231,6 +232,19 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
 	 */
 #ifdef CONFIG_X86_64
 	wrmsrl(MSR_GS_BASE, ctxt->kernelmode_gs_base);
+
+	/*
+	 * Reinitialize FRED to ensure the FRED MSRs contain the same values
+	 * as before hibernation.
+	 *
+	 * Note, the setup of FRED RSPs requires access to percpu data
+	 * structures.  Therefore, FRED reinitialization can only occur after
+	 * the percpu access pointer (i.e., MSR_GS_BASE) is restored.
+	 */
+	if (ctxt->cr4 & X86_CR4_FRED) {
+		cpu_init_fred_exceptions();
+		cpu_init_fred_rsps();
+	}
 #else
 	loadsegment(fs, __KERNEL_PERCPU);
 #endif
-- 
2.39.5



