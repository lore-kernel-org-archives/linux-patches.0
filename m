Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C2F7FBDD;
	Wed, 21 Feb 2024 14:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524606; cv=none; b=DRMeMQQg7tGS8hHqbmH5OqywiEEra7Iyt7XQATqgkGNq6VW/KwqoKqQhY0zALtaoXMBewuI/TvE1tCHgcKr0hWr4yMn0lFL+ZNxH70hd0zobnGL2MiUIGW8Z1ddMOn2LkizSgM2z3j80r8ADgPVmmsCy1Adgln0ertdpDbxflyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524606; c=relaxed/simple;
	bh=T6vXLnRb+D7QlkzgxKxPLSjTRPZn4vHMRW5S7geoa9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAAZk6mV2YFDsLdNOxPE4/LO3RlkpDZh9t6+KbtkuCCgtUrP1XWKTBjVa9zOx4R2pSSMsi6uhpgIIUdhOQllvumBnC0ZsIKAvDm0F1AYC7OhUvJw1UD/iVmzc/XeO+MO+iNv6zmnbTG9Dm+B/dzy9+UcExr1T71vWCq68PS+bVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TX7XtTEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TX7XtTEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1258CC433C7;
	Wed, 21 Feb 2024 14:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524606;
	bh=T6vXLnRb+D7QlkzgxKxPLSjTRPZn4vHMRW5S7geoa9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TX7XtTEcAXCVps1Xic97JRYQnfcyLqMHbX7juedI81QwymA7KMPtVAfXwVDXoOZCv
	 PrNTINIQ68qSQcahsHniznaNAGKS4mniXnEgXh65xpuXB903OlWoIEx4s01xiqZu5d
	 4vIxpPvTHPXA88nBnNOiP0Y7HuXJKiOaGQwyIrKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 295/379] MIPS: Add memory clobber to csum_ipv6_magic() inline assembler
Date: Wed, 21 Feb 2024 14:07:54 +0100
Message-ID: <20240221130003.637809911@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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
index 5f80c28f5253..6c837a256cf6 100644
--- a/arch/mips/include/asm/checksum.h
+++ b/arch/mips/include/asm/checksum.h
@@ -242,7 +242,8 @@ static __inline__ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
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



