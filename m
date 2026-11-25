Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621082;
	b=dNF7xy09Nmmoq+4WoJWro/ZAVNld7UCQVFiTDBLI6gF2ZGh0fLGKPQCyLQGZine82Myf
	 xBZtQozLwnydpScjYfF4a9PWAy+NBxjF51fhIj+vcAqze7IJSi7/oy7ZfLFax5YbAAtEF
	 u9F6BDW3YPDd9A1Qh7qINE0TYqdZPPwGqBXKHHspjyUKHokW8L97ySh/ZBr44v6tx/e3a
	 Qos2faFuq0lRTUxqjsbddvQP+w8JXDUxIdgPYcb08Pw1lTyuwDcddSKiX6S48hfEFFrXJ
	 M79DDXJeqycpkuKafuEbXE4NrwGXQEEIxN+7JuI6aRTynbAdo1tW9HCfXlnRSGjEbkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+18no149A2up8V7s39R9aPoiarpDDjWVW7qDiMys76E=;
	b=RQmxh4WyV9R+plRw6SbUavqyqrg/hYtyMoMfCHJnbPvkwB/JK40l0GIj5/Kqk1J1xSqw
	 bizyqOsfFr2SRqwuE6o4oP7PpQIfHjFXy/EIOei7+bZJan5OCpDd5GTGVP0HTu3Jqi2T4
	 ew0Q0CAJpksgsiNk/AoI9eGJEHZGnflHmtex227tI9DECvUv6H1VdFQBzq2C9BIFjC4r4
	 cFYTvSKN1BXy7idRMHDLKwX8xBO4d2ur15Z+o9YmVvPsivv29bifpFiCQyTFDAcHTdOk4
	 gDfhKN3AD5tJ9UONV57Qd568jrF7OD1Y+Pone36ANzUFbI2HacBjyvuA/sLf739pPXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hw4YESAr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A366A606A31E;
	Wed, 25 Nov 2026 15:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hw4YESAr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9641F000C4;
	Wed, 25 Nov 2026 15:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621082;
	bh=+18no149A2up8V7s39R9aPoiarpDDjWVW7qDiMys76E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hw4YESArVbG8YUolilEJV8UX4am0WC14RTT9BoMoU/bNzK2Y2aYFSgXYAnhxFdD7Y
	 x/pN/9UmrkSIUBJs09J4umgua5Voi7kYInxd7jSSmcl8l+7y6WAwD8BT2VpbfoaFZk
	 jg6Tq0uX0TQwFUulWKwj69WGebYGy3p+JnBRK6zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 070/990] fsnotify: preserve 64-bit pre-content ranges
Date: Wed, 25 Nov 2026 15:23:57 +0100
Message-ID: <20261125143823.727911163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 1dcf2be94b9be2d366a0d2b70c2b1c7ebccf1443 ]

vfs_fallocate() and remap_verify_area() pass 64-bit lengths to
fsnotify_file_area_perm(), which truncates them to size_t on
32-bit systems.

Use 64 bit (unsigned) types throughout the entire pre-content
notification chain to keep the full range. The userspace range
field is already 64-bits.

Fixes: 9740d17162de ("fsnotify: pass optional file access range in pre-content event")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Link: https://patch.msgid.link/20261015175701.3674449-1-thnkslprpt@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.h    | 2 +-
 fs/notify/fsnotify.c             | 2 +-
 include/linux/fsnotify.h         | 4 ++--
 include/linux/fsnotify_backend.h | 6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 775f55080dd4d..aa19675452d7b 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -443,7 +443,7 @@ struct fanotify_perm_event {
 	struct fanotify_event fae;
 	struct path path;
 	loff_t pos;			/* FANOTIFY_NO_RANGE if unavailable */
-	size_t count;
+	u64 count;
 	u32 response;			/* userspace answer to the event */
 	unsigned short state;		/* state of the event */
 	unsigned short watchdog_cnt;	/* already scanned by watchdog? */
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index cae0adce6d47a..f081bfba4dd92 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -210,7 +210,7 @@ static inline __u32 fsnotify_object_watched(struct inode *inode, __u32 mnt_mask,
 
 /* Report pre-content event with optional range info */
 int fsnotify_pre_content(const struct path *path, const loff_t *ppos,
-			 size_t count)
+			 u64 count)
 {
 	struct file_range range;
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 28a9cb13fbfa3..c4461411dc55e 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -135,7 +135,7 @@ int fsnotify_open_perm_and_set_mode(struct file *file);
  * fsnotify_file_area_perm - permission hook before access to file range
  */
 static inline int fsnotify_file_area_perm(struct file *file, int perm_mask,
-					  const loff_t *ppos, size_t count)
+					  const loff_t *ppos, u64 count)
 {
 	/*
 	 * filesystem may be modified in the context of permission events
@@ -213,7 +213,7 @@ static inline int fsnotify_open_perm_and_set_mode(struct file *file)
 }
 
 static inline int fsnotify_file_area_perm(struct file *file, int perm_mask,
-					  const loff_t *ppos, size_t count)
+					  const loff_t *ppos, u64 count)
 {
 	return 0;
 }
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index d67a893d75fa6..042f0e7f159d1 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -322,7 +322,7 @@ struct fs_error_report {
 struct file_range {
 	const struct path *path;
 	loff_t pos;
-	size_t count;
+	u64 count;
 };
 
 static inline const struct path *file_range_path(const struct file_range *range)
@@ -922,12 +922,12 @@ static inline void fsnotify_init_event(struct fsnotify_event *event)
 	INIT_LIST_HEAD(&event->list);
 }
 int fsnotify_pre_content(const struct path *path, const loff_t *ppos,
-			 size_t count);
+			 u64 count);
 
 #else
 
 static inline int fsnotify_pre_content(const struct path *path,
-				       const loff_t *ppos, size_t count)
+				       const loff_t *ppos, u64 count)
 {
 	return 0;
 }
-- 
2.53.0



