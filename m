Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD43C1F941B;
	Mon, 21 Oct 2024 10:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507786; cv=none; b=lLYhWX4S1h2Gu1rNoMQN1eQEgJqQC0S/HR+UWMItD5+IKZgWbn3uzrCLOtCLrFS6VcT6edJyBZyhcHibvNT6W6MJjrrKw1mHei0r946P91uF+jYgF9Q6kB3ZNmb9CchQ8xHxIAvIjgB3Z6z6J4ImJ1NimhIla3IN8cLRbfnr+tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507786; c=relaxed/simple;
	bh=+wH1MyFEyFPqEKiRhNuZh3xbfRAazDi7Wf2QrPgdkiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVsfaO+69HK9V9Xa7moaSH9dTc15aLc3DPe24efszf3it09PeptkW3a1GDkfqNjy9h1X+KKjMnlT2NDk6E4xKZjYXzd+8IFMQTjEGJz4GFS4mgS5ESY9PXnPMc2yPZ8vu4SeyfuPh9CrY7P6ZzsM6WNqhPXi8zOBX0Uf7j1XSsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvmy8skI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvmy8skI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB68C4CEC3;
	Mon, 21 Oct 2024 10:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507786;
	bh=+wH1MyFEyFPqEKiRhNuZh3xbfRAazDi7Wf2QrPgdkiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvmy8skId69V7TdlL/WmoFwub1Ve5n4gIc9ZvdYCHts8DwTqXcKwwj1tUYBJE/23V
	 /VgxFiF14eV4NvGakOE24BiO/MgdhAzZx7MXphuftksicggoXN0uw82lfWdwd/GPKb
	 BOElm3jLJYqmcLiDoRYkp2+q4ZSIXLOeg+jqsyp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Wikner <kwikner@ethz.ch>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 5.10 19/52] x86/entry: Have entry_ibpb() invalidate return predictions
Date: Mon, 21 Oct 2024 12:25:40 +0200
Message-ID: <20241021102242.378149241@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 
 .pushsection .noinstr.text, "ax"
 
@@ -17,6 +19,9 @@ SYM_FUNC_START(entry_ibpb)
 	movl	$PRED_CMD_IBPB, %eax
 	xorl	%edx, %edx
 	wrmsr
+
+	/* Make sure IBPB clears return stack preductions too. */
+	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_BUG_IBPB_NO_RET
 	RET
 SYM_FUNC_END(entry_ibpb)
 /* For KVM */


