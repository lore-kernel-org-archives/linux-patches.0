Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF4115C8A
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC71C43150;
	Mon,  5 Dec 2022 19:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269305;
	bh=B5bAviYb4rjoA/QSY+VVumt0tAskH7nTTO/ChzZwV90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfB6O9pubESEMgUNQ+ejPuqiHUaf5kpoP6UNGvEQb+9G1qGPP8vvA6DgIYpslLfEg
	 Bmv1MowYCYp/OaWe3U3SUL3CdyT9F2l/FIVHpbI6MTBdM0uwtUNYmEy4dI4b/b+mpw
	 Tly8Mbo0FaH7bsYsZr/P3hiAeqgWkEEkTqoUJrDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 078/153] btrfs: sysfs: normalize the error handling branch in btrfs_init_sysfs()
Date: Mon,  5 Dec 2022 20:10:02 +0100
Message-Id: <20221205190810.963522420@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhen Lei <thunder.leizhen@huawei.com>

commit ffdbb44f2f23f963b8f5672e35c3a26088177a62 upstream.

Although kset_unregister() can eventually remove all attribute files,
explicitly rolling back with the matching function makes the code logic
look clearer.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/sysfs.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1154,8 +1154,11 @@ int __init btrfs_init_sysfs(void)
 
 #ifdef CONFIG_BTRFS_DEBUG
 	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_debug_feature_attr_group);
-	if (ret)
-		goto out2;
+	if (ret) {
+		sysfs_unmerge_group(&btrfs_kset->kobj,
+				    &btrfs_static_feature_attr_group);
+		goto out_remove_group;
+	}
 #endif
 
 	return 0;


