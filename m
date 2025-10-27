Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF6E31B82C;
	Mon, 27 Oct 2025 18:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590670; cv=none; b=ZIl6kiaQEKu8z2woUkbNtVoE4OLrr+h3fneKRYWChawExUm6f6+NYkBX+V21bkEuVNRJgpDncxeWvPQum1RJD0oNWouhI0u1dHMbSpwaYJRCQZS4IZd+meLroRShbAFGVQAe4CPGVYesaN1jbhN58utj5D+b2TmE4L0rERGyeAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590670; c=relaxed/simple;
	bh=ZQ1Pga82YqKwa2yMoQoAKF+D1THFdS+l3H8QjKDn9Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owoK2D0Vp3l14ie9YMPn/AJ6ta05EjUCdabjsQJa04Poce5/Rzcdipryhqhg5paNK+r7HkOM++hdWdioSoPJFX7xrwQqEtee+Zku0vgqn7eD/NVPp3FgS+eL9qnJQVGIE9lJe48ncnT7m/Ca+GLZcw9k0a5POCFEH9erI4IQk6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SwqDeV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SwqDeV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22195C4CEF1;
	Mon, 27 Oct 2025 18:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590669;
	bh=ZQ1Pga82YqKwa2yMoQoAKF+D1THFdS+l3H8QjKDn9Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SwqDeV0LPdn3QMGuHDVgz6VcD+0E8sBG3AZdOdAeI/AbRiitZvO7f19XRyLa0nM9
	 h7jBhoF8qrPttA3Q+r5xy4y64wn01Cm6Z7zdb67FRns/euDhM6cFUby9yEoY2MhPaB
	 mvB4f5XV7pVYRdeHlcJfpL5OMpIOgjtr4nwZ7N7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0be4f339a8218d2a5bb1@syzkaller.appspotmail.com,
	stable@kernel.org,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>,
	Ahmet Eray Karadag <eraykrdg1@gmail.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 131/224] ext4: guard against EA inode refcount underflow in xattr update
Date: Mon, 27 Oct 2025 19:34:37 +0100
Message-ID: <20251027183512.486516430@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1030,7 +1030,7 @@ static int ext4_xattr_inode_update_ref(h
 				       int ref_change)
 {
 	struct ext4_iloc iloc;
-	s64 ref_count;
+	u64 ref_count;
 	int ret;
 
 	inode_lock_nested(ea_inode, I_MUTEX_XATTR);
@@ -1040,13 +1040,17 @@ static int ext4_xattr_inode_update_ref(h
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
@@ -1055,9 +1059,6 @@ static int ext4_xattr_inode_update_ref(h
 			ext4_orphan_del(handle, ea_inode);
 		}
 	} else {
-		WARN_ONCE(ref_count < 0, "EA inode %lu ref_count=%lld",
-			  ea_inode->i_ino, ref_count);
-
 		if (ref_count == 0) {
 			WARN_ONCE(ea_inode->i_nlink != 1,
 				  "EA inode %lu i_nlink=%u",


