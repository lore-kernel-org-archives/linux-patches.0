Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301FB1684AC;
	Tue, 11 Mar 2025 15:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706664; cv=none; b=NHx86HyVZUt8lqM26piua/2ooc6u1PVZ1AmBVzQM8gJcSlh467RDOBzglKbnjfxn3buxKjo2cyIsAJ5kYHB6N6hfrlNdjc3lcv94cXc1GrA3WU5JnzuYGCKXP6+hldVcKqMk4K3bkxrsRuCyxLtCdStIP6vb2qBOoLxakmxs3Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706664; c=relaxed/simple;
	bh=FL7Puz9Y/JCtK/Nt3F/DvQwqPwXmDVXbLdZ9THMpWIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODl3xkRkJNC90YdgTF8RHJGj/y7Xz/Ra1xoak1+a2CdKHJoSBbPra3/4j7mVPq4Kx9gB+gFWhMkaN+J9lW9lGPRPhT61xMiPCP9lzkmmENkj0zXcfCqrjQwrySefFfHtYeTmvi4yh04+4o+U9QsUOKPvSPqhXFZUlYkeYCqhap0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FOkdVts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FOkdVts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA541C4CEE9;
	Tue, 11 Mar 2025 15:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706664;
	bh=FL7Puz9Y/JCtK/Nt3F/DvQwqPwXmDVXbLdZ9THMpWIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FOkdVtsOqbWTNdMs7hSgO8e9PZdfaN0Anr3bhGBniyNVnZS+yzEqULNG4Jn2uaCD
	 d0pBUPdJ4oN4SUxn/C7b43F93eQDLLb+2tp4a6wSwxClQ+DYKFatHi9thsF75RN2eH
	 aTU27HcgrOejKuBA1EdU7Dywya6vgaCEtXy2YRY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Anton Mitterer <calestyo@scientia.org>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 125/462] btrfs: output the reason for open_ctree() failure
Date: Tue, 11 Mar 2025 15:56:31 +0100
Message-ID: <20250311145803.298362284@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1340,7 +1340,7 @@ static int btrfs_fill_super(struct super
 
 	err = open_ctree(sb, fs_devices, (char *)data);
 	if (err) {
-		btrfs_err(fs_info, "open_ctree failed");
+		btrfs_err(fs_info, "open_ctree failed: %d", err);
 		return err;
 	}
 


