Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8BE421EE4;
	Tue, 31 Mar 2026 16:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974563; cv=none; b=arWpenZDoG69Vjd3oTZwGyQaG1ljV20twJMi0TzGVqmzWxO3ZaBFMxjHJ9x0DL7tk4j+yRiqn+q0/DleqaCTkBS5g63TjRYNz6xbT6BkySomtj4N+b51RO6I5rOyHzV6mTZXX25zjVbRbHSylSnJxlthqqWvcIHAb1vs6m60zNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974563; c=relaxed/simple;
	bh=j/VOvBbl/KBVPYilapXpv21XFbX7XY/92jI12ys9WDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhkFaiRcrocb2Jgy7nhKoAulQ0bNJHqkOke+aoIU54uIh9ppW7JXK1WdfizDo8Kc3sk9TLEIUH646/nuC3tqU8VQfpYwb6AM0SqRQABI4tocaXPEYb2SO4+fHlFztbEpT51MHE8cNXtDb3buu6oC+6jpDllBQwFvX95hjWhUsOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kspmJG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kspmJG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C9BC19423;
	Tue, 31 Mar 2026 16:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974563;
	bh=j/VOvBbl/KBVPYilapXpv21XFbX7XY/92jI12ys9WDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kspmJG77f9h3EYptCgETbKzZkLxeigzMFHcS6ciiGmjU3N8q22MACPrxDV+PVlgc
	 3pnjtE050/hh+GRo//y/TrtNc7/suj2s5Rmb/BUPhY8SHmUI1+JDhV2IRfeOvVEeo1
	 LfqI8OZJUDxCaomZGbfVSiaby5rNHXX29+4T5vSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 133/175] ext4: make recently_deleted() properly work with lazy itable initialization
Date: Tue, 31 Mar 2026 18:21:57 +0200
Message-ID: <20260331161734.672809333@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit bd060afa7cc3e0ad30afa9ecc544a78638498555 upstream.

recently_deleted() checks whether inode has been used in the near past.
However this can give false positive result when inode table is not
initialized yet and we are in fact comparing to random garbage (or stale
itable block of a filesystem before mkfs). Ultimately this results in
uninitialized inodes being skipped during inode allocation and possibly
they are never initialized and thus e2fsck complains.  Verify if the
inode has been initialized before checking for dtime.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20260216164848.3074-3-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ialloc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -688,6 +688,12 @@ static int recently_deleted(struct super
 	if (unlikely(!gdp))
 		return 0;
 
+	/* Inode was never used in this filesystem? */
+	if (ext4_has_group_desc_csum(sb) &&
+	    (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT) ||
+	     ino >= EXT4_INODES_PER_GROUP(sb) - ext4_itable_unused_count(sb, gdp)))
+		return 0;
+
 	bh = sb_find_get_block(sb, ext4_inode_table(sb, gdp) +
 		       (ino / inodes_per_block));
 	if (!bh || !buffer_uptodate(bh))


