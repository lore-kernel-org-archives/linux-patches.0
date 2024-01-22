Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB4A59B5E;
	Tue, 23 Jan 2024 00:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970314; cv=none; b=Jj7FzhiUQIqVTGy90za/deJkh7GFqH8iaxXdHCQtmW5XYDvHiYuu33LviPFUxo6QhPP0Mz5mDS8EKrEXMbLDj6loBGl/7rMGwRasaoACtBJ60nI/xQdCoXPBXGKQlqGVnZrVwV0EqdeAsAkKKe4wwMuLE5DZixsALOD8aSGkudU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970314; c=relaxed/simple;
	bh=Bfs+V2gJ6jt/67/MJgbx49Vzbp+clD5wexVVr1wR6V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUx6GvSlu+Jr0/Pizfk+vCAQK5upCxdMSpe75W/kE7bE690NpZ5NA9McWTOfJ6Yrji9Q5+4NFWHFQUQdOvye8C+eyKlqCM+Bslu1C5QANIK5eKInp4Thipo3Nu9fUiJBJCb/U1Er/8dx0bm3VUP6VWTeLebqZk9KL+u7Z7sfBzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hie0zlZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hie0zlZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525FAC433F1;
	Tue, 23 Jan 2024 00:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970314;
	bh=Bfs+V2gJ6jt/67/MJgbx49Vzbp+clD5wexVVr1wR6V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hie0zlZ5fvqZFMDMs/2Nv+d9ZIGQjJwK62FvwBQHuo9QKA6yWA/ETWyXLO3FVYIgC
	 5NcmXebtsiIqy0d5OybVx72j5SNGeltlaQZWRO4GdNFiTjD+03jToU0MVVx139S6Hn
	 3twQbjVJhhzLI53lauJLtzBHiWVf3atTMq60/tUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 631/641] arm64/ptrace: Dont flush ZA/ZT storage when writing ZA via ptrace
Date: Mon, 22 Jan 2024 15:58:55 -0800
Message-ID: <20240122235838.020500249@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit b7c510d049049409e8945b932f4b0b357fa17415 ]

When writing ZA we currently unconditionally flush the buffer used to store
it as part of ensuring that it is allocated. Since this buffer is shared
with ZT0 this means that a write to ZA when PSTATE.ZA is already set will
corrupt the value of ZT0 on a SME2 system. Fix this by only flushing the
backing storage if PSTATE.ZA was not previously set.

This will mean that short or failed writes may leave stale data in the
buffer, this seems as correct as our current behaviour and unlikely to be
something that userspace will rely on.

Fixes: f90b529bcbe5 ("arm64/sme: Implement ZT0 ptrace support")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240115-arm64-fix-ptrace-za-zt-v1-1-48617517028a@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/ptrace.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 20d7ef82de90..b3f64144b5cd 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1107,12 +1107,13 @@ static int za_set(struct task_struct *target,
 		}
 	}
 
-	/* Allocate/reinit ZA storage */
-	sme_alloc(target, true);
-	if (!target->thread.sme_state) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	/*
+	 * Only flush the storage if PSTATE.ZA was not already set,
+	 * otherwise preserve any existing data.
+	 */
+	sme_alloc(target, !thread_za_enabled(&target->thread));
+	if (!target->thread.sme_state)
+		return -ENOMEM;
 
 	/* If there is no data then disable ZA */
 	if (!count) {
-- 
2.43.0



