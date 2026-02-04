Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1723280A3B;
	Wed,  4 Feb 2026 14:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216228; cv=none; b=U2wkicP/uIeViOCxN8tjYFGeV0CjBgTKoELsbPUWRba7rf/atRUqughJgA5KeNLiy3d2LrKMmkrRiIfjqJuGQ4XxsKUK97pUbH/HHc7xfRLE8sRKzsAs+7ItrJmNxuESpMU7kgiaXdcG/lRZVdKAXXNqoyS+NYfK6g2GOi5E7WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216228; c=relaxed/simple;
	bh=ojvybpUOVABD/T8gQD28sGV2jGI5unZxtdSfJ9Gi6Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTcbvZTcVpxjYN9NVZxP21XbNfcFo2I0c91p61TK3a+RrunEhGZ1RUMu7wBr+KWw6nWpKcQroOigyqsGs1p0rtVoNk0tc1GZaOyaU7fXGCKjXBOjjWRpZzo6we20DP1hp8KRkPPbQASJid4RbGe+OK3hb5+rO6Q8CRp+Q6Z4hFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PL1vwJFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PL1vwJFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27224C4CEF7;
	Wed,  4 Feb 2026 14:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216227;
	bh=ojvybpUOVABD/T8gQD28sGV2jGI5unZxtdSfJ9Gi6Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PL1vwJFBVu4GDHNTSlZy5We19qE3t5DYbQYsIOzB+qzW9W3fzCIQlcNgjd4QaYJ0V
	 P5jysMTHmlns7upeo+e09BvcTIuRP+iWOT3XKQmARdHMTnjS7KH9f6/fdaIR9bkEwg
	 5qNf8nzc7r3yECGrtv3KBUeTFP8MXLkGkl7QKtEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/161] btrfs: send: check for inline extents in range_is_hole_in_parent()
Date: Wed,  4 Feb 2026 15:37:47 +0100
Message-ID: <20260204143851.919366239@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 08b096c1372cd69627f4f559fb47c9fb67a52b39 ]

Before accessing the disk_bytenr field of a file extent item we need
to check if we are dealing with an inline extent.
This is because for inline extents their data starts at the offset of
the disk_bytenr field. So accessing the disk_bytenr
means we are accessing inline data or in case the inline data is less
than 8 bytes we can actually cause an invalid
memory access if this inline extent item is the first item in the leaf
or access metadata from other items.

Fixes: 82bfb2e7b645 ("Btrfs: incremental send, fix unnecessary hole writes for sparse files")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index d86b4d13cae48..f144171ed6b7e 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5892,6 +5892,8 @@ static int range_is_hole_in_parent(struct send_ctx *sctx,
 		extent_end = btrfs_file_extent_end(path);
 		if (extent_end <= start)
 			goto next;
+		if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE)
+			return 0;
 		if (btrfs_file_extent_disk_bytenr(leaf, fi) == 0) {
 			search_start = extent_end;
 			goto next;
-- 
2.51.0



