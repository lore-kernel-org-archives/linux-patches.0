Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B96145353;
	Thu, 11 Apr 2024 10:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830721; cv=none; b=E85vhYoAvxYprvrMKe8M9RM2tbRvC8wo5TiPQpuxUM/b7NTcDHxtg+LUW1sRaGt+W2/TupGIVzUmzqz4CbISOWLYyIVFdH64UKByRAz/cSZ9DRlfuHX+pLscKk/gSx9xiMxUou0dgeO3XUkTOzIhq4YEKM+/qyPTiaxX0vcBj50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830721; c=relaxed/simple;
	bh=qv0ZI7+yUeos5hL4LI7AockFKpe2lokfWGpjwzc2bxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSd7SPnVBJcwYY81UkKZnB13dWsgEGqHdVwrkisPU5RJLtHRxELB86dqNrkge1bneJZtjjNMIb3i26YNIivCnIwv7huPsc6gdnw7O427/qmDBK8rlvYL/HGCpppzACQgJD9/U8FyGABKMNrM+AOQeBu/ISMvzBoeQlA0TfPYKdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBfBQ5FP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBfBQ5FP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFFAC433F1;
	Thu, 11 Apr 2024 10:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830721;
	bh=qv0ZI7+yUeos5hL4LI7AockFKpe2lokfWGpjwzc2bxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBfBQ5FPi5y8M8PZIXYrBoAv1EpnyIZ9sziugE+YIxrhJBh/cUxhidj7Yqfvm4PI9
	 uc2tv+UgohB11CNEazE0Wf45IRmgoUjIK210IrzCc0mYgb1ZQ/DTdcww7tiSp3v0zE
	 D8xTJaG4NWGk0Nis+AXCbjCqv81uOMQ9+OymmFRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"x86@kernel.org, linux-kernel@vger.kernel.org, sashal@kernel.org, Rui Qi" <qirui.001@bytedance.com>,
	Rui Qi <qirui.001@bytedance.com>
Subject: [PATCH 5.4 094/215] x86/speculation: Support intra-function call validation
Date: Thu, 11 Apr 2024 11:55:03 +0200
Message-ID: <20240411095427.725841640@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rui Qi <qirui.001@bytedance.com>

commit 8afd1c7da2b0 ("x86/speculation: Change FILL_RETURN_BUFFER
 to work with objtool") does not support intra-function call
 stack validation, which causes kernel live patching to fail.
This commit adds support for this, and after testing, the kernel
 live patching feature is restored to normal.

Fixes: 8afd1c7da2b0 ("x86/speculation: Change FILL_RETURN_BUFFER to work with objtool")
Cc: <stable@vger.kernel.org> # v5.4.250+
Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    7 +++++++
 arch/x86/include/asm/unwind_hints.h  |    2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -13,6 +13,8 @@
 #include <asm/unwind_hints.h>
 #include <asm/percpu.h>
 
+#include <linux/frame.h>
+#include <asm/unwind_hints.h>
 /*
  * This should be used immediately before a retpoline alternative. It tells
  * objtool where the retpolines are so that it can make sense of the control
@@ -51,14 +53,18 @@
 #define __FILL_RETURN_BUFFER(reg, nr, sp)	\
 	mov	$(nr/2), reg;			\
 771:						\
+	ANNOTATE_INTRA_FUNCTION_CALL;           \
 	call	772f;				\
 773:	/* speculation trap */			\
+	UNWIND_HINT_EMPTY;		\
 	pause;					\
 	lfence;					\
 	jmp	773b;				\
 772:						\
+	ANNOTATE_INTRA_FUNCTION_CALL;           \
 	call	774f;				\
 775:	/* speculation trap */			\
+	UNWIND_HINT_EMPTY;                      \
 	pause;					\
 	lfence;					\
 	jmp	775b;				\
@@ -152,6 +158,7 @@
 .endm
 
 .macro ISSUE_UNBALANCED_RET_GUARD
+	ANNOTATE_INTRA_FUNCTION_CALL;
 	call .Lunbalanced_ret_guard_\@
 	int3
 .Lunbalanced_ret_guard_\@:
--- a/arch/x86/include/asm/unwind_hints.h
+++ b/arch/x86/include/asm/unwind_hints.h
@@ -101,7 +101,7 @@
 	".popsection\n\t"
 
 #define UNWIND_HINT_SAVE UNWIND_HINT(0, 0, UNWIND_HINT_TYPE_SAVE, 0)
-
+#define UNWIND_HINT_EMPTY
 #define UNWIND_HINT_RESTORE UNWIND_HINT(0, 0, UNWIND_HINT_TYPE_RESTORE, 0)
 
 #endif /* __ASSEMBLY__ */


