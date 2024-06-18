Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B81185E57;
	Tue, 18 Jun 2024 13:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715603; cv=none; b=cwZtdcW3KSyGoe402x1W2OAGQCPEe40yjUOfTYIIVbNqFk/h8lNDol0w+TBPkyAysFzvHB+Os7NR356W82DMFz0kpD63Fa2FJs55kD3EJqS5xhvGLEWBY7DYOdyJxOxgdeZmqcOyAOg1/Hnr9qUt/4kI5+cKZFOIgs/1mYN09LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715603; c=relaxed/simple;
	bh=60u66dya/yG+ClucxOI8N9R1Gt+rULQaPgcor+EWyTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pt+lpfZegqsVSzJX1PA/8jlWN1UjZk/E6xy7HyqoujjdxF8QyAGnqi1S4K/NlR2WIAlV5eSQJCW6esXu+1LOO8zRfysP5Ky+3WFSmBODLxHN1wSIzHinN2+D0CSKUv0t/Jo2e+uArEMZjncjgs49whVLTR8c2YiOrJyTwL5Jq4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAbWKVLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAbWKVLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E493C3277B;
	Tue, 18 Jun 2024 13:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715603;
	bh=60u66dya/yG+ClucxOI8N9R1Gt+rULQaPgcor+EWyTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAbWKVLU+UjFwyD8JHzuU8rVpKv5ke4sCfEKZxgFj6DWaiF47jPTNe4zf/PngpVZ4
	 dHqupvvJpBDyjjwtcD0rsfaikOB8P/p4ygwi1WdnFcFBEiF7XHtWH2wUSYnlBuBLIk
	 WrA0OTr+oWQxxSPnT23nYx3eth+PmGzN4VdNr/zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 364/770] fsnotify: Dont insert unmergeable events in hashtable
Date: Tue, 18 Jun 2024 14:33:37 +0200
Message-ID: <20240618123421.319602434@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit cc53b55f697fe5aa98bdbfdfe67c6401da242155 ]

Some events, like the overflow event, are not mergeable, so they are not
hashed.  But, when failing inside fsnotify_add_event for lack of space,
fsnotify_add_event() still calls the insert hook, which adds the
overflow event to the merge list.  Add a check to prevent any kind of
unmergeable event to be inserted in the hashtable.

Fixes: 94e00d28a680 ("fsnotify: use hash table for faster events merge")
Link: https://lore.kernel.org/r/20211025192746.66445-5-krisman@collabora.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 057abd2cf8875..310246f8d3f19 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -702,6 +702,9 @@ static void fanotify_insert_event(struct fsnotify_group *group,
 
 	assert_spin_locked(&group->notification_lock);
 
+	if (!fanotify_is_hashed_event(event->mask))
+		return;
+
 	pr_debug("%s: group=%p event=%p bucket=%u\n", __func__,
 		 group, event, bucket);
 
@@ -779,8 +782,7 @@ static int fanotify_handle_event(struct fsnotify_group *group, u32 mask,
 
 	fsn_event = &event->fse;
 	ret = fsnotify_add_event(group, fsn_event, fanotify_merge,
-				 fanotify_is_hashed_event(mask) ?
-				 fanotify_insert_event : NULL);
+				 fanotify_insert_event);
 	if (ret) {
 		/* Permission events shouldn't be merged */
 		BUG_ON(ret == 1 && mask & FANOTIFY_PERM_EVENTS);
-- 
2.43.0



