Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89062E9EC7;
	Thu, 30 Jul 2026 14:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421706; cv=none; b=dek0MGB6UGHcyM92xP5Zbjqya5sRkxqu7lPZr5Lh0+TLyOuipZuewBcejZhILiocd1iXjzUx+jdbWPpazVd76r2AnAa2Jat44kCo7kFvqqfSSe7xrNXVTZD06wTKMTbluRhIFgH4PWBV78yiMHfkHa56V6yV/TWKaQPKsJogNcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421706; c=relaxed/simple;
	bh=Jbmvo7GeglVzarfFkm2AunbzpowsrS4/mknZUV5hRx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byihS+cWgGg5krm+QAyRJunpe/5H8pbQ3iMggfJbqn3aDXDxFXVnXxOWOIEGOPeGmL9QK2RmL1xwKbCX/+Vj9H1U8r+JkKv7H0IbGsSi+gTPa4gtVZpcRi66A9dqYlEGAmPEsZqUzDwCmN5n39wFltK40uonoyBCLgMk6+ntdbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QIDJ/cix; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QIDJ/cix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCC01F000E9;
	Thu, 30 Jul 2026 14:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421705;
	bh=Wypr3Kk4wuXZH+nHLhhHDR93WGjFok+je/UNuSSaZZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QIDJ/cixEe4bIkDH1wMJoc6LsArRZiiGlMeTWC8JPN2lFZp8TkPCqEfCoyeZsKHcl
	 HDq+hfG0Oi2XRFa9rieyrUF+kpDW3J6FOTpKIUWJZmIpzWM0UT/sKhbE4AcogvGAgw
	 v97qTki1qPARbFNolarsIDK/qkepi9omQoBifpX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	Leo Martins <loemra.dev@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 194/744] btrfs: dont propagate EXTENT_FLAG_LOGGING to split extent maps
Date: Thu, 30 Jul 2026 16:07:47 +0200
Message-ID: <20260730141448.405525842@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Martins <loemra.dev@gmail.com>

[ Upstream commit 5eff4d5b17fa1950e80bfd1ba43dc0699e61a644 ]

When btrfs_drop_extent_map_range() splits an extent map, the new split
maps inherit the original map's flags through a local 'flags' variable.
Commit f86f7a75e2fb ("btrfs: use the flags of an extent map to identify
the compression type") changed the EXTENT_FLAG_LOGGING clearing to
operate on em->flags instead of that local 'flags' copy, so a split of
an extent map that is currently being logged wrongly inherits
EXTENT_FLAG_LOGGING.

The flag is then never cleared on the split, and when it is freed while
still on the inode's modified_extents list (for example by the extent
map shrinker) it trips the WARN_ON(!list_empty(&em->list)) in
btrfs_free_extent_map() and leads to a use-after-free.

Clear EXTENT_FLAG_LOGGING from the local 'flags' copy used for the
splits and only clear EXTENT_FLAG_PINNED from em->flags, restoring the
behaviour prior to f86f7a75e2fb.

CC: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/all/20260629-btrfs-skip-logging-v1-1-4e3a28c1acaf@kernel.org/
Fixes: f86f7a75e2fb ("btrfs: use the flags of an extent map to identify the compression type")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Leo Martins <loemra.dev@gmail.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_map.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 6b79bff241f21d..a8bce1d4e92c80 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -866,13 +866,13 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 			goto next;
 		}
 
-		flags = em->flags;
 		/*
 		 * In case we split the extent map, we want to preserve the
 		 * EXTENT_FLAG_LOGGING flag on our extent map, but we don't want
 		 * it on the new extent maps.
 		 */
-		em->flags &= ~(EXTENT_FLAG_PINNED | EXTENT_FLAG_LOGGING);
+		flags = em->flags & ~EXTENT_FLAG_LOGGING;
+		em->flags &= ~EXTENT_FLAG_PINNED;
 		modified = !list_empty(&em->list);
 
 		/*
-- 
2.53.0



