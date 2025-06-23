Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEAF219E0;
	Mon, 23 Jun 2025 21:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713773; cv=none; b=o0wiGCvyHzwUkazedkMq+HwbEpZ1jqm0IDCqctk+tkywtlEvaiLxLTCFm617eSBGrcuYvvvGOre+GB9EVgvU3+9dm8anzuRGvp2KmrpCOpru0XlwhcU3RL95ijSxv/k7R0gEzrqysu6PFNbnZr4haw9mmHcARW1QIp7SGJ34Cc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713773; c=relaxed/simple;
	bh=1G+GRYsZ3X5d3a0E1zyl6iH0+rmhNY6Qxs7oc30iI48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KN+txZHW3sxYPNfi1hbgWEs0u8sjHH6EsHL79jwUau4xFLGmfSVeXlGqMNgzNhhCEWemgnPGBQhkTMSujeAmKvS2snB+0CNzbwsr0yMTRSJDGuTb/sFpfPWlGjk/wqVkegR4dkynrJ+8LbA5gL1gc/c94WP6PSXTx1QQcus9A7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ANWsQjg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ANWsQjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57313C4CEEA;
	Mon, 23 Jun 2025 21:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713773;
	bh=1G+GRYsZ3X5d3a0E1zyl6iH0+rmhNY6Qxs7oc30iI48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ANWsQjgV1tcKX2KRNLTECrjqu1c+fw7FdzR4LzSHlaCk157KWx2XWxEul5CV9ybb
	 xeXS15exyzNJkt3sD9o4dKCqXSyTGJ/PdwP7awVL0Z0E4G9DrMqVNEBK7qIEkJPJvt
	 tXvpMXjI1bwMtIcEgF9ueKmhcVqVOihHHMUDkUxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Luis Chamberlain <mcgrof@kernel.org>,
	kdevops@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.10 185/355] ext4: fix calculation of credits for extent tree modification
Date: Mon, 23 Jun 2025 15:06:26 +0200
Message-ID: <20250623130632.246468701@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit 32a93f5bc9b9812fc710f43a4d8a6830f91e4988 upstream.

Luis and David are reporting that after running generic/750 test for 90+
hours on 2k ext4 filesystem, they are able to trigger a warning in
jbd2_journal_dirty_metadata() complaining that there are not enough
credits in the running transaction started in ext4_do_writepages().

Indeed the code in ext4_do_writepages() is racy and the extent tree can
change between the time we compute credits necessary for extent tree
computation and the time we actually modify the extent tree. Thus it may
happen that the number of credits actually needed is higher. Modify
ext4_ext_index_trans_blocks() to count with the worst case of maximum
tree depth. This can reduce the possible number of writers that can
operate in the system in parallel (because the credit estimates now won't
fit in one transaction) but for reasonably sized journals this shouldn't
really be an issue. So just go with a safe and simple fix.

Link: https://lore.kernel.org/all/20250415013641.f2ppw6wov4kn4wq2@offworld
Reported-by: Davidlohr Bueso <dave@stgolabs.net>
Reported-by: Luis Chamberlain <mcgrof@kernel.org>
Tested-by: kdevops@lists.linux.dev
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20250429175535.23125-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2367,18 +2367,19 @@ int ext4_ext_calc_credits_for_single_ext
 int ext4_ext_index_trans_blocks(struct inode *inode, int extents)
 {
 	int index;
-	int depth;
 
 	/* If we are converting the inline data, only one is needed here. */
 	if (ext4_has_inline_data(inode))
 		return 1;
 
-	depth = ext_depth(inode);
-
+	/*
+	 * Extent tree can change between the time we estimate credits and
+	 * the time we actually modify the tree. Assume the worst case.
+	 */
 	if (extents <= 1)
-		index = depth * 2;
+		index = EXT4_MAX_EXTENT_DEPTH * 2;
 	else
-		index = depth * 3;
+		index = EXT4_MAX_EXTENT_DEPTH * 3;
 
 	return index;
 }


