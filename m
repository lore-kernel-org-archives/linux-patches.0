Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B8017C220;
	Fri, 15 May 2026 15:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860524; cv=none; b=X0NqOuThuQ+OusSjHrkLwCg4plsQyxxyGP6+QE4yAAM6Zd+fBk/s7Ny9nETkO8bUEM2xx14xmv3jGQPhTG1whT12FO5r8HjpQpNnf4W5Auln7Lf2BZ2rgA0YszOqx8Xga7o87i7k6A1Z5MRvH0G8YSQPR9V6okcaULvAyZHOVPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860524; c=relaxed/simple;
	bh=70SGxOhYCbB9idvTOPwIFOsSSnurzK59gU8NPbS/vZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ufwm9ADmW+6fJLRUBzC+GoyF1L7pZrGe0WuabY1Ap9H8x1OyvamKgiRzDMW9gG61fV8tFEiQH0cZiawOs+Ef+2zOInvc7Jh8tGPjgRVs/DHaImXFj3PVF8Asp1YH1nfqylJo5rp5EHYbi4nE+Xy3+STezfqqa6KLa6lV+t2OtC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BD5pvfC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BD5pvfC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C498C2BCB0;
	Fri, 15 May 2026 15:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860524;
	bh=70SGxOhYCbB9idvTOPwIFOsSSnurzK59gU8NPbS/vZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BD5pvfC0YPsM3WRRl3m7LKDxclfrcLWsJKpAk88qfLPAqIHRXtM22TX9Ey1b/x2VX
	 q9PI7KC1LV/CPLiKUW9wzPihkeVywyLjHqTired1xQRroLmKQe5LOzzLHXza3r9goo
	 Mvh91cs7+v6bOney/IOkNWevX6znL0Fmd9KVH9CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 123/144] mm/damon/core: disallow time-quota setting zero esz
Date: Fri, 15 May 2026 17:49:09 +0200
Message-ID: <20260515154656.359347359@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 8bbde987c2b84f80da0853f739f0a920386f8b99 upstream.

When the throughput of a DAMOS scheme is very slow, DAMOS time quota can
make the effective size quota smaller than damon_ctx->min_region_sz.  In
the case, damos_apply_scheme() will skip applying the action, because the
action is tried at region level, which requires >=min_region_sz size.
That is, the quota is effectively exceeded for the quota charge window.

Because no action will be applied, the total_charged_sz and
total_charged_ns are also not updated.  damos_set_effective_quota() will
try to update the effective size quota before starting the next charge
window.  However, because the total_charged_sz and total_charged_ns have
not updated, the throughput and effective size quota are also not changed.
Since effective size quota can only be decreased, other effective size
quota update factors including DAMOS quota goals and size quota cannot
make any change, either.

As a result, the scheme is unexpectedly deactivated until the user notices
and mitigates the situation.  The users can mitigate this situation by
changing the time quota online or re-install the scheme.  While the
mitigation is somewhat straightforward, finding the situation would be
challenging, because DAMON is not providing good observabilities for that.
Even if such observability is provided, doing the additional monitoring
and the mitigation is somewhat cumbersome and not aligned to the intention
of the time quota.  The time quota was intended to help reduce the user's
administration overhead.

Fix the problem by setting time quota-modified effective size quota be at
least min_region_sz always.

The issue was discovered [1] by sashiko.

Link: https://lore.kernel.org/20260407003153.79589-1-sj@kernel.org
Link: https://lore.kernel.org/20260405192504.110014-1-sj@kernel.org [1]
Fixes: 1cd243030059 ("mm/damon/schemes: implement time quota")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1577,6 +1577,7 @@ static void damos_set_effective_quota(st
 			esz = min(throughput * quota->ms, esz);
 		else
 			esz = throughput * quota->ms;
+		esz = max(DAMON_MIN_REGION, esz);
 	}
 
 	if (quota->sz && quota->sz < esz)


