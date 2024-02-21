Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4B66995F;
	Wed, 21 Feb 2024 13:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521681; cv=none; b=MoR1GJOE/NvBqYJB/racRfp/VC0h5x2v5az5Qy3gOTab+AJfmAIK9gftR+QNrwX/DY5bs5vdK3VcFynYUjBNWkuQ61RZVDjQ+XD2+LHtA226qFhvJz0b1CEyQ/yUW9x0OEio/W9Gv7RWQBDLWtoi5YhL0oXEupaS7Aof25Y84bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521681; c=relaxed/simple;
	bh=mglABByQjoDl4WXumKoHVLhdoYOR+mKWgRLzVaB805M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvFCy/r7DNR+/lhw3tCMpcBjveAVA0ZPGNcQXbtihEG2QskGK10JGmZPXYIDjjmljdNFcTSCEyxSq0/8nivRYgq49vQbfydeTXiARjkMY++23RfDf9ni9Bl6FLuwS0gCA4joMaITy9M1e1WF6SF75udw0nOKtLfXDm1CxlkTxc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lmIyJW12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lmIyJW12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E53C43390;
	Wed, 21 Feb 2024 13:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521681;
	bh=mglABByQjoDl4WXumKoHVLhdoYOR+mKWgRLzVaB805M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lmIyJW124ZOjFF6rqSOt76mykM/3jIcXTGoS/9hBtsg90sE26LCA3qxu/iCLpvBUV
	 5XrzVGwB1xJz8yviL5rlL496BGgFlRycZtehF4rrr/J4ak82ophRjCL1woKfOBEwap
	 QGpZyyWDzTFZC0u1MWNH6JlG10uXoOSOOpqR8SH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 171/202] MIPS: Add memory clobber to csum_ipv6_magic() inline assembler
Date: Wed, 21 Feb 2024 14:07:52 +0100
Message-ID: <20240221125937.289392993@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e8161e4dfde7..4680bac894f6 100644
--- a/arch/mips/include/asm/checksum.h
+++ b/arch/mips/include/asm/checksum.h
@@ -276,7 +276,8 @@ static __inline__ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
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



