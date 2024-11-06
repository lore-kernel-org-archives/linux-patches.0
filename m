Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBBD1CCB5F;
	Wed,  6 Nov 2024 13:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899333; cv=none; b=odPcJdH9QwzJu+3riQvYViB1tTKI+Ofbt9v4nW8UwXL4bGIKUweoX99UrInz9rXl8iWnIuhFkU8cPm4XkWcsqVpNy+aGGL7UzU7vhabViWrSh9zwxR6uMOl+pf4EzIdCg4UnHa3IitWM7oXbZwZwKAiOvEvppwptl6zBSFUp4cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899333; c=relaxed/simple;
	bh=LEQXXkyr/yyVQYowMRCm/N/6buPs8E3XRtsbm68hSiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0SYUnxKh9eRY2rHWRN84rsizUBMj3PORN0P8No0KCCH7Zoo/Ud1EGuEt/lY0SEIljMFdU3iOeeJkSyiE1SbKWRH+4CFv021Yc+zcFGLL7z4yigCQFBtoXTuxW98HDNQbD979aAdeliT2r7t1V7OH7Al41nYFlR1saQ6l/9Pz0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZ+EUaHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZ+EUaHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CB0C4CECD;
	Wed,  6 Nov 2024 13:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899333;
	bh=LEQXXkyr/yyVQYowMRCm/N/6buPs8E3XRtsbm68hSiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZ+EUaHA3SzPO6xPLK6bM+DAej8hUGhyBlVqKac+DbJBs+p1NGFr4EKbxKG++HIsI
	 3IhX30hoDrfJYnG06Y0YB8YNXKnQlfCgW8rhb322tY7Qq0x4kaFKrW0NdjZTJHIigg
	 fi+Lj8fxcTVD4EmBiPAKjApCmFbqahkXtIFLi76M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mel Gorman <mgorman@techsingularity.net>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	NeilBrown <neilb@suse.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 60/73] mm/page_alloc: treat RT tasks similar to __GFP_HIGH
Date: Wed,  6 Nov 2024 13:06:04 +0100
Message-ID: <20241106120301.746250988@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@techsingularity.net>

[ Upstream commit c988dcbecf3fd5430921eaa3fe9054754f76d185 ]

RT tasks are allowed to dip below the min reserve but ALLOC_HARDER is
typically combined with ALLOC_MIN_RESERVE so RT tasks are a little
unusual.  While there is some justification for allowing RT tasks access
to memory reserves, there is a strong chance that a RT task that is also
under memory pressure is at risk of missing deadlines anyway.  Relax how
much reserves an RT task can access by treating it the same as __GFP_HIGH
allocations.

Note that in a future kernel release that the RT special casing will be
removed.  Hard realtime tasks should be locking down resources in advance
and ensuring enough memory is available.  Even a soft-realtime task like
audio or video live decoding which cannot jitter should be allocating both
memory and any disk space required up-front before the recording starts
instead of relying on reserves.  At best, reserve access will only delay
the problem by a very short interval.

Link: https://lkml.kernel.org/r/20230113111217.14134-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4e9e9cb98f336..72835cf4034bc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4725,7 +4725,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 		 */
 		alloc_flags &= ~ALLOC_CPUSET;
 	} else if (unlikely(rt_task(current)) && in_task())
-		alloc_flags |= ALLOC_HARDER;
+		alloc_flags |= ALLOC_MIN_RESERVE;
 
 	alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, alloc_flags);
 
-- 
2.43.0



