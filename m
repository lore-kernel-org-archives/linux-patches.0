Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FEEBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB2EC433D2;
	Tue,  7 Mar 2023 18:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214456;
	bh=vU9G4G+Llss0uSFhzJX5rkdwUweQyaXWZsSvTMpTHb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQAS6zb54nzYxSl7QTfErnef2soeaD/7+MB2xnIaQ2ERJOSk4oHyA3n9Oi/LglCf4
	 mOLvPKg4lKhXEg76TDzTQD4JSyIFdVw1pgRjCcfyoHiT7lW51939J/wKNQK37NPFmu
	 w7+8ZuPR/jQr7tfNhOZe/TRElyedL/c6lSE2DWlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dmitry V. Levin" <ldv@strace.io>,
	Elvira Khabirova <lineprinter0@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 827/885] mips: fix syscall_get_nr
Date: Tue,  7 Mar 2023 18:02:41 +0100
Message-Id: <20230307170037.793144056@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Elvira Khabirova <lineprinter0@gmail.com>

commit 85cc91e2ba4262a602ec65e2b76c4391a9e60d3d upstream.

The implementation of syscall_get_nr on mips used to ignore the task
argument and return the syscall number of the calling thread instead of
the target thread.

The bug was exposed to user space by commit 201766a20e30f ("ptrace: add
PTRACE_GET_SYSCALL_INFO request") and detected by strace test suite.

Link: https://github.com/strace/strace/issues/235
Fixes: c2d9f1775731 ("MIPS: Fix syscall_get_nr for the syscall exit tracing.")
Cc: <stable@vger.kernel.org> # v3.19+
Co-developed-by: Dmitry V. Levin <ldv@strace.io>
Signed-off-by: Dmitry V. Levin <ldv@strace.io>
Signed-off-by: Elvira Khabirova <lineprinter0@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/syscall.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/syscall.h
+++ b/arch/mips/include/asm/syscall.h
@@ -38,7 +38,7 @@ static inline bool mips_syscall_is_indir
 static inline long syscall_get_nr(struct task_struct *task,
 				  struct pt_regs *regs)
 {
-	return current_thread_info()->syscall;
+	return task_thread_info(task)->syscall;
 }
 
 static inline void mips_syscall_update_nr(struct task_struct *task,


