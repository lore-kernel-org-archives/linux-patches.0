Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AC13AB26B;
	Sat, 30 May 2026 17:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161314; cv=none; b=bQxIqKFS6ATOe0jZzkbRe9REY2uzlMLPxGbjM2LQNqBHULbuA47PuewRgxKXThyW7ljYlTPftawAH/RsP3dAQBgxiMTR6JWWBw5wTDS1NOHhHq5vtcfDjRl1SqCCjoiShWKEsQjlzAAM0XQHQehJtjLAXgI/nUGnXj7XVpKdEZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161314; c=relaxed/simple;
	bh=VGCDtwm/ZlXfC0UW9YavP0eRDsQyfDN3ltHqy/apMPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxOuFfLPRYqtY3h/X0ZqCEg7g1cXjZYklZLZ3SBwkHNAJr7yE8eiwjiqeu/TevgLsujTb1eXZdqIWCSx4bWXWf+dT+HRpqk3inecOz2XA0xDfxFcdp3PazZlgmHSNKxqVWIXCFRYOwX3NB86vcaeLlDoUIpvK26MUhl3QttzShE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isUzj5Fi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isUzj5Fi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BD31F00893;
	Sat, 30 May 2026 17:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161313;
	bh=4p8kJiN/Ba982ly5nr6/hnJzTlkykdmD9fr1AA8aVUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=isUzj5FiXg8ZlNKjYKr7pu9+UnOfC4W5f1ylMc4WSXDHxQPMHRFizHllMSNHvRF0I
	 xd57OPJnmk0JI5joRVbZonJApdug9NQYO7jAIjBH6KR3oDa6sFN4Glankg0GrREjgk
	 +b5Zlef6qYF6gsQfh4/8cXcVWE8QTTtVeWG4zXVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Yuhao Jiang <danisjiang@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 587/969] ocfs2/dlm: fix off-by-one in dlm_match_regions() region comparison
Date: Sat, 30 May 2026 18:01:51 +0200
Message-ID: <20260530160316.620885381@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 01b61e8dda9b0fdb0d4cda43de25f4e390554d7b ]

The local-vs-remote region comparison loop uses '<=' instead of '<',
causing it to read one entry past the valid range of qr_regions.  The
other loops in the same function correctly use '<'.

Fix the loop condition to use '<' for consistency and correctness.

Link: https://lkml.kernel.org/r/SYBPR01MB78813DA26B50EC5E01F00566AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com
Fixes: ea2034416b54 ("ocfs2/dlm: Add message DLM_QUERY_REGION")
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dlm/dlmdomain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index dff3d2a48b608..3cd86b5de10f3 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1002,7 +1002,7 @@ static int dlm_match_regions(struct dlm_ctxt *dlm,
 	for (i = 0; i < localnr; ++i) {
 		foundit = 0;
 		r = remote;
-		for (j = 0; j <= qr->qr_numregions; ++j) {
+		for (j = 0; j < qr->qr_numregions; ++j) {
 			if (!memcmp(l, r, O2HB_MAX_REGION_NAME_LEN)) {
 				foundit = 1;
 				break;
-- 
2.53.0



