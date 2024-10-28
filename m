Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC90F18E35B;
	Mon, 28 Oct 2024 06:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097402; cv=none; b=R5PuJwjOl9Nwr63xlQjMTyZtC1A5suFsksYKiS+TvEx5ZUBBufk0gLUDLtxZ5q7fg4vmkuwp5m606reRz4AhVGos1GtNDSpm1SQPVWnOxZIHgJXsJImQO2FIXreKSYI/uIJEZXnfFUHnghKOL52L+rrnW9asSYj+ZEtDX542lTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097402; c=relaxed/simple;
	bh=sR4Vswl97Y+AZsUhLSF2jY7No8FzqPp8fXpZnEE2Ye4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8sREBL7gV6gfmoWkWwFFmez+jrpmhtluC6z0rzY5xHYcc19QvD95duvZW5XSHGZ09zLBiTKyo2A2Tlraz1IwwGZSTic7Dw/ck+2SdhRixAa7uOQHxLELYhx7WWbUFkf8ydrC/+oGhoNBHGmZuQKd2vKbE0riO/8YhBVHXsxqXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zN+HLtMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zN+HLtMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE36C4CEC3;
	Mon, 28 Oct 2024 06:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097402;
	bh=sR4Vswl97Y+AZsUhLSF2jY7No8FzqPp8fXpZnEE2Ye4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zN+HLtMK41a9F16tqSyRWw2ee8he//cKoWyxkO88z6f/OmIkYlWsjhAmebJkT7+hz
	 WRY7lfVwh+3DJk/RMODBL2H3mniKNsQalXtvENYVo238uI2Fx3wzaJKngKkX3wUiBS
	 CCudaRtWFyh+M7ObOlF79oVXEe4dsb2rfeBKyOJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 116/137] btrfs: zoned: fix zone unusable accounting for freed reserved extent
Date: Mon, 28 Oct 2024 07:25:53 +0100
Message-ID: <20241028062301.955352165@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3562,6 +3562,8 @@ void btrfs_free_reserved_bytes(struct bt
 	spin_lock(&cache->lock);
 	if (cache->ro)
 		space_info->bytes_readonly += num_bytes;
+	else if (btrfs_is_zoned(cache->fs_info))
+		space_info->bytes_zone_unusable += num_bytes;
 	cache->reserved -= num_bytes;
 	space_info->bytes_reserved -= num_bytes;
 	space_info->max_extent_size = 0;


