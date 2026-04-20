Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42C52DE6E3;
	Mon, 20 Apr 2026 16:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701222; cv=none; b=eiMyd/2GmvJA56TsfZ4tmbQW5m/zYAV6hnKnIJmsErP14DH+7ISNZWIBsfTvUc73Lsh9HvIBi3Bp0oy08vk7mNSaXSGeLjO2zqCWcX0v/puaHMIWmOui4CtAKh3unpC9FyqwzlbBLRc9g7woBEh/HOKYvaRBVGLFmIg2aeMetzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701222; c=relaxed/simple;
	bh=/81kCo76GsD9R1hzWbcg02TtS/aOKlNMV9oVN80VPH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVFzxh7IJ29LXRDPYZmge+voudeDyRiiQfHQh1I50PjNfMOI63rM04I+BDlwbpxqtiVlNlk6CEllmkgDK3e6Mq6mtQCfNATWHmvSfQx359lrgHU5TONLP/prF97jupQFf59pKQpqOgpfNGWdLFWAagbUzm0KXHdeDTs+xG6dtSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGKDk7b/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGKDk7b/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C35C19425;
	Mon, 20 Apr 2026 16:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701222;
	bh=/81kCo76GsD9R1hzWbcg02TtS/aOKlNMV9oVN80VPH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qGKDk7b/34Kcx1ThNzvHeda+6z4Yqem/7q324VHzNXAvsRS0YIPxHRvQkLrNKFRKz
	 kgImDflU8U5xJnlOQuGJ6EYCYZBBRV+QXVZ+Pe4KYP8SufH5PMeTahSKZddBEW8m5S
	 PT6jITrR0TpBcigbpbokzYLrfXzoP+g9zpt/DWSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Goldwyn Rodrigues <rgoldwyn@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/162] btrfs: tracepoints: get correct superblock from dentry in event btrfs_sync_file()
Date: Mon, 20 Apr 2026 17:40:44 +0200
Message-ID: <20260420153927.461342632@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Goldwyn Rodrigues <rgoldwyn@suse.de>

[ Upstream commit a85b46db143fda5869e7d8df8f258ccef5fa1719 ]

If overlay is used on top of btrfs, dentry->d_sb translates to overlay's
super block and fsid assignment will lead to a crash.

Use file_inode(file)->i_sb to always get btrfs_sb.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/btrfs.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 0ca86909ce5bd..b964cba4169c2 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -771,12 +771,15 @@ TRACE_EVENT(btrfs_sync_file,
 	),
 
 	TP_fast_assign(
-		const struct dentry *dentry = file->f_path.dentry;
-		const struct inode *inode = d_inode(dentry);
+		struct dentry *dentry = file_dentry(file);
+		struct inode *inode = file_inode(file);
+		struct dentry *parent = dget_parent(dentry);
+		struct inode *parent_inode = d_inode(parent);
 
-		TP_fast_assign_fsid(btrfs_sb(file->f_path.dentry->d_sb));
+		dput(parent);
+		TP_fast_assign_fsid(btrfs_sb(inode->i_sb));
 		__entry->ino		= btrfs_ino(BTRFS_I(inode));
-		__entry->parent		= btrfs_ino(BTRFS_I(d_inode(dentry->d_parent)));
+		__entry->parent		= btrfs_ino(BTRFS_I(parent_inode));
 		__entry->datasync	= datasync;
 		__entry->root_objectid	= btrfs_root_id(BTRFS_I(inode)->root);
 	),
-- 
2.53.0



