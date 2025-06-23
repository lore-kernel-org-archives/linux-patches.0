Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CEFC2E0;
	Mon, 23 Jun 2025 21:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714284; cv=none; b=BuB0osq3XXIkbJ464+yINxMKoq94MBwdoumiUCgBM02FudtWPyTlB4w+Wte0flmbHZep1dBVsw805cBd/CUTtky4zo/7D69Pdtpp/YTN3scT79fkHef7/DbvUsNvOiy919r/0wKTPjt7YcocZ0vxhgPNEwuws9hyDmd0tiDKjh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714284; c=relaxed/simple;
	bh=ZA72sWKoSfJnj8Wt9kGvgn0NpgX/cch4s/6zkII8xCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niUkVhAA7oe5p85sMQrbA83joOnbX8vGObRwajhcSE7UYc3XsLMQKniaXl8H9NY5b9WvwpJEU4vQ3vhb5iWUIr8D1GeOXGlXVF5DHHwX0O51mpjdi3I8K2ewvgWL2RUZuMDozrlagTz6FglX2f4XKKoq63+vOVZp4cf8aIEMTVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlEFusw/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlEFusw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29675C4CEEA;
	Mon, 23 Jun 2025 21:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714284;
	bh=ZA72sWKoSfJnj8Wt9kGvgn0NpgX/cch4s/6zkII8xCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tlEFusw/GP0L2t1JKp+RDr0FWkEvAMrcqnVs1zDG0QeMg0D7tOELX14tepqIJx+8u
	 zmcICYq1trGtkxr9bcuu0sqzrkY43rN7dNR1RtUc9VGbg28IEJygcIof0jnPFeyYnX
	 FGHDHuW18QI/CjrRaFPyaU9rtAgb5IAdp2C/edwg=
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
Subject: [PATCH 6.12 093/414] ext4: fix calculation of credits for extent tree modification
Date: Mon, 23 Jun 2025 15:03:50 +0200
Message-ID: <20250623130644.416255647@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


