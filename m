Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2797314F9DA;
	Tue, 20 Feb 2024 21:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462857; cv=none; b=t05O4zDxBlHPbH9KK8tAfE3OYINWtyBDI5dHg5LDP1C2Sn5vFnYycv09uAImNRZGCyvPlEeOFnM+aRb83+Ts81YmXp9cSnGma9i1aHwOkm4pVON4Ye2Pd2Hj4xau/LRv7PRAsbR3Bes24rCu/T3nIbIPTCB913XlsVH4qQN+tx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462857; c=relaxed/simple;
	bh=45I1mCC4Q+YrHMoN129WoaDcwYfHVV9P76N/RZKc2Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOyqJwfUeSHTCi3HK+mbNE0JOD69NwLe1XI5+5GLbCxbDGswsRqoVPldBS5b00AQVXKysYKXCvyGyul6bpQgD56YmCrcFhrG3Bnh91neDI6xJspNkLYj3rXFNyM4L5EHmuN4tQoc4C5qwHR7IthaQLBgLrLn6TrKaLCaWzix9Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHf5CIQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHf5CIQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D825C433C7;
	Tue, 20 Feb 2024 21:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462857;
	bh=45I1mCC4Q+YrHMoN129WoaDcwYfHVV9P76N/RZKc2Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xHf5CIQzxgtwM9rF0u5c24o6PbXKOxFu/o+iVqB5z/C/aMsjCpLvuZPZSgKlo1+4x
	 yyJXnX6UFQVPUwhUXCoYXLU8OOFw+4xXt1xH50jv5l0Ucwg5aBO5CLt1Pu6ECjmjjR
	 9bHt/GfYeaNqh9KPoRqpkvu6FNfrJkNh+OuVp+7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangfeng Xiao <xiaojiangfeng@huawei.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/197] powerpc/kasan: Fix addr error caused by page alignment
Date: Tue, 20 Feb 2024 21:50:17 +0100
Message-ID: <20240220204842.814615205@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>

[ Upstream commit 4a7aee96200ad281a5cc4cf5c7a2e2a49d2b97b0 ]

In kasan_init_region, when k_start is not page aligned, at the begin of
for loop, k_cur = k_start & PAGE_MASK is less than k_start, and then
`va = block + k_cur - k_start` is less than block, the addr va is invalid,
because the memory address space from va to block is not alloced by
memblock_alloc, which will not be reserved by memblock_reserve later, it
will be used by other places.

As a result, memory overwriting occurs.

for example:
int __init __weak kasan_init_region(void *start, size_t size)
{
[...]
	/* if say block(dcd97000) k_start(feef7400) k_end(feeff3fe) */
	block = memblock_alloc(k_end - k_start, PAGE_SIZE);
	[...]
	for (k_cur = k_start & PAGE_MASK; k_cur < k_end; k_cur += PAGE_SIZE) {
		/* at the begin of for loop
		 * block(dcd97000) va(dcd96c00) k_cur(feef7000) k_start(feef7400)
		 * va(dcd96c00) is less than block(dcd97000), va is invalid
		 */
		void *va = block + k_cur - k_start;
		[...]
	}
[...]
}

Therefore, page alignment is performed on k_start before
memblock_alloc() to ensure the validity of the VA address.

Fixes: 663c0c9496a6 ("powerpc/kasan: Fix shadow area set up for modules.")
Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/1705974359-43790-1-git-send-email-xiaojiangfeng@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/kasan/init_32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/mm/kasan/init_32.c b/arch/powerpc/mm/kasan/init_32.c
index a70828a6d935..aa9aa11927b2 100644
--- a/arch/powerpc/mm/kasan/init_32.c
+++ b/arch/powerpc/mm/kasan/init_32.c
@@ -64,6 +64,7 @@ int __init __weak kasan_init_region(void *start, size_t size)
 	if (ret)
 		return ret;
 
+	k_start = k_start & PAGE_MASK;
 	block = memblock_alloc(k_end - k_start, PAGE_SIZE);
 	if (!block)
 		return -ENOMEM;
-- 
2.43.0



