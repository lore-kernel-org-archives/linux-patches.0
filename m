Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065342;
	b=e1DouJ28w61delOcu+saYMazHHSDRkx8QZK0brFodKvkt7Qgm+cDcbdvrx+1EnGb88bI
	 UA54ixzxUsHWM0GMtZnsyswlQzLgVemJ/5KkN/3lRUTcCI+q2IhntUQFtEw3rFkl35faC
	 6/bQC+OsydKuXNl1hCG87ZpVra1FgOLIgNOZGA7OGS11GUXmKa+dpVMJnq6kfRCYKUi7y
	 KO7LUx6fBiVWm+CLnu7kqrIJdPcBTVPLyC7JKlcfhKGSiq35CBknRAbFXIZZgYARhK8OU
	 MjfB+nb3zAejsUYiduGf+HE3q0IeeIGu1Thd21k7fcvOIkEKI7wn69zVM9XyEPP/oLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DqHEo/GRzC+GUI6+zL2lqIy0UZjvwaPGz0t/w8fTgA8=;
	b=34hYW+l3X/kI+uMBX9RYlF9Y1SuvTpcaZDRwRtplY3BQF/2HQK72pChNvuI2OM+ut4ur
	 TEqjBY+c6r8rMJNGKYbVmH2lkS6UhI4GKzVea9czbczr1SzqSMuSsrUVYOM9DVK808zMH
	 tXiY+MEnuUGvfXiEZXm6ZqXC9NuEnwehO502JIn4PAlErXlvuL7OLFhY6IGaxDkBT10Qv
	 QbtJYR9NU+v/U2Nyeujyo95QXuNSZhyrz/X6JbTnI8P5aW58Ifg8OhDiXJrhkmeKsOE0Z
	 LmvjDE9vza3L40xFSG3Zz6AO/dr+hMIaq+bo+ugevMlXPyQfg/XBYhOJjhUyUlpryzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w71grPGi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8837606A32E;
	Sat,  7 Nov 2026 15:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w71grPGi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9746F1F0089F;
	Sat,  7 Nov 2026 15:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065341;
	bh=DqHEo/GRzC+GUI6+zL2lqIy0UZjvwaPGz0t/w8fTgA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w71grPGiGkHpRti4YOMGeQ7s7bq0yKuTNQGeq/XoOIdC5+1YpuVrFo20f5cHD49nW
	 f8Wn5rgmqpXC5KrhZSptbkyDG48vJZHZhUY7rFwD6TrNh/13h7WcQbCQQocNqmAJBC
	 bb6NelGOLZhGgz0ujxvM6Di1QPrmXICQse/0p2gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1078/1257] mm/damon/core: prevent size quota overflow in the temporal goal tuner
Date: Sat,  7 Nov 2026 08:56:14 -0500
Message-ID: <20261107135009.037111997@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 4293c54b72e75a9d8d2e79b1498cbc782267a4db ]

Patch series "mm/damon: fix the temporal goal tuner's size quota
conversion", v5.

damos_goal_tune_esz_bp_temporal() hands the size quota to
damos_set_effective_quota() through quota->esz_bp in basis points, and the
multiply that gets it there is unchecked.  On 32-bit it wraps above 429496
bytes, and a wrapped product below 10000 divides to a zero effective
quota.  damos_quota_is_full() is then true on the first test of every
charge window, so the scheme makes no progress for as long as the goal is
unachieved.

Patch 1 bounds the conversion.  Patch 2 pins the boundary in the core
kunit suite, where the new test would fail without patch 1 on any word
size.

This patch (of 2):

damos_goal_tune_esz_bp_temporal() converts the scheme's size quota into
basis points with "quota->esz_bp = quota->sz * 10000", both unsigned long,
and damos_set_effective_quota() divides the result back by 10000.
quotas/bytes is unbounded; bytes_store() hands it to kstrtoul() as is.

On 32-bit the product wraps for any size quota above ULONG_MAX / 10000,
that is 429496 bytes.  A wrapped product below 10000 divides to a zero
effective quota: 429497 gives 0.  damos_quota_is_full() is then true on
the first test of every charge window.  Other wrapped values are wrong
without being zero: 500000 gives 70503.

Triggering this needs a scheme with a quota goal, the temporal goal tuner,
and a size quota above ULONG_MAX / 10000 -- 429496 bytes on 32-bit,
1844674407370955 on 64-bit.  The scheme then makes no progress for as long
as the goal is unachieved, which is easy to notice, and writing a smaller
size quota restores it.  Nothing is corrupted and nothing leaks.  This is
unlikely to be hit on a tested setup.

addr_unit does not cover this.  It only scales the numbers a paddr context
writes to quotas/bytes, so a large enough scaled value wraps just the
same, and vaddr and fvaddr contexts take raw byte values.

Bound the multiply.

Link: https://lore.kernel.org/20260928084816.5575-1-sj@kernel.org
Link: https://lore.kernel.org/20260928084816.5575-2-sj@kernel.org
Fixes: af738a6a00c1 ("mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 7.1.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6dd2ad9636a34..1b05b4809522d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3148,7 +3148,7 @@ static void damos_goal_tune_esz_bp_temporal(struct damon_ctx *c,
 
 	if (score >= 10000)
 		quota->esz_bp = 0;
-	else if (quota->sz)
+	else if (quota->sz && quota->sz <= ULONG_MAX / 10000)
 		quota->esz_bp = quota->sz * 10000;
 	else
 		quota->esz_bp = ULONG_MAX;
-- 
2.53.0



