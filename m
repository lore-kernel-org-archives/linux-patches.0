Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1DF71727;
	Mon,  8 Apr 2024 13:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581358; cv=none; b=sT9+7thKzjVQP+ITN8orv8h08IOyWHskVWL0jiqrA2NKdileS3lRLBYnedWA7qm4/pC9Fbizh9NisaH6k5ikbkLlt+KThlEmbiEVAwBZ9KA3N0KEiDTUJL+cvcf299px/QO6AH6qo0Y0fPW8uCp0eoh+dh4z3DWL4adKF+U9zqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581358; c=relaxed/simple;
	bh=4DeeosRJhjzIgWBlhJDjYKhTumUMcb6d1ujmg+OtHn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQRqd/Mup4sel+sPlT6aIEeWQnW9/ZydiwhFeGhJ2/DVyIo33Utt5RBUEqaj3MGjWBFfLrw0le86cVqpjmssZFvIK9n2fWH7UaKNYtXZ7oVpwWDF+X4ojYIEwbldWBkA/bSySgK6WetgafQHMFqrQuDGQoF7Bfpw5lNEWFsomKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jw2FBQcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jw2FBQcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC00C43390;
	Mon,  8 Apr 2024 13:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581358;
	bh=4DeeosRJhjzIgWBlhJDjYKhTumUMcb6d1ujmg+OtHn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jw2FBQcF8/4AJqbYd6Y13scfGU/XQV5nbFNMS1sXC8RlcVxOfG8WvnIP741fJMvNB
	 MLoGfS5JPOef7QAFoLSmqN98Iai/32BuX8dzN6u77vzG+AhY0kKHc0Ye8sfy+Dw4lo
	 Ybk3rQqYHTKdR/f9d0fauAfYqoe08CM/KiQO3NkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/690] parisc: Fix csum_ipv6_magic on 64-bit systems
Date: Mon,  8 Apr 2024 14:48:24 +0200
Message-ID: <20240408125400.913686977@linuxfoundation.org>
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



