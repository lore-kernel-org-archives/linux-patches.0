Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849AABA3F;
	Mon,  1 Apr 2024 16:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990726; cv=none; b=kQv3/rbgK39XNXvshR0HwEgE+kbtSsN7wm0jalvzzXHi2FTE4qQXBcLl+lp6pjD2uLpRJ27kQwSnmpWKmVaGMVvr/jKtobNEF00/DNz55vmdFe+of53s2f9yOSHRhutRRlTuZTmU7hbZOjqc8COPwYljlFHk8Lkz2uispYOa53M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990726; c=relaxed/simple;
	bh=wHT0UBiQ7ZHGlHGXzw7fGqbJvE0qfpNLB3mFNN0FfjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hK8iz8lTRFY2X33R69l8OEOL9cOP5bEXyMNLxHs68uDy85CtjKuClAGLeTCBGBdicaQQ+zUEFdeg3nLdN71jmf9ZQjR6C+lxsOppFoobxB/5G4yjkiRXKdofODeLSmWWTgNIUT6M8rIAS2u6CTsDaaUgjaYR7WGg/1DPUya4MYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqglqdcn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqglqdcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1ABC433C7;
	Mon,  1 Apr 2024 16:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990726;
	bh=wHT0UBiQ7ZHGlHGXzw7fGqbJvE0qfpNLB3mFNN0FfjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqglqdcnByGFrWr8Ig/WkuxkM1Z5xuMxpXQJ6xwmGvkuK1cpeWPDsG6RNq7/pBz2F
	 dPJA762U0Am+xb7HtpiQiwxfnkppU0BNr61l+qf+CLFsOuzNWFo4lMujqTqGsWbCPB
	 vEcVH1CmuNKYmUKteJEbrLlxoR0/rDYCBM9u6RrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/272] parisc: Fix csum_ipv6_magic on 32-bit systems
Date: Mon,  1 Apr 2024 17:43:57 +0200
Message-ID: <20240401152531.867449843@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 4408ba75e4ba80c91fde7e10bccccf388f5c09be ]

Calculating the IPv6 checksum on 32-bit systems missed overflows when
adding the proto+len fields into the checksum. This results in the
following unit test failure.

    # test_csum_ipv6_magic: ASSERTION FAILED at lib/checksum_kunit.c:506
    Expected ( u64)csum_result == ( u64)expected, but
        ( u64)csum_result == 46722 (0xb682)
        ( u64)expected == 46721 (0xb681)
    not ok 5 test_csum_ipv6_magic

This is probably rarely seen in the real world because proto+len are
usually small values which will rarely result in overflows when calculating
the checksum. However, the unit test code uses large values for the length
field, causing the test to fail.

Fix the problem by adding the missing carry into the final checksum.

Cc: Palmer Dabbelt <palmer@rivosinc.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Charlie Jenkins <charlie@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/include/asm/checksum.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/parisc/include/asm/checksum.h b/arch/parisc/include/asm/checksum.h
index f705e5dd10742..e619e67440db9 100644
--- a/arch/parisc/include/asm/checksum.h
+++ b/arch/parisc/include/asm/checksum.h
@@ -163,7 +163,8 @@ static __inline__ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
 "	ldw,ma		4(%2), %7\n"	/* 4th daddr */
 "	addc		%6, %0, %0\n"
 "	addc		%7, %0, %0\n"
-"	addc		%3, %0, %0\n"	/* fold in proto+len, catch carry */
+"	addc		%3, %0, %0\n"	/* fold in proto+len */
+"	addc		0, %0, %0\n"	/* add carry */
 
 #endif
 	: "=r" (sum), "=r" (saddr), "=r" (daddr), "=r" (len),
-- 
2.43.0



