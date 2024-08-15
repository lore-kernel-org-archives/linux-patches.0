Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7083214;
	Thu, 15 Aug 2024 14:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732670; cv=none; b=DXUiO4K7RZkxhZKbh2HXT12LqBwNzv7LacpSDUOrr3F2HueczxuqXk4enkqG0Yrk1bsg8d2PDRweavb28yh5NzFMqr4pRU3IG4/7R1vXeLMdJUFeP3wcJqvr3NMS7wzib3PmIzMyxA21IsbYv0APMquibcXJJEPPzjnOeXu0tjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732670; c=relaxed/simple;
	bh=ymx201nHQuVYpjqe9KUkrGCaJa5sdO1DgmcbplGsLoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=spnLKArAw8CULXyd2UX/6s6x9099Ve63l45X0t5oWtir5HuDr4F/nNjdG2GfUbu1oGo55qA398jhJUbalDLCAuv4mjsXIW3Lk+R6hqJUGNTkS8oK3ABHFF4vR7pNyVafxuYoK2kptpHPRaB6GUvojKPwxm65VltVVtO4H4rge7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fv7XZu1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fv7XZu1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5029C32786;
	Thu, 15 Aug 2024 14:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732670;
	bh=ymx201nHQuVYpjqe9KUkrGCaJa5sdO1DgmcbplGsLoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fv7XZu1gQYo0xxJDd4iIqKKCMiBiRZ9tSUbXV9UEdgZ+Iq8tyGopXg/ds+Yd7tR0+
	 yR8SJgJ2Vom4QG8zl7NHEFzXn/nzdDDqMslQKxzbZgj127Y5l1DdxwMgy/Y0gzMPsJ
	 ySveOI0WPZEiTtoqVZCtoriM/9m9y00Esh4wgkLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Joel Granados <j.granados@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/352] sysctl: always initialize i_uid/i_gid
Date: Thu, 15 Aug 2024 15:24:45 +0200
Message-ID: <20240815131927.754421811@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 98ca62ba9e2be5863c7d069f84f7166b45a5b2f4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/proc_sysctl.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -471,12 +471,10 @@ static struct inode *proc_sys_make_inode
 			make_empty_dir_inode(inode);
 	}
 
+	inode->i_uid = GLOBAL_ROOT_UID;
+	inode->i_gid = GLOBAL_ROOT_GID;
 	if (root->set_ownership)
 		root->set_ownership(head, table, &inode->i_uid, &inode->i_gid);
-	else {
-		inode->i_uid = GLOBAL_ROOT_UID;
-		inode->i_gid = GLOBAL_ROOT_GID;
-	}
 
 	return inode;
 }


