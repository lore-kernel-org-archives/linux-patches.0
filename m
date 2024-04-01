Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B101BA3F;
	Mon,  1 Apr 2024 16:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990729; cv=none; b=mFucl2csgebadPmw+l1Qp3SF1jsPB4yRoT4RiIP9nNnzNkVernOVjMw/s5h2m8FHeHIQZ1DyqlDE7LRpLSVUT/NHj/vhydEd88CKCqHLbIkR++PpLO85tbWba/r3nYpT/2QL9V6CKxijz8czPZkoJB/FfkovAQap2KDCpRFm21s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990729; c=relaxed/simple;
	bh=b9y8DvWUhCGWyd7xnJPEh/IvY6DBHD/o6U26W453WnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxRWMoA7B9HIpJRhvvvzILcQwjWBi/703VhOaVb0HRo5N6ASx3s4NRDZVDClGwiusWmJe4/BRi8HR26NuV98uDolfozy4OCC3BXKY5e1GKXAoZ7MwP0eaRzW3mMw3vHy8GYRs0gVJiuvoqsfJMURYSOEa0zQSPo2NlrEcdWsY9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcBF6/5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcBF6/5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FF9C433F1;
	Mon,  1 Apr 2024 16:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990729;
	bh=b9y8DvWUhCGWyd7xnJPEh/IvY6DBHD/o6U26W453WnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcBF6/5lHWaPHg632/3ZNvm3LmjxJ6Q/c6jWEwlS6KZN4ry+TFUFiBLIvptCMCdLr
	 8UJk6fgoiyoVpPAQ5ew94DqQ7nCBS0QSTS1l6akHo76Z9dtrmdyVBrb65UtbgyCXiQ
	 JtYi8kaaG2Is+u15NmyuuJGCpOsuPoKq4HcdrlIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/272] parisc: Fix csum_ipv6_magic on 64-bit systems
Date: Mon,  1 Apr 2024 17:43:58 +0200
Message-ID: <20240401152531.902220129@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



