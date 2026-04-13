Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557CB31E84D;
	Mon, 13 Apr 2026 16:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099347; cv=none; b=JN38UBsaQYyGrS2p4PvuHuAsoPg/hpOzH9iwMJGg0858k7o7gbN3nJ7rDmmmgV/pCr96Ueom2H2Uq9nH+e+rocRtsL3QX62QgE6WrlqMAlHJYU7/N4rQP5XRv5j+IfzU92LmvNyahA8Zj7OpuPQ2h7BT5BNzOrqApwqKsIVA3gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099347; c=relaxed/simple;
	bh=CU/dqCCYYWTtE6oOn73EU2K3Y4wrn1tOQq6iSD3ysJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uP1TmgWDFuLqQfLDtdMneN8IbTUrNHaEQH9axA5ZYyg1oAOXJWvtNV5BHd8lz79ZQsiae9zuPgsIxZHc9JR+4+ey3+AqG/00NGOdiVzxbB2Jt5Z1oaG/1yvMLuQtufGVuyOc9CC1eF+YDsosFnL9BtJFqco6tS54oCtRUGaUDh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtQ6JTvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtQ6JTvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E056DC2BCAF;
	Mon, 13 Apr 2026 16:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099347;
	bh=CU/dqCCYYWTtE6oOn73EU2K3Y4wrn1tOQq6iSD3ysJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtQ6JTvUaLmM8WFPACZcm2aZPhGthnJPSasI+an4StNEKhtPKd2FIWHsLo6cPlix4
	 lRT3XtPAOe3iQHARF8Oe8SD2FveZMarVVDxYoldGiNvqEtJgMu0MX4hKj2AmYkr8Py
	 Dk9nkThnM5ZXSw6Lu/43bOZScqNClfDB2nZ1gQJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.10 305/491] ext4: make recently_deleted() properly work with lazy itable initialization
Date: Mon, 13 Apr 2026 17:59:10 +0200
Message-ID: <20260413155830.459739616@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -686,6 +686,12 @@ static int recently_deleted(struct super
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


