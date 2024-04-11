Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39750148314;
	Thu, 11 Apr 2024 10:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831527; cv=none; b=HIHozJhPcL/kHHlCVGv/R/12tpDT/1OMnCAIUf/pvroVE6+81UpJlc8QTl+ovQh2R9s4WImy7p9M8cJbXEBUDw/sDDQKMhxERm2ND6haLQFLVHCygjQnYfyzlvdLu76ExZCdUrGDN571cMkHryqLPNqv9Kf/P9ua3tTzIbfpiyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831527; c=relaxed/simple;
	bh=01w8cUQ4b47A8Qlqw+NlRFfILh/T7J6Ljcegq/wMCt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9nbZUmw4LzyzN97gPjlzSPf6tOpxdIT/ey0GkBXjgcFV8lndnz8tsPk9nbO++UXyEjBMT8BeIfbikzlD951yzaxkxwxS4HFkn6pAgAtV4vWVPDB8itYK5dXN8iS9N9XO/XCsaRNcQvVrZ/oWIJkn0331sieLQ+8nHxKx9/bK9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I72ieom+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I72ieom+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57C5C433F1;
	Thu, 11 Apr 2024 10:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831527;
	bh=01w8cUQ4b47A8Qlqw+NlRFfILh/T7J6Ljcegq/wMCt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I72ieom++/s0EFjlnsyn9Ap8unetQzCagt1teRwWsy5Di47Em6pIMQLCEujQnqZsn
	 x39hLgezvGNGSUJcQxEh4RqB8V0DOFjkDyXHEKIijmS7z1ARLV7NsdRLhcYIwr15IC
	 ZKW4yhCL7Pl4Z5PEZHtMMLGg18tM5jZ8s2EtEC48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/294] parisc: Fix csum_ipv6_magic on 64-bit systems
Date: Thu, 11 Apr 2024 11:53:21 +0200
Message-ID: <20240411095436.784514560@linuxfoundation.org>
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

[ Upstream commit 4b75b12d70506e31fc02356bbca60f8d5ca012d0 ]

hppa 64-bit systems calculates the IPv6 checksum using 64-bit add
operations. The last add folds protocol and length fields into the 64-bit
result. While unlikely, this operation can overflow. The overflow can be
triggered with a code sequence such as the following.

	/* try to trigger massive overflows */
	memset(tmp_buf, 0xff, sizeof(struct in6_addr));
	csum_result = csum_ipv6_magic((struct in6_addr *)tmp_buf,
				      (struct in6_addr *)tmp_buf,
				      0xffff, 0xff, 0xffffffff);

Fix the problem by adding any overflows from the final add operation into
the calculated checksum. Fortunately, we can do this without additional
cost by replacing the add operation used to fold the checksum into 32 bit
with "add,dc" to add in the missing carry.

Cc: Palmer Dabbelt <palmer@rivosinc.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/include/asm/checksum.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/checksum.h b/arch/parisc/include/asm/checksum.h
index e619e67440db9..c949aa20fa162 100644
--- a/arch/parisc/include/asm/checksum.h
+++ b/arch/parisc/include/asm/checksum.h
@@ -137,8 +137,8 @@ static __inline__ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
 "	add,dc		%3, %0, %0\n"  /* fold in proto+len | carry bit */
 "	extrd,u		%0, 31, 32, %4\n"/* copy upper half down */
 "	depdi		0, 31, 32, %0\n"/* clear upper half */
-"	add		%4, %0, %0\n"	/* fold into 32-bits */
-"	addc		0, %0, %0\n"	/* add carry */
+"	add,dc		%4, %0, %0\n"	/* fold into 32-bits, plus carry */
+"	addc		0, %0, %0\n"	/* add final carry */
 
 #else
 
-- 
2.43.0



