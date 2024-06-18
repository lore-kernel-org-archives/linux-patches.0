Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACA613B780;
	Tue, 18 Jun 2024 12:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715275; cv=none; b=bKufSkd20076Sj3H9CNITjn3Kn9jsyejdPQviGBu9e4PU7PRDYccDniDjdVG26FynepgoHhVoXdjOP4y4HIjrfM7hgaA503Vfvg6d9TC4o40y9TGz7Zh6hH+jKTzboXKRswu4dJhyqyyZRFB2O7V+n7OsD8YJk+DUYBIZZbcTZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715275; c=relaxed/simple;
	bh=VORCmnoqY4sQL2a8kOPnX/3rHKVH9O6/UcnU0fMEzaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgTS4oi/KxA23NkDK7BkyZuJOs9noY1gD4+5bjHO2GgYHoWH4kGicPxbvBJXA5miDd8B+u9FlIR5gKdQRFXIG4pO7Hl8wzUy6GZIPMRXWZVE+vJW7hcHQhzlxD7GdDsEHmMpzrHhQAfzy4iC8KowAtICpFReBMc3cbKgS8TQdJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxEujvQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxEujvQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8210C3277B;
	Tue, 18 Jun 2024 12:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715275;
	bh=VORCmnoqY4sQL2a8kOPnX/3rHKVH9O6/UcnU0fMEzaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxEujvQNgBrtbiLIkY43cuHGT4OpsquCMcyT9n6pAavtvKg5Q9P4hAnkUdM0RGGTP
	 TwuYLZqHkQqjCCdMJgTc/g1TrmCfzJ1BEOTfv88d4atrpm/z/wxkG9mNh+Zx6HIhiI
	 yzORp9mxSBhaDxBAU+w8M8cx7pUBVqNyyIY2AJlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 254/770] fanotify: limit number of event merge attempts
Date: Tue, 18 Jun 2024 14:31:47 +0200
Message-ID: <20240618123417.080438701@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit b8cd0ee8cda68a888a317991c1e918a8cba1a568 ]

Event merges are expensive when event queue size is large, so limit the
linear search to 128 merge tests.

In combination with 128 size hash table, there is a potential to merge
with up to 16K events in the hashed queue.

Link: https://lore.kernel.org/r/20210304104826.3993892-6-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 50b3abc062156..754e27ead8742 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -148,6 +148,9 @@ static bool fanotify_should_merge(struct fanotify_event *old,
 	return false;
 }
 
+/* Limit event merges to limit CPU overhead per event */
+#define FANOTIFY_MAX_MERGE_EVENTS 128
+
 /* and the list better be locked by something too! */
 static int fanotify_merge(struct fsnotify_group *group,
 			  struct fsnotify_event *event)
@@ -155,6 +158,7 @@ static int fanotify_merge(struct fsnotify_group *group,
 	struct fanotify_event *old, *new = FANOTIFY_E(event);
 	unsigned int bucket = fanotify_event_hash_bucket(group, new);
 	struct hlist_head *hlist = &group->fanotify_data.merge_hash[bucket];
+	int i = 0;
 
 	pr_debug("%s: group=%p event=%p bucket=%u\n", __func__,
 		 group, event, bucket);
@@ -168,6 +172,8 @@ static int fanotify_merge(struct fsnotify_group *group,
 		return 0;
 
 	hlist_for_each_entry(old, hlist, merge_list) {
+		if (++i > FANOTIFY_MAX_MERGE_EVENTS)
+			break;
 		if (fanotify_should_merge(old, new)) {
 			old->mask |= new->mask;
 			return 1;
-- 
2.43.0



