Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEA123EA92;
	Mon, 27 Oct 2025 19:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593522; cv=none; b=ne7lwTMQISdfTyLLRmJ/pCMJdrUDZZpLSmhzwWbu93wtuIo6s72BGc+XB7zXWklcqXPl79Zp18YZ1/nI8f+Hzv3mvcAHWqIDPnqX9X6pziaExaQGCgfuHuiVcl/1+s+JspJn8ngFzm3LhoS3jjsn8WDmNrUPZ0DuEZGin9bX1uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593522; c=relaxed/simple;
	bh=ocHmNAMGYSZR+Vd6lMKdggo8W9ieo4dqVfUbbiCB4Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRJYpCGNiKbnfU8eTBV5YMRMV+jxiV+DuCMxYJG31NaBsCVWg7VNzTNxhgQbUbV84Y4KnO95QamO1/45Hzkk6xLbb7VdZ8JDa/f+6SlD26UQMWK6L1s85FzaQ7bL7dXfstzCAZdLXnsQxXIgFT2yOSFAQMqzNzNX4HOONlnTV50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ixi9kzS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ixi9kzS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78C9C4CEF1;
	Mon, 27 Oct 2025 19:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593522;
	bh=ocHmNAMGYSZR+Vd6lMKdggo8W9ieo4dqVfUbbiCB4Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ixi9kzS6xzExpVbeiX+UuEFVEWoDDHPQVF8fVzOBUB8cD0mC7Epfpq2Boy3wCkV+3
	 DqBs4jpgrb4Zszupe/KXpX6bBmrMPu1gPZkBLOFMirPbWMefGXBP4YQyCe+UT+vbyL
	 47SlPHAvlOq5p4QUgs8guNQsbSEkaPiFTJYWCKww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 109/184] mm/damon/core: use damos_commit_quota_goal() for new goal commit
Date: Mon, 27 Oct 2025 19:36:31 +0100
Message-ID: <20251027183517.857332901@linuxfoundation.org>
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

commit 7eca961dd7188f20fdf8ce9ed5018280f79b2438 upstream.

When damos_commit_quota_goals() is called for adding new DAMOS quota goals
of DAMOS_QUOTA_USER_INPUT metric, current_value fields of the new goals
should be also set as requested.

However, damos_commit_quota_goals() is not updating the field for the
case, since it is setting only metrics and target values using
damos_new_quota_goal(), and metric-optional union fields using
damos_commit_quota_goal_union().  As a result, users could see the first
current_value parameter that committed online with a new quota goal is
ignored.  Users are assumed to commit the current_value for
DAMOS_QUOTA_USER_INPUT quota goals, since it is being used as a feedback.
Hence the real impact would be subtle.  That said, this is obviously not
intended behavior.

Fix the issue by using damos_commit_quota_goal() which sets all quota goal
parameters, instead of damos_commit_quota_goal_union(), which sets only
the union fields.

Link: https://lkml.kernel.org/r/20251014001846.279282-1-sj@kernel.org
Fixes: 1aef9df0ee90 ("mm/damon/core: commit damos_quota_goal->nid")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -811,7 +811,7 @@ int damos_commit_quota_goals(struct damo
 				src_goal->metric, src_goal->target_value);
 		if (!new_goal)
 			return -ENOMEM;
-		damos_commit_quota_goal_union(new_goal, src_goal);
+		damos_commit_quota_goal(new_goal, src_goal);
 		damos_add_quota_goal(dst, new_goal);
 	}
 	return 0;


