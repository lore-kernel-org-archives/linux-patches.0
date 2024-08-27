Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D6D1C86F6;
	Tue, 27 Aug 2024 15:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772765; cv=none; b=B+rKD+2z3gNjFg4b9PyxDmXUUoS1oSxu/gvVhCQZNadISl9Nn4kSnm3pjmWZP+tYtoUe3Tkypg0EirTm6OUBMojaqnk+TioKwIdP/IiHixUve6jPuILiF8BdCGq4BporieZifjLNmHU5XUF6A3OSiEzZ+lScnpcVahEdnmPZEMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772765; c=relaxed/simple;
	bh=Bb64APcS1l4FoaAdAl/fCj/82zBhsSpFKlvhPxGlOCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRWEJyzIG0LiUFYYvJFIpCgXr8et/9qBrlxX5GJwXytOiT2GuQbELuRZveuidw2RieizE8dsw2gKQ7ixOAWq1uwlqq8kGu1MFTKUHZwoiMRHUVbRWhsxmW7NOu1EGg/oqwjZYG427ImDwX/d3JeNjgd/ShSf2xoqk1nuoGCgaHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEG0Abzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEG0Abzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAB2C61041;
	Tue, 27 Aug 2024 15:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772765;
	bh=Bb64APcS1l4FoaAdAl/fCj/82zBhsSpFKlvhPxGlOCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEG0AbzomJdUpYG0aClpWPLoEb4Wg94RPlgTqpmMNO+lJkV4cFPG4fTBLgJE/LCm5
	 pR/MgtxEuIj1DyJSbWfWRNOOctwICYbqCWCOcmd3fZ8s2NCFxRrbRfxxbSDhVaAxaW
	 1ah1xMtlyFxAYCPm7EOLMZxtoxff2YnStP0xxbe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6.1 313/321] gfs2: dont withdraw if init_threads() got interrupted
Date: Tue, 27 Aug 2024 16:40:21 +0200
Message-ID: <20240827143850.171349155@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1259,10 +1259,8 @@ static int gfs2_fill_super(struct super_
 
 	if (!sb_rdonly(sb)) {
 		error = init_threads(sdp);
-		if (error) {
-			gfs2_withdraw_delayed(sdp);
+		if (error)
 			goto fail_per_node;
-		}
 	}
 
 	error = gfs2_freeze_lock_shared(sdp, &sdp->sd_freeze_gh, 0);


