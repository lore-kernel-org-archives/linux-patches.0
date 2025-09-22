Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E4B2F0C64;
	Mon, 22 Sep 2025 19:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570084; cv=none; b=o6wYOJP6IHlQ7naW8XEaHUMYANCTrmhoMo9TwTADCdt7oj7OCeva35HGlvpGCBIoY2Un4PfT36j/yyMSBzGrOKKcLFkHWdGO2BM1r8ZY8kg0JoxekVLq6WTprvyBcg8Gp8cGRRa9HmeNtmWy8s6BN1sroqSYg4Air0dX1MEwwfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570084; c=relaxed/simple;
	bh=PbPaE3MT9Qvi6E9ooBHxEfTsXUcg1D3qZvbID8Kj2qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlHXCgpBQpb6mvemMfs+m3licub4xBqMrGADsCbAEUIVWfpRsMI0qCz5230XvC3HlAMsDME320HgUyszaY4D+eKXigGdep7k1fge1agn1YUXzcs9NKm1x+r3eHsX+pdWkM/F8rPIWGGpdQYmEfeCgiFJE6r5hO6waRzP6lGO08E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PzdOx1ZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PzdOx1ZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2EDC4CEF0;
	Mon, 22 Sep 2025 19:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570084;
	bh=PbPaE3MT9Qvi6E9ooBHxEfTsXUcg1D3qZvbID8Kj2qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzdOx1ZGqbVubdV98BcVagTICS3w//ksd9ZC0ajPmLMpHaG18uo00+zVTuAkPQBAh
	 GcdI4AejbFoZcz0ktJGpWVEfO9T1tnM6Ty+l1UuM/aHjVu10wls6jRQXDuGPratm4f
	 OtSCTdorDZM2fReUadlG0SMelWUO3ZMR1dKhi7j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 003/149] btrfs: zoned: fix incorrect ASSERT in btrfs_zoned_reserve_data_reloc_bg()
Date: Mon, 22 Sep 2025 21:28:23 +0200
Message-ID: <20250922192412.980934474@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 5b8d2964754102323ca24495ba94892426284e3a ]

When moving a block-group to the dedicated data relocation space-info in
btrfs_zoned_reserve_data_reloc_bg() it is asserted that the newly
created block group for data relocation does not contain any
zone_unusable bytes.

But on disks with zone_capacity < zone_size, the difference between
zone_size and zone_capacity is accounted as zone_unusable.

Instead of asserting that the block-group does not contain any
zone_unusable bytes, remove them from the block-groups total size.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Link: https://lore.kernel.org/linux-block/CAHj4cs8-cS2E+-xQ-d2Bj6vMJZ+CwT_cbdWBTju4BV35LsvEYw@mail.gmail.com/
Fixes: daa0fde322350 ("btrfs: zoned: fix data relocation block group reservation")
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index d7a1193332d94..60937127a0bc6 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2577,9 +2577,9 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
 			spin_lock(&space_info->lock);
 			space_info->total_bytes -= bg->length;
 			space_info->disk_total -= bg->length * factor;
+			space_info->disk_total -= bg->zone_unusable;
 			/* There is no allocation ever happened. */
 			ASSERT(bg->used == 0);
-			ASSERT(bg->zone_unusable == 0);
 			/* No super block in a block group on the zoned setup. */
 			ASSERT(bg->bytes_super == 0);
 			spin_unlock(&space_info->lock);
-- 
2.51.0



