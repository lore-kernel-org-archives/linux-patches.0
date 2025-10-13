Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC5930EF64;
	Mon, 13 Oct 2025 14:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366936; cv=none; b=UdyQMtqHK4YVLmMP3NIc+z1HN0Su6rDG3EHN6bqajuQWFQZdwX+emTlgSPopi4LMqEwN2cy13W4SF/QO13KpyENhQJyCXD21P6HE3GQyVCHNyyldPuOIZ16e+NsCiK13LYeyodvkS2POSf6c2pXd/R2LzlcQ0x4ZPpdViL2qUQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366936; c=relaxed/simple;
	bh=hf0MeK9gtfLPbD0IftvB1VOcBKcDO47JzrbiJxpJ8kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baMwR6w6v5OMnJZavg5XIBiXCitNkBycAAJ73beHUE+qYgw7uY/v4HTtFz2SZ5+fU7nlxwqt1I91jvbI9BME4oWOR3EGZ/syp95mGs0sOr0GayHDdhXbZwn3d646L8TXW4lKFTJ89OhMTNf+XBxKU9loQME3oc3XybZhiSMXEy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGHm4+ga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGHm4+ga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E3DC4CEE7;
	Mon, 13 Oct 2025 14:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366936;
	bh=hf0MeK9gtfLPbD0IftvB1VOcBKcDO47JzrbiJxpJ8kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGHm4+gaJ/cNiddFX5CzznWewot1ijWHcUcBCH+xaDlg3B2wX1bLNDwSRY3d7ZGR+
	 YrqK47ipzYNuM8LSs3YuaeA1IEQao41duNtZIME60L4ppfjfmt26uV85xemNYVv8ZS
	 xsU238q1tlfof4ut/46SkWo+aEFeIF/uaf+nL4Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9c3e0cdfbfe351b0bc0e@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/196] btrfs: ref-verify: handle damaged extent root tree
Date: Mon, 13 Oct 2025 16:43:28 +0200
Message-ID: <20251013144315.857671990@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit ed4e6b5d644c4dd2bc2872ffec036b7da0ec2e27 ]

Syzbot hits a problem with enabled ref-verify, ignorebadroots and a
fuzzed/damaged extent tree. There's no fallback option like in other
places that can deal with it so disable the whole ref-verify as it is
just a debugging feature.

Reported-by: syzbot+9c3e0cdfbfe351b0bc0e@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/0000000000001b6052062139be1c@google.com/
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ref-verify.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ref-verify.c b/fs/btrfs/ref-verify.c
index 56ceb23bd7409..195fce42b982d 100644
--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -987,11 +987,18 @@ int btrfs_build_ref_tree(struct btrfs_fs_info *fs_info)
 	if (!btrfs_test_opt(fs_info, REF_VERIFY))
 		return 0;
 
+	extent_root = btrfs_extent_root(fs_info, 0);
+	/* If the extent tree is damaged we cannot ignore it (IGNOREBADROOTS). */
+	if (IS_ERR(extent_root)) {
+		btrfs_warn(fs_info, "ref-verify: extent tree not available, disabling");
+		btrfs_clear_opt(fs_info->mount_opt, REF_VERIFY);
+		return 0;
+	}
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-	extent_root = btrfs_extent_root(fs_info, 0);
 	eb = btrfs_read_lock_root_node(extent_root);
 	level = btrfs_header_level(eb);
 	path->nodes[level] = eb;
-- 
2.51.0



