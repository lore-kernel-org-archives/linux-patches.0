Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4147145B28;
	Thu, 11 Apr 2024 10:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830647; cv=none; b=kJpnxWVA7oM3FAeh57JoHZtWzVCfdgcuW+rjJVZCqDPMdTfbeanRYBbDmmend9fU8flcHQZG++YExJv/vU3qXVgRag9wBBfByPjWDJFNrSWedQiw+myb9X5gwmGWdzgxYDwJOnJm2H3B9M+dJ66gQO+Rd79Biqk6rjwf2gFqUMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830647; c=relaxed/simple;
	bh=hxwqIXXU9m1gg4zy1WgIGQXW8OWiDKmVuQejUBz7JAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G82o1qHnTF3PmIgoyXrkXhrIqi3CSnir1vFLlwGr1UsqsXU1hdHSRJQamwVtNF52u7QuwxMzJbEif3m7EGLmCKdqIRHDiyNrr20T+MoGgqLWLTyOKpNXq0sbby7PW8zEtNU+tnXtS4gVaDNcYj0/pdwqyWgUSrqG2it0NBTHB00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPIDPC9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPIDPC9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715ADC433C7;
	Thu, 11 Apr 2024 10:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830646;
	bh=hxwqIXXU9m1gg4zy1WgIGQXW8OWiDKmVuQejUBz7JAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LPIDPC9ScHbso0GTM/KjAPMUPwAdtKqFogpSHqoBZqxrA2bxG61seoLr52M+s5MKt
	 WPTT8+j9snVX3ECScwwIbgp6fSu4EsArzeyaqiZugzW2vhMch/Fzg5Njo7g2iio8ib
	 qu9SHC3FF+0ouwAiM+c4KejXFPemrYNNw4E1U89Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/215] parisc: Fix csum_ipv6_magic on 64-bit systems
Date: Thu, 11 Apr 2024 11:54:00 +0200
Message-ID: <20240411095425.833621546@linuxfoundation.org>
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
index 0a02639514505..7861d365ba1e2 100644
--- a/arch/parisc/include/asm/checksum.h
+++ b/arch/parisc/include/asm/checksum.h
@@ -152,8 +152,8 @@ static __inline__ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
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



