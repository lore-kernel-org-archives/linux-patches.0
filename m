Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BAE260580;
	Thu, 28 May 2026 20:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000199; cv=none; b=Eom8pdtdf5yY83m8OsrFI9lfxati6LstIKyoTNDb4KrbMiOHRpCsWvfzo2enCPre3fF2l2oTapcsJEYMXllgRCU4eXK73APziejo3Glv2I8XnPwTM3dp3c2qRIT/JNFsh4SaTc1+sRRBzLvSjv4hPpDcN2fZWC+4WFIKsF+MUig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000199; c=relaxed/simple;
	bh=GtdV/AczT68QLI0xQXkbh1iRDevdPUSEn5ykSwBY36E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPHUZfvBRIQAd+xMjbjFrK6jbg1DPpWP6Kw1BRgtyXTTBglnR1qvU5fqZi30+8yVwXWESEgyuWJjoxjdULVROy9GpQDMN8G8h2fZ8jHjYNc8b/C3MN1rc5n6NUw0PT9lx7jDgaToCavmrvBGAOytGwKM6iw4/FomZ31oajzZuio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msiBhR58; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msiBhR58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECA11F000E9;
	Thu, 28 May 2026 20:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000198;
	bh=InUCaieJlUg7Qoq8aY5P/RL08fAhVESKBHB6S+RP+2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=msiBhR5834pXKg/BtrdvW7qUOzS13e1aZ9tpMN9JLT7P8SnxHpB7aMrg2LQNNxDxn
	 jX0wkBySRsl5E0lRHIC5Qfp/m6knVyv3K1qAHOI7ubRgMqsZ4+6+DXRlV8HUqJAEky
	 QV9cv8KpOkILFQqbTxpOglCu8UFl468mBqNxh6Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 337/377] RDMA/rtrs: Fix use-after-free in path file creation cleanup
Date: Thu, 28 May 2026 21:49:35 +0200
Message-ID: <20260528194648.175851014@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3f305e694fe8c..1b1c6ea4ee5a4 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c
@@ -295,8 +295,8 @@ int rtrs_srv_create_path_files(struct rtrs_srv_path *srv_path)
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



