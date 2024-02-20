Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D51446C9;
	Tue, 20 Feb 2024 21:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464768; cv=none; b=CHYAJcrnxS52J66YeIGLTONK4dEYHZDPnfAohvHh+zZZji/4n8M6du156UUQ+Mokfq3HC6tt+isaxWxUmL72BuqiJ2yn27hudanEnUQxUJVxie/YrXpgzozF7yPt1EazHscpzzXM+Fs+Bifxo3Luwa59f2Tf5sLU70EltFNgS4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464768; c=relaxed/simple;
	bh=S/hWyW67xJ1ZKreq58ceLu+nx0vbF30js0dFPiD/9fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yy7I99yWMp+EN7eofKLz7N9kTkZlK2hpw600AxljCarwKj5BaUc4IJ3yXMXF0xhrJjzYGA63Ot1h2I6V0vkV2pApURYan/h2D8UBL/DshV07tbLQi0CCdvWKdPNyhEB9hK+m5lWAWCdAta1K1cG45pMYvnSmiHA3s4tMzJIQV/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brnaxwfW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brnaxwfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D206C433F1;
	Tue, 20 Feb 2024 21:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464768;
	bh=S/hWyW67xJ1ZKreq58ceLu+nx0vbF30js0dFPiD/9fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=brnaxwfWxYKuRm966TmNupjm8Cb4YAd1ReI08mPp9tko/QUfx5I2fGQaBJLFNC2qS
	 JTzZxH2pzTwFkmR+mTmWDd5zML49Z2ISxhSjIuyI3XpcIBnxO2qaAliIhpbX79jt76
	 3u5ZHB1rJydDFtsRbPkyqFZU1eKrpJrOPgUqXFoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangfeng Xiao <xiaojiangfeng@huawei.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 101/309] powerpc/kasan: Fix addr error caused by page alignment
Date: Tue, 20 Feb 2024 21:54:20 +0100
Message-ID: <20240220205636.340668646@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



