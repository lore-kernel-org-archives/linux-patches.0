Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C0D189BAF;
	Mon, 28 Oct 2024 06:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097873; cv=none; b=gGJhhV4CyEylsXFtEKeZLU0Nrsv/8jLlH4AxBdU3cWs15C7M0mgIpXlkCMcTQlKvHL3lxpPkERZumLIa0xM4k0Q7mwm44xmR6B0cwkKN30l7kDYvMq9kQczm9/JiT3Z03VoofUI8H7BA0CxHcVaMvYvTVYooZgMAAw6r4rYcmfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097873; c=relaxed/simple;
	bh=dsWio33Drwzik5WnpTYz9YagzYTn66G2otewksKRuWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2dZAFeEFaS0KircQb5oXr8XTUZtFO40hM3kGCL3s3DQQs4rn9v2s37eNIks5JNEn/ambVN6jyzgWFVb+pbA7ormKK/jrEKNbrLirLUI/0meAEAjir1Eai0uLUueZuuscjDnV6bsZ+XW8r+bK//9/SJz/p1fXaUGy9ZLeOBoRKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAvcbJBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAvcbJBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2538CC4CEC3;
	Mon, 28 Oct 2024 06:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097873;
	bh=dsWio33Drwzik5WnpTYz9YagzYTn66G2otewksKRuWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jAvcbJBeJybDTq3scuR0+M0eOml2jhdeezE8kS0NPYUZulHokhhM2xesA84Xtce1D
	 TKcptzIe5ADUfxkvPhvKtENRcTNwAsJUIMAAZ9EXX+GGt7b7Z0pd4LT6hpurbm4RRK
	 7VoOW9MlwEbxdSvA+bkZmyQjoA83kl7NGC8B/AmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 178/208] btrfs: zoned: fix zone unusable accounting for freed reserved extent
Date: Mon, 28 Oct 2024 07:25:58 +0100
Message-ID: <20241028062311.014402404@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3794,6 +3794,8 @@ void btrfs_free_reserved_bytes(struct bt
 	spin_lock(&cache->lock);
 	if (cache->ro)
 		space_info->bytes_readonly += num_bytes;
+	else if (btrfs_is_zoned(cache->fs_info))
+		space_info->bytes_zone_unusable += num_bytes;
 	cache->reserved -= num_bytes;
 	space_info->bytes_reserved -= num_bytes;
 	space_info->max_extent_size = 0;


