Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A5A14A4E2;
	Tue, 20 Feb 2024 20:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462772; cv=none; b=ITU2EOlLLK7vE6Ck3iyK+YS7tHo86d69oc/eL/4w9rPS8Ob+8OBujA1hagUy79OPJMrsQV7R48Jxieic4L4GzZRf2zbPRhU4cRnOaO7qtYd0Cn1mEP4Y4simaLgP0Aaz+J7aJeTO22Xcwwgnbq5ZhlrCXnNBFgc2ofJEf/wiu6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462772; c=relaxed/simple;
	bh=h80ZGe2dml+7jDi9KGvYp/DGzKXRc9S5f38CjxPhvKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKqbS0IleX94M4UWPjXpMr/t64PMOhcyQ0Yy1A/ak/n6MnDYvVVOvbpwXeVkluZkhshli7478gi9ert9Bzvar/56pWzUs+mnF7F0CKdcRL8GAP6fvXAoZ4qjZb6n7/qysyReOeaVWv4Gw/JSUK4yavISUqXcQAGweprwxX3pn9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XEU7uzAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XEU7uzAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1274FC43390;
	Tue, 20 Feb 2024 20:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462771;
	bh=h80ZGe2dml+7jDi9KGvYp/DGzKXRc9S5f38CjxPhvKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XEU7uzArtIv5bJiFQ4eYFOpuhST5ClOR94V73TSrF6bofiVKiYPpFO2jJ9PwUXGRX
	 FyE3ybRNAwQjroKS+i5Ais9gyDPJ5NuGkS0ZL0e6wJg9G8kN16L55Gtgb3Y5/fsFPY
	 liCwqY+mZyuzhmdiw6o2dhL7n027GCFeNy/CeRPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/197] MIPS: Add memory clobber to csum_ipv6_magic() inline assembler
Date: Tue, 20 Feb 2024 21:49:50 +0100
Message-ID: <20240220204842.011983609@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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



