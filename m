Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89FF1DE4F9;
	Wed, 19 Feb 2025 09:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956691; cv=none; b=P3F33r340f0tg80CdH3WXe6pxrRxspoHAr7Too393w7nG5/UoiPVqWzKKISYFb7XM95aYWC9EotZi/x1muEMv+7uoNV1bY8hrMWhKJOEqLnuHpjKImmN3opDZ/bj28Dbv1faFxgE0gpT97v5NumdtwyQP2atsoXuAS/66v5B9GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956691; c=relaxed/simple;
	bh=gnB1UtIYfyiBGeKMgjKfCFYA5JduCZyGcYCNjuM8ZOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acz0+n+dyaXftiG6UYd71Z1c2d39tOT1WEZAJA4GtfBSMl2GfO8p2o1hPbEUyjigVyhfmDTyCxDO0z9SZEjnCanHW1tGKLwrS6fvZgyiFJ98xFPZezzmjVAC28o1ua5lAUpvyaN6rD73hb605lSOD7/VR73jH6epd6V7m41FjAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDiJXZ0k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDiJXZ0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDDBC4CED1;
	Wed, 19 Feb 2025 09:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956691;
	bh=gnB1UtIYfyiBGeKMgjKfCFYA5JduCZyGcYCNjuM8ZOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDiJXZ0kw19hKI5PcKDCJRkDK9lLZ3RNUu5r++ULNwBtyiKsJmWt0oFhGlfjyn+RP
	 4ERei+VTi+86KxeEYoy2iwp8INkeQU8//PlKWfFbdkzYsQKbxUaMo2mbF1bRZBT6Sf
	 dLGeeYio8KAwxqGSECAovst5kmJiFd2SN8SLHEEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Anton Mitterer <calestyo@scientia.org>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 266/578] btrfs: output the reason for open_ctree() failure
Date: Wed, 19 Feb 2025 09:24:30 +0100
Message-ID: <20250219082703.486435044@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Qu Wenruo <wqu@suse.com>

commit d0f038104fa37380e2a725e669508e43d0c503e9 upstream.

There is a recent ML report that mounting a large fs backed by hardware
RAID56 controller (with one device missing) took too much time, and
systemd seems to kill the mount attempt.

In that case, the only error message is:

  BTRFS error (device sdj): open_ctree failed

There is no reason on why the failure happened, making it very hard to
understand the reason.

At least output the error number (in the particular case it should be
-EINTR) to provide some clue.

Link: https://lore.kernel.org/linux-btrfs/9b9c4d2810abcca2f9f76e32220ed9a90febb235.camel@scientia.org/
Reported-by: Christoph Anton Mitterer <calestyo@scientia.org>
Cc: stable@vger.kernel.org
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1468,7 +1468,7 @@ static int btrfs_fill_super(struct super
 
 	err = open_ctree(sb, fs_devices, (char *)data);
 	if (err) {
-		btrfs_err(fs_info, "open_ctree failed");
+		btrfs_err(fs_info, "open_ctree failed: %d", err);
 		return err;
 	}
 


