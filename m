Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6031578B4C;
	Wed,  7 Aug 2024 15:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043232; cv=none; b=b+KJAfvFhQK2CLW3p3pOmnL2PI5ZtbLL4781EWzOK11I4cJKNpwlXS7lw5VhldkKHbHMCubZ3/F6Ku8hAPaZSF2QmReG7KO/UYyDTwpB06xGu6vl/IAD90+C2briB3g55/vECaaPsa/msCwWGxB3Ai4xEGdG/H1/HsQzDBvWPLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043232; c=relaxed/simple;
	bh=PTbuYNMdoEm4M8JqLheB/O4oQym8LbCASUL8yD8Xu8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FJrhw7UHloTxU9gimEwiNUzVabfxzvR0JSm3EEU2okEwgWk9dUfcYE/bditYO4cqamsBud9Oc7t1nOiby5byhcJuftCftz/Q5yfMoH8V22JEX7mXwm5WoKVEo02L3ml5HAi3pgdiKlpjSH57GxNYEXjwXDvTY7+IT3INkNolFrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJq02viY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJq02viY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6742C32781;
	Wed,  7 Aug 2024 15:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043232;
	bh=PTbuYNMdoEm4M8JqLheB/O4oQym8LbCASUL8yD8Xu8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJq02viYO525EB9gX3/meBJhZN16Gw0OxCcD/EGOsgTsj/zN1ZCjJDgqA1cha6loR
	 4k7IJPcupVFwN0mtq7xX6LY6hQWSI1vICPPb6FL0cUDWQ2UKAm/pPfL16xv4D7yR9s
	 nrUyn+IHjN7Gm1sF1mXslq1gUDpjYhtbZA424uH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Joel Granados <j.granados@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/121] sysctl: always initialize i_uid/i_gid
Date: Wed,  7 Aug 2024 16:59:08 +0200
Message-ID: <20240807150019.894308282@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 fs/proc/proc_sysctl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index cec67e6a6678f..071a71eb1a2d4 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -480,12 +480,10 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
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
-- 
2.43.0



