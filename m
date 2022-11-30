Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F92A79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051A5C433D6;
	Wed, 30 Nov 2022 18:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833158;
	bh=Vmvo4GiujzdmVdRyiQdUThTBBGe87xHyS7XUnhB6w48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vE7UkiYrkpgJVyqDz5FWkvFDDgRPnLkQdpAu97JcjQMz0/CuxORrfnsNrxS9JpsvZ
	 ToD2JV3FADm6E3Cqvz5VPQHwH4Mxw6O2m02P1N/f/rCLfN9CkNg6WNhRxDJMu+lh7+
	 57+FOJu2ZEWn7IkxxINMDTBpmxp07nZJdUqDtAxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 159/162] btrfs: sysfs: normalize the error handling branch in btrfs_init_sysfs()
Date: Wed, 30 Nov 2022 19:24:00 +0100
Message-Id: <20221130180532.784418432@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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
@@ -1767,8 +1767,11 @@ int __init btrfs_init_sysfs(void)
 
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


