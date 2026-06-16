Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0E334889F;
	Tue, 16 Jun 2026 15:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624341; cv=none; b=snrnAF/Kvz+SjLSFz0bZtyeNre2YF898Ids4P3O+PlwzzoPcH64WqwtSyeg5yIUNr3UaGUbeww9f+9liW4dSffksAmzt4KH++3L5TW7QLjychbzGFblDzwmPB5QkguWDzcYZdnEutmC1DZGNiDwSY7+0wx5yeYg9y8WF2Oj1S8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624341; c=relaxed/simple;
	bh=8GkATdAmypfIkNjfl8NGxSEakB0MrITPSRJ8pwN7YSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETyqHk5SjyAqppUbLvuYLgowriTNFaBIr+di2CjwXtbyNQA4osb6XP95wbVO+Fwe1VelaYPWrZlKJZGSjKp6ImIZIwtUwMXit1rfjjhtl8SW0iT6Xi3hn5FfHQ9WOsEpRWO0GyfZSWLte0xrfkhfMo7fJxFTKNfHKlH/xV9Sz8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0Pa4RLJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0Pa4RLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EC41F000E9;
	Tue, 16 Jun 2026 15:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624340;
	bh=d74cP/SxRX1ZhoalYDSdC+JB6D1NBm+fqxkNalEVa/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0Pa4RLJQjWFdPiSqQugAB0DXjgX+AWdbbXYZtvXYAShjLiZ8BN1I7mkgMLwlca+Y
	 51VNywBUu8xVXmmLLevqaOEqn135AW42BnQmpy2l2zsQGPM/Tv7uyGPsiVnGSRh7Ow
	 zG4/VYc3PF/OJWWSRbw8BbpGlaSGhQbXxjE9wGOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 300/378] mm/damon/lru_sort: handle ctx allocation failure
Date: Tue, 16 Jun 2026 20:28:51 +0530
Message-ID: <20260616145125.880338128@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit ab04340b5ae5d52c1d46b750538febcde9d889e7 upstream.

DAMON_LRU_SORT allocates the damon_ctx object for its kdamond in its init
function.  damon_lru_sort_enabled_store() wrongly assumes the allocation
will always succeed once tried.  If the damon_ctx allocation was failed,
therefore, code execution reaches to damon_commit_ctx() while 'ctx' is
NULL.  As a result, it dereferences the NULL 'ctx' pointer.  Avoid the
NULL dereference by returning -ENOMEM if 'ctx' is NULL.

Link: https://lore.kernel.org/20260529000104.7006-3-sj@kernel.org
Fixes: c4a8e662c839 ("mm/damon/lru_sort: use damon_initialized()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/lru_sort.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -442,6 +442,10 @@ static int damon_lru_sort_enabled_store(
 	if (!damon_initialized())
 		return 0;
 
+	/* damon_modules_new_paddr_ctx_target() in the init function failed. */
+	if (!ctx)
+		return -ENOMEM;
+
 	return damon_lru_sort_turn(enabled);
 }
 


