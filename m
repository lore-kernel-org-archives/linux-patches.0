Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1762C15BB;
	Tue, 31 Mar 2026 16:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975396; cv=none; b=HAQcsKzhQHcJqSdF1O1P2Y+Z6r5Bw73MwFah6/QtPjpOoeBDlZFMsqNiyEtW1JhZApL26FoakVnOk2jE/CCwYIeiXUNrjA+EwrMWLTU3qI5512y81QIZeAYMzD54Rq5eeWgW9Ss/4c6HsZw9njZfzGc9uq0z+R3r4l5rLzl5TPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975396; c=relaxed/simple;
	bh=2xc4OW1jim2NmLLddcR4QugTvKDWns+JpfEOzDiBpZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rur5r0hyEQGtGZbbRUeBcy/2s5UXYLCjJhSK3LPFidypjuQUYsoSUI5bVw6iXldx9o4MleM5Ov4l22OEaUc2amdOiUGAIiHYIUzL8/Qvf2DAk0hwv+8R6y3RfcJF6nBbSVNqQmwh8vWfpH9LnNecj8lmT+uXSOV5eV1nJ1N60tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cP/gQgik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cP/gQgik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9A7C19423;
	Tue, 31 Mar 2026 16:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975396;
	bh=2xc4OW1jim2NmLLddcR4QugTvKDWns+JpfEOzDiBpZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cP/gQgikMszJbtvE9bru0y37e0IiVNceEMGZWt7s0LAVNgrODYyv/kN9ltkNOClF5
	 xMTsd4iFuwjuhMLpNb0SJmRXCdaDqZXKUliVyZ5OLusoADL8phINWEXVuE++qDrgvU
	 MvDOAGKl0dSr8l+A56le6P4Ylt/gyOTZ1hSVBsII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 279/342] mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure
Date: Tue, 31 Mar 2026 18:21:52 +0200
Message-ID: <20260331161809.204150777@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Law <objecting@objecting.org>

commit 7fe000eb32904758a85e62f6ea9483f89d5dabfc upstream.

Patch series "mm/damon/sysfs: fix memory leak and NULL dereference
issues", v4.

DAMON_SYSFS can leak memory under allocation failure, and do NULL pointer
dereference when a privileged user make wrong sequences of control.  Fix
those.


This patch (of 3):

When damon_sysfs_new_test_ctx() fails in damon_sysfs_commit_input(),
param_ctx is leaked because the early return skips the cleanup at the out
label.  Destroy param_ctx before returning.

Link: https://lkml.kernel.org/r/20260321175427.86000-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260321175427.86000-2-sj@kernel.org
Fixes: f0c5118ebb0e ("mm/damon/sysfs: catch commit test ctx alloc failure")
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1526,8 +1526,10 @@ static int damon_sysfs_commit_input(void
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
 	test_ctx = damon_sysfs_new_test_ctx(kdamond->damon_ctx);
-	if (!test_ctx)
+	if (!test_ctx) {
+		damon_destroy_ctx(param_ctx);
 		return -ENOMEM;
+	}
 	err = damon_commit_ctx(test_ctx, param_ctx);
 	if (err)
 		goto out;


