Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037909;
	b=axXg3WW0Glu+1ZuyJpds3NCvyGSGKFn/bjVum/P97BhQEGv7POgtgnIcNvJhMoDd/U/d
	 GNw2C6SVzjBP4P3KQbawOgKO/qygGL43oCL2VyCFzIASpRRQ59Ssv3rQXdmZYJjboqG0O
	 ZWb0pO0nmU3TziIfo49mspv4RxKUsWX4sqqTEHJTmOZyadTKiZPlA2QEivY4gtv/WzCcW
	 iCjdTH/SO/6UUOuF3Quzm56HYspEnxTZSZJxoT18KBj9OuEbbykvBFPZLQe4NfT042aHR
	 bwhBPRf2/wwyO7Rl2G6yP4Xphqa+R9IsjK4/CdKUlmHKLkk9wGOXkp6bPkn7ItnC81A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=elFAHpjdtyEfO1nu4w2DVnste7XInYL4w5ifgQa4OZ4=;
	b=eqwgcnK00NdrA6fT2AakQrOKBFnQ8mXC5P+wr7mV02NmakABE3/F+L2qriZDBcyoC209
	 8fL8A788Mh0ovZ2MG7vGvSOjIolfkRAtXwuFgG6PNGanEzap3dmOOfST5z3SDMRyoZF8l
	 rpauXdUldaMWsXsQxtHoWbN7xpJlbPAL28eGqqZs92+iigYEYNn2Ou1GF8mxj5ZFO0luD
	 j/+ilNoAn/hpil51BMa8JVs/1+uuaQp1RotLphsnJBqoIq4+bErzcwuKs8J/X0EIOHDiv
	 xEkZqDFeBjgeqHYaICimX3SLHnR/S0mZGUwjJaNNBFzAeIS2QxXUnUiZ8NvoSG+buIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NUgdgKSw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B29606A320;
	Wed, 18 Nov 2026 21:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NUgdgKSw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BA51F000C4;
	Wed, 18 Nov 2026 21:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037909;
	bh=elFAHpjdtyEfO1nu4w2DVnste7XInYL4w5ifgQa4OZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUgdgKSwR3mGJfoF8iV+T/uhVLpoydFs1H9xrG68Vwk6Ca9z9cfTL4l6Byt4kM3dJ
	 xuahYYa2c84TS/tzFnQHuhCKy8bqjzpcrm3QgMvlEbTRJmanyPHlkzS4VTKy6Uz4Of
	 JHsTMmt2PDWxpml9tIy28S6YOtDVBCJbAhCkSN4c=
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
Subject: [PATCH 6.6 1517/3318] mm/gup: check for overflow when converting nr_pages to bytes in GUP-fast
Date: Wed, 18 Nov 2026 15:35:39 +0100
Message-ID: <20261118150406.462510527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5a78c23a77248..af2435cd73d66 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3218,8 +3218,8 @@ static int internal_get_user_pages_fast(unsigned long start,
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



