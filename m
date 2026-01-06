Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0A8346A10;
	Tue,  6 Jan 2026 17:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719721; cv=none; b=ZHAY4df3Fv5/1SLxaX4+Oc1rxDWNth2KB3UigssqdPpjCkDfqeEO6wMle/W/qnAiH+2REpvu0Jhc9jzxFlHtmFVLgI2VsHYypbhlLexjPfyIDO05Jrngiwc+slCFjQjB5SNbow+zV3uxtf8HBaxUFrSdUu5zz6jrR8NvQKqYjzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719721; c=relaxed/simple;
	bh=9zu4IQR3wN7/Xj47hUhuQImCBKREN8tnuY5gZfVbDnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIQrpZECBCFSQBTkaOFs+2dg7eK13a6Gq1Th9eRxE1D8vF4tYj+hWUQWC0Hq9P1OWiiQdJ598w/P4Lk726QGUAYBDOTabnlheHRw2nXvdEOeQnHhGkF0EV8n60JFh7L9Jiz6kKKoaShgTcUpoO+mrsAPMux1KH/DxGn3vI0wxVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLrxYDqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLrxYDqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D9EC16AAE;
	Tue,  6 Jan 2026 17:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719720;
	bh=9zu4IQR3wN7/Xj47hUhuQImCBKREN8tnuY5gZfVbDnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLrxYDqswuA6hyBOaLVjcReGiFulvMRjAOzBzJLaLkY3rQDjksKuUDn8+kpSTnBKP
	 OzkL+RnqqQiup4aPjeviwpPP+WRiuUpVYxtOqDkdDqlEPRQv8BIAoe18k0xvBt5INI
	 dc7pKfqZlasxZhhlqK1suGR48Xw1A7/oWpACue4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/567] btrfs: fix a potential path leak in print_data_reloc_error()
Date: Tue,  6 Jan 2026 17:56:24 +0100
Message-ID: <20260106170451.432906762@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 313ef70a9f0f637a09d9ef45222f5bdcf30a354b ]

Inside print_data_reloc_error(), if extent_from_logical() failed we
return immediately.

However there are the following cases where extent_from_logical() can
return error but still holds a path:

- btrfs_search_slot() returned 0

- No backref item found in extent tree

- No flags_ret provided
  This is not possible in this call site though.

So for the above two cases, we can return without releasing the path,
causing extent buffer leaks.

Fixes: b9a9a85059cd ("btrfs: output affected files when relocation fails")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 01a1b979b717f..ce13b0ec978ed 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -253,6 +253,7 @@ static void print_data_reloc_error(const struct btrfs_inode *inode, u64 file_off
 	if (ret < 0) {
 		btrfs_err_rl(fs_info, "failed to lookup extent item for logical %llu: %d",
 			     logical, ret);
+		btrfs_release_path(&path);
 		return;
 	}
 	eb = path.nodes[0];
-- 
2.51.0



