Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962F61DF981;
	Tue,  8 Oct 2024 12:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392190; cv=none; b=r35yTPs1dv3zg1qZFOvyW15SSJmp+RtkbPAP3TB3+KQHKkJs4NwlcGAOvyMcyj0oUC4VZq3Wkf8jB/HJH0U4ApmtIxkwC4AFYpGWD3xu4S4yzQjp7ZzYXca1GR88MuCo3DPls9vnUyH/BxkUVHtVMblbCMxsRV20kyz69aIOVTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392190; c=relaxed/simple;
	bh=EBdHam9tX9+7/pLOhO6e4ceDl6ylOMTsnGZgMHy51s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bs3nxg2Uf1dvMhboB6BOXVEhuHcwr2mQ3DQGI87X3fIVVXn/IOH+H8g2chdM0wrCYnOM0rKm4HpwbclCMiCWU/RFNynI3uG48eqnIHmW02+6GqyqJr5I5XlUKEiSd5jgMhneseFHPHOTK92mUUziqaJRfqFid8ocyWaRVijk13c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUCGkrC6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUCGkrC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAE2C4CECC;
	Tue,  8 Oct 2024 12:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392190;
	bh=EBdHam9tX9+7/pLOhO6e4ceDl6ylOMTsnGZgMHy51s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YUCGkrC6bZffrbRuG8D2txBkEUASA9sCVI5XOpj/lBG1CZ9fXpo03baqABM54l53B
	 UB1TRKY8MqquOc0gk4aj8ZT6BsCYicKlY+7tzHsMzADTePKDNyJ5xuZPdGICtOPjj/
	 fxans4w0nwZhr8Ku3SfDkukzm+Cpbve7XR+vgKKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 311/558] iomap: handle a post-direct I/O invalidate race in iomap_write_delalloc_release
Date: Tue,  8 Oct 2024 14:05:41 +0200
Message-ID: <20241008115714.550716480@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7a9d43eace888a0ee6095035997bb138425844d3 ]

When direct I/O completions invalidates the page cache it holds neither the
i_rwsem nor the invalidate_lock so it can be racing with
iomap_write_delalloc_release.  If the search for the end of the region that
contains data returns the start offset we hit such a race and just need to
look for the end of the newly created hole instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20240910043949.3481298-2-hch@lst.de
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 389de94715b53..8e6edb6628183 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1241,7 +1241,15 @@ static int iomap_write_delalloc_release(struct inode *inode,
 			error = data_end;
 			goto out_unlock;
 		}
-		WARN_ON_ONCE(data_end <= start_byte);
+
+		/*
+		 * If we race with post-direct I/O invalidation of the page cache,
+		 * there might be no data left at start_byte.
+		 */
+		if (data_end == start_byte)
+			continue;
+
+		WARN_ON_ONCE(data_end < start_byte);
 		WARN_ON_ONCE(data_end > scan_end_byte);
 
 		error = iomap_write_delalloc_scan(inode, &punch_start_byte,
-- 
2.43.0



