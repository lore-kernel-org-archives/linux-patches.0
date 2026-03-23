Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B94B3B47CF;
	Mon, 23 Mar 2026 15:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278882; cv=none; b=oupd84bfiNCcKZe1+AjR/1wpqGczgssRgOto1Mz+CnDys0rdR3HMXYdzcpdIR4cAPEBv3pILrI74DpnnopmevrI2S4y8DMw4tTM6fQzZqY/Y28jTlPS89AWnHYoPDMHVwOXbt9JkHEp6N09iTmyAPZO8UjDEcJELkCc5azGF7PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278882; c=relaxed/simple;
	bh=gKvYgva7kBjKFzX76M/y3zUEzeNAqnctZfoJGamEBUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0mhEzIS2rGQpXXuwN/nkw3aRG62F3fINE4iv5gMAQ3f5xtNUO5zY7XIfEj8NspZacKbMelgTwsNlbK9BlQT5LK1eqm8T/HupD8OdummHO/RNaT3lVUlEjFzi6MJzQB4iXRLc0vNmuWG7c5M/0xdazGGtEFm8twBd0oo6EaBREI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6aIP5bE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6aIP5bE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80D9C2BC9E;
	Mon, 23 Mar 2026 15:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278882;
	bh=gKvYgva7kBjKFzX76M/y3zUEzeNAqnctZfoJGamEBUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6aIP5bEP4dH4KfKhjatwXTLrLAmV6rHJ8/cMWckZMOB8mrH5vqUdAi+1JwFSJZ3X
	 5NWG0X2G9JUqm6KYmc+RK/68u47AnXQEMZs2s7pn39e9Xqq8TlYdpNmuOUheYBnMWb
	 N5neCMVDIec8XQq63FqTQQAD7fYrgIGvwpGH0uL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.6 448/567] s390/stackleak: Fix __stackleak_poison() inline assembly constraint
Date: Mon, 23 Mar 2026 14:46:08 +0100
Message-ID: <20260323134545.063990731@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

commit 674c5ff0f440a051ebf299d29a4c013133d81a65 upstream.

The __stackleak_poison() inline assembly comes with a "count" operand where
the "d" constraint is used. "count" is used with the exrl instruction and
"d" means that the compiler may allocate any register from 0 to 15.

If the compiler would allocate register 0 then the exrl instruction would
not or the value of "count" into the executed instruction - resulting in a
stackframe which is only partially poisoned.

Use the correct "a" constraint, which excludes register 0 from register
allocation.

Fixes: 2a405f6bb3a5 ("s390/stackleak: provide fast __stackleak_poison() implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20260302133500.1560531-4-hca@linux.ibm.com
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/processor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -146,7 +146,7 @@ static __always_inline void __stackleak_
 		"	j	4f\n"
 		"3:	mvc	8(1,%[addr]),0(%[addr])\n"
 		"4:\n"
-		: [addr] "+&a" (erase_low), [count] "+&d" (count), [tmp] "=&a" (tmp)
+		: [addr] "+&a" (erase_low), [count] "+&a" (count), [tmp] "=&a" (tmp)
 		: [poison] "d" (poison)
 		: "memory", "cc"
 		);


