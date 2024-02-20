Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD103151CEB;
	Tue, 20 Feb 2024 21:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464547; cv=none; b=Xk4PT8fro+jnU2thc0f5q/UjNhF09N9NO91CLJ28qC6HqYLIJxljT5CujUYDYw8jkuGcHUZb5UIesrSNafs31jGTRTR2I8wUrCAlCdSvz3Up+RgpCynsurs5U3lxbL2uY0IKe84q0nK9zquCZ6fSEjCVjQB8rV2Y7MNgZDC7XZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464547; c=relaxed/simple;
	bh=7kCjagViAHGuv4Bi7oLLaM69uzV57RDzwK/WQxixSPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D65WZLGQeQkIidE01DFe0B32+IyeNYSlg7Hoi8Zz2lC5T6CEDKGLg6UAc+N/03XOfXzLQCFtR5CjSJ+kJB4pP8eWWMHAorDqizn5C4Ewraa1uiekNCrINFS92yHPzQvES/3CYkHurPFcuzpGzYEoJz72U7p2j6j/twoht3EWahE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpYAxVab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpYAxVab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220B1C433F1;
	Tue, 20 Feb 2024 21:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464547;
	bh=7kCjagViAHGuv4Bi7oLLaM69uzV57RDzwK/WQxixSPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpYAxVabgJ1sTqIaIryaa2C8Iu2Q2ClD10dHkop7QfKNu7Gdjz+EpwaYDh+DHqLwz
	 4lq8krFpgJGbYableXQtolZC3kKLfhbSUjOi1KBSUGWpk2dasAbHHlyPan0pg3FzAO
	 3/85CTKWfdAFlGkAgy6mGy4n+y2kfQ6Co/xLzNXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 058/309] MIPS: Add memory clobber to csum_ipv6_magic() inline assembler
Date: Tue, 20 Feb 2024 21:53:37 +0100
Message-ID: <20240220205635.030320014@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit d55347bfe4e66dce2e1e7501e5492f4af3e315f8 ]

After 'lib: checksum: Use aligned accesses for ip_fast_csum and
csum_ipv6_magic tests' was applied, the test_csum_ipv6_magic unit test
started failing for all mips platforms, both little and bit endian.
Oddly enough, adding debug code into test_csum_ipv6_magic() made the
problem disappear.

The gcc manual says:

"The "memory" clobber tells the compiler that the assembly code performs
 memory reads or writes to items other than those listed in the input
 and output operands (for example, accessing the memory pointed to by one
 of the input parameters)
"

This is definitely the case for csum_ipv6_magic(). Indeed, adding the
'memory' clobber fixes the problem.

Cc: Charlie Jenkins <charlie@rivosinc.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/checksum.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/checksum.h b/arch/mips/include/asm/checksum.h
index 4044eaf989ac..0921ddda11a4 100644
--- a/arch/mips/include/asm/checksum.h
+++ b/arch/mips/include/asm/checksum.h
@@ -241,7 +241,8 @@ static __inline__ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
 	"	.set	pop"
 	: "=&r" (sum), "=&r" (tmp)
 	: "r" (saddr), "r" (daddr),
-	  "0" (htonl(len)), "r" (htonl(proto)), "r" (sum));
+	  "0" (htonl(len)), "r" (htonl(proto)), "r" (sum)
+	: "memory");
 
 	return csum_fold(sum);
 }
-- 
2.43.0



