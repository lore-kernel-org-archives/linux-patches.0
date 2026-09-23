Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0352348A2BC;
	Wed, 23 Sep 2026 14:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174475; cv=none; b=Moq/otwbo6dTyoSGADqcESf20omUTXmamQDhIjRxdTJ8xGY5rOWocxfBEFLNgKQHlMaH1iHISHoKa0vbujsrcaoNCGDAfifXgaxJrNRk65rEHfItjRFpHoCbZbwfx6J6PWtmvRw4t0UFb9juu3STS1WSLLcVzSPzewrC6eYZM+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174475; c=relaxed/simple;
	bh=OukZFa9er++PM9XtdcLzhL8+waBQ8o1k9E7ixAVbifI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeaxBEyT+cdOl4cEda/nuxPrv95r2JyUgOgezs/ZGiBYdS2X+Fjzak8qZxrUDE3FP3dBWlhC8aQrJm76tiAoR/9EcxcbugPQAW7oxqczCPJPRgAeneH63oCztoe2NnlxW5m2DcQausoR6DtyWZgZNa4E/hTGBDt6Ey2dXMRkO7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyN3ItMo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyN3ItMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBEC1F000FF;
	Wed, 23 Sep 2026 14:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174473;
	bh=HxbF/vBbDka+qWXyL7KEi+c9CdZkGKcFc2x1BOPUjz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zyN3ItMo5fWFFoMPiJGfNFarv5QuonHdb6gVQUW+D9rE3Ic8TK925wbmJdIaKTDRC
	 3hAqii+bOJyXZbPmsD10YM1F3/NnLcu+NqlVCoYIUJX8+GMQort4T783F0q5aKr9S+
	 jnLbBlbSQGmyESArSjKAnilT9OzsZ2Q2bB+APRXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 126/398] btrfs: tree-checker: print dev extent offset in error message
Date: Wed, 23 Sep 2026 16:03:20 +0200
Message-ID: <20260923140646.704558146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a1167d9420474ab9ed9efca99d86aeb6217c0265 ]

If a dev extent's offset is not sector size aligned, the error message is
printing the dev extent's objectid instead of the offset. This is a copy
paste error, as before this check we check the objectid field.

Fixes: 008e2512dc56 ("btrfs: tree-checker: add dev extent item checks")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 79f297d9ebc4a..baaca330e5dba 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1925,7 +1925,7 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
 				 sectorsize))) {
 		generic_err(leaf, slot,
 			    "invalid dev extent chunk offset, has %llu not aligned to %u",
-			    btrfs_dev_extent_chunk_objectid(leaf, de),
+			    btrfs_dev_extent_chunk_offset(leaf, de),
 			    sectorsize);
 		return -EUCLEAN;
 	}
-- 
2.53.0



