Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591189;
	b=YmrQgneBBifPzch7lN/Mfn+UIJ97GdDTJ6i2uAZPcxdswKDwG4TU40qLI0FS/fb0m51x
	 KSabiu4zb3O8CQ4X/z18vK31IPXbLmO6ySUVviOsLTWY9c5EMqVWXP1VyzJyT6Vr6xYeP
	 E7MLrN4lSaghbCz0f/A94u26aCQgoucyN8ZRuCh5M/tb3ckxmg2OhO59Jt3BOsvaPiDBx
	 j9HbVBTZOACWDpVxLVxZLt1j4DvoujkuLwNe8h0YBDvBwIyKbacH+zgc9lBPnXEIeMWFv
	 A4aKBX2Pgkwr0rPAGgKD2px0Rkm+ZSzasPO3BSZsm/x1SYnqptncCwB/97UNKnpMTCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kJDdb/Q+uDwkWTsreFdZLP0NTMcm3uA0ua6YO5OeaQg=;
	b=dpCZPg3xzxw+btnOvldwexmTZxLdweQacCZM6X99o0eMLgY5MGvtcSRAFbsGq5I83EvJ
	 UCkSWupQkhiwc5gC0CTxiqkQwGFjJJqgbijzd0uCnUcX72kQMlyLxfBJVrAzO2zYywcOP
	 c6Ga+60BteiTPHosb/8cKWS2HKcFKC3WsSoUxDCHMz+z4aq0xT5FbM80tzPL0sjwtNeh0
	 swzWNpHz5WbfoAu/uu96Ryn4/L1vUr4q6iw+/5NZ/Zv83syaWZXiCXvKAO7ozebCbNI/8
	 bn/FJ0BISel12Htf6TXMDAbOIo0vtzcFUm1mKPhTDUIGc2kKfyKFRNgWB+OfuV9l9Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b9bSWin8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410996075E09;
	Fri, 13 Nov 2026 17:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b9bSWin8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F471F000C5;
	Fri, 13 Nov 2026 17:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591189;
	bh=kJDdb/Q+uDwkWTsreFdZLP0NTMcm3uA0ua6YO5OeaQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b9bSWin8A22tfCji/85Oi9ULnYDRvqaxyICOXC3txiBxdsoqJcg76dVxN+/dSmhsP
	 fvmq8ClAK/LULyuSyJLVr4aHiD4wlk5bx0Hk7Oyiulq50dv2t/4qR18JdcqtLfEqcl
	 leHjpxANA1J6knsGMe5yUNEJHaafltrL1MxfV6gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 325/670] mm/gup: check for overflow when converting nr_pages to bytes in GUP-fast
Date: Fri, 13 Nov 2026 10:48:09 -0500
Message-ID: <20261113153822.900675755@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 21a3888d3d2f87b7f15ccea1f0befd57346fe899 ]

The overflow check in gup_fast_fallback() only covers the addition to
start. The preceding nr_pages << PAGE_SHIFT can already have truncated
the length on 32bit.

Users such as RapidIO's rio_dma_transfer() can derive such page counts
from a 64-bit userspace length.

Let's just check_shl_overflow() to reject any such overflow with
-EOVERFLOW early.

Fixes: c28b1fc70390 ("mm/gup: reorganize internal_get_user_pages_fast()")
Cc: stable@vger.kernel.org
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-22-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index c3df6f7d0bf2c..0e1a0c6c5f213 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3458,8 +3458,8 @@ static int gup_fast_fallback(unsigned long start, unsigned long nr_pages,
 		might_lock_read(&current->mm->mmap_lock);
 
 	start = untagged_addr(start) & PAGE_MASK;
-	len = nr_pages << PAGE_SHIFT;
-	if (check_add_overflow(start, len, &end))
+	if (check_shl_overflow(nr_pages, PAGE_SHIFT, &len) ||
+	    check_add_overflow(start, len, &end))
 		return -EOVERFLOW;
 	if (end > TASK_SIZE_MAX)
 		return -EFAULT;
-- 
2.53.0



