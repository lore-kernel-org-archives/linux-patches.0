Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A722F6931;
	Mon, 13 Apr 2026 16:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097192; cv=none; b=o7e+vo3ZBJN5r4a8TKcqgmYdx2/Z2iSJga2sj/b0+Ampvzp8DDL6nSolt5iAW57mIDkS6cAmt+aqGOdbu8takuMpmuvgUqqqni61koGqwhHRLoMsVyhXrXDUYpw+Nc6XxGisMGicEphX8d+pxUcoZ/qDgy8mpSNDfEa4u/iKqU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097192; c=relaxed/simple;
	bh=FUsXJZSNc57ubSqmmvGiXEu7vrGxkh08vC6uxD379KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvMXX2AjiTfG9HBjk+nYDIv+gVEK7NUqQFyKSzWKLy/v+PCwpIvjOux4UEDQqY2G5rF83BWemr71Eaam/p8qY2+K84QvdlQYHL0r7mI0MpiVtqyB9eGYrmhsS222N3H0vyAQuykwgmOFCR86qXEPgYbLsyxCom8ksncfsRjlEyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aiHnxxLJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aiHnxxLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C88C2BCAF;
	Mon, 13 Apr 2026 16:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097192;
	bh=FUsXJZSNc57ubSqmmvGiXEu7vrGxkh08vC6uxD379KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aiHnxxLJS8cGn0AAbUMmrQQOjKUhXMgU2OGOH/1Tl+7SrSRXlBZxUG8HvygiglMvy
	 j+TAFtrVEoQeYDFEhVU+PMDyj6q+4NE7QhjHRBeFqrWA8Qku4qHKQgRTmS/QOFWOPr
	 ZVdAVfYoXCI5QJBO7Ud6o6bp6c/sYs/Gf/AqbaKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 041/570] eventpoll: Fix integer overflow in ep_loop_check_proc()
Date: Mon, 13 Apr 2026 17:52:52 +0200
Message-ID: <20260413155831.966916445@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1952,7 +1952,8 @@ static int ep_poll(struct eventpoll *ep,
  * @ep: the &struct eventpoll to be currently checked.
  * @depth: Current depth of the path being checked.
  *
- * Return: depth of the subtree, or INT_MAX if we found a loop or went too deep.
+ * Return: depth of the subtree, or a value bigger than EP_MAX_NESTS if we found
+ * a loop or went too deep.
  */
 static int ep_loop_check_proc(struct eventpoll *ep, int depth)
 {
@@ -1971,7 +1972,7 @@ static int ep_loop_check_proc(struct eve
 			struct eventpoll *ep_tovisit;
 			ep_tovisit = epi->ffd.file->private_data;
 			if (ep_tovisit == inserting_into || depth > EP_MAX_NESTS)
-				result = INT_MAX;
+				result = EP_MAX_NESTS+1;
 			else
 				result = max(result, ep_loop_check_proc(ep_tovisit, depth + 1) + 1);
 			if (result > EP_MAX_NESTS)


