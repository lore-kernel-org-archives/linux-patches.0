Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DED5F9E4;
	Sat,  3 Feb 2024 04:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933319; cv=none; b=mPXJDUEryET2vZ7I2rmh/I4jE7c+WUFr1vNf+sw6duy16trYEg3jGUgf7OsZTPCGq939OkCNmjgwNzV+/0YIJyol6xP2qScGDeAgRTE5YSruuNLU7fD3zUh5hfxq7jQfujF9O10apatfb7YOjTvgDKeuNdnf9xS7uIemBJlK3x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933319; c=relaxed/simple;
	bh=7IC6lLNeH3+xqXhhmXebZFUfqhnd2nu20TaXZX+t8xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRlwJjh0vO5ojWMcFaEdM8nnkl8nTeyj//Gj28Q+CcfutPBvdNMqUXDpeHn0jMQ7vP/03StgJpZbYOo3O6yJJQ24/lxA4teMZyS8peSoSUsrKV6Klyk+uFKmaip8/DqfmOQE+D6VQ8Id+bWPuUeCEHoB39pH4UTz9IvTPHf3ULg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPUD2pxJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPUD2pxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9140BC433C7;
	Sat,  3 Feb 2024 04:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933318;
	bh=7IC6lLNeH3+xqXhhmXebZFUfqhnd2nu20TaXZX+t8xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPUD2pxJjCNOwmtx7sSsr/jV6RKvTmrEspdnPxqyE4jdYD2zhTbY1QYLSpmcYN5bu
	 ExnTWhbO4E69UoacYITJpFTfAbjvuNhaVJM5FouVVl8+TdceNiKLqGGHw8QBMNMM8V
	 f4NUiUSQKjprDjgRsDv2IlckSWB7Vw81wRKva2RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Kunwu Chan <chentao@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/219] powerpc/mm: Fix null-pointer dereference in pgtable_cache_add
Date: Fri,  2 Feb 2024 20:02:55 -0800
Message-ID: <20240203035317.567951613@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit f46c8a75263f97bda13c739ba1c90aced0d3b071 ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure. Ensure the allocation was successful
by checking the pointer validity.

Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231204023223.2447523-1-chentao@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/init-common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/init-common.c b/arch/powerpc/mm/init-common.c
index 119ef491f797..d3a7726ecf51 100644
--- a/arch/powerpc/mm/init-common.c
+++ b/arch/powerpc/mm/init-common.c
@@ -126,7 +126,7 @@ void pgtable_cache_add(unsigned int shift)
 	 * as to leave enough 0 bits in the address to contain it. */
 	unsigned long minalign = max(MAX_PGTABLE_INDEX_SIZE + 1,
 				     HUGEPD_SHIFT_MASK + 1);
-	struct kmem_cache *new;
+	struct kmem_cache *new = NULL;
 
 	/* It would be nice if this was a BUILD_BUG_ON(), but at the
 	 * moment, gcc doesn't seem to recognize is_power_of_2 as a
@@ -139,7 +139,8 @@ void pgtable_cache_add(unsigned int shift)
 
 	align = max_t(unsigned long, align, minalign);
 	name = kasprintf(GFP_KERNEL, "pgtable-2^%d", shift);
-	new = kmem_cache_create(name, table_size, align, 0, ctor(shift));
+	if (name)
+		new = kmem_cache_create(name, table_size, align, 0, ctor(shift));
 	if (!new)
 		panic("Could not allocate pgtable cache for order %d", shift);
 
-- 
2.43.0



