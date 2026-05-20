Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11C6372EED;
	Wed, 20 May 2026 17:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296684; cv=none; b=N4qPKGvugLRa62UWIpg3hZjf/vQq50RLxxyVLhFOYCDgoSeSlDVV+qy0TeWmsDlBqfiDIq6LYRh9WkL78d6gkJDWCV/C/AE/JsDLUPAVLEEK2Oq+tqCijXosnkqEdDjNbRRJ4gpChazMgpiYwcrn9/Je28EK07ESIH5u87VpesE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296684; c=relaxed/simple;
	bh=2Szc7FPMLFT5fHGMTaBAhaEISoAn7ab/+4ykPVpFdQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+gXs4hIn/Z0F5Krg2qOTTOkxr97SgpKKdVQUNX3gw/p8DgSF5HxtTiU5Q0C0r+zsdrZHJXZ9RLUMKWBdgw8Q9CGjDYYXy4auCYGcdiQxDOXg7pdzKt5hdcL6pnkYl8+ZiUDI0cI8c+aCoMxHeIj/PCOl5eqViaA2PKuvOcn9RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXsc83BG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXsc83BG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587B31F000E9;
	Wed, 20 May 2026 17:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296682;
	bh=4p9llpOg209ZEu/s/731oqVD54QrMWxowYmh2he8kLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IXsc83BGJOOwsz2X7T/Q09IHZK7yQ8YepIZOb9UDU0sKJJHJcsvqCv55d935w59L/
	 o6ACiCFxD6JSpxcahm39qrNTOCqDwUNrfnPKLByk1NTymiZJtVi07Cs0FbYjVC9wou
	 M9N46jqXsT9RybX0CR23EHgEflDmdoEedagCmJA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0892/1146] btrfs: fix double-decrement of bytes_may_use in submit_one_async_extent()
Date: Wed, 20 May 2026 18:19:02 +0200
Message-ID: <20260520162208.422968194@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 82323b1a7088b7a5c3e528a5d634bff447fa286f ]

submit_one_async_extent() calls btrfs_reserve_extent(), which decrements
bytes_may_use. If the call btrfs_create_io_em() fails, we jump to
out_free_reserve, which calls extent_clear_unlock_delalloc().

Because we're specifying EXTENT_DO_ACCOUNTING, i.e.
EXTENT_CLEAR_META_RESV | EXTENT_CLEAR_DATA_RESV, this decreases
bytes_may_use again. This can lead to problems later on, as an initial
write can fail only for the writeback to silently ENOSPC.

Fix this by replacing EXTENT_DO_ACCOUNTING with EXTENT_CLEAR_META_RESV.
This parallels a4fe134fc1d8eb ("btrfs: fix a double release on reserved
extents in cow_one_range()"), which is the same fix in cow_one_range().

Fixes: 151a41bc46df ("Btrfs: fix what bits we clear when erroring out from delalloc")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c5b291ddb4776..dc2b22e65bad5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1245,7 +1245,7 @@ static void submit_one_async_extent(struct async_chunk *async_chunk,
 				     NULL, &cached,
 				     EXTENT_LOCKED | EXTENT_DELALLOC |
 				     EXTENT_DELALLOC_NEW |
-				     EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
+				     EXTENT_DEFRAG | EXTENT_CLEAR_META_RESV,
 				     PAGE_UNLOCK | PAGE_START_WRITEBACK |
 				     PAGE_END_WRITEBACK);
 	if (async_extent->cb)
-- 
2.53.0



