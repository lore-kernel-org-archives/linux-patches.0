Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6331448EF;
	Thu, 11 Apr 2024 09:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829563; cv=none; b=Y7aDm/hJebkHcquxoJ1fMXkGDwSJzdD2WqL41kq4G8MakwVFlc3G49hgEyLPPSJIzA5TuFSBDkVbZ8aalSFAFAIfhCnnhNObsisTNufK8ZmtKwhfE3NpKZ9o3I2iqXb6nNMPzPqGu6GNC0Mn2Uq5KcsTUAubAAKm+2QIPlQr0YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829563; c=relaxed/simple;
	bh=Pbqd50hhva8+5ICKiCHVXhxbsBpXIl8osTcmOuFOyfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mk9/pEfiVaG1j6tTVM4BSPDmfTAIYbrIUm1wpOZumABkUPGXErOVEW+YO2SUyXLUeEUG61SfLipq6uTY2KnuoFQ9lMsPlsTgqNIlvoZjgM48EZxULZC5bGX/PPX3iOCYZ+uPVDxHsfh6a9b66ZHhnVS1blh6gMOWX12rwl9X4QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LK4KOLit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LK4KOLit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EB1C433F1;
	Thu, 11 Apr 2024 09:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829563;
	bh=Pbqd50hhva8+5ICKiCHVXhxbsBpXIl8osTcmOuFOyfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LK4KOLitVo2aHWQBoX8O+3S6gxuTPizfRX6lvxAfcWYvqJ48bOYukSDNYfVPrkigq
	 Aezl/trXva/WrGIRBX+D3X1VVWzzpBy7jwQYX/NaQmXmudCsJCdTvOrsmv92ZEZOWZ
	 AjLiJBrTCnWMyJtSQhQEXe7TWORgGOPXdOiOBXiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 029/175] parisc: Strip upper 32 bit of sum in csum_ipv6_magic for 64-bit builds
Date: Thu, 11 Apr 2024 11:54:12 +0200
Message-ID: <20240411095420.434283088@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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
index 7861d365ba1e2..ef34e8f839d55 100644
--- a/arch/parisc/include/asm/checksum.h
+++ b/arch/parisc/include/asm/checksum.h
@@ -141,6 +141,7 @@ static __inline__ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
 	** Try to keep 4 registers with "live" values ahead of the ALU.
 	*/
 
+"	depdi		0, 31, 32, %0\n"/* clear upper half of incoming checksum */
 "	ldd,ma		8(%1), %4\n"	/* get 1st saddr word */
 "	ldd,ma		8(%2), %5\n"	/* get 1st daddr word */
 "	add		%4, %0, %0\n"
-- 
2.43.0



