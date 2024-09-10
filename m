Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7668A1DA4C;
	Tue, 10 Sep 2024 10:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965131; cv=none; b=GFzSco5Rj/89z4+FFgafBzHO9ok9//dQg4J588q1dP5IgHtzRNzGH9Cy+g47rtLrr0hzTf3Ip4NDxnTE99qnR2etUKBCtS1zDXxsaNzoJRxITweL2HAB4krQ8xIeXlwNdnHOseN7s9RjP0dNDmK9Gg6wETGg52elmCW39TWbjcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965131; c=relaxed/simple;
	bh=q0AennzIc/1s39LuIGlQ0iX9gCNjSfzA10/kSlf2SzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvRwG/isfjegeOlwiEATFxV5uxnX+lce+h6RXSLOetvAfveZh9SoyNyBGWeCvkBtohnFIXIsmMy4O2RqCp5qvSDir7emruIPsCgw4RHEplz6TU7tD5cn0rCk64K72dANiOFKMaP1+ltHdxiqOoOaWCdtr4QQ7u+PZhDrnVwpaU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0sxe+fb7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0sxe+fb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24A8C4CEC3;
	Tue, 10 Sep 2024 10:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965131;
	bh=q0AennzIc/1s39LuIGlQ0iX9gCNjSfzA10/kSlf2SzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0sxe+fb78csD2yaif75gN8ipZ4HSb8PFskblUKzBhHYywA2vjUmqA2W5e21d1bfa5
	 2ed5JNAwO9wfot6ipThm5loEhkhOM9VDEGtn5r8cfO4USSswCmIFibixOnvwbx8zwB
	 0KK00MIcZRM6P8vwgSc7u89Bu49ZPpsOVbu0NazE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 147/186] btrfs: initialize location to fix -Wmaybe-uninitialized in btrfs_lookup_dentry()
Date: Tue, 10 Sep 2024 11:34:02 +0200
Message-ID: <20240910092600.655505758@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4bf28f74605f..cd3156a9a268 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5527,7 +5527,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 	struct inode *inode;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_root *sub_root = root;
-	struct btrfs_key location;
+	struct btrfs_key location = { 0 };
 	u8 di_type = 0;
 	int ret = 0;
 
-- 
2.43.0



