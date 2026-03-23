Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999E13AD527;
	Mon, 23 Mar 2026 14:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277744; cv=none; b=hjX9AFm3Xlq2yYdOO0qU/I4+e19cTrYYHVohBAgkUhEFSpFo7e3V7AV48t2rhuyntMsJloH+hZCYoT0WcaRFBw0WmQEpMjLksmoFMP6F0N/CUJ798sqKjgmuhSTCnHrJNjMV4BfVAzvPD0jwT75RWUHUp+4K8qvJWgjp2aAr9I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277744; c=relaxed/simple;
	bh=bXUoFdnVEI7vOjgzs5qikcvTG1JeSxbNCtxTslvqMqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmLTdWXmQmIxCRaYJ4EiHcbkEBKpnOsa5mrl/QhOS6pmit+zA6XrNSu2b2uak1PFaR+iPIXhnv1AI36rSJ2gzP4FxcJRd0m1k/VZbYw/3/1ansxUytDWQPAnlFRMnIjsuM5vW3I+f7WcL2qAyHiuiGOXhqhS/IK7yB/aKJXdM5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPrWtAUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPrWtAUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22600C4CEF7;
	Mon, 23 Mar 2026 14:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277744;
	bh=bXUoFdnVEI7vOjgzs5qikcvTG1JeSxbNCtxTslvqMqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPrWtAUhsQ+1vQ/NE1kxuYB1R65ghosM3Z8ICEexiKO5x7qTuWAKGkLC3bApBgpXJ
	 uEJcKlLTyEsxEOFtCqpMvxngBxM8rxBLBFMfYtlQO45ahMg2Scja+0hFPMTMYuF5Xm
	 RdkD1JTqIHD9fiYx19ngcO6HBYG+Ca0O9ONRxEh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 087/567] eventpoll: Fix integer overflow in ep_loop_check_proc()
Date: Mon, 23 Mar 2026 14:40:07 +0100
Message-ID: <20260323134535.983095325@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 fs/eventpoll.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1907,7 +1907,8 @@ static int ep_poll(struct eventpoll *ep,
  * @ep: the &struct eventpoll to be currently checked.
  * @depth: Current depth of the path being checked.
  *
- * Return: depth of the subtree, or INT_MAX if we found a loop or went too deep.
+ * Return: depth of the subtree, or a value bigger than EP_MAX_NESTS if we found
+ * a loop or went too deep.
  */
 static int ep_loop_check_proc(struct eventpoll *ep, int depth)
 {
@@ -1926,7 +1927,7 @@ static int ep_loop_check_proc(struct eve
 			struct eventpoll *ep_tovisit;
 			ep_tovisit = epi->ffd.file->private_data;
 			if (ep_tovisit == inserting_into || depth > EP_MAX_NESTS)
-				result = INT_MAX;
+				result = EP_MAX_NESTS+1;
 			else
 				result = max(result, ep_loop_check_proc(ep_tovisit, depth + 1) + 1);
 			if (result > EP_MAX_NESTS)


