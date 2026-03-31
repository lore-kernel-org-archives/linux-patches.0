Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FF94266BC;
	Tue, 31 Mar 2026 16:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976047; cv=none; b=nhIEt5IQaqBO+ucYEU07jq/wnd5Y7ZiNu8OgGc6RVusheJkiynfjQ2HqSJS8vn4iTLGTvvYj4THt53v5BC3NpztMbSLULnBn9viNXA/Y/Qim+KJKv6M8y97mHfGj2WVpFl8JEhqprBlmdZpM19VKcKHgMD9+gxWiQnY/ch4XNv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976047; c=relaxed/simple;
	bh=bpwsubwuHvmTFWfU8PH1uagJj5ebFzkoT5TTGk0fxwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlOCy+RGkzw9xd1svpqGJRMOQnNbQXM5SBtUbKnR6M/F8qt7/3DgnKZoW1O7sCWFhx01uvbl3HiRCAB0f7ubM/5OFxMR+xg91iSxxnbiv6ZOgPmYo9qtEyv8mY+VRFUelQOD5cz+wcCBQ9piO6VQkqNrZUUGYv50wnL4uU7dQQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gs/BWNOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gs/BWNOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1941BC19424;
	Tue, 31 Mar 2026 16:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976047;
	bh=bpwsubwuHvmTFWfU8PH1uagJj5ebFzkoT5TTGk0fxwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gs/BWNOLHYPg3qDRebKz3Nk2a1SgzUx/yCIIgR5TapD+RZRPj2ggMQWd3gUmwqWk1
	 j7mQcV8KEiQbw3RRdzaWQZK+fKtvYEc9qBsfsxJt9QYowPe0/Km2rVOPwSRXad9mZH
	 CCoRbvHJWzddf3iaAkcGeGbFQ2f+yMkzUH8nokKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.12 187/244] ext4: make recently_deleted() properly work with lazy itable initialization
Date: Tue, 31 Mar 2026 18:22:17 +0200
Message-ID: <20260331161748.662879969@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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


