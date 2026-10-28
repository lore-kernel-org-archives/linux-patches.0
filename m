Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217412;
	b=HnuGJk6kkIo9P9dSF/XZyPmgMq8e5PzoRFd7xOakOW/VF/DTVrEXK4xcdSZR2/3aP7o4
	 +HcHXwPNSfITO1gXwmiTUzEXRdb5vjxfYIuVpCns487RRXSrSlfGo0RWiL0o7YAS1v0vW
	 NtLstbWwtFTMD47bb7NZk+iG/aTZfHSa6HKi9EyIkwbiezLtJZrid+L3CY1vKhWVJCyBZ
	 KgLHEIqjyzbTUBNbGUtaaXcbE91r6wlTKbBlJ6vMR3h7jt8/70Ae9rsrmtjkryOzCgQE4
	 RbMHaQsmsrcFkTCBXciGoaRlR547/KLJz7wCvfQHsTXHnKw3n/4RiQKop1FqmcvcjhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lDCCyZs090mjyFzpIOUmUQf+QPPxNcQl1xjTIF86VDU=;
	b=UT4CJYXyzoO2RKCW0uN8+FUCC1JSK6ebDuZkoSNqiW1HdL5Adsr5LlVx9oIby2jJA0JM
	 QeWW7JEhXIu+j2uCqFuqHEL+N7WzO2pA/JwKptI4gfpzn8U4Kq/Op0k22nC+PslysSDF3
	 b0W4koNU6yA14hKAd21G07bcnvTAjOMknx43H1QBNwBqZTxqXtCfBnMy3a2IdICkPXnwD
	 FOM3Ev/ocZ1MysN7o6ef2ilUh7sZAcdJd3ULcPjM7etmwWVVjAolN9LldebQCT6HVH/Zu
	 WE53ZhYFeqz5GwBwiAZHsn5D/Oq2OHY+tc+OxLOAYeZLyAAVAVG9T3GtU7VYBs59gug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TqdBpx/w";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186B3606A31C;
	Wed, 28 Oct 2026 19:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TqdBpx/w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8901F01825;
	Wed, 28 Oct 2026 19:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217411;
	bh=lDCCyZs090mjyFzpIOUmUQf+QPPxNcQl1xjTIF86VDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TqdBpx/wBUb8yRaZX36sbuuKmmKFFOACM9kaRkEPYMjBhRbClYUouOuzRwMwE6DkQ
	 U8Q0/droAyI18FDl+bEaoGWBHMQjQGSbMbu3/FFwAvvLlHEfT2Ojkuk+NHQj/Iv+1x
	 itKKKZn7CkjILakltF0Bbi1UnVdkgg6NwZtN2PpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1878/1887] mm/kmemleak: use object_cache instead of kmemleak_initialized to check in set_track_prepare()
Date: Wed, 28 Oct 2026 18:06:14 +0100
Message-ID: <20261028170542.192176805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit 835bc157da689f834d10296d0942aed88b310b4f ]

Patch series "mm/kmemleak: use object_cache instead of
kmemleak_initialized", v3.

Use object_cache instead of kmemleak_initialized to check in
set_track_prepare(), so that memory leaks after kmemleak_init() can be
recorded and Rename kmemleak_initialized to kmemleak_late_initialized

unreferenced object 0xc674ca80 (size 64):
 comm "swapper/0", pid 1, jiffies 4294938337 (age 204.880s)
 hex dump (first 32 bytes):
  80 55 75 c6 80 54 75 c6 00 55 75 c6 80 52 75 c6 .Uu..Tu..Uu..Ru.
  00 53 75 c6 00 00 00 00 00 00 00 00 00 00 00 00 .Su..........

This patch (of 2):

kmemleak_initialized is set in kmemleak_late_init(), which also means that
there is no call trace which object's memory leak is before
kmemleak_late_init(), so use object_cache instead of kmemleak_initialized
to check in set_track_prepare() to avoid no call trace records when there
is a memory leak in the code between kmemleak_init() and
kmemleak_late_init().

unreferenced object 0xc674ca80 (size 64):
 comm "swapper/0", pid 1, jiffies 4294938337 (age 204.880s)
 hex dump (first 32 bytes):
  80 55 75 c6 80 54 75 c6 00 55 75 c6 80 52 75 c6 .Uu..Tu..Uu..Ru.
  00 53 75 c6 00 00 00 00 00 00 00 00 00 00 00 00 .Su..........

Link: https://lkml.kernel.org/r/20230815144128.3623103-1-xiaolei.wang@windriver.com
Link: https://lkml.kernel.org/r/20230815144128.3623103-2-xiaolei.wang@windriver.com
Fixes: 56a61617dd22 ("mm: use stack_depot for recording kmemleak's backtrace")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kmemleak.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index add87fc14ca6d..4e5bc3cec3ca6 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -611,7 +611,12 @@ static noinline depot_stack_handle_t set_track_prepare(void)
 	unsigned long entries[MAX_TRACE];
 	unsigned int nr_entries;
 
-	if (!kmemleak_initialized)
+	/*
+	 * Use object_cache to determine whether kmemleak_init() has
+	 * been invoked. stack_depot_early_init() is called before
+	 * kmemleak_init() in mm_core_init().
+	 */
+	if (!object_cache)
 		return 0;
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 3);
 	trace_handle = stack_depot_save(entries, nr_entries, GFP_NOWAIT);
-- 
2.53.0



