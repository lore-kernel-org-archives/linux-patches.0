Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A602E38A710;
	Tue, 10 Mar 2026 11:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142004; cv=none; b=jJf8XalaA9rMD9WNgwDFE5CQ/ewe1xHfuUdh//sqXYd29KSW59uWBZhFeQRSwUGf2rAOkghfaLC4hHH1JHeAhnfd6r19Ydk/IemAwtC6baEJ//N62T2edD4LnNoifI97Ow0KAA6umKbHXGqRBTXUPD7o8ofl8WJlAjdc66eZGy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142004; c=relaxed/simple;
	bh=G5UVq+1QseGD+La/+F61V1kJGVC+6+aia55c/QpvpSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXArvCyL6RLOqEOPTTxszWgXV8g42nwBs/FbsIFVGy1maF4OsbBhQfasb1M5xgq1Ib6bubXTftndZF38QVD6IDcSSq0FJPOwyMdKl08pLZRObGBapSwa9nteGuSXgRfIUEn8Ii6bzW1ryqCFy9aUXYTG7CGmWjh0EVluVuXqHlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RkTrlTHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RkTrlTHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDEDC2BC86;
	Tue, 10 Mar 2026 11:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142004;
	bh=G5UVq+1QseGD+La/+F61V1kJGVC+6+aia55c/QpvpSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkTrlTHUXJca0yrpt5gNYUeXAg+OwWZi5uhZLb8Wg05b/3mnBqXpyCJmc5cgRfc0U
	 cTC54uQd5H47KY4UfmSfyE+lC5wZHF8lCG1D9GHfwT9DxjFCMSPmFQyV8Bi/TodCTD
	 KeoTEzQ9NdJcGt3nj3MWHWr0k1lWtE06rJGfEm2eWVp4QtVlYnaihUlVSDJJ9zFid0
	 z4wQlPPV1rW13Qi5LmH2zeATp6gYPslaaPFsIZF196qNDJFvZcKt29thCAOLF+vv7D
	 X4HQfyQfdQxbB8MfFxkD0aakG3iNVVxzoLcPdWDbMNtadzEDWills2Hh4bI/y1hQyB
	 YkaGbdArqNFwg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jann Horn <jannh@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Christian Brauner <brauner@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 130/314] eventpoll: Fix integer overflow in ep_loop_check_proc()
Date: Tue, 10 Mar 2026 07:16:29 -0400
Message-ID: <db785e40145858f5eab8b3bec496737454408cde.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jann Horn <jannh@google.com>

commit fdcfce93073d990ed4b71752e31ad1c1d6e9d58b upstream.

If a recursive call to ep_loop_check_proc() hits the `result = INT_MAX`,
an integer overflow will occur in the calling ep_loop_check_proc() at
`result = max(result, ep_loop_check_proc(ep_tovisit, depth + 1) + 1)`,
breaking the recursion depth check.

Fix it by using a different placeholder value that can't lead to an
overflow.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Fixes: f2e467a48287 ("eventpoll: Fix semi-unbounded recursion")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://patch.msgid.link/20260223-epoll-int-overflow-v1-1-452f35132224@google.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index ee7c4b683ec3d..bcc7dcbefc419 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2061,7 +2061,8 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
  * @ep: the &struct eventpoll to be currently checked.
  * @depth: Current depth of the path being checked.
  *
- * Return: depth of the subtree, or INT_MAX if we found a loop or went too deep.
+ * Return: depth of the subtree, or a value bigger than EP_MAX_NESTS if we found
+ * a loop or went too deep.
  */
 static int ep_loop_check_proc(struct eventpoll *ep, int depth)
 {
@@ -2080,7 +2081,7 @@ static int ep_loop_check_proc(struct eventpoll *ep, int depth)
 			struct eventpoll *ep_tovisit;
 			ep_tovisit = epi->ffd.file->private_data;
 			if (ep_tovisit == inserting_into || depth > EP_MAX_NESTS)
-				result = INT_MAX;
+				result = EP_MAX_NESTS+1;
 			else
 				result = max(result, ep_loop_check_proc(ep_tovisit, depth + 1) + 1);
 			if (result > EP_MAX_NESTS)
-- 
2.51.0

