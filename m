Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D2B374CC;
	Wed,  7 Aug 2024 15:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043591; cv=none; b=BvI9C9CAjqfvBwg036TXFZKN44azLx0DSbDoPPUIkNFAnhEvL13Nnd0HnHewnXw7h76AhMSQ5itPFY2ANcXxi7DAMP5+zzsJCBSfAijfthdPeWSuXYQEZPegkajBu9QAIgT+rNDMQXOgiAnEdYEZDldNXBc830VOZAJF6vKSpAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043591; c=relaxed/simple;
	bh=4I0cN/74Ks3kHrW3WeuMaGEA2fuFtgriFzD+U53QMGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DHENp9frVddIkVIiRcQMsRZE/N6lkB4RafGS9xg4SMNr/exgCMraPTjcQMuoLeSBURGhqB6K/hLV+K5cADOwdnjan5zU9gbFYU872Gb3lxzCp7zlAaDcmqj3Lu8RUsJDa4W5TIEShrubskOsyZUpufdle9gHwQwW5WyBhpuoTrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JP3PuX+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JP3PuX+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE21EC4AF0D;
	Wed,  7 Aug 2024 15:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043591;
	bh=4I0cN/74Ks3kHrW3WeuMaGEA2fuFtgriFzD+U53QMGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JP3PuX+A9RoErQvt7MHNUeUF86gqGqA7c0oX0pmlXziNBc2fZWsNjGng1GMcQwsV+
	 fNCsrLNuWaljHeiCGE29Uej1+HRZFgKbNJUVLol65dTNN+AGO62sVmeSAtzBYa1rmH
	 e7p4AMvYNQb0bPPRLPnHUizcOcDqryZcc7sEntTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Joel Granados <j.granados@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 07/86] sysctl: always initialize i_uid/i_gid
Date: Wed,  7 Aug 2024 16:59:46 +0200
Message-ID: <20240807150039.492996119@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c468cc0f6d69b..df77a7bcce498 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -483,12 +483,10 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
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



