Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65171C5D77;
	Tue, 11 Mar 2025 15:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705705; cv=none; b=MY1Rh8RTtnc4IxRwgfKSQo0ifOaIoZy79q3fWf4NXfIdWm+yyZA1rH74nBj3lYz/X/ataXIfUWROJvnszfASK4dmYZutM7o0pe3QMD5f6t+2nmMhFoN0CRjEKXhsjQuW8uTf3qPCEcM7JkrqmgrOCOCwiEXGlAEAJegsFKvG85U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705705; c=relaxed/simple;
	bh=EGPr7gPkDBuzuBiix2d7satKbRZ4UW6UmA1mMn9diHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmI/hsEcsZA+hmdoDgPI8WKf96vFS5Q06v3LCXfqreOUyBdkPTg3ACbhB2yfq8NwnhsGOAut2HweS+sfMBZVrjRmwt4mObbSYYMXpEzBGRPQbFPtWBUYLtDV91C7JJl1IhoA+7j48N7HtoNRBTnuPBRG6mq4aeWumsIZ4HCBo/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlA1CW+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlA1CW+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45369C4CEE9;
	Tue, 11 Mar 2025 15:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705705;
	bh=EGPr7gPkDBuzuBiix2d7satKbRZ4UW6UmA1mMn9diHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlA1CW+mEoafJShVcZMKA6LOOw3jz5VKsWQYlJvYCwJLddqBDvSHKujwojknNCCK0
	 g7I4SUbutxHM03HTjCeTVrXDypMhgSTx84aFf+vuEtRoZGhCnQEqcnBcJNv5cwRSfW
	 R6r4h2+2Zb42YQrLWjn7wcyQCk1hOV4qmgQ0rub4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 5.4 119/328] s390/futex: Fix FUTEX_OP_ANDN implementation
Date: Tue, 11 Mar 2025 15:58:09 +0100
Message-ID: <20250311145719.625147729@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit 26701574cee6777f867f89b4a5c667817e1ee0dd upstream.

The futex operation FUTEX_OP_ANDN is supposed to implement

*(int *)UADDR2 &= ~OPARG;

The s390 implementation just implements an AND instead of ANDN.
Add the missing bitwise not operation to oparg to fix this.

This is broken since nearly 19 years, so it looks like user space is
not making use of this operation.

Fixes: 3363fbdd6fb4 ("[PATCH] s390: futex atomic operations")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/futex.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/include/asm/futex.h
+++ b/arch/s390/include/asm/futex.h
@@ -46,7 +46,7 @@ static inline int arch_futex_atomic_op_i
 		break;
 	case FUTEX_OP_ANDN:
 		__futex_atomic_op("lr %2,%1\nnr %2,%5\n",
-				  ret, oldval, newval, uaddr, oparg);
+				  ret, oldval, newval, uaddr, ~oparg);
 		break;
 	case FUTEX_OP_XOR:
 		__futex_atomic_op("lr %2,%1\nxr %2,%5\n",


