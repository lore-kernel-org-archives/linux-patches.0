Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AF235973;
	Tue,  8 Apr 2025 11:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112224; cv=none; b=dK0bn1NbhNXaBplq0u5dPW/0JnlxIqNAe3GNiYVT9wcF0vW1dYRU+hQZM/CAG2nl6SWo3zNHeHomInyddxSWJqZN9/fzNARLfk1iSW1M/Y+m6lHyFkTTFGuEa9Cf+gwPS+Wpm+GwBNIvXi9FOYM76cOT88o6+sPIwLL8RKWdu4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112224; c=relaxed/simple;
	bh=jDsj6MgTzKJ5oHBIcpDnNmsvzOPCIdLAlEZxsMIordQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdHuVeheTUlpdzlXCGWyuNCTFKB9R/OPuiImnNDm4iRyweZhL34WIJvcCiq8QzVMZQSGOXUsXgBXGElShsk1UP7Ai3E2ztxCU1OBtTY1i3ysvpHl/ST6e2MuNBmJE8IEd+ndBqT8JMVZMp7+1QLt8qx9rlEUNzlpolicTXxfF6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GS8xnrnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GS8xnrnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A9FC4CEE5;
	Tue,  8 Apr 2025 11:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112224;
	bh=jDsj6MgTzKJ5oHBIcpDnNmsvzOPCIdLAlEZxsMIordQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GS8xnrnpPALquHpFYaCetsi9flmI2sjaiutEI9fReA49CQGy/lTdIaWAfdTpXhpy1
	 nGgMVn1vnB7Y1PFUQWaaD2SY/E8nTMusqLKMrYB1DQ5CKDcu7il7NX918bT20A3NhD
	 6fbNjLl2sJzWUus0Mnb2Rh/xuy2w9S+Slezu29rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.14 681/731] bcachefs: bch2_ioctl_subvolume_destroy() fixes
Date: Tue,  8 Apr 2025 12:49:38 +0200
Message-ID: <20250408104930.108888835@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

[ Upstream commit 707549600c4a012ed71c0204a7992a679880bf33 ]

bch2_evict_subvolume_inodes() was getting stuck - due to incorrectly
pruning the dcache.

Also, fix missing permissions checks.

Reported-by: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/fs-ioctl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -515,10 +515,12 @@ static long bch2_ioctl_subvolume_destroy
 		ret = -ENOENT;
 		goto err;
 	}
-	ret = __bch2_unlink(dir, victim, true);
+
+	ret =   inode_permission(file_mnt_idmap(filp), d_inode(victim), MAY_WRITE) ?:
+		__bch2_unlink(dir, victim, true);
 	if (!ret) {
 		fsnotify_rmdir(dir, victim);
-		d_delete(victim);
+		d_invalidate(victim);
 	}
 err:
 	inode_unlock(dir);


