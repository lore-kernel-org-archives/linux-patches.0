Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045716;
	b=fVu/SW2i/ET4Yvb0DjJNxZjagpIwu7YTZr11eISRwHMgyvRa3038sAVIdq9tT5zDsh66
	 MJA6NIlZoOHb7deuI865jL9VVMGyrK38bORUjuTjopCuxf59O25vknLH/m0iB3YJhchfN
	 cyH7c2fMSzfI3K2VdltyEqMTeANEQzk+RTDBKhcnZCesSq8uq79AS3TettFRUMIoXZkJN
	 1RLCprza97zd0V14uhPGD73xkok/m3yAHhHD9uyPvgirLeEAYYIPfETPNEfzY3f7QMz/o
	 s6KsiVll54zlp34EgyCh7vxRuUwv7VlMOB9pmXGOmVahkillCqmee1RDXvvCaILBgGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+eQ50HahSVtHQOTZAENP1czWOmWDTWTZYPen+BaFUqs=;
	b=EHu9OXT77p1WLKzchg/E7YFddAaqs9HP6U4OLWBMZ58AMlxXgZ/sJM7a/wXBk6uRPUiW
	 HJZtyAALJ8C2bbD+ylG2XoaFIx8hWmE55otd0JW/N7KwOL6G56KqFerKfYce1f6wh7Vkt
	 Ri2wPLfZxRl2vGlSO4gzr93tTLsOafxJ+fpoqJOE68wHA7PiCWPUKGx2JeqvcvDQWkypt
	 7oUrwdow9/E6R57YtDLtYUToDRqJp9m2N2faOl3Yx/CXZY4CxafF+2jw2cZMZZLDRsDLh
	 gORRt82KT/uNKXKewufjqe98q5IKRnq1Sn5/9OxTPvGX9zbaE2hVUPfAicd7v+gT2kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QOx7+NMv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903DF606A32A;
	Wed, 18 Nov 2026 23:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QOx7+NMv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCE81F000C4;
	Wed, 18 Nov 2026 23:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045716;
	bh=+eQ50HahSVtHQOTZAENP1czWOmWDTWTZYPen+BaFUqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QOx7+NMvmd5WyV1LtGYz4q+8ciMxdjuC2nMtwk6H2lIGekZjOu6E0MsOCwvFOB69i
	 Vq0jFWYio6HaKEcbuR3r2N/5nf137ApasWHWCMOIM7pKhq8PudHyxmHJ1FSqfKUvna
	 hBFgcV10IcuqCxcPkQZYnZwchRJiIfZUY4aIZPhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Alexey Gladkov <legion@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1022/2857] ucount: take the rlimit reference before checking the limit
Date: Wed, 18 Nov 2026 15:34:16 +0100
Message-ID: <20261118150238.396903008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit b14fcabd34e02c40f72d3cd1e9bd4fd18df40ff1 ]

inc_rlimit_get_ucounts() takes the reference that pins a ucounts level
while its rlimit count is non-zero only in the walk whose increment is
the 0 -> 1 transition, and only after that walk passed the limit check.
A walk that raises the count from zero and then fails the limit backs
out without the reference, while a concurrent walk that raised it past
one keeps its increment and never takes one either:

  CPU0 (obeys the limit)              CPU1 (overrides it)
  new = add_return(1) -> 1
                                      new = add_return(1) -> 2
                                      new != 1, no get_ucounts()
  new > max -> dec_unwind
  sub_return(1) -> 1   (no put)

The count is 1 with no reference held. When CPU1 drops its charge,
dec_rlimit_put_ucounts() takes the count to 0 and puts a reference
nobody took, which frees the live struct ucounts, and the user_namespace
it pins, with kfree_rcu(). The mirror interleaving leaks the reference
instead.

An unprivileged user reaches this on a kernel with CONFIG_USER_NS=y: in
a user namespace with RLIMIT_SIGPENDING 0, one process taking
synchronous SIGSEGVs (forced, so override_rlimit is set) races a second
process in the same namespace and uid that queues real-time signals,
which obey the limit. The two hold different sighand->siglock but charge
the same per-namespace SIGPENDING ucounts. Unpatched, with rcuref
debugging:

  rcuref - imbalanced put()
  WARNING: lib/rcuref.c:266 at rcuref_put_slowpath+0xf4/0x120
   put_ucounts+0x5a/0x180
   do_dec_rlimit_put_ucounts+0x70/0x90
   __sigqueue_free+0x33/0xc0
   get_signal+0x56f/0xd20
   arch_do_signal_or_restart+0x87/0x380
   irqentry_exit+0x243/0x650
   asm_exc_page_fault+0x26/0x30

Take the reference on the 0 -> 1 transition before the limit is checked,
so the walk that raises the count from zero owns that level's reference
even when its request is rejected, and unwind a rejected level through
do_dec_rlimit_put_ucounts(), which releases the reference when the count
returns to 0. The get_ucounts() failure path is unchanged. With the
patch the same interleaving, forced some 80000 times in a KASAN build,
produces no warning and no KASAN report.

Fixes: 15bc01effefe ("ucounts: Fix signal ucount refcounting")
Cc: stable@vger.kernel.org
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Link: https://patch.msgid.link/20261019185913.805378-1-nickolai@csail.mit.edu
Acked-by: Alexey Gladkov <legion@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/ucount.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index 7f29cc9728189..e218ea54af92f 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -317,23 +317,26 @@ long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type,
 
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
 		long new = atomic_long_add_return(1, &iter->rlimit[type]);
-		if (new < 0 || new > max)
+		/*
+		 * Take the extra reference on the 0 -> 1 transition before the
+		 * limit check: a rejected walk must not leave a concurrent one
+		 * holding the surviving increment with no reference.
+		 */
+		if (new == 1 && !get_ucounts(iter))
 			goto dec_unwind;
+		if (new < 0 || new > max) {
+			/* undo iter too, releasing the reference taken above */
+			do_dec_rlimit_put_ucounts(ucounts, iter->ns->ucounts, type);
+			return 0;
+		}
 		if (iter == ucounts)
 			ret = new;
 		if (!override_rlimit)
 			max = get_userns_rlimit_max(iter->ns, type);
-		/*
-		 * Grab an extra ucount reference for the caller when
-		 * the rlimit count was previously 0.
-		 */
-		if (new != 1)
-			continue;
-		if (!get_ucounts(iter))
-			goto dec_unwind;
 	}
 	return ret;
 dec_unwind:
+	/* get_ucounts() failed for iter: undo iter without a put */
 	dec = atomic_long_sub_return(1, &iter->rlimit[type]);
 	WARN_ON_ONCE(dec < 0);
 	do_dec_rlimit_put_ucounts(ucounts, iter, type);
-- 
2.53.0



