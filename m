Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EB334A3D6;
	Wed, 21 Jan 2026 18:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020059; cv=none; b=FQ4qATCmu2MI0LzNrIGr4hhsB620s5QWYcWEKZyzSmzi5OcVZaimr/N/GTBjBGFEzhcInomQOcTCesLmCr8QNr2rCWoiGV2GJn5iyUoQi5fjyvtYqGcMFSKt4jVkkhmj0Y8tFKZqDqr1XUsW5FP5pfdbnQZp0J8PFE0htATEA1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020059; c=relaxed/simple;
	bh=KmhDBQMfrP2FWOtNSLo4VM/GO4s9IzB9EqYeDg6wQhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oo/eL6g2Km7Caj1utM2aOINQV5sumL6wblc9T4Av3pn9ondaYvrv0aDtE+sBL5K/YysrloBOltcKj9i3h0GrkjsuecdaGLI7iokueVsRY+rAVoJTtjJWxh2pX/MpoBuyBS3/Y8KGu6tT2gvyxRnyT9a1kyma0/s7ys3CCiHlH3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6WVQ3LY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6WVQ3LY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92951C4CEF1;
	Wed, 21 Jan 2026 18:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020059;
	bh=KmhDBQMfrP2FWOtNSLo4VM/GO4s9IzB9EqYeDg6wQhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6WVQ3LYi23/P/rrdyehw/ROKIKfr9tDxinlQ5SLPt/WI2MLjxtXRe3vip0xa0WlH
	 C3uegqp4Z9DDuDs51ODtgWcP3mkdd1shUb9cGoE/5WNFhsJXnUAzSWFD867aKw92t+
	 QO4u4M66lujZortp9gHWLXGr10l6fo/X8NI6HhYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/198] btrfs: send: check for inline extents in range_is_hole_in_parent()
Date: Wed, 21 Jan 2026 19:14:18 +0100
Message-ID: <20260121181419.637451498@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 96a030d28e091..9012ce7a742f4 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6399,6 +6399,8 @@ static int range_is_hole_in_parent(struct send_ctx *sctx,
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



