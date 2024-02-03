Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C795811188;
	Sat,  3 Feb 2024 04:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933486; cv=none; b=fA78vI04F585bWgj305mmqiWM/t0sOpYk7qIStrTtpMqC25JK+QB9IRBjf15P55+zQhno7xh8I4N1KSM64HM8rIsHOvYLfPfUkZ6Sy7JgqSnY5kOwv+JnR4opEys/rPtyphBOnG3Po5YIKzgdf0a0/Im8w8Zq5EgSS7EA55tuZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933486; c=relaxed/simple;
	bh=ezVxg3VJPd4LDUQc418SmUIcEZViDyDw6yCz8gTRTCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gxk5mOZD9POm0EiCSoYsgu0hN3lhizIvye+e2OBGoRK/odZejw0vqMDkhtfBUS0KpKgnbNd5nJmYfKpyxAgU/4ZHankEi/4wZg6tjxxnUi9Sl6nQdUfhiYJS51pFxvjJ7NlZe3p7SJ+hfieapFjkFVs0oBzuID3pv449xOJcrvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUE7JmDX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUE7JmDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F26BC433C7;
	Sat,  3 Feb 2024 04:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933486;
	bh=ezVxg3VJPd4LDUQc418SmUIcEZViDyDw6yCz8gTRTCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUE7JmDXrBbQLQyb+rNsBsUIXBcp/3QH4zEMmCqwzK9p8O+C/PLmMdrWAj/nRRo/6
	 25Tcpm4a+kRg0S9d2oyDkFUQhyE7QoUYtjvW6zG3bPtvPe6f2kyVJmAGRO4iQ2e9BA
	 IcC++8jwuZJTfPSU74jEN/zbgbwR/d+zGAGrFDak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Kunwu Chan <chentao@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/322] powerpc/mm: Fix null-pointer dereference in pgtable_cache_add
Date: Fri,  2 Feb 2024 20:01:40 -0800
Message-ID: <20240203035359.158150187@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



