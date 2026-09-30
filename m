Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F9A5221E0;
	Wed, 30 Sep 2026 17:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790959; cv=none; b=t52ENzyJHJTQ2/1Wkt83PD9Km+M7sYJSXPDLNnFzODi/uipvZR2QB2JFKJbxKKibR1WEcgN4nStolrxws2XmgqMACXl33e39tADVonB+oQrUSu+u9PRtHQLWKaSssMQTkK7in1EcEbv9qmyrb5/NDcfiYJb0tGTbs9GYX324OBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790959; c=relaxed/simple;
	bh=Kn9uiabDUtE1nDNmvkQzGF27lGageMqDk50g9QDSOGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spLy/uRp48loymfWpaEKQ4xDD9MOzaLfMyrcVcoxVPQJkB5UL88BST5nMp+beMdcTS2rhnf0b/KCTa+YK6bvxJVLFdARg/vgASg75wh6dlLXIKvTiduw0APlfoO1WcPl8QPnyhID8Z+3dig/Irhj+kUW9jg9U0J9ZPnl8VyKFws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DV/Mls3Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DV/Mls3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566661F000FF;
	Wed, 30 Sep 2026 17:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790957;
	bh=fotyLroRjX8QK0RwNw0i90+wSUUBYl0F14gr6bO4owE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DV/Mls3QWZBb0Oc0pUtez7sWMC/0yWOtGMAHUod1fP/g9DlyQ9yiXLdnlpXcKaDkx
	 LJuOnrz3MAOJPR0KsW1nhmvO0EIlEwXdbSInuFaI07FExuizw/F5gSMI6XQFg49+W+
	 tFxKICAmGS7pU/Nl1ucZtbgRXWS9Z+bnV808e2GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhengYuan Huang <gality369@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/752] btrfs: balance: fix potential bg lookup failure in btrfs_may_alloc_data_chunk()
Date: Wed, 30 Sep 2026 17:19:57 +0200
Message-ID: <20260930152400.927711142@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhengYuan Huang <gality369@gmail.com>

[ Upstream commit 18d32b0013efba19f7ad3e5b08d7aee813d604a6 ]

[BUG]
Running btrfs balance can trigger a null-ptr-deref before relocating a
data chunk when metadata corruption leaves a chunk in the chunk tree
without a corresponding block group in the in-memory cache:

  KASAN: null-ptr-deref in range [0x0000000000000088-0x000000000000008f]
  RIP: 0010:btrfs_may_alloc_data_chunk+0x40/0x1c0 fs/btrfs/volumes.c:3601
  Call Trace:
    __btrfs_balance fs/btrfs/volumes.c:4217 [inline]
    btrfs_balance+0x2516/0x42b0 fs/btrfs/volumes.c:4604
    btrfs_ioctl_balance fs/btrfs/ioctl.c:3577 [inline]
    btrfs_ioctl+0x25cf/0x5b90 fs/btrfs/ioctl.c:5313
    ...

[CAUSE]
__btrfs_balance() iterates the on-disk chunk tree and passes the chunk
logical bytenr to btrfs_may_alloc_data_chunk() before relocating a data
chunk. That helper then queries the in-memory block group cache:

  cache = btrfs_lookup_block_group(fs_info, chunk_offset);
  chunk_type = cache->flags;   /* cache may be NULL */

A corrupt image can contain a chunk item whose matching block group
item is missing, so no block group is ever inserted into the cache. In
that case btrfs_lookup_block_group() returns NULL.

The code only guards this with ASSERT(cache), which becomes a no-op when
CONFIG_BTRFS_ASSERT is disabled. The subsequent dereference of
cache->flags therefore crashes the kernel.

[FIX]
Add a NULL check after btrfs_lookup_block_group() in
btrfs_may_alloc_data_chunk() and print and error message for clarity.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9ab226814cfde..459dd6da41af5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3476,7 +3476,11 @@ static int btrfs_may_alloc_data_chunk(struct btrfs_fs_info *fs_info,
 	u64 chunk_type;
 
 	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
-	ASSERT(cache);
+	if (unlikely(!cache)) {
+		btrfs_err(fs_info, "balance: chunk at bytenr %llu has no corresponding block group",
+			  chunk_offset);
+		return -EUCLEAN;
+	}
 	chunk_type = cache->flags;
 	btrfs_put_block_group(cache);
 
-- 
2.53.0



