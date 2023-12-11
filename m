Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B880321B8;
	Mon, 11 Dec 2023 18:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okv5kfuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015AFC433C9;
	Mon, 11 Dec 2023 18:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321173;
	bh=TyuDYpkrpaOwaFgBNofnT2NBVqPjB/JRcKYJPJZtMpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okv5kfuE5DV83gO5PDAmEiJNepbmr5o9czVznowKuRzLIdR4Qeo7NnJilgh8b5QpM
	 GtY3KjoI62G2KKcn9qNzNcTcUQ+px1jQ/uLYIRgADaUkoq3Vw/XPOgW0GpWPJBKSKb
	 LZWfB12XsBhNm5yxBAV4umI+w1p2pLwV1toutS5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Anand Jain <anand.jain@oracle.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 137/141] Revert "btrfs: add dmesg output for first mount and last unmount of a filesystem"
Date: Mon, 11 Dec 2023 19:23:16 +0100
Message-ID: <20231211182032.553634388@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit a480eb262b178e2baffa758b9cd5bde2d8470287 which is
commit 2db313205f8b96eea467691917138d646bb50aef upstream.

As pointed out by many, the disk_super structure is NOT initialized
before it is dereferenced in the function
fs/btrfs/disk-io.c:open_ctree() that this commit adds, so something went
wrong here.

Revert it for now until it gets straightened out.

Link: https://lore.kernel.org/r/5b0eb360-3765-40e1-854a-9da6d97eb405@roeck-us.net
Link: https://lore.kernel.org/r/20231209172836.GA2154579@dev-arch.thelio-3990X
Reported-by: Guenter Roeck <linux@roeck-us.net>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Cc: Anand Jain <anand.jain@oracle.com>
Cc: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |    1 -
 fs/btrfs/super.c   |    5 +----
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3204,7 +3204,6 @@ int __cold open_ctree(struct super_block
 		goto fail_alloc;
 	}
 
-	btrfs_info(fs_info, "first mount of filesystem %pU", disk_super->fsid);
 	/*
 	 * Verify the type first, if that or the checksum value are
 	 * corrupted, we'll find out
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -337,10 +337,7 @@ void __btrfs_panic(struct btrfs_fs_info
 
 static void btrfs_put_super(struct super_block *sb)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
-
-	btrfs_info(fs_info, "last unmount of filesystem %pU", fs_info->fs_devices->fsid);
-	close_ctree(fs_info);
+	close_ctree(btrfs_sb(sb));
 }
 
 enum {


