Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47D11BC4E;
	Mon, 27 Oct 2025 19:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593385; cv=none; b=S3Hs75GRBY6nhLCo+QF09NCJS4GPXH/APx/fH2N7lLqgw4G4N+BmGF2cQBdFAvx823Pcw3rnVn4xuBaUxWIqRkvynvz28D7LqSHcAqUgKeMuJNbpEYD9WZvESZvap5WQajs1aZ97810shUvboAEhY2W8VTVbIFUagTevxcXPNeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593385; c=relaxed/simple;
	bh=g7u7d1wZPwtoN/PtUzTvbxLpAbH8gsLgb++ccHxDSp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbRZc/OrfwsfYKFzO8+j7ZqD0S3mV6yL87yHwb5EgY+wDaKB93cUfm12txxISFL5w59aDYQ96ypO5uSZkV3g7AqyhOS/4OEKs2Bd3kXGPKIa7KLn1EoJwJURtbVsSVh50aARymT0x2f/hQN4sqG01IiL8jj/40ryvqAUXCsubrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p89BgTC1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p89BgTC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485CFC4CEFD;
	Mon, 27 Oct 2025 19:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593385;
	bh=g7u7d1wZPwtoN/PtUzTvbxLpAbH8gsLgb++ccHxDSp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p89BgTC1+Tm4JfbvES8lLewXT8tusRVKDuVn4a3Eot8gXTzi5oFK2JEbQn9Mf7MUU
	 2O72qpWcX8KwX0elgURMG1GnRR6HyirKq/CXCTTHEPtLJkarpyGdKacfSGPd1UKUlw
	 fpIUwH9y96iKGslwCEnczYpdf7fPsL0LBW8GzLhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 110/184] mm/damon/core: fix list_add_tail() call on damon_call()
Date: Mon, 27 Oct 2025 19:36:32 +0100
Message-ID: <20251027183517.886255693@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit c3fa5b1bfd8380d935fa961f2ac166bdf000f418 upstream.

Each damon_ctx maintains callback requests using a linked list
(damon_ctx->call_controls).  When a new callback request is received via
damon_call(), the new request should be added to the list.  However, the
function is making a mistake at list_add_tail() invocation: putting the
new item to add and the list head to add it before, in the opposite order.
Because of the linked list manipulation implementation, the new request
can still be reached from the context's list head.  But the list items
that were added before the new request are dropped from the list.

As a result, the callbacks are unexpectedly not invocated.  Worse yet, if
the dropped callback requests were dynamically allocated, the memory is
leaked.  Actually DAMON sysfs interface is using a dynamically allocated
repeat-mode callback request for automatic essential stats update.  And
because the online DAMON parameters commit is using a non-repeat-mode
callback request, the issue can easily be reproduced, like below.

    # damo start --damos_action stat --refresh_stat 1s
    # damo tune --damos_action stat --refresh_stat 1s

The first command dynamically allocates the repeat-mode callback request
for automatic essential stat update.  Users can see the essential stats
are automatically updated for every second, using the sysfs interface.

The second command calls damon_commit() with a new callback request that
was made for the commit.  As a result, the previously added repeat-mode
callback request is dropped from the list.  The automatic stats refresh
stops working, and the memory for the repeat-mode callback request is
leaked.  It can be confirmed using kmemleak.

Fix the mistake on the list_add_tail() call.

Link: https://lkml.kernel.org/r/20251014205939.1206-1-sj@kernel.org
Fixes: 004ded6bee11 ("mm/damon: accept parallel damon_call() requests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1422,7 +1422,7 @@ int damon_call(struct damon_ctx *ctx, st
 	INIT_LIST_HEAD(&control->list);
 
 	mutex_lock(&ctx->call_controls_lock);
-	list_add_tail(&ctx->call_controls, &control->list);
+	list_add_tail(&control->list, &ctx->call_controls);
 	mutex_unlock(&ctx->call_controls_lock);
 	if (!damon_is_running(ctx))
 		return -EINVAL;


