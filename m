Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2905514279
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8A3C433C8;
	Wed,  9 Aug 2023 11:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580690;
	bh=oVfaT3LyWREIPZg0lWZrLgphT+bY5TTA3LUodind8S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKGkkXaAKqr8UO6gOlzDsLjbpJMaqL0Kfdmyicmqy8GYOo+IhQ8p01l1Bu86zt20y
	 mpyataz/L3/iOjIzTgVYUIQzW8mHP+nMf5St1hdV9E0YDKsc9DxSFJ741obnUKlJB/
	 /c+Xp6HuU+UHztYP7JH4pdwboM/haDJ8TOoTmCn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	David Sterba <dsterba@suse.com>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Subject: [PATCH 5.4 085/154] btrfs: qgroup: return ENOTCONN instead of EINVAL when quotas are not enabled
Date: Wed,  9 Aug 2023 12:41:56 +0200
Message-ID: <20230809103639.803346761@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marcos Paulo de Souza <mpdesouza@suse.com>

commit 8a36e408d40606e21cd4e2dd9601004a67b14868 upstream.

[PROBLEM]
qgroup create/remove code is currently returning EINVAL when the user
tries to create a qgroup on a subvolume without quota enabled. EINVAL is
already being used for too many error scenarios so that is hard to
depict what is the problem.

[FIX]
Currently scrub and balance code return -ENOTCONN when the user tries to
cancel/pause and no scrub or balance is currently running for the
desired subvolume. Do the same here by returning -ENOTCONN  when a user
tries to create/delete/assing/list a qgroup on a subvolume without quota
enabled.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1411,7 +1411,7 @@ int btrfs_add_qgroup_relation(struct btr
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!fs_info->quota_root) {
-		ret = -EINVAL;
+		ret = -ENOTCONN;
 		goto out;
 	}
 	member = find_qgroup_rb(fs_info, src);
@@ -1470,7 +1470,7 @@ static int __del_qgroup_relation(struct
 		return -ENOMEM;
 
 	if (!fs_info->quota_root) {
-		ret = -EINVAL;
+		ret = -ENOTCONN;
 		goto out;
 	}
 
@@ -1536,7 +1536,7 @@ int btrfs_create_qgroup(struct btrfs_tra
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!fs_info->quota_root) {
-		ret = -EINVAL;
+		ret = -ENOTCONN;
 		goto out;
 	}
 	quota_root = fs_info->quota_root;
@@ -1570,7 +1570,7 @@ int btrfs_remove_qgroup(struct btrfs_tra
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!fs_info->quota_root) {
-		ret = -EINVAL;
+		ret = -ENOTCONN;
 		goto out;
 	}
 
@@ -1621,7 +1621,7 @@ int btrfs_limit_qgroup(struct btrfs_tran
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!fs_info->quota_root) {
-		ret = -EINVAL;
+		ret = -ENOTCONN;
 		goto out;
 	}
 


