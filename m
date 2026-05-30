Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8134B2E7379;
	Sat, 30 May 2026 17:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162564; cv=none; b=sRkIG5EXPkPCkOrfyZZesmRCPgo0WBTOJlXscWIoYoLkyRsSbnOXkP9XA/QIwltej5IhNFrI8N/+nOnMdSAcVEAqQGO0pVl/ObKhkuhUHTbhD9begiCQ2IObaNwtItunXEjwB0Ov9KvEVF3sGrb6eUSsZyBsKURsQnVwEZEHziI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162564; c=relaxed/simple;
	bh=oRq7sAwJH6Qr0FYQINAE9Z7apg0HcZj7eHy8S2Xid40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRI6mYLrepw6/Qjg9Cfqt2x4iUTxQeE+rnU2Ue5/bajV4eRAzND4EUvAWLsSgUvRi92TrnXfbKqneip+CCdAd/EcH0MwcDke8HEaU6DDGKOwm66eHXAneZKx4k/UzXQlnd+A0uwXWgm1ig/AaJkkpINz1vVfwkB0dCHAxGnc/ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcFGReWG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcFGReWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B721F00893;
	Sat, 30 May 2026 17:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162563;
	bh=UhX0twbwwdfIEFbwTNhL3XGC6QpbziNK7InQpzc0gAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZcFGReWGPxVipF2bW4p5MWPc8qLXdR7VzW6DdIAK8ZTj1sKQyb58bQhav1cb/Ws2r
	 7OX4esr0H8s8ADKtKVKmn8ry69G0oPtS4SUqxB7Bvo+GbXO2zL1QFYwpFC0W/pLuSW
	 FSUrMhSzLv5GaC9k0UG36QJwnOGJ1cdR40SblWns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 960/969] RDMA/rtrs: Fix use-after-free in path file creation cleanup
Date: Sat, 30 May 2026 18:08:04 +0200
Message-ID: <20260530160327.281755425@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 5b74373390113fba798a76b483837029ab010fef ]

In the error path of rtrs_srv_create_path_files(), the sysfs root folders
may already have been created and srv_path->kobj may already have been
initialized. If a later step fails, the cleanup currently calls
kobject_put(&srv_path->kobj) before
rtrs_srv_destroy_once_sysfs_root_folders(srv_path).

kobject_put() may drop the last reference to srv_path->kobj and invoke the
release callback, rtrs_srv_release(), which frees srv_path. The following
call to rtrs_srv_destroy_once_sysfs_root_folders(srv_path) then
dereferences srv_path internally to access srv_path->srv, resulting in a
use-after-free.

This failure path is reached before rtrs_srv_create_path_files() returns
success, so the successful-path lifetime handling is not involved.

Fix this by destroying the sysfs root folders before calling
kobject_put(&srv_path->kobj), so srv_path is still valid while the helper
accesses it.

This issue was found by a static analysis tool I am developing.

Fixes: ae4c81644e91 ("RDMA/rtrs-srv: Rename rtrs_srv_sess to rtrs_srv_path")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260514113834.865530-1-lgs201920130244@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
index 2a3c9ac64a42e..fade349daf39e 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
@@ -296,8 +296,8 @@ int rtrs_srv_create_path_files(struct rtrs_srv_path *srv_path)
 put_kobj:
 	kobject_del(&srv_path->kobj);
 destroy_root:
-	kobject_put(&srv_path->kobj);
 	rtrs_srv_destroy_once_sysfs_root_folders(srv_path);
+	kobject_put(&srv_path->kobj);
 
 	return err;
 }
-- 
2.53.0



