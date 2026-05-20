Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33613546D9;
	Wed, 20 May 2026 16:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295501; cv=none; b=hIsdaQadDTmaLVtSK1Y2cL3C3ZVLUAmugT1nyy5+gfANl8zVdLSgIGzaF4pvv3e72yucxMVeqmvljlsBI9ElcnPcivVCA3c3OA+V5Yzj7ZyCj8ESAPo3e08Ly3b+XzL/kY6LL8Ok5zW8FOP+De/wzz+9NBaotb+SXoQYkYk/k0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295501; c=relaxed/simple;
	bh=XifkKyNTYQs6QgV3iVMJKRZXtk9C92ojaJwqFB0eqXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLym7ynfoTRcflvsLZFR155PLCpMgvL8Aj8nIPZlioSvGBTe+Myw3IICzmkqZUTRSgYLu3DQXh7pxZZMLCotB4nUxf9AKEXSaHjk+373535FtS1UcxI5SGg6NCrZKoUtmQQqLHn9y72/K0UX/t5sXFaA3FP9VU7JD8snDDna9Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GnTgGp4S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GnTgGp4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A3D1F000E9;
	Wed, 20 May 2026 16:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295500;
	bh=ehiHBCdYl6OH4EnTClmuJhll00FHMMS+EWLrqlC7UCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GnTgGp4S3D0jKm8zzk4BbtxqgqZIhSnP4FpP0jrwfRqbe99SeRjxekrteOQmUoKqB
	 +HBsI7dlk53I+toi3zKMIN3MjG/aW4Qgqar+VzSPrVd5MpTkfo+JBwKfFL2Zo3bbJt
	 w550erTg97pl4ZsNS6Ia9CC0s0mBp1giaLvCXw88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0444/1146] fanotify: avoid/silence premature LSM capability checks
Date: Wed, 20 May 2026 18:11:34 +0200
Message-ID: <20260520162158.246488041@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index c2dcb25151deb..5d030fbb2dffe 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1615,17 +1615,18 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
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
@@ -1990,8 +1991,8 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
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



