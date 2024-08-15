Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCC219FA7E;
	Thu, 15 Aug 2024 13:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730206; cv=none; b=G8ptaVpA01hXPvQ3azCCO6Pj1LJdrynMigrWLuv9J3mGpgaKf/VMbzwkhED/jFBQpMuc62kqgyFm+vvsXzMFG4FF41zR3kucMEIw4aAdZ1HEIRijtP+0mxvu17Gu3Is1Ex07xKv3UASPJqE/Lj/bwJ6uyEXDzO/jSq21xceJhXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730206; c=relaxed/simple;
	bh=byGt94+Jlib/K9BbGGt5ysOAz7sDK65C0l6JxDrSqzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XJmKGVb2x/awMu30iXjcB94ZRYv4s1Hp3KupaD0IBxc83MWCBLjeQWwQRpqsNa5LrpN56v1DWwmm4uJbIlmtQruENxTPtc7c3mDyo9jl8NbHsmE+VJdunALEuSboWNRW9WIZE9ub+9zQnY8ERKaWBVI4N/cLyp/SWnt7PEBkgrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGbXBE++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGbXBE++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFF9C4AF0C;
	Thu, 15 Aug 2024 13:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730206;
	bh=byGt94+Jlib/K9BbGGt5ysOAz7sDK65C0l6JxDrSqzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGbXBE++IsOSWqPwTBzOs/Vf6sSRvjV/H6Y3GAe9iCgw2ZNSDccmI2jaxP2evccDt
	 +BeRDz7urMppOfcIvsurXk96XOK0XUcJoDszVXzkRzW/RFASkR65jgDYOsQ+69TD3K
	 C9qYn72IO5C4bqcbmfCOXiS0f3PQ+HEeSdzTwlvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Joel Granados <j.granados@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 304/484] sysctl: always initialize i_uid/i_gid
Date: Thu, 15 Aug 2024 15:22:42 +0200
Message-ID: <20240815131953.148941968@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -466,12 +466,10 @@ static struct inode *proc_sys_make_inode
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


