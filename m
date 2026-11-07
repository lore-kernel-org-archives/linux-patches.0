Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065255;
	b=0onUQKbb6FEVmJ/fptQzbCxRYMWkTKsJOwssnwt9zEHIHsZ4vusalHtTN7WcIkviJoCY
	 CkPsh/iFaaVnSVOwwyAE4x/1iIpDaWAb6iaoZ24Z81B/rnIZrZDBYm1WITZcsOaxTYahz
	 Y6W4UuKexeQtGsJkGvLt0XVZWcupi62OIu9KpTZ6zqNSU8D6JgDfQyklFChtrZvvVHco6
	 bvaX3JX98t6w76O2a08sd2noFG5Hgjez7oVHTo1w7apN1/Nuriz7bSezUD/pVz3rLbee7
	 HVy5zQiXHaxzY5nDGdJMRxAOxMetrRB9nkM8NGGy5DG13dq6GefXgPwoHld05CGmYHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wLW23jyTdCv91BQ5DDXnoDc5WFd3dd+P2tCrb85PXFQ=;
	b=Niz1NtQQhhudwisbl4EiUU6NDZG/ZIM0DUgqGgdiWuSrPxhiPL5JX9JWDet0+BX3FDvP
	 /hZpkDums192KgSQE/3zRBbgvwJL8w5sQB5jM9NrfQgFEqzLl2wi/4oAiWrXclEVAzaJk
	 JlpBX+xgrAvF7/eV0Or8uIbmmW7r9LK3nWMgQKghLQTId5wZCUWUVGZnJNv1UEh0gP8pQ
	 N+lTPoAWnh2+xeiSC7y/KjmLk4YNo754esXHVxn7XUxRC0F9xuDXi82neoIG0J7K02Keo
	 gd11zB9O9K8fRJ/eA2RL1RrNpbaSRaDHLS2yOhPPFX2jr2i2zHBR1FUfWPhnemCE1Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ftnd4GuL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD7C606A32D;
	Sat,  7 Nov 2026 15:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ftnd4GuL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F57D1F0089F;
	Sat,  7 Nov 2026 15:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065254;
	bh=wLW23jyTdCv91BQ5DDXnoDc5WFd3dd+P2tCrb85PXFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ftnd4GuLqm7o/T0eJH/aa7UTLCM+87W8qUJQvicDOzCfEgZeWem8YW3B9kAB+1wC6
	 B4XulVbleLhk99Qbsd8c4yty3Bm64TDquUMUMhxJfIytglZzDdgns/iklWFxDY57zs
	 vIp9z6V2xsESVDxIHAM1TSx+hdY0nQ6hu9ebENrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Alexey Gladkov <legion@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1024/1257] ucount: take the rlimit reference before checking the limit
Date: Sat,  7 Nov 2026 08:55:20 -0500
Message-ID: <20261107135007.610417961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ec8b1445e2877..c3de5b94d25f7 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -308,23 +308,26 @@ long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum rlimit_type type,
 
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



