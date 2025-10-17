Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879053370F7;
	Fri, 17 Oct 2025 15:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714646; cv=none; b=nwp9qs2fIbEEhRc0KWRBO117RCcDHdgUanufYb8/DP9lK9KssUWuw1B0G7Qwa6A3RR/jRFw+zytFpYVRexeuv7saZm66CxUcOytEncnm3HhcO28zwMipvqsr0fZriIR+yqnwp6gRyWGpwjDRv1hUQER1F42x38QGHoJaYliK91s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714646; c=relaxed/simple;
	bh=Lu6PT5L16LBH2hF0Q6RONR9NCdxdaFkN6hshw4PuwRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFyP8ZObYHLw/ONJIupHygjhEiLelyk4OwtMy2umNBGz6m/gr/k8IqWBbTGRxp14sVJruEZX6TXMWBjRWePnFlzQanfcLNydcLGi/SJCuqe59+3Cfle8eLmeuA+1qs+MF95+oM3PdcDer0w4va5czZWBFIPa+IXXuEcekpBSOEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjHc6fml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjHc6fml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133B2C4CEE7;
	Fri, 17 Oct 2025 15:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714646;
	bh=Lu6PT5L16LBH2hF0Q6RONR9NCdxdaFkN6hshw4PuwRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjHc6fml3DZIUrl3B9DQFhozF2aFrbEe4hwMHnYHFF9OP6dPqKjG2qNDdfp3CS83u
	 i98pF9SlPXrpHUh50jCqtju++8w4FnvM58O98qTcc+ouHkx6vCXHkNtv4DmAvEIsvU
	 s1E5mJS4jple3e8OrQdVeG3Nq3vokRCVYjzNt39g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0be4f339a8218d2a5bb1@syzkaller.appspotmail.com,
	stable@kernel.org,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>,
	Ahmet Eray Karadag <eraykrdg1@gmail.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.12 218/277] ext4: guard against EA inode refcount underflow in xattr update
Date: Fri, 17 Oct 2025 16:53:45 +0200
Message-ID: <20251017145155.088395913@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Ahmet Eray Karadag <eraykrdg1@gmail.com>

commit 57295e835408d8d425bef58da5253465db3d6888 upstream.

syzkaller found a path where ext4_xattr_inode_update_ref() reads an EA
inode refcount that is already <= 0 and then applies ref_change (often
-1). That lets the refcount underflow and we proceed with a bogus value,
triggering errors like:

  EXT4-fs error: EA inode <n> ref underflow: ref_count=-1 ref_change=-1
  EXT4-fs warning: ea_inode dec ref err=-117

Make the invariant explicit: if the current refcount is non-positive,
treat this as on-disk corruption, emit ext4_error_inode(), and fail the
operation with -EFSCORRUPTED instead of updating the refcount. Delete the
WARN_ONCE() as negative refcounts are now impossible; keep error reporting
in ext4_error_inode().

This prevents the underflow and the follow-on orphan/cleanup churn.

Reported-by: syzbot+0be4f339a8218d2a5bb1@syzkaller.appspotmail.com
Fixes: https://syzbot.org/bug?extid=0be4f339a8218d2a5bb1
Cc: stable@kernel.org
Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Message-ID: <20250920021342.45575-1-eraykrdg1@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1036,7 +1036,7 @@ static int ext4_xattr_inode_update_ref(h
 				       int ref_change)
 {
 	struct ext4_iloc iloc;
-	s64 ref_count;
+	u64 ref_count;
 	int ret;
 
 	inode_lock_nested(ea_inode, I_MUTEX_XATTR);
@@ -1046,13 +1046,17 @@ static int ext4_xattr_inode_update_ref(h
 		goto out;
 
 	ref_count = ext4_xattr_inode_get_ref(ea_inode);
+	if ((ref_count == 0 && ref_change < 0) || (ref_count == U64_MAX && ref_change > 0)) {
+		ext4_error_inode(ea_inode, __func__, __LINE__, 0,
+			"EA inode %lu ref wraparound: ref_count=%lld ref_change=%d",
+			ea_inode->i_ino, ref_count, ref_change);
+		ret = -EFSCORRUPTED;
+		goto out;
+	}
 	ref_count += ref_change;
 	ext4_xattr_inode_set_ref(ea_inode, ref_count);
 
 	if (ref_change > 0) {
-		WARN_ONCE(ref_count <= 0, "EA inode %lu ref_count=%lld",
-			  ea_inode->i_ino, ref_count);
-
 		if (ref_count == 1) {
 			WARN_ONCE(ea_inode->i_nlink, "EA inode %lu i_nlink=%u",
 				  ea_inode->i_ino, ea_inode->i_nlink);
@@ -1061,9 +1065,6 @@ static int ext4_xattr_inode_update_ref(h
 			ext4_orphan_del(handle, ea_inode);
 		}
 	} else {
-		WARN_ONCE(ref_count < 0, "EA inode %lu ref_count=%lld",
-			  ea_inode->i_ino, ref_count);
-
 		if (ref_count == 0) {
 			WARN_ONCE(ea_inode->i_nlink != 1,
 				  "EA inode %lu i_nlink=%u",


