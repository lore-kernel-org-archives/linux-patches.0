Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DE01D14FA;
	Wed,  2 Oct 2024 14:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880439; cv=none; b=ni95mVIlCAJhCewhvSH32ulYPZuE/4MliwqobAH7ogNzDzdtQHNcVy29dcR+2qTE94GJoeOoxubN1H8uk7KHIqkhMaiT+PJNqEIX7c5GK26oPl+bKvmG6125I2LuJGoM+sDJr107hxG/YnzFkK58PWn84xxZX3yx5j30V5V85us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880439; c=relaxed/simple;
	bh=VqWv8Zs3/cTh4h8o9YNK8hqD2ByH3k91+Mgw+wHr9SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wd7Id0qGysh8Ul7DPxEWVSCxU+OMJHOpEI+/cTq0pSQ/1uZeyoqlZVw0+oR0pP1Un7bm1GlaH/GYLiRBxeIMDFN4lvJpnNAyamfLqrtyUnhJn6/BTc8g5vpb2dPEKYptdhfMYsda9mZ2Ak42E/XrQ0pB/rtfwfhup2Jn+sIhJyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAak2SWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAak2SWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5322BC4CEC2;
	Wed,  2 Oct 2024 14:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880439;
	bh=VqWv8Zs3/cTh4h8o9YNK8hqD2ByH3k91+Mgw+wHr9SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAak2SWhSJZETuappeyzNsUP8YYkcvV37idqUZ5svHVVbBjTv/KF6TWFGu6hCzew+
	 aC+1rcnXrrX7FQLocpcXsqn6+5qAKd0qB4vhr84Pl3rt8hPDQqaamd/fNP1jkwwSYz
	 pd3PqeJcw63cRhjMJALmwpJ69kGceiOKhw4tCQqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Parton <njparton@gmail.com>,
	Archange <archange@archlinux.org>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 459/538] btrfs: tree-checker: fix the wrong output of data backref objectid
Date: Wed,  2 Oct 2024 15:01:38 +0200
Message-ID: <20241002125810.561259517@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit b0b595e61d97de61c15b379b754b2caa90e83e5c upstream.

[BUG]
There are some reports about invalid data backref objectids, the report
looks like this:

  BTRFS critical (device sda): corrupt leaf: block=333654787489792 slot=110 extent bytenr=333413935558656 len=65536 invalid data ref objectid value 2543

The data ref objectid is the inode number inside the subvolume.

But in above case, the value is completely sane, not really showing the
problem.

[CAUSE]
The root cause of the problem is the deprecated feature, inode cache.

This feature results a special inode number, -12ULL, and it's no longer
recognized by tree-checker, triggering the error.

The direct problem here is the output of data ref objectid. The value
shown is in fact the dref_root (subvolume id), not the dref_objectid
(inode number).

[FIX]
Fix the output to use dref_objectid instead.

Reported-by: Neil Parton <njparton@gmail.com>
Reported-by: Archange <archange@archlinux.org>
Link: https://lore.kernel.org/linux-btrfs/CAAYHqBbrrgmh6UmW3ANbysJX9qG9Pbg3ZwnKsV=5mOpv_qix_Q@mail.gmail.com/
Link: https://lore.kernel.org/linux-btrfs/9541deea-9056-406e-be16-a996b549614d@archlinux.org/
Fixes: f333a3c7e832 ("btrfs: tree-checker: validate dref root and objectid")
CC: stable@vger.kernel.org # 6.11
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1493,7 +1493,7 @@ static int check_extent_item(struct exte
 				     dref_objectid > BTRFS_LAST_FREE_OBJECTID)) {
 				extent_err(leaf, slot,
 					   "invalid data ref objectid value %llu",
-					   dref_root);
+					   dref_objectid);
 				return -EUCLEAN;
 			}
 			if (unlikely(!IS_ALIGNED(dref_offset,


