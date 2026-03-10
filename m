Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3B82BF3E2;
	Tue, 10 Mar 2026 11:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141099; cv=none; b=EPbf64/LJop25EThrv2R5jhbh/R5rbl1+JcFrz+IY9EiBT70/m3Q4b0mAC+HdEjPb+bnPo/eJkP8cq4rhTFnndbjTkF+KwNa4molGSKYxTBu+pppeEn4aFkW05Vcy45fORK1pH8ObZ3WMqI9Vqrqn0Q7PrkrJVJ1OYO8uUtmVCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141099; c=relaxed/simple;
	bh=4/vF/GhRHwRjNMenJ2yq7uKjxNQ8DvjC3wGc2xj0UNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzK4Yro1k7J4rTi3sRxr48Hzmyd3hlZ+Ip7GxTtEs5vL88xfmU8b17QAmBSNecxEwpJMrDILREaFRlTTmDQy9z5QwInHGpdrK8eWuKCjMpJeiUc7/tRF7dIz9O7nB3Pqj5tFZPrNEwEDUa9naDYTz0W4MFX21v1Dqq6s6tMafZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iLTO+u2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iLTO+u2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2964C2BC9E;
	Tue, 10 Mar 2026 11:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141099;
	bh=4/vF/GhRHwRjNMenJ2yq7uKjxNQ8DvjC3wGc2xj0UNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLTO+u2IsPU6kbhE7qnO1OzI52UU3JvUrmxdrrK/6P/IzEwcTPSUa8bABTE7bW0Xv
	 1H36oosVAjXnAuPqo6GItanQS7QQN4itiVOh94bMT+jUVtMmf22q3EBss5vkyiPDj/
	 Awh04g81Sjg+u/NQq6imQ5fdwe2OKxqJnlwvq3BakX/ssjTXvZk90yu/QR3bp2uoHP
	 upsptAlAPyChn4YHdYG0Tlvr94Xv5xp9QUx3Ep+tRRKn0S8Sw5ZZ+xdXwfRVlZOx5k
	 gICwTHAQT+VsA8MV6vhxDJf/2zU5nsECKdJFWOyi9cYxmHk8sztvB+WXvS+QwzDXe2
	 xFY589yRVzteQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jann Horn <jannh@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Christian Brauner <brauner@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 100/311] eventpoll: Fix integer overflow in ep_loop_check_proc()
Date: Tue, 10 Mar 2026 07:02:27 -0400
Message-ID: <ee6f98343d509bf0287ea5f9f2921a182c925971.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 6c36d9dc6926f..d20917b03161b 100644
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

