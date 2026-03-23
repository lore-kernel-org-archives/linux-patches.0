Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571023B8BDA;
	Mon, 23 Mar 2026 15:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278927; cv=none; b=lEmzeUO/tj6n0B6sCxT+hjODpxjAbHb/oHaOCM95iiDo4LcjD4JdjWnn3i7dpIhVhj1x/FIpKGakNnzl6/k3P2s2eWNH36kik3x4uIOmXtVZSjcbLJcYZ8mLhwXNPGdqTQBPDaP7vQqEe6RLc2lHU4YVKkvp9g+quu/HjJQP4tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278927; c=relaxed/simple;
	bh=Ah5UxsNs31Y+aD0M+PltTxBIipUWuCB7qRx0om1Kx6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFk5IwNyB33MxUE5Ut3XRwMWZfY56WH+FyYf6ZA9JXq5OZJqLB2PVOeTeye/d2+PSdxm+rt9AGiXD+aA5XqTxQhnUypMJC+1+9y+WprVXrErbhu78VZnTqAgE2lbZSSnWBInZEYpLWQMPuA/ThA7dhngYcWDOPi2+c+gWegmejk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0y8U2Ht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0y8U2Ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3041C2BCB1;
	Mon, 23 Mar 2026 15:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278927;
	bh=Ah5UxsNs31Y+aD0M+PltTxBIipUWuCB7qRx0om1Kx6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0y8U2Hta8ELfX1pAsfp5EcDyykJcNnmRK0Da/btHvfgXI3sjJJ2ColA6J05ANq8j
	 MB0Vqmq3sAQLHQYkRapvIWdI3Uo4Bi/Lih0cCMga+w3YTlGNMhm2+xXfH/brUngkYb
	 qMbED0fiLzXEvJYskHuSUpttRlu/1BAwbn2c6ano=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Gerlach <lukas.gerlach@cispa.de>,
	Paul Walmsley <pjw@kernel.org>,
	Leon Chen <leonchen.oss@139.com>
Subject: [PATCH 6.6 421/567] riscv: Sanitize syscall table indexing under speculation
Date: Mon, 23 Mar 2026 14:45:41 +0100
Message-ID: <20260323134544.303943009@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Lukas Gerlach <lukas.gerlach@cispa.de>

[ Upstream commit 25fd7ee7bf58ac3ec7be3c9f82ceff153451946c ]

The syscall number is a user-controlled value used to index into the
syscall table. Use array_index_nospec() to clamp this value after the
bounds check to prevent speculative out-of-bounds access and subsequent
data leakage via cache side channels.

Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
Link: https://patch.msgid.link/20251218191332.35849-3-lukas.gerlach@cispa.de
Signed-off-by: Paul Walmsley <pjw@kernel.org>
[ Added linux/nospec.h for array_index_nospec() to make sure compile without error ]
Signed-off-by: Leon Chen <leonchen.oss@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/traps.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -20,6 +20,7 @@
 #include <linux/irq.h>
 #include <linux/kexec.h>
 #include <linux/entry-common.h>
+#include <linux/nospec.h>
 
 #include <asm/asm-prototypes.h>
 #include <asm/bug.h>
@@ -317,8 +318,10 @@ asmlinkage __visible __trap_section void
 
 		syscall = syscall_enter_from_user_mode(regs, syscall);
 
-		if (syscall >= 0 && syscall < NR_syscalls)
+		if (syscall >= 0 && syscall < NR_syscalls) {
+			syscall = array_index_nospec(syscall, NR_syscalls);
 			syscall_handler(regs, syscall);
+		}
 
 		syscall_exit_to_user_mode(regs);
 	} else {


