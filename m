Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC01140366;
	Thu, 11 Apr 2024 10:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831521; cv=none; b=fQIqyA3MghW4h5HfMAb0+6x8TOgoACfsajz3gpfx93gHTbe03ZZdhmozR+B1b/3dzj+Ly3Hre0csjAdgEcLcJVrGAZnquu26JLW3LMjKahohcRytcCdqam/cwJK0RTf6tn+qp26PUtcbGWtrIMxnULcOmCTUggPWcBMqHj/OfDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831521; c=relaxed/simple;
	bh=KX2txMkPaz6GSzsIAzX7Z4b1Par3jZ8fYeuY6JqKZNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5kzE3VDyYTyPlPV/T1Ihyeeo89YC7qTeydMMDE4fEYh0kxNJukWBGwRYT7DbZoUTyzqwbVMLl6snfHMQetfw+9uxje3/mdJaY2PzlRS6AE76eo2O+nxcWK64l3w4v3UEcUA8lrDa30/Gd39YmpsNoJhwOD74SubqqbtNWjnq8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=daVQcHMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="daVQcHMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC064C433C7;
	Thu, 11 Apr 2024 10:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831521;
	bh=KX2txMkPaz6GSzsIAzX7Z4b1Par3jZ8fYeuY6JqKZNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=daVQcHMKTVUCGniCIvMFv5RDbuq5U9GUl/ivmq1wDJu1guit+aBm1Ep9C7Tzou0OC
	 5r/aXDXBBHhcP1Zl0I3tAjicNorGx0II4FnZVz3t0AgdazBQwW9CsVFY6Ib7gvRF8b
	 PkowqBdGZIDfgAmMdyEZT+MJlnDUU3VKu5bf0+zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/294] parisc: Fix csum_ipv6_magic on 32-bit systems
Date: Thu, 11 Apr 2024 11:53:20 +0200
Message-ID: <20240411095436.754378450@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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



