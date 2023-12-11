Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8566FC06;
	Mon, 11 Dec 2023 18:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxHK4EKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4BFC433C8;
	Mon, 11 Dec 2023 18:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320288;
	bh=R/k8s7O4dlFYeHkl8CPV6byNTZMOjb7Qh808bDdY94o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxHK4EKZNCWwMFGzmvZxyA4DrAdiC41HxnrCRJLinYCjIQLICjnQ343tvNebnx62j
	 fVUa6jNiORtnldBZukCPB6fME51DawbznSo6zRBwxV59+hbUCdIe41xcyXXH14HzyS
	 YKddbbrwRL17kPJuoX0DFccd3PbCHHwr4ViNPYkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Anand Jain <anand.jain@oracle.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 63/67] Revert "btrfs: add dmesg output for first mount and last unmount of a filesystem"
Date: Mon, 11 Dec 2023 19:22:47 +0100
Message-ID: <20231211182017.697748074@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182015.049134368@linuxfoundation.org>
References: <20231211182015.049134368@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit dd94ffab1b6d84b3ba9a8d09b6b0f44610d397eb which is
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
@@ -2829,7 +2829,6 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
-	btrfs_info(fs_info, "first mount of filesystem %pU", disk_super->fsid);
 	/*
 	 * Verify the type first, if that or the checksum value are
 	 * corrupted, we'll find out
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -291,10 +291,7 @@ void __btrfs_panic(struct btrfs_fs_info
 
 static void btrfs_put_super(struct super_block *sb)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
-
-	btrfs_info(fs_info, "last unmount of filesystem %pU", fs_info->fs_devices->fsid);
-	close_ctree(fs_info);
+	close_ctree(btrfs_sb(sb));
 }
 
 enum {


