Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7773B481A6;
	Mon,  8 Apr 2024 13:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581364; cv=none; b=etHV2rN9xGWzzoDrMazebJ+TZuA6KYs9S13ux1NXFSPXWZ4l9TrQXjD7sfGQUwtLXE1NIdQvaLQL+lGK7HbEoo/e027JDVHG8WF3X6y4YH6lWxXYC+OWsZ1zuDRKRbsGgcujCc/S57BcDcO7TqkwnMiDi2A6CDxZBWysZpG2adg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581364; c=relaxed/simple;
	bh=VI1cs2XhB49OL+WaOMwXzMTm0ikFFJRWQB9qEIJ/a14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StAG8q4fcmQPVrlT0CsZTB3+oZDUaA5nbI/4bmxlGWAcH3IvhSVwshDBQ8HAm6/MhlF4izj9gXuaEcBEv1jw0NXpsLjeXRWdUdw9TW4D1Ln0FOboFKqI09k71sCMb8EKIGpsNP0Jsz993SX5PjBTszRy/1u237H2wH05sb23GM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoFgELMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoFgELMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B1EC433F1;
	Mon,  8 Apr 2024 13:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581364;
	bh=VI1cs2XhB49OL+WaOMwXzMTm0ikFFJRWQB9qEIJ/a14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoFgELMn2VdKlmh0lnQWG+i9WGJXFguDPOg/6s4HXyTCEOL1QXKSW5wXTIsNDq/5h
	 thHmBzsd3nyRvSsluBnhaxyDQHyNPYmeg5xQD7dbKmUMFr6eD6s0qm5wJxrX+wrZxO
	 F21a07R2e/UW7YP3FJsbhkZ6XK/CZJFybAFx+bRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/690] parisc: Strip upper 32 bit of sum in csum_ipv6_magic for 64-bit builds
Date: Mon,  8 Apr 2024 14:48:25 +0200
Message-ID: <20240408125400.944066048@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



