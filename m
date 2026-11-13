Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591564;
	b=cDb1Wl8WUJZpzJ+Yc1vyQ8CXwQcpA1C7+JlnW5Gmv7hjjXK6B/8EEUjG6BzERJ8lzJFr
	 I+v80qpv9ghOoe7XeKM1LGvNLqTNrHhHnDdDg2vYjb38DVPpJzBw6IqBaJBWpKCneM5nq
	 YfV9kkD50LbLmtvgC53Mpnf5Kmuid67qKrX2zDY6bTTLtDcMr545y34JbOAjhWfx3toq6
	 lf86jO6cbS9DmgxEI8MOytlQv09YD65tHn+19+MSKcaA0pJWbZVcl1fpeFrymXbPBYA5t
	 6Dj4T91YZVUggxqxRdHvI00jczZ7FcoqOJ9AtnxBPFtJbsyU2/CrdjPnx6bXJ7FM4dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4WTkY+kvIKQFE4eGlCyHLvW8tkMTV5bnfG09P6DmPvU=;
	b=OQ1nJ2qGFemXd3Fa46f4GpDJZzjbOwGKieF11Jn1rujKKpqoMMvmnEWjSUc6wx8isRcc
	 j2yDM3sFGUNaoP+dB+LvTPJpGIJWec80ZdN7U9o53EXoEWIAyJucpfTFb2KjdEupRcy8i
	 D1tEEwZlM58NdmSNLJFuF6im5gGgxA398wbAb7VYu9910Ojy3LYvq86Xg5Hr6VFEc0BEv
	 fgpED92QmZcyvKHb+zlIMHWJkj3iMJKF9XTBzzMo1K2UW5Uctfb2jdNO6DfBVPRsLt9ZR
	 f8RSXB9tEBcf59KIGNluJ0/gkwPQE3aB26eQu7S65IBdXrVM4wNTcPibVGZgbi4Ka7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BAq+oIBW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0133860A5BC8;
	Fri, 13 Nov 2026 17:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BAq+oIBW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85841F000C4;
	Fri, 13 Nov 2026 17:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591563;
	bh=4WTkY+kvIKQFE4eGlCyHLvW8tkMTV5bnfG09P6DmPvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BAq+oIBWoqVJ67CPfxrBY78T8Woh6uO0Rbyl6G5s34fFCXJ8i9EgfRk/FrhRa2Yqc
	 6GfWZssJgXrGK2Jfs3nkMJjaO5bHLgct0BQ/d88pWngdO6+jzrAmKKX67xqsbc46mN
	 5ZHoUyl5oxhAi6wcIaKlZg6X7ZhulD/Xl1JaepOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Kan <ckan@cloudflare.com>,
	Matt Fleming <mfleming@cloudflare.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Caleb Kan <calebkan1106@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 615/670] stackdepot: stop preallocating after the final pool
Date: Fri, 13 Nov 2026 10:52:59 -0500
Message-ID: <20261113153832.651546424@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Kan <ckan@cloudflare.com>

[ Upstream commit 8f56ea8e0706d92774603260779c7032f03ef3ac ]

depot_init_pool() decides whether another pool is needed before it
increments pools_num. When it registers the last allowed pool, pools_num
is still one below stack_max_pools, so the existing comparison clears
new_pool.

With new_pool cleared, stack_depot_save_flags() can allocate another
order-2 pool after a lookup miss. depot_keep_new_pool() retains its pointer
in the global new_pool, so the allocation is not lost. However, pools_num
has already reached stack_max_pools, and depot_init_pool() rejects every
attempt to register the pool. It remains allocated and unusable until
reboot. The non-NULL pointer prevents later saves from allocating more
spare pools.

Account for the pool being registered in the limit check so registering
the final pool installs STACK_DEPOT_POISON and prevents the extra
allocation.

Link: https://lore.kernel.org/20261022083330.3159793-1-matt@readmodwrite.com
Fixes: 31639fd6cebd ("stackdepot: use variable size records for non-evictable entries")
Signed-off-by: Caleb Kan <ckan@cloudflare.com>
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Caleb Kan <calebkan1106@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
[ sashal: Used the existing DEPOT_MAX_POOLS constant instead of upstream's stack_max_pools variable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/stackdepot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index 245d5b4166999..1f1d63d21f26b 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -273,7 +273,7 @@ static bool depot_init_pool(void **prealloc)
 	 * NULL; do not reset to NULL if we have reached the maximum number of
 	 * pools.
 	 */
-	if (pools_num < DEPOT_MAX_POOLS)
+	if (pools_num + 1 < DEPOT_MAX_POOLS)
 		WRITE_ONCE(new_pool, NULL);
 	else
 		WRITE_ONCE(new_pool, STACK_DEPOT_POISON);
-- 
2.53.0



