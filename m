Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95320839E6;
	Mon,  8 Apr 2024 13:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582705; cv=none; b=Cr8TMpo950dV2aKHvrQQEgbi0n3/Wjeaz14FCK+F5y99h/YJe3KYT1udSqn3alzRhtjvop8xgL+8cU78aVR5vUqcDBYGQD11K1Pgu8mUbCRluPGyrbQwa2MhGCyX/iMNJYSYweUEO5kBQrfSuSRwm8aIlKaA9SmVcwvIlNe6Xak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582705; c=relaxed/simple;
	bh=aCasu0xm5uSC9JUj3ccDEqSlknuPMIlnS5stDS+i658=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJXHvXtAkVllYD7dN0hNe+Mn6uSF0PmBn62l6ayDBqh2GssUqlXNAlaMp7677pRMW3uZ5P51I/8U1CV9dqiJf+472nMMRjIQeXFUscAcwRLbelzQeaoUuN/a+DN5eG87e55SGzwbWdG4tm9AhmvLPFeSOUD58KPIELln3oAwcwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHYhh5Xg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHYhh5Xg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EEAC433F1;
	Mon,  8 Apr 2024 13:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582705;
	bh=aCasu0xm5uSC9JUj3ccDEqSlknuPMIlnS5stDS+i658=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHYhh5XgDaSH3j0p7l3B+loLISWaoh6YZucXc8M2FTsJSxYDB6y57GV8VNQvFEFkc
	 GjFoWIdGNRIEWDh8KMt9+EoGR578bNCIgW6TImggaqdU4Uq4sGP6+fpy5NDhqjTZ3M
	 xe5Tv6AHt4F8xB37GIaASmccm/vfQsa8HBhw4sok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 169/690] fsnotify: Dont insert unmergeable events in hashtable
Date: Mon,  8 Apr 2024 14:50:35 +0200
Message-ID: <20240408125405.692515983@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



