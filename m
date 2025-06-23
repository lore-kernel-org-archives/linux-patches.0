Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070B213A265;
	Mon, 23 Jun 2025 13:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684563; cv=none; b=qNjW6APy+mdiTr6enh56yxyjCwpt6VrbbLQ2q7GqJgWgNMgm37dFQLgM6jWMR4+AN3kCnlfI+0W1c55zjjgc2ZJ91p6bTr+vLAKHNSlXG/P63IR5W2LQpU3N59D5SQAoo17GJeeEZJtJ4d+GkhQT4eYS0DttLdRK9aYqmEV+MN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684563; c=relaxed/simple;
	bh=j6s0ngS1vmDWALm63PySTscWT0GvVchT3z8cMSv8ayM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szPslOfUTjP5QUSWfQLTBEHe1nNFwd2pcw6w8/GSPqpfjn884TooLtCYHygslgV9ObwsbHizOJITelMEBGwXqXVPNdE8TZv5EX6PSvwRJ92Mg0PD0R6lXY9ZoqwX/ylvnuE8DgJVgerJWFZAtNQZi8A10Z3WZyzyoMuN9XftYcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pjgf3lph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjgf3lph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF73C4CEEA;
	Mon, 23 Jun 2025 13:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684562;
	bh=j6s0ngS1vmDWALm63PySTscWT0GvVchT3z8cMSv8ayM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pjgf3lphMT+DBpY5//w1HuS8D/1tWNGhi278L/lxJ15mioFhxlUNlNUQawC3gfJYD
	 bSx3Kea7BsVtU8UcQw/B9EpF4CT5HoO0cU4ecpMrD8anhlQkggDCUSEue6Zn0gOvbN
	 ikiMkvw7vbyOXwQ7d3SOCNj5bywCXNAhh78CiCkY=
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
Subject: [PATCH 6.15 113/592] ext4: fix calculation of credits for extent tree modification
Date: Mon, 23 Jun 2025 15:01:11 +0200
Message-ID: <20250623130702.962726485@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2396,18 +2396,19 @@ int ext4_ext_calc_credits_for_single_ext
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


