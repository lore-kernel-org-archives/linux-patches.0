Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B4A1A76AE;
	Tue, 30 Jul 2024 17:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360018; cv=none; b=JFgsT0albWZoSV5qW98tGuI2oxE8Y52mrb/yBKOSECSWTPC1acDopIyAz70QPMMVN1nYsRN/2wgOEfSeNAcxhUGtwZ43PclMA3W057/qAXWH7saB2HsOk1r9Ujqxd59H8uhgCn+V4I/d4Guy4BJ8RCxUSEXScvuM98DWBW4dOVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360018; c=relaxed/simple;
	bh=oNAvr7N3d8Hn1h4mPBIwDSsrdCjNrUQvMyRShU2f6Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gEA2DX7bTsuVKfZPyaj7dBX2kttFza6CAeD60NBiUN1WXXgk2HuJbomsgVYUZY5P3gRa61hBPnRvNaMoI7+YmeFmkY4qS80PwSFZCvGYXLdIwLVo42doCQV8XQoKrBoJul8mI8Z4BnuLOvci+0b2qA9ziz9SU3Or7lryNPXg9e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=puLXMwfJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="puLXMwfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F6DC32782;
	Tue, 30 Jul 2024 17:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360018;
	bh=oNAvr7N3d8Hn1h4mPBIwDSsrdCjNrUQvMyRShU2f6Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puLXMwfJe8+HF2khM/TwbO1yX2WdbZeBaQCFVjTAvX0wb9vPNfWjPmvYmhsh2IgxE
	 UUcPIcycmmDK6zcd5cHrbzhIO9e2kWYFFz9eV+UItCkorpIHTDZDrxNOh4yX3bxEnH
	 YniGkXtpSzttRd7EUnZti9sc+5Us80ChvG3boN7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Joel Granados <j.granados@samsung.com>
Subject: [PATCH 6.10 572/809] sysctl: always initialize i_uid/i_gid
Date: Tue, 30 Jul 2024 17:47:28 +0200
Message-ID: <20240730151747.369180850@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit 98ca62ba9e2be5863c7d069f84f7166b45a5b2f4 upstream.

Always initialize i_uid/i_gid inside the sysfs core so set_ownership()
can safely skip setting them.

Commit 5ec27ec735ba ("fs/proc/proc_sysctl.c: fix the default values of
i_uid/i_gid on /proc/sys inodes.") added defaults for i_uid/i_gid when
set_ownership() was not implemented. It also missed adjusting
net_ctl_set_ownership() to use the same default values in case the
computation of a better value failed.

Fixes: 5ec27ec735ba ("fs/proc/proc_sysctl.c: fix the default values of i_uid/i_gid on /proc/sys inodes.")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Joel Granados <j.granados@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/proc_sysctl.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -476,12 +476,10 @@ static struct inode *proc_sys_make_inode
 			make_empty_dir_inode(inode);
 	}
 
+	inode->i_uid = GLOBAL_ROOT_UID;
+	inode->i_gid = GLOBAL_ROOT_GID;
 	if (root->set_ownership)
 		root->set_ownership(head, &inode->i_uid, &inode->i_gid);
-	else {
-		inode->i_uid = GLOBAL_ROOT_UID;
-		inode->i_gid = GLOBAL_ROOT_GID;
-	}
 
 	return inode;
 }


