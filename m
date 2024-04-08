Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBC371B20;
	Mon,  8 Apr 2024 13:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582755; cv=none; b=T44BWVpMwAmSvz0ADqBTJzNrNdRDFfRNFiDQxis9Bd4hBzQEsepnNeL7XFK3SRdyQ3vMFsvRuwKQDYOUTuSpg0uJBtr4JmuGArxUvsgAiFD7Ur0qpfskWzqAvxhC3xSlyiXu0libbLJFHvsxQ68TbIvd9zmIoC3TCyXj6SjTdvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582755; c=relaxed/simple;
	bh=Qv4+TDY30l/0dAOScrtEQRjmc6qmrzAGQ0Sj3uvZHTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJuy46qaYnzpm/lu5XFloLtcGBTs97cAz7gr9Jzopin102kwYPn9qaPlVvTUfmdd+5bl4TVmj6r2HfqTeGxynvj9GbQdFm3Wqgv4eBmFRjOaOJhsb0wJq0MY/kx4O8k43zT+XOLyAPTM5J6FkXvbNyfwF43w/zzjpOdVFSP0U5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pa47yOpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pa47yOpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF59C43390;
	Mon,  8 Apr 2024 13:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582755;
	bh=Qv4+TDY30l/0dAOScrtEQRjmc6qmrzAGQ0Sj3uvZHTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pa47yOpWiaD0X6JaUlquv2n/lAb3uIM1QKkJGC1eVYMdQtZlD6Du/2R3aeBZRogAD
	 gAgWg5dfORuAx5KmhxPpUlN2Xt5+vHo9hnTFzlC5SorXsTbNKbbbCkGyww+yTVNG4A
	 3LzKhEvs+/vVD2Ow1DOv4Hx7Q8Bu9Jl8U+xLwkTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 173/690] fsnotify: Add helper to detect overflow_event
Date: Mon,  8 Apr 2024 14:50:39 +0200
Message-ID: <20240408125405.826488174@linuxfoundation.org>
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

[ Upstream commit 808967a0a4d2f4ce6a2005c5692fffbecaf018c1 ]

Similarly to fanotify_is_perm_event and friends, provide a helper
predicate to say whether a mask is of an overflow event.

Link: https://lore.kernel.org/r/20211025192746.66445-9-krisman@collabora.com
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.h    | 3 ++-
 include/linux/fsnotify_backend.h | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 4a5e555dc3d25..c42cf8fd7d798 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -315,7 +315,8 @@ static inline struct path *fanotify_event_path(struct fanotify_event *event)
  */
 static inline bool fanotify_is_hashed_event(u32 mask)
 {
-	return !fanotify_is_perm_event(mask) && !(mask & FS_Q_OVERFLOW);
+	return !(fanotify_is_perm_event(mask) ||
+		 fsnotify_is_overflow_event(mask));
 }
 
 static inline unsigned int fanotify_event_hash_bucket(
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index a2db821e8a8f2..749bc85e1d1c4 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -510,6 +510,11 @@ static inline void fsnotify_queue_overflow(struct fsnotify_group *group)
 	fsnotify_add_event(group, group->overflow_event, NULL, NULL);
 }
 
+static inline bool fsnotify_is_overflow_event(u32 mask)
+{
+	return mask & FS_Q_OVERFLOW;
+}
+
 static inline bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group)
 {
 	assert_spin_locked(&group->notification_lock);
-- 
2.43.0



