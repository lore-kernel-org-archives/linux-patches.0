Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4481922C4;
	Wed,  5 Feb 2025 14:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766466; cv=none; b=JTlsrr6mlTgvI/Zsqlm4toVpIv81FksRcA+bCvIFmrvipfzid6yk/pjjgxlxDMuLe3G8zJ7hMIcp5aUhAX6uT8rvpeBYreTkgFtui8q1vc8S6w7HFPHhUjucVj26fIe1TswkYSCZiytS/W7burTmTL26DSVhpdW2LjOtueJsxGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766466; c=relaxed/simple;
	bh=+HEAaJF8Vfn0JysQdJusarpQaXO7hTReiidKIIHz9pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUNhvSBqkrHJfYs4/r5qfQkTevvBEmwWEyKqNeUveKsE+VKp5LGe0DGmB2RRZz3Cv48ViseJmXrXWxh9sEzkkfx1FoVNg5ROcSpO9vlAc+x3Xw2kpCZp0PkqbCHuwn1BwkvVjmgE0zId6CNQK6afFSzisbPcB6k8pBE9xhCJv9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KMrCQYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KMrCQYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79C7C4CED1;
	Wed,  5 Feb 2025 14:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766466;
	bh=+HEAaJF8Vfn0JysQdJusarpQaXO7hTReiidKIIHz9pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2KMrCQYl8DlxkfvevgMoK3qJ/Gtf3vXiZter9WChzpsxbxmy3cB7r7sRvRuCowkxD
	 +Y+ZxzuIVbUaxl+q8L13r5Kz+SAdAJ/3dzH1Lx4aW9nisTvQqSfZOJBgxp8cTRs7W2
	 kjZAz+oxCOL1ye+W9raw//h29Yr5U8l79U1q2Sc4=
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
Subject: [PATCH 6.6 365/393] hexagon: fix using plain integer as NULL pointer warning in cmpxchg
Date: Wed,  5 Feb 2025 14:44:44 +0100
Message-ID: <20250205134434.264582788@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bf6cf5579cf45..9c58fb81f7fd6 100644
--- a/arch/hexagon/include/asm/cmpxchg.h
+++ b/arch/hexagon/include/asm/cmpxchg.h
@@ -56,7 +56,7 @@ __arch_xchg(unsigned long x, volatile void *ptr, int size)
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



