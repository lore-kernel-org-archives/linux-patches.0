Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85017612D7;
	Tue, 20 Feb 2024 21:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463460; cv=none; b=YgPLVHzShBY2lBKQOJVQwqoOQEVV30KqIQqxQP2cfMaWKIR81O3yUT1hym4E1wnROTCya59PnQ5IKO/PRZjfEktNGvypCzrW0FoiuuMV0KAbnVjZtZLlcmrjdCw/nqPbcuFdS9KF12872FeiHXI35c/zkLoKrB3Om9XR/bkk4Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463460; c=relaxed/simple;
	bh=xhM5anRfP7dD521WvHA99qrumrDCIuZ9pGcV8enRO5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFRyxvWM510SsxW6JyCSg05C6OwCeh1dBWrYFVaPBHBs7i3g/OmwCqfhjc3UiVmkv3EUvadw927fGpsyurUdhbcY/LdF2rGRy73Ec/2iyEIu1iTja8XCfXfL9m0Nym4p06dlxzmBAHVD5fuYlPLK6jhJA5nVRkh7kPwE4VKyA6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmpbtXTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmpbtXTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E386C433F1;
	Tue, 20 Feb 2024 21:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463460;
	bh=xhM5anRfP7dD521WvHA99qrumrDCIuZ9pGcV8enRO5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmpbtXTYn5zcFYAqHu2FE78b35zlrAlAp+yEBpTgf+MTPIYRXzBxLg/3CtZPaGfVT
	 qeZKebk3XWYE08XAlJaCDnBYd7BSpmFjEMPr3Zvj/zztK3iXs2HtQLlcExn5/pTpy8
	 uYH2VitI6VDL41JyceRgJP/qQxhyjhkRg6RwY7gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/331] MIPS: Add memory clobber to csum_ipv6_magic() inline assembler
Date: Tue, 20 Feb 2024 21:52:46 +0100
Message-ID: <20240220205639.170426302@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



