Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393BD2135CD;
	Tue,  8 Apr 2025 11:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110262; cv=none; b=gedZJLyXQD3mJgjJb14Rn6/94qcdofc1xcjYHdfsVDdGCooLpDU+l5tgN/ovVUbYEnzwQ3Ef9KD9nc2cVfNJtw6p9MJD7JDDVBwnzgxWD12k8mHbixECDFVzO8IzL/2DSK5rf4KSEZFB5jIiQq7M7WVgVoBdApAN5BT3pToUF8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110262; c=relaxed/simple;
	bh=IVW8+jlEsmRaoxTZ9ReDgrhROH9y0N6zuargdmWH0FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLZ+iSNH6/z+jfBU+lk+11rIAFBJJPuLv9jM0+8kAEZx4EhkoIhMAsb2yFSJcxoeo6zjrPQBMdyUAs4hWc3IYiwkAubpQeom+Su9qgajrE502xcJXQF/FQ/nToRQw02BPxxmvaBonf4a5RyRSafk/HGRkOkguVOfjHPbJKiLZa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2Nrrb83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2Nrrb83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE66C4CEEA;
	Tue,  8 Apr 2025 11:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110262;
	bh=IVW8+jlEsmRaoxTZ9ReDgrhROH9y0N6zuargdmWH0FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2Nrrb83y/NI4nqGh6x1nrcLvFbFr45fU2+iy99VgjNGOtkMk2EAJEeweNtWGx2Lv
	 M/ZlyAHFv2fqOR3ZNdXw4S8RUM4kFaihMKlakJvx8ynYG+cQyLNPj6XJ+rF7MMUR+f
	 UtWo43g2POPwPRAviKxkyN7sgqyxmCF5pvHPAp3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.10 212/227] btrfs: handle errors from btrfs_dec_ref() properly
Date: Tue,  8 Apr 2025 12:49:50 +0200
Message-ID: <20250408104826.672932321@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 5eb178f373b4f16f3b42d55ff88fc94dd95b93b1 upstream.

In walk_up_proc() we BUG_ON(ret) from btrfs_dec_ref().  This is
incorrect, we have proper error handling here, return the error.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5240,7 +5240,10 @@ static noinline int walk_up_proc(struct
 				ret = btrfs_dec_ref(trans, root, eb, 1);
 			else
 				ret = btrfs_dec_ref(trans, root, eb, 0);
-			BUG_ON(ret); /* -ENOMEM */
+			if (ret) {
+				btrfs_abort_transaction(trans, ret);
+				return ret;
+			}
 			if (is_fstree(root->root_key.objectid)) {
 				ret = btrfs_qgroup_trace_leaf_items(trans, eb);
 				if (ret) {


