Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF8D15B10D;
	Mon, 28 Oct 2024 06:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097108; cv=none; b=o00zMdVLLPaF48Dz+ov4KYsnRSyM+0z9cCBxmF+qQf4FWGyBeigJ+1zL4mev4CQ+0DC7PXWfQNld4QpIyu6iBLsTr5AqPAkIUtXo6nEsl5rbWh2V1BbiYXRve2n232hUOb4Bjqy+5rr0Kck//im0BqaRWVWS/ryISnwII5/aZ+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097108; c=relaxed/simple;
	bh=mqWCJ1C4ip5SWKnpdmm6L6zN3F3ikkLv4Gje/kHQYso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMjqiBVSei5IN3oqlu7fTizr1tJ+ljosN72dvX6hvNEBakmQpr5oxEjlCo+LTCVi1XtSwAHarkdGWxhZuZNyNPfDRZsigfG8xb4QbcBCBvUFPnpufnx9rOW8evSPt+D4aRLveLPvkBICXu+poDRJWTbcCC+SvDvI5WsBB2R3Sv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RW3foXIn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RW3foXIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D92C4CEC7;
	Mon, 28 Oct 2024 06:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097108;
	bh=mqWCJ1C4ip5SWKnpdmm6L6zN3F3ikkLv4Gje/kHQYso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RW3foXIn6jZsaHd/i7CgcGqOIs1vru/xKyR/bhUUZAx9FlJ87Wkmx6hAWyWrhVm8g
	 t52/Dj5yLdGp8WF8zlBVPW6cxuLJHIT/slrbuCFuwA6C2qI5053OLosa50IkQOaOAH
	 hq/gGzdHmarIfmkEqwbv2uQXlld96ZqrhsnGpYkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 67/80] btrfs: zoned: fix zone unusable accounting for freed reserved extent
Date: Mon, 28 Oct 2024 07:25:47 +0100
Message-ID: <20241028062254.474197598@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit bf9821ba4792a0d9a2e72803ae7b4341faf3d532 upstream.

When btrfs reserves an extent and does not use it (e.g, by an error), it
calls btrfs_free_reserved_extent() to free the reserved extent. In the
process, it calls btrfs_add_free_space() and then it accounts the region
bytes as block_group->zone_unusable.

However, it leaves the space_info->bytes_zone_unusable side not updated. As
a result, ENOSPC can happen while a space_info reservation succeeded. The
reservation is fine because the freed region is not added in
space_info->bytes_zone_unusable, leaving that space as "free". OTOH,
corresponding block group counts it as zone_unusable and its allocation
pointer is not rewound, we cannot allocate an extent from that block group.
That will also negate space_info's async/sync reclaim process, and cause an
ENOSPC error from the extent allocation process.

Fix that by returning the space to space_info->bytes_zone_unusable.
Ideally, since a bio is not submitted for this reserved region, we should
return the space to free space and rewind the allocation pointer. But, it
needs rework on extent allocation handling, so let it work in this way for
now.

Fixes: 169e0da91a21 ("btrfs: zoned: track unusable bytes for zones")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3386,6 +3386,8 @@ void btrfs_free_reserved_bytes(struct bt
 	spin_lock(&cache->lock);
 	if (cache->ro)
 		space_info->bytes_readonly += num_bytes;
+	else if (btrfs_is_zoned(cache->fs_info))
+		space_info->bytes_zone_unusable += num_bytes;
 	cache->reserved -= num_bytes;
 	space_info->bytes_reserved -= num_bytes;
 	space_info->max_extent_size = 0;


