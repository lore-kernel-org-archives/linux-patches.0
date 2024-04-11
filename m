Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1B01474CD;
	Thu, 11 Apr 2024 10:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831530; cv=none; b=TN6aOpPUPWC6SHxKrnZHcNkVjxG/zO9DG8M+Es9GoAvfeQ1AtmaBZ8SrsduTH5znj9cY7Oyt8lUPBTHn+mZxouL+SU/8D722VWLMBTUtY5YwlRI8suiZcEFQkWcE3oJWIWG/rVyKX4Hnrt6fmesqUc3AMZ+8hI10y4Y6QGDf/PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831530; c=relaxed/simple;
	bh=pR937hVfq8aFr/9uSoQcvLws5Ydqzttl1qfVMe2y318=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQMyHQb6qWbfqgJ9TXF/0EV7T0JwOVEVH56+zelFeTZFKj//WoxCdrUYnv5C/8aR/eRahPgUxQVROpCIIXaTuQQCVnWdCXJBvhIieNRzwTzJWmyGBME5UuGEmhvenyjVm6zXUjkamOKFR5/0QeouYmJBzUoShUlZD0RSU+k7pMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfHu1vjr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfHu1vjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A890AC433C7;
	Thu, 11 Apr 2024 10:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831530;
	bh=pR937hVfq8aFr/9uSoQcvLws5Ydqzttl1qfVMe2y318=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VfHu1vjrpFBy/nfqI2X1STM0LrPqWSBL/AuR0iGIBtjfNSEt9vkNw0THV8QDe8KxW
	 3W/PDIFFpBLvgik7PJWvHE4hzvrAkQR5QcS728OvRSmDKP6V+E1PVdoFryB7lIrCCp
	 Rk8UH0GMGmMj1U8iQ9PXH4c38UDbLVU3k507BNv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/294] parisc: Strip upper 32 bit of sum in csum_ipv6_magic for 64-bit builds
Date: Thu, 11 Apr 2024 11:53:22 +0200
Message-ID: <20240411095436.815532373@linuxfoundation.org>
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



