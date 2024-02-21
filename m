Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667041E522;
	Wed, 21 Feb 2024 13:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521306; cv=none; b=gitqNACHcm/42vc8IP+dSPg+wXnHjez5zcy4hgkdFfuYHmyNVsgqx3J09CPHk1tEt8+tUEJ8sMZPzi6gMO2UOEixorVGMXsdyCQZF4n4yDXguAWn2+0Xr178rENzleLPqBKRxQwZC+98kZmUXS7/70yx/cnUGIQ+tTreWAKPHM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521306; c=relaxed/simple;
	bh=TsuVqB8mrgSCVis7g51TcOAX0pIfylDrmXa/DCV0cWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvQ/qSwtL9/pYpG9wTXG8D/4NPJ5hWq5g+BGmFWNeMTqwW0AWGYbGn8wrF7P4oVfAskxkAyvnT//ieSx0NtpOquroJ2mwPvZMN8O0GlcyO0o4Db0Kd5qiGDUEwACfeaM1135Xn0ak8Y6f6JVv86pEzD3zU94GXOdDOoBWcIqg9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qLi8vw22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLi8vw22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F4EC433C7;
	Wed, 21 Feb 2024 13:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521306;
	bh=TsuVqB8mrgSCVis7g51TcOAX0pIfylDrmXa/DCV0cWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLi8vw22ZlBbhCzOrZJV8J9QJ2eP1MQooUN2LhvS0W2oAjTcdC/u5+aZt7DDruRuw
	 Tq6clLuRLn7ZXLIEkRI6uv+NH06gkQKIwGCV7/9/0qfzdmhsS26E4xXHTOp9lSN7Dg
	 F6TOghLT1c7Es6ipatpngs/mGHkblLEWWC180YTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Kunwu Chan <chentao@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 050/202] powerpc/mm: Fix null-pointer dereference in pgtable_cache_add
Date: Wed, 21 Feb 2024 14:05:51 +0100
Message-ID: <20240221125933.449533106@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2b656e67f2ea..927703af49be 100644
--- a/arch/powerpc/mm/init-common.c
+++ b/arch/powerpc/mm/init-common.c
@@ -65,7 +65,7 @@ void pgtable_cache_add(unsigned shift, void (*ctor)(void *))
 	 * as to leave enough 0 bits in the address to contain it. */
 	unsigned long minalign = max(MAX_PGTABLE_INDEX_SIZE + 1,
 				     HUGEPD_SHIFT_MASK + 1);
-	struct kmem_cache *new;
+	struct kmem_cache *new = NULL;
 
 	/* It would be nice if this was a BUILD_BUG_ON(), but at the
 	 * moment, gcc doesn't seem to recognize is_power_of_2 as a
@@ -78,7 +78,8 @@ void pgtable_cache_add(unsigned shift, void (*ctor)(void *))
 
 	align = max_t(unsigned long, align, minalign);
 	name = kasprintf(GFP_KERNEL, "pgtable-2^%d", shift);
-	new = kmem_cache_create(name, table_size, align, 0, ctor);
+	if (name)
+		new = kmem_cache_create(name, table_size, align, 0, ctor);
 	if (!new)
 		panic("Could not allocate pgtable cache for order %d", shift);
 
-- 
2.43.0



