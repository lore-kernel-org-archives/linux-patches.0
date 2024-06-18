Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F85156C5F;
	Tue, 18 Jun 2024 13:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715615; cv=none; b=XNvARvgbDWA6cJ+eT4r5BQZ+t4n4WiYehCtsPUbTvNxPSt5pC6ZXyYsFC7G7qa6EijeVq3F8uHnwM1n7yfZYCileKHTE2FuTFUTIotWeQaeGNsxeBbCuoymbygR2NYkIwy87BuhJrwBKa3DbxvcHyXZ21FbqwT1qxnGcv6WDGLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715615; c=relaxed/simple;
	bh=BLWHezxy3MWVf8if1WL+mUcHZMUJ3sjEIBGblWObmC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEpfkHDZOxqKQsoZbxbmYLVfEVotvo/IjBauUZ+m5nQywunSFb7QSj8R9QHuzgBMzkK4SQmn4LHWMKhckcG+bHtbeHrYDPNbcKXFfmSYnU6cMMSy0M8PEdQyip3XNpHR2L5quQ3yxzSYlybNIb1/GufvrBOhtw4QEBxqyhQC8Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIU9z3rs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIU9z3rs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D47C3277B;
	Tue, 18 Jun 2024 13:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715615;
	bh=BLWHezxy3MWVf8if1WL+mUcHZMUJ3sjEIBGblWObmC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIU9z3rsjn4ghc+EmOc2iq+xwKMVOMQHKpfC1w1yIFsxLQv7v0PpRTAnKZki8yFLe
	 CH/AEWmRGKtTwmNvKVAzKiScP22OORULb/OFcrsdgmHyM+nWa3r8IpNQRqpl47RkUI
	 o1vbR1+ufGDtxWgMgVd03l1HqikDKHW1kdhyzmdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 368/770] fsnotify: Add helper to detect overflow_event
Date: Tue, 18 Jun 2024 14:33:41 +0200
Message-ID: <20240618123421.471845416@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



