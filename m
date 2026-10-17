Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1F83AEF36;
	Sat, 17 Oct 2026 16:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256287; cv=none; b=l8nzbavWFinDT1M2up2OJGfW46i7GZou32BJNNlE3mXQ2s44F3ZvnUvHRS3l+ytreDs03782ZWHxUxat/3uhocChfA/8P52Wa7GECjQ5Dbe5/jF9NHT9eXZ2UPOCuESdJQ/KCzxgavw0UG91J6jCo3tX4HX7QWqvxYm+mvOjb44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256287; c=relaxed/simple;
	bh=SShRnYwXssYgz2hclw1SkFxLZQi0u9HC4+RW+cmsTcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRUYHVCYUVbouQZNF/c/DFS3lt2nU0w062zYMdkJ69Clu00S4UsMfyT2E0Gq6+2GCLEFWFUA63/BEeQx4L9jDdq6Qe+qg5H5NzhY8eXH/2TT3NHXGKSrK51cbRnSWb3Wjx/IL4tckS8k+CZFD2yUmGrT0CZpLSh1z6sl2RgAP6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYOONIH6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYOONIH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F201F000C4;
	Sat, 17 Oct 2026 16:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256285;
	bh=zzrfIwG7UwxUenm2CgD4GWiE6+EGXNcHgqEwAaq9Vj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYOONIH6zKlfSPvtOkihQO1HcQTaC/zfK+EUMaTZ/Q+1yrCOKOfp9E/IgYkyjVwuw
	 fDzG7uOg5cTA+CP5jWBdFcC60zWM/xJw68TUctkbmPZwwgVZGYlIB1IAG5YA9jAHrq
	 LS+guptAiyHFRERwBma7LwJraOK43zLy9kaY1KQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0186/1674] mm/damon/core: dont skip damos_adjust_quota() while esz is not zero
Date: Sat, 17 Oct 2026 17:40:58 +0200
Message-ID: <20261017160435.923137400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: SJ Park <sj@kernel.org>

[ Upstream commit 52ae167ce16609c7e6fffef588b3c2c26de2db19 ]

DAMOS could unexpectedly stop working when a user disables quota using the
online parameters commit feature.  Fix it by correcting a wrong quota
unset check in damos_adjust_quota().

DAMON users could disable all quotas by unsetting time and size quotas,
and removing all quota goals.  The intention of disabling quotas would be
making DAMOS run at full speed.  When such quota disabled setup is
detected, damos_adjust_quota() skips all its work.  The skipped works
include effective size quota (damos_quota->esz) updates and charged quota
amount (damos_quota->charged_sz) resets.  The intention is to avoid doing
unnecessary work when quotas are disabled.

However, users could do the setup while effective size quota is non-zero,
by doing the disabling with the online DAMON parameters commit feature.
In this case, because the effective size quota exists, DAMOS will keep
working with the quota until it is fully charged.  After the effective
quota is fully charged, the charged quota amount (damos_quota->charged_sz)
cannot be reset because damos_adjust_quota() skips it.  Then, DAMOS stops
working until the quota is newly set or DAMON is entirely restarted.

The problem happens because damos_adjust_quota() assumes the user setup
for disabling quota immediately disabled it.  In reality, the quota is
still working until the effective size quota is also updated to zero.
Other logic for catching that uses damos_quota_is_set(), which understands
the fact and therefore checks the effective size quota in addition to the
user setup.  Fix the issue by using damos_quota_is_set() in
damos_adjust_quota() to determine if its works should be skipped.

The user impact is a non-deterministic and unexpected DAMOS stop behavior.
That is, users would disable quotas using the online parameters commit
feature, expecting DAMOS will run at full speed.  However, depending on
the timing, the setup can be updated while the effective size quota is
non-zero.  Due to the above mentioned internal mechanism, DAMOS stops
working instead of running at full speed.  It is unexpected behavior.  It
is also non-deterministic because sometimes the setup is done when the
effective size quota is zero, depending on the timing.  It doesn't cause
critical issues like crashes or leaks.  Users can simply set a reasonable
quota again, or restart DAMON.  But definitely it is an unexpected and
non-deterministic behavior that makes it difficult to reliably use.  Also
investigating the root cause of the behavior would be quite difficult.

Link: https://lore.kernel.org/20260916135020.86483-1-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index fe91b296f4c66..bd46a63b611cf 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1087,7 +1087,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	unsigned long cumulated_sz;
 	unsigned int score, max_score = 0;
 
-	if (!quota->ms && !quota->sz)
+	if (!quota->esz && !quota->ms && !quota->sz)
 		return;
 
 	/* First charge window */
-- 
2.53.0



