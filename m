Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4539199FCC;
	Tue, 10 Sep 2024 10:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964391; cv=none; b=nc+Y4DoICDB9FsKgubheeu6YZ6CyXv4B7DqMfKdxmzrRuiRhrKgXcm73+AMAHZDvjhGu9oHYxaNs1SX1C3OIPDhuySTfs0/nkOnQbZPrYcnCy51imGaPithMxuXLySqCTlpmF8BZMEtwTNKfJKdC5FCozddIHj78XcQF1iweZSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964391; c=relaxed/simple;
	bh=nlcHogt7SsnXi4G9kP5X1Qitr+qLA53INnzB8jm7Esw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIuwp87thNKssZka3svYo2mY2e9VyiQGTVM8V+rGdBC7SobA54fCmsGJd+Rf+9E2kl7iwm2qPlApT4jNqU/f0slvJrlkF8XRBGKikaGwOEGi+gRkyC3Gz59Ipn/nk2EEgd+noNzb2wQCiRSi6DNWiqOExVZS7RzS/wti5t8umm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5io4ceQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5io4ceQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B282C4CEC3;
	Tue, 10 Sep 2024 10:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964390;
	bh=nlcHogt7SsnXi4G9kP5X1Qitr+qLA53INnzB8jm7Esw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5io4ceQuoVbFIWTjWjOlYL/76GOPkY3fSXLuJl9h/LEX1+gO6e94Jrn7J2ZfLo9v
	 nFCbWDvOxoakqL1jev+VMyW9qy42TqnvYBUKc9TiFnGZuhcykXePgyCSDHVkQ7K33P
	 I4EphwLe2h7ALhNsIxOu19DoOIfzRoAUv77Txx30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/269] btrfs: replace BUG_ON with ASSERT in walk_down_proc()
Date: Tue, 10 Sep 2024 11:32:33 +0200
Message-ID: <20240910092614.079110344@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 1f9d44c0a12730a24f8bb75c5e1102207413cc9b ]

We have a couple of areas where we check to make sure the tree block is
locked before looking up or messing with references.  This is old code
so it has this as BUG_ON().  Convert this to ASSERT() for developers.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c6ecfd05e1db..2d39481fb3ce 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5144,7 +5144,7 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 	if (lookup_info &&
 	    ((wc->stage == DROP_REFERENCE && wc->refs[level] != 1) ||
 	     (wc->stage == UPDATE_BACKREF && !(wc->flags[level] & flag)))) {
-		BUG_ON(!path->locks[level]);
+		ASSERT(path->locks[level]);
 		ret = btrfs_lookup_extent_info(trans, fs_info,
 					       eb->start, level, 1,
 					       &wc->refs[level],
@@ -5168,7 +5168,7 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 
 	/* wc->stage == UPDATE_BACKREF */
 	if (!(wc->flags[level] & flag)) {
-		BUG_ON(!path->locks[level]);
+		ASSERT(path->locks[level]);
 		ret = btrfs_inc_ref(trans, root, eb, 1);
 		BUG_ON(ret); /* -ENOMEM */
 		ret = btrfs_dec_ref(trans, root, eb, 0);
-- 
2.43.0



