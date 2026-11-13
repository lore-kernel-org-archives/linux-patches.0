Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590408;
	b=hvnU8Q78kL+MQRlILZb5xw6QHuh1wJkRpA8HVmDB3/iw3jOHboptRba+6N50CebfqGfM
	 4RO1cH6CLXXWiQS7zei+OBAUWL7hfQ9+Nw/WEvoPjElYoEQWF0bWu0EFuCuYf1ADyF9lD
	 QZiNIfJH0XNv02rlnWFASemcMambdham+PtWsv6k41nkvl0+tJgwOnhBrnfa+HkeVd60q
	 vbkgqjWJpO2WrcMOgrVQh9lWS5HtQtpz4Wb20hDulPwXvX33RBESIrAO5KTcENIVH7ZOp
	 wDhRDHHBRgglZ7WXru9ysPoJAxzJA4SjiCVZz+vQzUQS00JLgUEYMlZLkwo8fTxA57w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uDL5vpi+NXNzTf62HaAP9YEDhGNj8PSQrI8fhrV4Thw=;
	b=upZonU1SnHWkJcsQFU4PoEXCO8yfVi9rjlbTJkH0NVbxHbW0S6QqTTGQ7F5JwKURoLtI
	 LeAy8A2wTUWXTf2RlWrXJtfc063CAHGV+2axxEPjXvvrevuM/1Me/6DyHScX8pCPeDCXC
	 eddAyFtAvhOmu0+GkXcWhPqMX/5bPRDHt0hzPdHcPCvvw+5orS+cy7MRz0BMkvz5X/xKh
	 DiXGlORvBDuh6w41QSWA9nPO5uo5P8gZzpvjLnLjboBUJj98cRoOGGOqcFVBkZzbVIcwe
	 JM/piY+0j2S0xe5sls9Vazz13t911kbtTWD6RhZhEAkWcPPqxz0fQuSsdTWq3iaShSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ucHKn2LO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8071E606F70D;
	Fri, 13 Nov 2026 17:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ucHKn2LO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310AB1F000C4;
	Fri, 13 Nov 2026 17:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590408;
	bh=uDL5vpi+NXNzTf62HaAP9YEDhGNj8PSQrI8fhrV4Thw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ucHKn2LOSDjPLqjDBbloHd4s94OC/w9gSUjV93mBNlWW/WmGJHcENki2ja2AC4u1g
	 MAQ5oWoHMVMLkMzvIt2GTuj9aa3AnBIio/FVacxD5d614R2/iNJbs0jyOnW7PdcoOl
	 O9C3KPMC6fbzmmBLRKcgGSgPBr/u440/m37mAqqI=
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
Subject: [PATCH 6.18 375/686] mm/gup: check for overflow when converting nr_pages to bytes in GUP-fast
Date: Fri, 13 Nov 2026 10:48:28 -0500
Message-ID: <20261113153833.624861306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ac5abfc3dff7e..9ce5c8ef72fad 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3217,8 +3217,8 @@ static int gup_fast_fallback(unsigned long start, unsigned long nr_pages,
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



