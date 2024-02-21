Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550DB3D981;
	Wed, 21 Feb 2024 14:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525108; cv=none; b=CYTdT34hPjv5pqRDOJ8a+DiuDjdTNgOme4F5UEkL6THuVDj2hX4zOdpNYKOYn2u3OiN2aqeSAMN5HUg9rp63HM61i9O7jVm9VU4Z39EDz5ObJnwODkyPuTki4BP9zPHf5PLTC4CmXgd+6IwnukdlUsUwLKFd2ykJTi2ZpZKy0aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525108; c=relaxed/simple;
	bh=i2SHeGy/GaXNob2ybWThg01T3FY25L+AaaxwXExA+eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifdLlS9yjfLQkIDjepxf3jG3gNNMzn/8A0EzO/R8yZHt1tNnbAusNrKzMBjhoafOBSRchwfDWxjuo3jUQSfhMtugw3eEPq08mGyD/ch1AwF1eiz2rexZ1EiZF/hdSEPDnZEyr3uGwB21ImCcVVzdwUK+qATgRKu4SzQ1UpX0uUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkGrucWY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkGrucWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB693C433C7;
	Wed, 21 Feb 2024 14:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525108;
	bh=i2SHeGy/GaXNob2ybWThg01T3FY25L+AaaxwXExA+eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkGrucWYIeA0zFXnrcjllG4+xfcvWSA+rq8nQQIm5Rwo1kvBipax4XFio9R+HJhs8
	 y1O63VGXFN2a2+jmA/Jq0Z1vPMrq+8PsV651xUkHTeuSZj2+3ZrAdZG9iGR6/truIQ
	 zZvauq1lT6/Kca6HkovEsM5Di+HfkscK9oq/6VxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Kunwu Chan <chentao@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/267] powerpc/mm: Fix null-pointer dereference in pgtable_cache_add
Date: Wed, 21 Feb 2024 14:06:42 +0100
Message-ID: <20240221125941.916358989@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a84da92920f7..e7b9cc90fd9e 100644
--- a/arch/powerpc/mm/init-common.c
+++ b/arch/powerpc/mm/init-common.c
@@ -104,7 +104,7 @@ void pgtable_cache_add(unsigned int shift)
 	 * as to leave enough 0 bits in the address to contain it. */
 	unsigned long minalign = max(MAX_PGTABLE_INDEX_SIZE + 1,
 				     HUGEPD_SHIFT_MASK + 1);
-	struct kmem_cache *new;
+	struct kmem_cache *new = NULL;
 
 	/* It would be nice if this was a BUILD_BUG_ON(), but at the
 	 * moment, gcc doesn't seem to recognize is_power_of_2 as a
@@ -117,7 +117,8 @@ void pgtable_cache_add(unsigned int shift)
 
 	align = max_t(unsigned long, align, minalign);
 	name = kasprintf(GFP_KERNEL, "pgtable-2^%d", shift);
-	new = kmem_cache_create(name, table_size, align, 0, ctor(shift));
+	if (name)
+		new = kmem_cache_create(name, table_size, align, 0, ctor(shift));
 	if (!new)
 		panic("Could not allocate pgtable cache for order %d", shift);
 
-- 
2.43.0



