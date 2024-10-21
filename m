Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0D61F4FDD;
	Mon, 21 Oct 2024 10:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507342; cv=none; b=fJJa3R7zC/2GX3IMJh0UUsJv6+TxriTz6wehs31khqmvvYIBvDZdrnD44pINHIEExLDazRC/W6nKhbGTrI8O3AaTSngO7VeZ9vcgoSm5UQ9Wu+bwwBY3jQifcHQvrEPQL+YtroTiarohSJoQRvpW/p4P+0rW952q1WY3BqK0nUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507342; c=relaxed/simple;
	bh=rA/SR38oo462CAfWp8vbLjnWkF3rQSvcBvhtMCH8Fb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVjrQdnuH1yAhiDxzRIoUnq6rXRXmRI/fDh97yHxP2McdQE2zaBy+5Ytdrz6tv+sRNrQIifckvkGKNKl0TjVo+mgPb3/KNtPcbv6CmQp/82TDGbP7KSo/YbWk1KhpyzGs0UaKX0KF15JtheUYvtRku0sFn+2HtrTCf3jw5N9rLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlKoVn2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlKoVn2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1461BC4CEC3;
	Mon, 21 Oct 2024 10:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507342;
	bh=rA/SR38oo462CAfWp8vbLjnWkF3rQSvcBvhtMCH8Fb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zlKoVn2Fe1nBj6d/KuzrdxgSQKtcI0nMPtv27JiBatDLxp1ZLtbegT+69LAEAN7J3
	 JlkD+h9r3Dci2P8zuROXK0S9Og281lTOGkE6Z8BuBJ+Jhqt6riRUMYEQ3SsWtfoE7V
	 vG83ZFAWYlGyrj0sLyUnaRjNuVLsTQSYkCeOxII8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Wikner <kwikner@ethz.ch>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.1 45/91] x86/entry: Have entry_ibpb() invalidate return predictions
Date: Mon, 21 Oct 2024 12:24:59 +0200
Message-ID: <20241021102251.578828357@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


