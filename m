Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290C484D12;
	Wed,  7 Aug 2024 15:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043073; cv=none; b=DuoDzHRrHfMxSqOryaT15/f1A/h1mHVDj6OA/Mv1rl5GOW/+qd5D5PYTUoXW77CXfWu1E7X/2+fLO0MRdXrvqJfTwBFbnbgpo7eSRMuW5wzE1TCXHeq4YnYIRvjwGVPFP6Z6HcTblsecFvW1NVjqV8Q5DzHQGc64UYdX1h32cZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043073; c=relaxed/simple;
	bh=jPXTh2OPZsWZhk0dul3jfBXG5yuBhQCAH5QjtQsF3iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGosjy7dt7yEin20lwGE/vsIbu3aw362JbFEEitmi4gSaG5ipG3lpf2+yD7IZszf4HpUPq+Gjwc7yXQNFIF7fKjikVwydof8PLzaMFcdY0FG93Ba1D3zn7GqSKZDO8VosiEvTlITlRU48vjspG5+jy3pOvlUgb/3fH8vdHPCvCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yUueT70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yUueT70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD2FC4AF0B;
	Wed,  7 Aug 2024 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043073;
	bh=jPXTh2OPZsWZhk0dul3jfBXG5yuBhQCAH5QjtQsF3iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yUueT70yGAuzaZNjBqGYsRSk27cuYG6TbG13j/+zrP7DF1g4+w/SgJqZbPcLJSXG
	 HHvZzZSaVCAK/25P9ACgcnoKaQj6vNbD81ZZTrD7Fqi1MnX4AFuGZprGorN8EOihwz
	 5JxaTTHExdJWXfF9lwBswsMbVg2K7Wsd/xf8RzBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.10 081/123] btrfs: do not subtract delalloc from avail bytes
Date: Wed,  7 Aug 2024 17:00:00 +0200
Message-ID: <20240807150023.428003766@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit d89c285d28491d8f10534c262ac9e6bdcbe1b4d2 upstream.

The block group's avail bytes printed when dumping a space info subtract
the delalloc_bytes. However, as shown in btrfs_add_reserved_bytes() and
btrfs_free_reserved_bytes(), it is added or subtracted along with
"reserved" for the delalloc case, which means the "delalloc_bytes" is a
part of the "reserved" bytes. So, excluding it to calculate the avail space
counts delalloc_bytes twice, which can lead to an invalid result.

Fixes: e50b122b832b ("btrfs: print available space for a block group when dumping a space info")
CC: stable@vger.kernel.org # 6.6+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/space-info.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -573,8 +573,7 @@ again:
 
 		spin_lock(&cache->lock);
 		avail = cache->length - cache->used - cache->pinned -
-			cache->reserved - cache->delalloc_bytes -
-			cache->bytes_super - cache->zone_unusable;
+			cache->reserved - cache->bytes_super - cache->zone_unusable;
 		btrfs_info(fs_info,
 "block group %llu has %llu bytes, %llu used %llu pinned %llu reserved %llu delalloc %llu super %llu zone_unusable (%llu bytes available) %s",
 			   cache->start, cache->length, cache->used, cache->pinned,


