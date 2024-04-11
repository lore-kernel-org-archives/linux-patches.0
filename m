Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A097145353;
	Thu, 11 Apr 2024 10:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830644; cv=none; b=Sj3q/rCehFaotWDFtKbVv2akO8CfBgk2JsdkaSJHegGndM65BF6n/fwzHFgo+AmCwXpvNcfL4btbW6VCvnymGHYxG3YcPB2b2JSaUPnGmcKyH1CBmXuHWOJhIJNGLR2XL8HEKxawqg8OxySGBrISTxulHkcv3+Ux138wWerGKX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830644; c=relaxed/simple;
	bh=rbHgf2o/Qv7MEmQco/IQ2KAO3E8e7vi1Gat2GqDxGiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQavr2MvfDjR76Qt1I+5Ga4af2/YqICFQ6NSmg2EWwtoBg0ACzM8fOMZZp+vCaOs9uKdCEA4V0QsdNPj23T0H7MkhSbD30ZgC2h/iKEwnbLxOHjzZTi9zd5ARzySbrt6pGurK45EimnRE/Eee1x4m3FpWTknNYidAeI4oSCsgDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtEJ8Hit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtEJ8Hit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820C4C433F1;
	Thu, 11 Apr 2024 10:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830643;
	bh=rbHgf2o/Qv7MEmQco/IQ2KAO3E8e7vi1Gat2GqDxGiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtEJ8HitLWjZVsJ3ghCiq9vOO2cJZ33/Wdr/uTaVe/UYOG/2q2iJ4AcSkT1fK+FXV
	 nymWLbbhvqi5bhgYZ3/5P7YlSMieLY/PQn4/uXBCzYpGLisTyiH/2oTnUruy20XdNn
	 B8Lwm8w53fkt6Xy2ER/M4Hck2audPC58yzlWJAGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/215] parisc: Fix csum_ipv6_magic on 32-bit systems
Date: Thu, 11 Apr 2024 11:53:59 +0200
Message-ID: <20240411095425.803750394@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7efcd901b9656..0a02639514505 100644
--- a/arch/parisc/include/asm/checksum.h
+++ b/arch/parisc/include/asm/checksum.h
@@ -178,7 +178,8 @@ static __inline__ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
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



