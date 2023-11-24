Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2E035F04;
	Fri, 24 Nov 2023 18:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gIWC+t+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1EFC433C7;
	Fri, 24 Nov 2023 18:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851354;
	bh=rfCFxeGSs2UFOZJyiZnm5lHLix8fHlICM4D09YiMw9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gIWC+t+f+kmS65Oscmf6MgAeIxxntyVTwqcmRXstD+VtUuAq1Hv8lTuLeZz05BSI
	 MEZirlkxr40YA66fJqqFhCBqpwCyJzhY4+BuHzTEIw71WgfroPJ1uUuu4kyAts7iDC
	 u3Dc1dpBD79jTNmYfwsWur12Cc5DMIOXntgR9iDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6.5 415/491] gfs2: dont withdraw if init_threads() got interrupted
Date: Fri, 24 Nov 2023 17:50:51 +0000
Message-ID: <20231124172037.077557666@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 0cdc6f44e9fdc2d20d720145bf99a39f611f6d61 upstream.

In gfs2_fill_super(), when mounting a gfs2 filesystem is interrupted,
kthread_create() can return -EINTR.  When that happens, we roll back
what has already been done and abort the mount.

Since commit 62dd0f98a0e5 ("gfs2: Flag a withdraw if init_threads()
fails), we are calling gfs2_withdraw_delayed() in gfs2_fill_super();
first via gfs2_make_fs_rw(), then directly.  But gfs2_withdraw_delayed()
only marks the filesystem as withdrawing and relies on a caller further
up the stack to do the actual withdraw, which doesn't exist in the
gfs2_fill_super() case.  Because the filesystem is marked as withdrawing
/ withdrawn, function gfs2_lm_unmount() doesn't release the dlm
lockspace, so when we try to mount that filesystem again, we get:

    gfs2: fsid=gohan:gohan0: Trying to join cluster "lock_dlm", "gohan:gohan0"
    gfs2: fsid=gohan:gohan0: dlm_new_lockspace error -17

Since commit b77b4a4815a9 ("gfs2: Rework freeze / thaw logic"), the
deadlock this gfs2_withdraw_delayed() call was supposed to work around
cannot occur anymore because freeze_go_callback() won't take the
sb->s_umount semaphore unconditionally anymore, so we can get rid of the
gfs2_withdraw_delayed() in gfs2_fill_super() entirely.

Reported-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: stable@vger.kernel.org # v6.5+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/ops_fstype.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1261,10 +1261,8 @@ static int gfs2_fill_super(struct super_
 
 	if (!sb_rdonly(sb)) {
 		error = init_threads(sdp);
-		if (error) {
-			gfs2_withdraw_delayed(sdp);
+		if (error)
 			goto fail_per_node;
-		}
 	}
 
 	error = gfs2_freeze_lock_shared(sdp);


