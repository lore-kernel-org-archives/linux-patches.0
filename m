Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAEC22FAF8;
	Mon, 10 Mar 2025 17:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629213; cv=none; b=HJUDVd4akhdxolbjBogqgDlhExQqK3lOSqZ+i6MLQnBLwgRSyky6HxZM2zz+AJR1RHfAi1r7ypQNONhGH+F4SlxXYzqC8PfoIDUC7AQnHGEq3Gb1joJTs2JwiEagSqvR9NvXMm1L+IjcTfL9h+WHm+lYUlCrgch57C+dcLtgw5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629213; c=relaxed/simple;
	bh=LFUySeA6dtwrrWD0AcP4cnqIC8VsCQzDtPP8jY/4WDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGbRkp1mMzsLTYEO48SPgYjNcGY8mu/8CeZ/s+dZJ8OAH4qhajSjm73Gm4KjcFFn4eLyPN5KZ/SZJXCPv/0XvkOCpouTB5Zb3hKX5g8dEAxRA1vXoonMu3xfspdJ/NGgGSmvIvcnLTP4yvB7hYAAv4tfzo4yaIP+UdZA9CDz4/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2Bb7qPh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2Bb7qPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82914C4CEE5;
	Mon, 10 Mar 2025 17:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629212;
	bh=LFUySeA6dtwrrWD0AcP4cnqIC8VsCQzDtPP8jY/4WDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2Bb7qPh11P8jLnAv4G6WeQVKbzoOMB2mkjzkdG9iEsK6iVCneKlcMFqncfdYPAWQ
	 JuejBglC5qMnUxtEdEGUP2/JHNbnU4MM1lDxPltVyVT4CXLZCgqSWJj6RKXE1UxM9B
	 VFuJE1fO00RTZYWgpEcyLNyNlCqD7ko9L+m3nU7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Willem de Bruijn <willemb@google.com>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Brian Cain <bcain@quicinc.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 184/620] hexagon: fix using plain integer as NULL pointer warning in cmpxchg
Date: Mon, 10 Mar 2025 18:00:30 +0100
Message-ID: <20250310170552.896325423@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 8a20030038742b9915c6d811a4e6c14b126cafb4 ]

Sparse reports

    net/ipv4/inet_diag.c:1511:17: sparse: sparse: Using plain integer as NULL pointer

Due to this code calling cmpxchg on a non-integer type
struct inet_diag_handler *

    return !cmpxchg((const struct inet_diag_handler**)&inet_diag_table[type],
                    NULL, h) ? 0 : -EEXIST;

While hexagon's cmpxchg assigns an integer value to a variable of this
type.

    __typeof__(*(ptr)) __oldval = 0;

Update this assignment to cast 0 to the correct type.

The original issue is easily reproduced at head with the below block,
and is absent after this change.

    make LLVM=1 ARCH=hexagon defconfig
    make C=1 LLVM=1 ARCH=hexagon net/ipv4/inet_diag.o

Fixes: 99a70aa051d2 ("Hexagon: Add processor and system headers")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202411091538.PGSTqUBi-lkp@intel.com/
Signed-off-by: Willem de Bruijn <willemb@google.com>
Tested-by: Christian Gmeiner <cgmeiner@igalia.com>
Link: https://lore.kernel.org/r/20241203221736.282020-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Brian Cain <bcain@quicinc.com>
Signed-off-by: Brian Cain <brian.cain@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/hexagon/include/asm/cmpxchg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/hexagon/include/asm/cmpxchg.h b/arch/hexagon/include/asm/cmpxchg.h
index cdb705e1496af..72c6e16c3f237 100644
--- a/arch/hexagon/include/asm/cmpxchg.h
+++ b/arch/hexagon/include/asm/cmpxchg.h
@@ -56,7 +56,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
 	__typeof__(ptr) __ptr = (ptr);				\
 	__typeof__(*(ptr)) __old = (old);			\
 	__typeof__(*(ptr)) __new = (new);			\
-	__typeof__(*(ptr)) __oldval = 0;			\
+	__typeof__(*(ptr)) __oldval = (__typeof__(*(ptr))) 0;	\
 								\
 	asm volatile(						\
 		"1:	%0 = memw_locked(%1);\n"		\
-- 
2.39.5



