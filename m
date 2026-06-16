Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A623C09E1;
	Tue, 16 Jun 2026 18:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632931; cv=none; b=RzE0fjTdBpVjZ6zu4PHuLNFzGvuPW8h0MfDTCwhw3SKu0nwu0yAolV1YEWIt1RVgCTTXh+HlIVBlzIE0qu2bI6x8eSL7qTEU9Tm0GuNrIg9C94o0VUWlJ9zyzbWYcryNvVjAQ21gVRiAGMGuO7bv7tFXvt4Cx2pH+ABnTDAjPF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632931; c=relaxed/simple;
	bh=Ret6alQyEiMkTjnm9sdxMQCoxBdcTmMK0C9dMQhNYxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVQ2++KI+V5YtjeZ7LnXdcm4go9Kw7QmVre0UCbWH8985D3dSM8FHncRPNW/K03Gj2aKdTKu63h7wzk5mYuEG8jIDl0udHxkfe8NFXdi/mx46dG0KVQ/nKGxPoqDvPo48Csg/At/g5KDfbDzD92rrBJAoYqvlZ6uB88IexhtjzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTchkoNJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTchkoNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3B81F000E9;
	Tue, 16 Jun 2026 18:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632930;
	bh=NA+rQXcPRkh/69ToISD5R+ayunAGgzrj+qYC5tWdyXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTchkoNJ9kDZb4fUNLhnxFuI6WqyUFJungrQLOyeFAV/+/lSYbgMwfYr7TYTRkEj6
	 QLH1shvpZuoJp74WK46qalANtSEa0CumhFdfwJjPutj+pglmcHOy40oPn22ye+a/n0
	 bxDW1sWM4uVPk9N0FHjlV8wK/ZeIKuTUcEkjioDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 504/522] mm/damon/core: disallow time-quota setting zero esz
Date: Tue, 16 Jun 2026 20:30:51 +0530
Message-ID: <20260616145149.336236710@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -802,6 +802,7 @@ static void damos_set_effective_quota(st
 	else
 		throughput = PAGE_SIZE * 1024;
 	esz = throughput * quota->ms;
+	esz = max(DAMON_MIN_REGION, esz);
 
 	if (quota->sz && quota->sz < esz)
 		esz = quota->sz;


