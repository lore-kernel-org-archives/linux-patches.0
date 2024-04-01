Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FE547768;
	Mon,  1 Apr 2024 15:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986720; cv=none; b=Tj/vvOREoR1HDjxZpPJ/EDshlSEI6NT/D3d6zgD/Rq9dRbndWKDUzpeDkzHsHwDF+CxULWincy7swIC2CEwBCeoen7l9TKbFgNqCm0VdOUz57tGsxPLHjo6r3L+tAmzERa3onb5LkDnxXnQp00eHOuWptCl8x1JPSC5E6aKNciw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986720; c=relaxed/simple;
	bh=lICalFs4pka+1CKd75YKDA8FLCiPlMdkLE4rRl6lIgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUtrdRLJikSoU/Qu8ROOjSX0ImStm8zYvWxUUEy+2PWKBJhPkMmi4RubyjajJB/Y43n1ptZOoaWOD9YM2/MAB52bM62QJNa28S2ptiOS+to+V7O4bLs6VjRh2zwvFPep+vOKpuwcwSoHy4sPmynYtbvM9kwV344KsWeKDD5kSoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BFt0ZwLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFt0ZwLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8DEC433C7;
	Mon,  1 Apr 2024 15:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986720;
	bh=lICalFs4pka+1CKd75YKDA8FLCiPlMdkLE4rRl6lIgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BFt0ZwLWtOIfs72x8ve5P9abRsmwXk9koj180p0C0+vQs9JlVQPEyeakj7YNnoz0q
	 cgiHDtRr5zweHAwE9vSjcCBOOfxwTn1Xr2NVZvG06XLIp+oVEe0IX05G9mK+rMXBep
	 VaFKWwfKdv+t0kEvvnsDB673knIIUgqFZhuAdqz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 062/399] parisc: Strip upper 32 bit of sum in csum_ipv6_magic for 64-bit builds
Date: Mon,  1 Apr 2024 17:40:28 +0200
Message-ID: <20240401152551.038731725@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 0568b6f0d863643db2edcc7be31165740c89fa82 ]

IPv6 checksum tests with unaligned addresses on 64-bit builds result
in unexpected failures.

Expected expected == csum_result, but
    expected == 46591 (0xb5ff)
    csum_result == 46381 (0xb52d)
with alignment offset 1

Oddly enough, the problem disappeared after adding test code into
the beginning of csum_ipv6_magic().

As it turns out, the 'sum' parameter of csum_ipv6_magic() is declared as
__wsum, which is a 32-bit variable. However, it is treated as 64-bit
variable in the 64-bit assembler code. Tests showed that the upper 32 bit
of the register used to pass the variable are _not_ cleared when entering
the function. This can result in checksum calculation errors.

Clearing the upper 32 bit of 'sum' as first operation in the assembler
code fixes the problem.

Acked-by: Helge Deller <deller@gmx.de>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/include/asm/checksum.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/parisc/include/asm/checksum.h b/arch/parisc/include/asm/checksum.h
index c949aa20fa162..2aceebcd695c8 100644
--- a/arch/parisc/include/asm/checksum.h
+++ b/arch/parisc/include/asm/checksum.h
@@ -126,6 +126,7 @@ static __inline__ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
 	** Try to keep 4 registers with "live" values ahead of the ALU.
 	*/
 
+"	depdi		0, 31, 32, %0\n"/* clear upper half of incoming checksum */
 "	ldd,ma		8(%1), %4\n"	/* get 1st saddr word */
 "	ldd,ma		8(%2), %5\n"	/* get 1st daddr word */
 "	add		%4, %0, %0\n"
-- 
2.43.0



