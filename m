Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585705;
	b=UfqFx690vFlsuiKGwJTp4mYynZY5l8bhRYvDoXePOkuQdOn2szFNxlrrh+akVji+C3ed
	 a4p1nbkgmNmPRfeFGpygFjRAqoF4OriyN81D60fUtRgbUCnSxtFVP2/9nRAo8SleAkh3N
	 RLJfsGDGS/B4Sco8nklG3Vo+c3iGBIahzyloNt25UGzbrCnb91nS4RpVqoexNE3PLiXoA
	 F8w9+eIb3Y9tRR/I5a78iCuo8bKRIiw/+ytSGD6aIDuAXZIfQQLW1h3E3OYKPoOWvLqYS
	 C/am+b3k9FGiuiFQsD2apGkc3Xoa7bt/cHzd/tuKMo8MmqvfLENwtwxHxWlz9aWNHXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ga27bSlrBfMH6EWeVm6kM3KY+Klk/kSeJpYc3YOBDbs=;
	b=xy63ZsUkXSBOFlcN+/d0tKEVfkYT4A5Dw4avrKgwPT/WNoboSNv/KO+aBR9DWJIROz81
	 8AN+8vm1atpp3lxUXcgRQz2yLfFjRxV1qj2fhT1cBjA2gNhLtG+sXdmySSeh0O820OyE+
	 /7TeXmROezn54ebNrfenQIFJSo9t4cI9qhw0u16n5ulWksGndAPqAnMn6mYmvUCWh4v7K
	 4rOFnDBRP4DlpGysqegfadRUfIvGB03TJaifOUpTYnryp4Td2Yy4X/WAcV5GVlBDg9XUq
	 0XsQi2ybKmwXwI57QwyeuyeCGWjrn4VQMxyT6XImk4Qz8nuQaisiml70i5jVaaE7K/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HHGVXztV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2A660A3834;
	Fri, 13 Nov 2026 16:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HHGVXztV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEBF1F000C4;
	Fri, 13 Nov 2026 16:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585705;
	bh=ga27bSlrBfMH6EWeVm6kM3KY+Klk/kSeJpYc3YOBDbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HHGVXztV3hMUqDEoh+Xz7qS7tqzCgbdG7PtvXJ+MUz7WdPLQGImZr+3U9z4/Wa5uI
	 sYxm4sVzEHFA5FdPO2hro2z6FmoHStbX1Mc2OnZdjMbTBtRuanvVZ6FzjXrZ6LS/qU
	 rHQ+oYt7B3YRhak4QalYGQ8KjNDbxXztvs6pRBZM=
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
Subject: [PATCH 7.3 310/507] mm/gup: check for overflow when converting nr_pages to bytes in GUP-fast
Date: Fri, 13 Nov 2026 10:50:14 -0500
Message-ID: <20261113153805.866529090@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 17f4150a6d7c6..b3937aff3ad44 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3200,8 +3200,8 @@ static int gup_fast_fallback(unsigned long start, unsigned long nr_pages,
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



