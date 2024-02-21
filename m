Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE24855E5E;
	Wed, 21 Feb 2024 13:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523222; cv=none; b=fn3YQzHg5Cf2iGG1B0dRsZwIYKsPrNowBYIIHyt4pZU81OYfpeNobYkwHeJdG4gXxcQT6XirQvuzOxOE+RK2QC4RLdnAWl/apZTvGT4KwROb4ZfmOpankWCyB0oD+eE80nNZCNRH6GpAIKFBNnCDT2H8Nlb+dFa3VO1jTWhK8Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523222; c=relaxed/simple;
	bh=maa3kSqao3fzS4HsaPZsdmTmIuEqBjpk+16VrRT0JXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMYDRoft8ILfnQvRZl6f445hts6yTLguEh+dtOXKTG0JePgBE4FMKY67PCKQKEjTV2/ZYHLqdPF4VPGoJH6b4WHt9a9ro0GdcgKwp6Ln50VFB/XBmhsoQWXp/i/xVcUzGTo8Igz3s+hOUUjMQwDFthmL+HQ3rLLaCEx80qbjA38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXxLfDro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXxLfDro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250DDC433C7;
	Wed, 21 Feb 2024 13:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523222;
	bh=maa3kSqao3fzS4HsaPZsdmTmIuEqBjpk+16VrRT0JXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXxLfDroNb7NyvVaiPMVPyveN6Q26OEW4m++WotaEKmnPgVP1wBRHw6v0TXeQ03Ja
	 Xmko3wQ+5twLTJsC/zd8I8RVD8iwhVUILPAl0llOJqHcR/7Ek8qMGvRkZNzjWv0Ye5
	 mb+HzQRKR0hlfNf6TxT2K25nOnKuayd6igIBJoZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangfeng Xiao <xiaojiangfeng@huawei.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 371/476] powerpc/kasan: Fix addr error caused by page alignment
Date: Wed, 21 Feb 2024 14:07:02 +0100
Message-ID: <20240221130021.749747252@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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
 arch/powerpc/mm/kasan/kasan_init_32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/mm/kasan/kasan_init_32.c b/arch/powerpc/mm/kasan/kasan_init_32.c
index f3e4d069e0ba..643fc525897d 100644
--- a/arch/powerpc/mm/kasan/kasan_init_32.c
+++ b/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -64,6 +64,7 @@ int __init __weak kasan_init_region(void *start, size_t size)
 	if (ret)
 		return ret;
 
+	k_start = k_start & PAGE_MASK;
 	block = memblock_alloc(k_end - k_start, PAGE_SIZE);
 	if (!block)
 		return -ENOMEM;
-- 
2.43.0



