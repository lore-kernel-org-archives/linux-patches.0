Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17FD1E32D7;
	Mon, 21 Oct 2024 10:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506644; cv=none; b=qO7ZOcb9OolNJtFy6xQyTN/leZLMAG4c5zoqxxIxLvDQAsEIEkQsAi8ciVnlsvHaAF1cMzCB1EaUmM8nF/Pmob8AhQQicWMstVX2SteprJfuckzVglzcPcR1uTcy6jAZILP1Bh6pc35scepzouW7PLNUe8LRdMY9XGChADJiF6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506644; c=relaxed/simple;
	bh=+bnnay2PVNqCbDnFsfIEyzoOwAWloHM9fSLqzZw0TzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQJPsdHmCG9qE5k4s+1nAEbU+429dAd1hP8BLy9LjxlSWzFq6R//NTGwG3MVN3o0juu/ucFG18kmVG4iWAr0720BSe+ULgCA7aJKIvE/cm/p3gjlYMekws1SvBEuzsm96Il+dHMup+1AFIMR4vERKE3E+8yI0RcwjVDOAdbF5NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NmAhrZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NmAhrZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7EEC4CEEA;
	Mon, 21 Oct 2024 10:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506643;
	bh=+bnnay2PVNqCbDnFsfIEyzoOwAWloHM9fSLqzZw0TzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NmAhrZIn9IWV/2RxzwAt4+o9uyKSbJgnq9Bmow/cMLIx+n8ZEa2fqoBAXUnyI6JB
	 KE1rDIAnRc29T+zuEin5zgT4SjPissxuDl+U9YQn1buX5UZSqnHEYGxWqx3BIZPz57
	 pwN/XB5MIpzrQ2u9gyy9RGSVCAxxy+93hFb5jkFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Wikner <kwikner@ethz.ch>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.11 043/135] x86/entry: Have entry_ibpb() invalidate return predictions
Date: Mon, 21 Oct 2024 12:23:19 +0200
Message-ID: <20241021102301.017672400@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Wikner <kwikner@ethz.ch>

commit 50e4b3b94090babe8d4bb85c95f0d3e6b07ea86e upstream.

entry_ibpb() should invalidate all indirect predictions, including return
target predictions. Not all IBPB implementations do this, in which case the
fallback is RSB filling.

Prevent SRSO-style hijacks of return predictions following IBPB, as the return
target predictor can be corrupted before the IBPB completes.

  [ bp: Massage. ]

Signed-off-by: Johannes Wikner <kwikner@ethz.ch>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry.S |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -9,6 +9,8 @@
 #include <asm/unwind_hints.h>
 #include <asm/segment.h>
 #include <asm/cache.h>
+#include <asm/cpufeatures.h>
+#include <asm/nospec-branch.h>
 
 #include "calling.h"
 
@@ -19,6 +21,9 @@ SYM_FUNC_START(entry_ibpb)
 	movl	$PRED_CMD_IBPB, %eax
 	xorl	%edx, %edx
 	wrmsr
+
+	/* Make sure IBPB clears return stack preductions too. */
+	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_BUG_IBPB_NO_RET
 	RET
 SYM_FUNC_END(entry_ibpb)
 /* For KVM */


