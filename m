Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58239248BA0;
	Wed, 15 Jan 2025 10:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937603; cv=none; b=gC4sGW2HUbI/q3ljra+xZOyivWJ6ML88LzSwRtd93m05XUc4MsWy9mRMok3kpsOlVytZ5Ia44o7+rYPq5xEr6grMJn6sRQKGwbYEgr69zZIT/mun+e2YtU/QKvpn03irV0nEskDTlBrBUhWSFGQFw0yN9eCTH5OHM0BxJUXFdqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937603; c=relaxed/simple;
	bh=oIYOhLNh27G2toUvPW+v1wdoi4EIbEVVE8vyZMeNfvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbGtqdvRbCXuiW+XPWkeGkxaB0l8KFrwF3K5CusEsaYOzZT09Mx0r9VGANCcn8Vo0Q+gIsHmhLgHZQ3FavP65VO+5I29TczVIkHkSSm9uXI+vDOgh5HdfLU7t4Dhz2TG5lx1bkmEvY5WFTo0zp62jtm98YPxNWZiOPG4LJYrQDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOeA4+en; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOeA4+en"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F940C4CEE3;
	Wed, 15 Jan 2025 10:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937602;
	bh=oIYOhLNh27G2toUvPW+v1wdoi4EIbEVVE8vyZMeNfvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOeA4+enMsf5fGGTuKS5Gb0J6HpW/lub+Ns0gFN3NE4HvvpwcZO4HRdpm8N5GHhCo
	 cvF/6CKU0D3hdVpVy76TbjW73pOZaULfme5kM+W0n8FyhrAO1X21ulm5VLON8RCLS6
	 n8j0SVVrVvM8gGuJj324CkPoWBqsSv3GLYfS72UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+205c2644abdff9d3f9fc@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 09/92] exfat: fix the infinite loop in exfat_readdir()
Date: Wed, 15 Jan 2025 11:36:27 +0100
Message-ID: <20250115103547.904456104@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit fee873761bd978d077d8c55334b4966ac4cb7b59 ]

If the file system is corrupted so that a cluster is linked to
itself in the cluster chain, and there is an unused directory
entry in the cluster, 'dentry' will not be incremented, causing
condition 'dentry < max_dentries' unable to prevent an infinite
loop.

This infinite loop causes s_lock not to be released, and other
tasks will hang, such as exfat_sync_fs().

This commit stops traversing the cluster chain when there is unused
directory entry in the cluster to avoid this infinite loop.

Reported-by: syzbot+205c2644abdff9d3f9fc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=205c2644abdff9d3f9fc
Tested-by: syzbot+205c2644abdff9d3f9fc@syzkaller.appspotmail.com
Fixes: ca06197382bd ("exfat: add directory operations")
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index d58c69018051..e651ffb06a43 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -125,7 +125,7 @@ static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_ent
 			type = exfat_get_entry_type(ep);
 			if (type == TYPE_UNUSED) {
 				brelse(bh);
-				break;
+				goto out;
 			}
 
 			if (type != TYPE_FILE && type != TYPE_DIR) {
@@ -185,6 +185,7 @@ static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_ent
 		}
 	}
 
+out:
 	dir_entry->namebuf.lfn[0] = '\0';
 	*cpos = EXFAT_DEN_TO_B(dentry);
 	return 0;
-- 
2.39.5



