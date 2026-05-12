Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8053EDE48;
	Tue, 12 May 2026 18:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608879; cv=none; b=Cco71mdjiUfOjJp2u0FqQBYdX+N3GsdAThmHUcXouwcDuT9608P8Ab6dJ/aUfpl1id//VDUMJ2UceU5p8vz+xPde91yK/y67FCUY+ef3xuFArQHc5rTiB0EtcH7PJGBZn6ZRmc4Ta3sxjxlk1o6VWUFh18rx/+qyAuRBOIYlY/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608879; c=relaxed/simple;
	bh=4bB2j1n6ccelR5uHqtJByC9wB8IwTbPPAIYGL/2wxc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvbId4ddQ0hRNDaCahQdgnBXzqdCSaeI3uBMDHmhFpow/Qp7zsCjYxwI1kEFSQlrM0+Iskn9HWNaaozNcegTpbLZuDWRdZs9HT/XEpVsvtFyU6LAfbBXhxUICZ40CEgfle5PaV43Pl6ZHBmSY9juW7Bp0Rv9dL68kR2oNthgFDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWkeIy+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWkeIy+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7ACC2BCB0;
	Tue, 12 May 2026 18:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608879;
	bh=4bB2j1n6ccelR5uHqtJByC9wB8IwTbPPAIYGL/2wxc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWkeIy+7jBBlCuFLxBoLqmVyhXMa/dKJ8UyP2tgP61xxNnHlYm3Ox3ow6mdhUZbI1
	 kzVSFzCmiKYAU9ol5Kpk5r09IQGYcveJb5ABAsDG0mPjSYIBLqjYhzVh8yIIrs+dVs
	 YvNmfdDwV+3x5vmTfY8UB68txUUm30hkrwqScoaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 249/270] mm/damon/core: disallow non-power of two min_region_sz on damon_start()
Date: Tue, 12 May 2026 19:40:50 +0200
Message-ID: <20260512173943.682064705@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 95093e5cb4c5b50a5b1a4b79f2942b62744bd66a upstream.

Commit d8f867fa0825 ("mm/damon: add damon_ctx->min_sz_region") introduced
a bug that allows unaligned DAMON region address ranges.  Commit
c80f46ac228b ("mm/damon/core: disallow non-power of two min_region_sz")
fixed it, but only for damon_commit_ctx() use case.  Still, DAMON sysfs
interface can emit non-power of two min_region_sz via damon_start().  Fix
the path by adding the is_power_of_2() check on damon_start().

The issue was discovered by sashiko [1].

Link: https://lore.kernel.org/20260411213638.77768-1-sj@kernel.org
Link: https://lore.kernel.org/20260403155530.64647-1-sj@kernel.org [1]
Fixes: d8f867fa0825 ("mm/damon: add damon_ctx->min_sz_region")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1352,6 +1352,11 @@ int damon_start(struct damon_ctx **ctxs,
 	int i;
 	int err = 0;
 
+	for (i = 0; i < nr_ctxs; i++) {
+		if (!is_power_of_2(ctxs[i]->min_sz_region))
+			return -EINVAL;
+	}
+
 	mutex_lock(&damon_lock);
 	if ((exclusive && nr_running_ctxs) ||
 			(!exclusive && running_exclusive_ctxs)) {


