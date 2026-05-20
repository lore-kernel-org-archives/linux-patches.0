Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D0D2367DF;
	Wed, 20 May 2026 17:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298261; cv=none; b=O3Y5qJpYpJIcFfwy7SmA2GjJ3V76zMlIWKdMSGrBE0Zdhul00fLoL+dOGr/l/VPNDeCXLfqmimZFN1/bG9JrbV1IEtb8xxpSRORNc0vWDMo1W4j6kIYExch1XhvSdUy1ZUL2yGMXyZTm/qYEtJc8qGQ5PhxypO7m+WGbrhJYV1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298261; c=relaxed/simple;
	bh=VVh99rP7EUeVS3ezDa5g/qJLq2Armc19U8YoF5hE5ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGuALPASzjfmXumVONqjCc4CAaUxvBSZQcZO4r7dwMhTGPAbP193NZ81WfkAH7EYVYcTp1uWTaNpyOv5z2TyiwqggNtsQZJRKhy42nhgXJpPp7SGWyumn7V3Dw2K/M1FUGlMcn1Jr0syQzCKWFHJM7iiu/JsM6Shm5AcEobsQu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRpU4jWZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRpU4jWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8366E1F000E9;
	Wed, 20 May 2026 17:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298260;
	bh=a0BSvlbuDUgSbUvecoQbZ9Lc/txIt7R+PxIapZ9EAJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gRpU4jWZt7pQU3wGzvt7YoIn74EOgj2oUnp/74FwA7jTdki+0usSZ0YJiE6gwUzzV
	 ayeB2E7KyIwM5OqwY7Yl6KTZBwaxdoNUXJKuLIN7vLKb1uzzs/Eyn43TmXjArzzioo
	 P/zHZdJmu0CTySQ40sOMnjlKcOFRp7QorNDczF3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 342/957] fanotify: avoid/silence premature LSM capability checks
Date: Wed, 20 May 2026 18:13:45 +0200
Message-ID: <20260520162141.949004480@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit 0d5ee3373426395478c355f3e93ba4b1118a04e9 ]

Make sure calling capable()/ns_capable() actually leads to access denied
when false is returned, because these functions emit an audit record
when a Linux Security Module denies the capability, which makes it
difficult to avoid allowing/silencing unnecessary permissions in
security policies (namely with SELinux).

Where the return value just used to set a flag, use the non-auditing
ns_capable_noaudit() instead.

Fixes: 7cea2a3c505e ("fanotify: support limited functionality for unprivileged users")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20260216150625.793013-2-omosnace@redhat.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 1dadda82cae51..1c05c11e3cb25 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1611,17 +1611,18 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	pr_debug("%s: flags=%x event_f_flags=%x\n",
 		 __func__, flags, event_f_flags);
 
-	if (!capable(CAP_SYS_ADMIN)) {
-		/*
-		 * An unprivileged user can setup an fanotify group with
-		 * limited functionality - an unprivileged group is limited to
-		 * notification events with file handles or mount ids and it
-		 * cannot use unlimited queue/marks.
-		 */
-		if ((flags & FANOTIFY_ADMIN_INIT_FLAGS) ||
-		    !(flags & (FANOTIFY_FID_BITS | FAN_REPORT_MNT)))
-			return -EPERM;
+	/*
+	 * An unprivileged user can setup an fanotify group with limited
+	 * functionality - an unprivileged group is limited to notification
+	 * events with file handles or mount ids and it cannot use unlimited
+	 * queue/marks.
+	 */
+	if (((flags & FANOTIFY_ADMIN_INIT_FLAGS) ||
+	     !(flags & (FANOTIFY_FID_BITS | FAN_REPORT_MNT))) &&
+	    !capable(CAP_SYS_ADMIN))
+		return -EPERM;
 
+	if (!ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN)) {
 		/*
 		 * Setting the internal flag FANOTIFY_UNPRIV on the group
 		 * prevents setting mount/filesystem marks on this group and
@@ -2006,8 +2007,8 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 	 * A user is allowed to setup sb/mount/mntns marks only if it is
 	 * capable in the user ns where the group was created.
 	 */
-	if (!ns_capable(group->user_ns, CAP_SYS_ADMIN) &&
-	    mark_type != FAN_MARK_INODE)
+	if (mark_type != FAN_MARK_INODE &&
+	    !ns_capable(group->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/*
-- 
2.53.0



