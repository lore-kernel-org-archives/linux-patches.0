Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC75325DCFA;
	Tue, 11 Mar 2025 15:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706785; cv=none; b=vGTK5Iqvu+oSinnsWibjXnTQ+66V8IqYdKVBRMgnZH3dyrTWg5KXPoTe6k+7WOPSEOnpuc6xLDkQMKTPVOKLKONEDWN7WlsmvuAmTWenIQv7pLjjGUTxRgaX+NtXOvhwsmgcQCEuYFKI29VUB2/WOC8VUWd09PyO+dKECKmhTn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706785; c=relaxed/simple;
	bh=NQc9Fq4xNvdz6X1421APHv2M2YiTCBAveROSIvAI1wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4kDh3jlxZpVotQ56BdbZKGibJO964uHk0mjZLZhMrV6ulCWQGEX/8Q5+VPDd7hKcoIin3hjfzD5OqvwhIjVSZTurl5Az8VMgpVRjj/tRxWImOwyJdxlBnz1Gcu4uTgWAq1tdn3iM+YaJnZfd6rDmCrSt+yGs8RbtXjTtpyJ97I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFnF3h6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFnF3h6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AEBC4CEE9;
	Tue, 11 Mar 2025 15:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706785;
	bh=NQc9Fq4xNvdz6X1421APHv2M2YiTCBAveROSIvAI1wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFnF3h6aM/CjuPJU2tV2fWQrDabopvGft3vSUbngKGUaMDNGjSETL3WSGrH0xzSiQ
	 d0ov2QLd9fpBWa9RKlPuxKgw6T/BEeMmNV2rQBY9mJkwy4qeuPP6nZWHrlgBmkAGbg
	 3uxcTYTYSaVCu+rQ4396YzEga+z/rbvqd+Ul+Ubc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 5.10 166/462] s390/futex: Fix FUTEX_OP_ANDN implementation
Date: Tue, 11 Mar 2025 15:57:12 +0100
Message-ID: <20250311145804.911991336@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -45,7 +45,7 @@ static inline int arch_futex_atomic_op_i
 		break;
 	case FUTEX_OP_ANDN:
 		__futex_atomic_op("lr %2,%1\nnr %2,%5\n",
-				  ret, oldval, newval, uaddr, oparg);
+				  ret, oldval, newval, uaddr, ~oparg);
 		break;
 	case FUTEX_OP_XOR:
 		__futex_atomic_op("lr %2,%1\nxr %2,%5\n",


