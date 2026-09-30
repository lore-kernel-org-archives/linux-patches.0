Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935004CC63A;
	Wed, 30 Sep 2026 18:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791974; cv=none; b=N4s3uqMX1PuOoYMO7WulJi45vM9QJNXQilw5zeWbmZLeX85CDFPfb0fZCf82xYVq2HKnBoaZYVAhrneAM6s9DiqzNNqmvJ40xwXrWPn5R8+F4Wef+xuw5K337eDlpdPrEIYePYF+YzNvy4gWi57YtNvnNeKP5QjTayBIpKTjQkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791974; c=relaxed/simple;
	bh=z4JX1yu+FBqEdF3pa8OemsAZKbRcZH/unu4RXxIJtJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mpyo7rxspDP4rN2wvpuqwimvLkpS3KH6CzE2CBcWK7jKoLPOTpAF1J7XckhTIlY30c/Q10ihAfgf9QO9qz4LgcFlpR4DQdGspBgwhCFBlKPzRB6a2ADwIeMP0YqnNvM93mjHamIYC1tVV/7KiA857rZ3pEZL5gJvqwKlgwjy5aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFfuLUgU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFfuLUgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF80F1F000FF;
	Wed, 30 Sep 2026 18:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791973;
	bh=dwugK/HZJhJjbwEeRGwl8rOuaMiPys+1zcYj/2n6/to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mFfuLUgUBIOBOGQvlCALYWrf3wEvBWXvSnUkOWaNw+7DmqWQsYWq07c5nRUq53r9k
	 usWj3RDAzY4A43UV6eAcUJOuT+SsUxAcbrNnPjZh6h8VXkDBUWaururZssgNT91gAT
	 N4q7MGtWJH0dZr+vHGvD8sem6S3zmcMcUmhJ3jFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 490/752] btrfs: tree-checker: print dev extent offset in error message
Date: Wed, 30 Sep 2026 17:26:00 +0200
Message-ID: <20260930152408.869630539@linuxfoundation.org>
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
index 5e2c44ab52b34..4b7454f7f383f 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1681,7 +1681,7 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
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



