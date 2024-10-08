Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7041DDA36;
	Tue,  8 Oct 2024 13:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393548; cv=none; b=Oau2cg5pRVb1uhXsd4YinuYh3s6s4/u+dMjNFkw8ai5PF0uvGHmY9YkMLS+bpWp2mX/YnKNUcOn3xdQBlGhSe7Rru6cteK4ksSCC+92fJsxIOW2j1qz2XqGopgZtA+UrZzM7H0ss21sqDzko2zakOINEZgVULGFEvhRhKRpP+u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393548; c=relaxed/simple;
	bh=93AeCP1o3Wv+mGG+xhkoAn9DtgzsFQemNhZGdkeJE08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGz2B3mcPZYLQEi1/F6RrPsZqJeYfrI/9K1x4zkEyThFemBmcfBstzoHHqvh+FsxmT9NMIS2MyvMjKz7eVk2Wnuu1fYhJj4PYQvf2LY3/s/oG1+jiVrri/PX/C3KZdIJvNwOLBVLIq2BHlJmwdHBdLX2T4iPEPh26yha051U/Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmwpBKzD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmwpBKzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8CDC4CEC7;
	Tue,  8 Oct 2024 13:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393548;
	bh=93AeCP1o3Wv+mGG+xhkoAn9DtgzsFQemNhZGdkeJE08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmwpBKzDt9lFV0HkDe6Hb9At2we73pjPb1e4n+3eB4TXHvJSCBBkEuqB9SvGe6zvU
	 /fUdkWv31lXEBo6zrmi/iHFsjrTvB7DdhqhbePVJnkQWKc5SruaulYfNavu0xTxq6F
	 jn5ly88TUKn+MBdq8eBjmgDsKyHfXoiK3VcmPmzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/386] iomap: handle a post-direct I/O invalidate race in iomap_write_delalloc_release
Date: Tue,  8 Oct 2024 14:07:09 +0200
Message-ID: <20241008115636.652807736@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
index 5371b16341fff..aedaad4c37d75 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1177,7 +1177,15 @@ static int iomap_write_delalloc_release(struct inode *inode,
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



