Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429A417AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9434C433C7;
	Wed,  9 Aug 2023 11:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580825;
	bh=ThE9WBsDcCqK+yf7CSKqcMWSS5THlmEZZNfvC4oUKYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AuB04WgEM3wF9i/4pSNl4Yq4owFwM2NE20YI86BUY0wrDP7P2U8zV2u+UvG6mLIob
	 o6OsTaOrl0GKLlNRigjtsb/isfKh6BEG3vgJQ6n96+qgK/HDD3WUX2f1eoxLFXZNYX
	 EUzUGkainaMbQlqLpdJvkXxN7LRlwJqs8VaOKHzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 143/154] ceph: use kill_anon_super helper
Date: Wed,  9 Aug 2023 12:42:54 +0200
Message-ID: <20230809103641.595194478@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 470a5c77eac0e07bfe60413fb3d314b734392bc3 ]

ceph open-codes this around some other activity and the rationale
for it isn't clear. There is no need to delay free_anon_bdev until
the end of kill_sb.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: e7e607bd0048 ("ceph: defer stopping mdsc delayed_work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/super.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index d40658d5e8089..279334f955702 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1174,14 +1174,13 @@ static struct dentry *ceph_mount(struct file_system_type *fs_type,
 static void ceph_kill_sb(struct super_block *s)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(s);
-	dev_t dev = s->s_dev;
 
 	dout("kill_sb %p\n", s);
 
 	ceph_mdsc_pre_umount(fsc->mdsc);
 	flush_fs_workqueues(fsc);
 
-	generic_shutdown_super(s);
+	kill_anon_super(s);
 
 	fsc->client->extra_mon_dispatch = NULL;
 	ceph_fs_debugfs_cleanup(fsc);
@@ -1189,7 +1188,6 @@ static void ceph_kill_sb(struct super_block *s)
 	ceph_fscache_unregister_fs(fsc);
 
 	destroy_fs_client(fsc);
-	free_anon_bdev(dev);
 }
 
 static struct file_system_type ceph_fs_type = {
-- 
2.40.1



