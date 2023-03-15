Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FC14431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40538C4339E;
	Wed, 15 Mar 2023 12:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882764;
	bh=bX2HSwoutEWnlmIkdwLoa7Vtv3B2ODyKh4ixwKnDa9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOgQTiXkvjev57F8jV4hoiua95+sS4e6jc5aFvCYhEED99kL7NgHeJHHqPj6hySIN
	 C7yi8XblA5wCcOoqS/LFfV0SQjuNZ+GNIFPerHKYoqzG9JikZtxVYv1L+m5HsgKzS9
	 oLmefJMvmJFofNub/fdaa3Bh8F+5SJoAkXGb/IrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H.J. Lu" <hjl.tools@gmail.com>,
	Borislav Petkov <bp@suse.de>,
	Kees Cook <keescook@chromium.org>,
	Tom Saeger <tom.saeger@oracle.com>
Subject: [PATCH 5.4 61/68] x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to generic DISCARDS
Date: Wed, 15 Mar 2023 13:12:55 +0100
Message-Id: <20230315115728.496000966@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "H.J. Lu" <hjl.tools@gmail.com>

commit 84d5f77fc2ee4e010c2c037750e32f06e55224b0 upstream.

In the x86 kernel, .exit.text and .exit.data sections are discarded at
runtime, not by the linker. Add RUNTIME_DISCARD_EXIT to generic DISCARDS
and define it in the x86 kernel linker script to keep them.

The sections are added before the DISCARD directive so document here
only the situation explicitly as this change doesn't have any effect on
the generated kernel. Also, other architectures like ARM64 will use it
too so generalize the approach with the RUNTIME_DISCARD_EXIT define.

 [ bp: Massage and extend commit message. ]

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lkml.kernel.org/r/20200326193021.255002-1-hjl.tools@gmail.com
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/x86/kernel/vmlinux.lds.S     |    2 ++
 include/asm-generic/vmlinux.lds.h |   11 +++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -21,6 +21,8 @@
 #define LOAD_OFFSET __START_KERNEL_map
 #endif
 
+#define RUNTIME_DISCARD_EXIT
+
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -900,10 +900,17 @@
  * section definitions so that such archs put those in earlier section
  * definitions.
  */
+#ifdef RUNTIME_DISCARD_EXIT
+#define EXIT_DISCARDS
+#else
+#define EXIT_DISCARDS							\
+	EXIT_TEXT							\
+	EXIT_DATA
+#endif
+
 #define DISCARDS							\
 	/DISCARD/ : {							\
-	EXIT_TEXT							\
-	EXIT_DATA							\
+	EXIT_DISCARDS							\
 	EXIT_CALL							\
 	*(.discard)							\
 	*(.discard.*)							\


