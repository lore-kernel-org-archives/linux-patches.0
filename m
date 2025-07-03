Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E7E2F0E3B;
	Thu,  3 Jul 2025 15:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555406; cv=none; b=psV7XxnFWuWgNfdg2ehERehCCjlCEMnsmbasY5TM6OE7Vn0o9KWN/T0Feux9BH7jwOGQgaa9p6EfifIr4G+29yYwZXqw6xxLmkTmqfUlSlo6bNiQpfC0JXghUAzk1pQuttOVTtTrh7Vzqu/HTY8W3+H4D+wYd6MkePPXx9lo6SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555406; c=relaxed/simple;
	bh=yciM341p9PUUprAugzs4IABXjibDKAP15QMyuau51v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eo0RoI0PiiEVoMYCUuwfPnc05aAdpFWQ3hqB4O/dsn9vDFbEsZpw8/H6H6FMqQOaIDIFRiKuJMDm3C6stAARKyoGH9FVlI/OUjgaNxu+lGmqkNOnUq/9tVq6zWfJR9lPuBC/i4Om+nd8mXPG9FfQbMWVesd4YupmYKonjqGbSts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yngGJ2xu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yngGJ2xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF55C4CEE3;
	Thu,  3 Jul 2025 15:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555405;
	bh=yciM341p9PUUprAugzs4IABXjibDKAP15QMyuau51v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yngGJ2xuidEieI0LU1L+7PnO7GvcsHrYTeYMvhXjkIRGM771lbTlIgW1+yMNXWxUC
	 YcRVawrmK9/c/MAxqWBs+jS0AwGAnsJvMyz8v0M3ZZ7oI4sEozKf4LPTKLZkwJGRBO
	 ZOt/LY33QPtnJ12Qti+hAk/CbU66DttFFgti5OYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.15 260/263] s390/ptrace: Fix pointer dereferencing in regs_get_kernel_stack_nth()
Date: Thu,  3 Jul 2025 16:43:00 +0200
Message-ID: <20250703144014.841721780@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit 7f8073cfb04a97842fe891ca50dad60afd1e3121 upstream.

The recent change which added READ_ONCE_NOCHECK() to read the nth entry
from the kernel stack incorrectly dropped dereferencing of the stack
pointer in order to read the requested entry.

In result the address of the entry is returned instead of its content.

Dereference the pointer again to fix this.

Reported-by: Will Deacon <will@kernel.org>
Closes: https://lore.kernel.org/r/20250612163331.GA13384@willie-the-truck
Fixes: d93a855c31b7 ("s390/ptrace: Avoid KASAN false positives in regs_get_kernel_stack_nth()")
Cc: stable@vger.kernel.org
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -1574,5 +1574,5 @@ unsigned long regs_get_kernel_stack_nth(
 	addr = kernel_stack_pointer(regs) + n * sizeof(long);
 	if (!regs_within_kernel_stack(regs, addr))
 		return 0;
-	return READ_ONCE_NOCHECK(addr);
+	return READ_ONCE_NOCHECK(*(unsigned long *)addr);
 }


