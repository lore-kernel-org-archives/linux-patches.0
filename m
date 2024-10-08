Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDE91E485;
	Tue,  8 Oct 2024 12:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390330; cv=none; b=E87Hc97d3zRvMVjqmAqr85/S+Ox4pgb1xHup8AwAL0KLvezulG+ehw1EFF7Dv6uIpbTfEVhsbIbZ/gBgY0I1xgAJztJbqUCRVthVpi3Ggk7S8/xOOwoeK7sstkO69n/cKa76t6jaN+N6ziqwfmOcHw+JvYtbcM3ryrT/Y0FDqTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390330; c=relaxed/simple;
	bh=xzjoFnjSPlmJBNNqOs3sqy3ncjg6Y5bXvbOZpnPXTcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4zGQDsLIzh9Rg4x7XsFQKBqVOt/E4vJTg92MT09CiFZmamZw0sPwdWMKUjc/A79FDeSnhZtuJLlffolo4yTkqZeuYbFiOhVCP79dvKew1e5PT95sAtxqqsjnZjbf/VhT+Udg+TafMZAyQuqFljeb4WaGA+bBA/BmWIAM/BPInY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9DB6YjC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9DB6YjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7082EC4CECC;
	Tue,  8 Oct 2024 12:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390329;
	bh=xzjoFnjSPlmJBNNqOs3sqy3ncjg6Y5bXvbOZpnPXTcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9DB6YjCC1BF7UJsNyjuqKZBXkFDjGXM09AFatur+LcO72CYLodYAlBNMos4lfvwN
	 1Dabr453BofhbXHpMr9CzS3dsfbUXpAqOCrAA5ryNUpwyVGKa84OLM1PrWcBnMPEpH
	 Hfuab6mCjv9y3p0gNyQzPr5d3X/7XrwJAZLXr9cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 255/482] iomap: handle a post-direct I/O invalidate race in iomap_write_delalloc_release
Date: Tue,  8 Oct 2024 14:05:18 +0200
Message-ID: <20241008115658.322424492@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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
index e817564e80e01..b9b035a5e7793 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1226,7 +1226,15 @@ static int iomap_write_delalloc_release(struct inode *inode,
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



