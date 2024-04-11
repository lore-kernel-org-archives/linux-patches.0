Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A567213E897;
	Thu, 11 Apr 2024 09:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829554; cv=none; b=nZIt4oPCyhDs6gKUozZYHZ55uDwl/OTPe7L5jAW05uVAj4SB7gfvZ8UjZzOu4lO+vpiI7uC5D+nM8RVQrsWwQ7UIcWE6B1cHu6C/7LyiMQ3hJuCJst5oJuQDPpEQMTUyOxeZ6GOT0ZTDjFDGOEabNLvhTjUWbvZPs/699hn9OlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829554; c=relaxed/simple;
	bh=7hZ/Xv5Ufyp0DQgLOVDIGKfqowU9m3DAVB19Jl7cvZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+XPgXVwtfnN2qbPys4Gz2h0yGC61LLSlNGOCxF3rhoS4L6u+UyUEGtPDumbCBIcu5zKmpIgpmm9HI+J8IaqX/mfMCDKb+WJ4LBh3qvmvFA51ibnwSj7egVRhGVf2aBFMqLuxenx7dG3XRMLE7o8dtX/4xI7VQGJA4dwheW1MUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppIEw9N3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppIEw9N3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F654C433F1;
	Thu, 11 Apr 2024 09:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829554;
	bh=7hZ/Xv5Ufyp0DQgLOVDIGKfqowU9m3DAVB19Jl7cvZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppIEw9N3vmZTEh+LaJ1iv17Zfhtpd5Jm1GZuIhrGuJB/uYwEfp5Uo8E2eQqbK3wLt
	 0l8jzgKUSZOESruMpXA4zviVEbUe6aLS1gdzonIypAEqOxOA/N7Zxc+C21zuNn+QzU
	 OvSxs0R+IOxW9Vbwo00NrkqrRQ/QTMVXguagbarI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 026/175] parisc: Fix ip_fast_csum
Date: Thu, 11 Apr 2024 11:54:09 +0200
Message-ID: <20240411095420.344073768@linuxfoundation.org>
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

[ Upstream commit a2abae8f0b638c31bb9799d9dd847306e0d005bd ]

IP checksum unit tests report the following error when run on hppa/hppa64.

    # test_ip_fast_csum: ASSERTION FAILED at lib/checksum_kunit.c:463
    Expected ( u64)csum_result == ( u64)expected, but
        ( u64)csum_result == 33754 (0x83da)
        ( u64)expected == 10946 (0x2ac2)
    not ok 4 test_ip_fast_csum

0x83da is the expected result if the IP header length is 20 bytes. 0x2ac2
is the expected result if the IP header length is 24 bytes. The test fails
with an IP header length of 24 bytes. It appears that ip_fast_csum()
always returns the checksum for a 20-byte header, no matter how long
the header actually is.

Code analysis shows a suspicious assembler sequence in ip_fast_csum().

 "      addc            %0, %3, %0\n"
 "1:    ldws,ma         4(%1), %3\n"
 "      addib,<         0, %2, 1b\n"	<---

While my understanding of HPPA assembler is limited, it does not seem
to make much sense to subtract 0 from a register and to expect the result
to ever be negative. Subtracting 1 from the length parameter makes more
sense. On top of that, the operation should be repeated if and only if
the result is still > 0, so change the suspicious instruction to
 "      addib,>         -1, %2, 1b\n"

The IP checksum unit test passes after this change.

Cc: Palmer Dabbelt <palmer@rivosinc.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Charlie Jenkins <charlie@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/include/asm/checksum.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/include/asm/checksum.h b/arch/parisc/include/asm/checksum.h
index c1c22819a04d1..7efcd901b9656 100644
--- a/arch/parisc/include/asm/checksum.h
+++ b/arch/parisc/include/asm/checksum.h
@@ -55,7 +55,7 @@ static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
 "	addc		%0, %5, %0\n"
 "	addc		%0, %3, %0\n"
 "1:	ldws,ma		4(%1), %3\n"
-"	addib,<		0, %2, 1b\n"
+"	addib,>		-1, %2, 1b\n"
 "	addc		%0, %3, %0\n"
 "\n"
 "	extru		%0, 31, 16, %4\n"
-- 
2.43.0



