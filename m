Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBDD47A5D;
	Mon,  1 Apr 2024 16:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988247; cv=none; b=Af5gxAYUuxloPkgf5Iu6+JzLb+9B0zsg8QHOCXuUACfExASnK7bqWoOIwDKl0AFo7e/R3QZreBWPFlJabSc0CSQp94w3TwJ7ZK4CUlR6rgnBt/SY+U6rTrqIRxcq3AJnt+ZMFkN7bLI3Wa8vMBIq17eKes5579BNUtwNzewvUrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988247; c=relaxed/simple;
	bh=p8m179phBJQ5JOMN1fPQBBfh9RxGF3UOMcY/cAH22O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPEXqt2bkBnjOBYmJ3Oyu96UTmM+ASxh38svw9I72Z0gXYf7YFC/SW7kLAsryNcIe9pq46FtESDYASzcX+EBt49HcCX8Fw6gk1SwsrZ4S5e/3g7mdlSOUs5+WbSXjw3QpLopDVg1HSY0vU7hFTeCZOIlxGzFhXT6EQ5hJq9XV1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vt+2RnKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vt+2RnKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949F8C433C7;
	Mon,  1 Apr 2024 16:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988247;
	bh=p8m179phBJQ5JOMN1fPQBBfh9RxGF3UOMcY/cAH22O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vt+2RnKsrBWkhQi17OBzZ1cdEoDZwk49N6w1ncr0TqRzjVF95nBMF/qfs+Q5UfXOO
	 0jd1BmR1d/NCq4/3zIvzfCHUBWNhWt2vOB0YKaATxhsJiPhMOi/PWiKQSZYxoUL6Ln
	 /X5ZiQ4vO96N/MmSqqMBdA9zr6SIulPemXjcXQI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Greear <greearb@candelatech.com>,
	Madhan Sai <madhan.singaraju@candelatech.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 127/432] debugfs: fix wait/cancellation handling during remove
Date: Mon,  1 Apr 2024 17:41:54 +0200
Message-ID: <20240401152556.912119993@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 952c3fce297f12c7ff59380adb66b564e2bc9b64 ]

Ben Greear further reports deadlocks during concurrent debugfs
remove while files are being accessed, even though the code in
question now uses debugfs cancellations. Turns out that despite
all the review on the locking, we missed completely that the
logic is wrong: if the refcount hits zero we can finish (and
need not wait for the completion), but if it doesn't we have
to trigger all the cancellations. As written, we can _never_
get into the loop triggering the cancellations. Fix this, and
explain it better while at it.

Cc: stable@vger.kernel.org
Fixes: 8c88a474357e ("debugfs: add API to allow debugfs operations cancellation")
Reported-by: Ben Greear <greearb@candelatech.com>
Closes: https://lore.kernel.org/r/1c9fa9e5-09f1-0522-fdbc-dbcef4d255ca@candelatech.com
Tested-by: Madhan Sai <madhan.singaraju@candelatech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20240229153635.6bfab7eb34d3.I6c7aeff8c9d6628a8bc1ddcf332205a49d801f17@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/debugfs/inode.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 034a617cb1a5e..a40da00654336 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -751,13 +751,28 @@ static void __debugfs_file_removed(struct dentry *dentry)
 	if ((unsigned long)fsd & DEBUGFS_FSDATA_IS_REAL_FOPS_BIT)
 		return;
 
-	/* if we hit zero, just wait for all to finish */
-	if (!refcount_dec_and_test(&fsd->active_users)) {
-		wait_for_completion(&fsd->active_users_drained);
+	/* if this was the last reference, we're done */
+	if (refcount_dec_and_test(&fsd->active_users))
 		return;
-	}
 
-	/* if we didn't hit zero, try to cancel any we can */
+	/*
+	 * If there's still a reference, the code that obtained it can
+	 * be in different states:
+	 *  - The common case of not using cancellations, or already
+	 *    after debugfs_leave_cancellation(), where we just need
+	 *    to wait for debugfs_file_put() which signals the completion;
+	 *  - inside a cancellation section, i.e. between
+	 *    debugfs_enter_cancellation() and debugfs_leave_cancellation(),
+	 *    in which case we need to trigger the ->cancel() function,
+	 *    and then wait for debugfs_file_put() just like in the
+	 *    previous case;
+	 *  - before debugfs_enter_cancellation() (but obviously after
+	 *    debugfs_file_get()), in which case we may not see the
+	 *    cancellation in the list on the first round of the loop,
+	 *    but debugfs_enter_cancellation() signals the completion
+	 *    after adding it, so this code gets woken up to call the
+	 *    ->cancel() function.
+	 */
 	while (refcount_read(&fsd->active_users)) {
 		struct debugfs_cancellation *c;
 
-- 
2.43.0



