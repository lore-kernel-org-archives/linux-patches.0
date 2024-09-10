Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26AC1917C2;
	Tue, 10 Sep 2024 10:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963047; cv=none; b=okH4cNA1K+4wf63VvD5DIM6OT+ZhImqRHh0NMEXhec41vgoRGUOCfzlFKythwGPGODSa8WgNF8ESs3SaOkrziIKZR3wAAEKn+p4kzCN2oCQKbEHOangYHDR6pjNcVoYv0XMnSQTq5n6zIX21ob4mo4fQi+qclTOkZgzt5CUoiLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963047; c=relaxed/simple;
	bh=tuIfdRGyTpQPzHt71V1QvkvXBHGXQGL9Jllltqv7Ti0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FK/hPHFtY+gCFtDinNvNhV318PZQXK0rfKZI0PE1/UkXL2gxux97HWF5bXMABk7M7g9V40H0tHLBlCAc+7luqVh3HYSZrLkqXz5gajVKzuDZCb9b/KCHAR5mFYOGpMDdvULV1NmstrOPWTLa+dqGCo3f8j3BMRDPPjFh/4+g4iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BE3AE59t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BE3AE59t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2869CC4CEC6;
	Tue, 10 Sep 2024 10:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963047;
	bh=tuIfdRGyTpQPzHt71V1QvkvXBHGXQGL9Jllltqv7Ti0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BE3AE59tmXOZhwmcxPVB2ohi17A8Mg6W4zwbdFzYCia0DMNOLUH47QoHPQ8r+Cz/y
	 MjuMJgOXCuf5ra6WCOH3//zfXUE/UflAk+CfstWQeA1ZKxvQYSwr+CtLgGv2V5k5p6
	 3qqu3eWAHmsY4fFXpPDoCb2qU+IDf6s3108SA1dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/192] btrfs: initialize location to fix -Wmaybe-uninitialized in btrfs_lookup_dentry()
Date: Tue, 10 Sep 2024 11:32:22 +0200
Message-ID: <20240910092602.880633000@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit b8e947e9f64cac9df85a07672b658df5b2bcff07 ]

Some arch + compiler combinations report a potentially unused variable
location in btrfs_lookup_dentry(). This is a false alert as the variable
is passed by value and always valid or there's an error. The compilers
cannot probably reason about that although btrfs_inode_by_name() is in
the same file.

   >  + /kisskb/src/fs/btrfs/inode.c: error: 'location.objectid' may be used
   +uninitialized in this function [-Werror=maybe-uninitialized]:  => 5603:9
   >  + /kisskb/src/fs/btrfs/inode.c: error: 'location.type' may be used
   +uninitialized in this function [-Werror=maybe-uninitialized]:  => 5674:5

   m68k-gcc8/m68k-allmodconfig
   mips-gcc8/mips-allmodconfig
   powerpc-gcc5/powerpc-all{mod,yes}config
   powerpc-gcc5/ppc64_defconfig

Initialize it to zero, this should fix the warnings and won't change the
behaviour as btrfs_inode_by_name() accepts only a root or inode item
types, otherwise returns an error.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/linux-btrfs/bd4e9928-17b3-9257-8ba7-6b7f9bbb639a@linux-m68k.org/
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 934e360d1aef..e5017b2ade57 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5890,7 +5890,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 	struct inode *inode;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_root *sub_root = root;
-	struct btrfs_key location;
+	struct btrfs_key location = { 0 };
 	u8 di_type = 0;
 	int ret = 0;
 
-- 
2.43.0



