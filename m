Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFCD2E62C;
	Mon,  8 Apr 2024 13:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581521; cv=none; b=qqvmu4MmrKLJ4+ONNKMiHLYqyPHNcKuuKy4yaM4b81ut9nGH0iNQCz8mBiAe1f8B/LfezZfXxdTDV7jN/p50vn+G6QvATHQs0oj8gdJMsYbwP5lttCtbzqxV4Y1zmO+arFFCn7lnAaMnbk/lydMcqily6iRUYmXjv8WOtLHXBXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581521; c=relaxed/simple;
	bh=I1nL7XBuy9d0nUUBJuMGkuqfbXApqqgyMrPXEX9BTgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQu9f27YQOaWRtYK7uY0ZSjsytGX9XQcrUoaGSR1pQ72NzrBkT8rqelXwXostfE9a9LikPOa5uyrXEk0t3yGMiMe0lnm53zYcyhsCP2v2BM92L2S8E18jboccfr9JJJpqn/vRvjekWWC0dbRPh8j2JIEVLjg/ivNrtZ6Jw2h41Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CebJGsMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CebJGsMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE75C433F1;
	Mon,  8 Apr 2024 13:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581521;
	bh=I1nL7XBuy9d0nUUBJuMGkuqfbXApqqgyMrPXEX9BTgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CebJGsMyHhsQghszCCbAPVQrj5AfSDIkYMpUtSuWXRnDkeUWgNsJaNH2r4Z+Xe48p
	 cKMaMu34sl5YvcZpwsv/aklu/Hz7Ge3k+vz0X4s7sYdNQTgdnn8dYeaAy2q+TTFNfJ
	 lpVCrDu3Vvxp5+CTQd10X/wz/KIMraXzPZzHl3m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Lyakas <alex.lyakas@zadara.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/690] btrfs: fix off-by-one chunk length calculation at contains_pending_extent()
Date: Mon,  8 Apr 2024 14:48:45 +0200
Message-ID: <20240408125401.652942779@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit ae6bd7f9b46a29af52ebfac25d395757e2031d0d ]

At contains_pending_extent() the value of the end offset of a chunk we
found in the device's allocation state io tree is inclusive, so when
we calculate the length we pass to the in_range() macro, we must sum
1 to the expression "physical_end - physical_offset".

In practice the wrong calculation should be harmless as chunks sizes
are never 1 byte and we should never have 1 byte ranges of unallocated
space. Nevertheless fix the wrong calculation.

Reported-by: Alex Lyakas <alex.lyakas@zadara.com>
Link: https://lore.kernel.org/linux-btrfs/CAOcd+r30e-f4R-5x-S7sV22RJPe7+pgwherA6xqN2_qe7o4XTg@mail.gmail.com/
Fixes: 1c11b63eff2a ("btrfs: replace pending/pinned chunks lists with io tree")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cc18ba50a61cf..1ce0fa487e5b2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1473,7 +1473,7 @@ static bool contains_pending_extent(struct btrfs_device *device, u64 *start,
 
 		if (in_range(physical_start, *start, len) ||
 		    in_range(*start, physical_start,
-			     physical_end - physical_start)) {
+			     physical_end + 1 - physical_start)) {
 			*start = physical_end + 1;
 			return true;
 		}
-- 
2.43.0



