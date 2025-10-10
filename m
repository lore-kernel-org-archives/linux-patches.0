Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C102421579F;
	Fri, 10 Oct 2025 13:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102436; cv=none; b=M1pm3HGZb4tJ+4AKuUlVoBgX30AMRs34BzWaxth+K5991pqohFs0wrVZtUDTIQ/B7Nbr9dGhiX0sEeZpDLQHjrkbPlsjdUW9muW0e/fDjF4V5kmrPr4mzjww/u9D/xWQgqYakzu6sFR0AUcOtJvHngaqYoCpbYgw90CqzTQnzKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102436; c=relaxed/simple;
	bh=wJGEE/+GCx++P98xxmGRsk4m8L/avcQH7/pWxciWDTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nigq41jbgObq2RjUUKawxr5c9vKoJphsrlox+PR840oIcydbUQfb05o9sHakhMRgu4L6ACA+AsyWXkfMRloF57IOcsz6N1xTZExI5W0bAcymvFpaVw0/gZW8HuiDXJTz/y6IwFyz3AtJXjs8s56jtuZrE/x92Nsnk5eUwjy3dSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LcNZ+l0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LcNZ+l0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47822C4CEF8;
	Fri, 10 Oct 2025 13:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102436;
	bh=wJGEE/+GCx++P98xxmGRsk4m8L/avcQH7/pWxciWDTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LcNZ+l0zzhZfSZ8lsFrCBJsHhS7HU3ihjf1/p0AKMeN5GL23OMZWdxm0GsVSRRoij
	 BRtsL65Bada9zyQ2HhiWqQ/ekWlU45D711ErOKgTv7sX0M/6XzY6wdTC/RFx7KBUtc
	 stw3gRWsusZ7mdmjr6oX+3RfjxlerePXLI2xM3N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9c3e0cdfbfe351b0bc0e@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 14/35] btrfs: ref-verify: handle damaged extent root tree
Date: Fri, 10 Oct 2025 15:16:16 +0200
Message-ID: <20251010131332.309244682@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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
index 2928abf7eb827..fc46190d26c8e 100644
--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -998,11 +998,18 @@ int btrfs_build_ref_tree(struct btrfs_fs_info *fs_info)
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



