Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4241ABEB1;
	Mon, 14 Oct 2024 15:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919083; cv=none; b=tDJRlS83tqghyUSdbaLkNgsE7R8FljApSvgj/nE9LMhGDqm79JnRPt/YwpIpOlfoMTwE8frja0FGaZbei8SBXNQHWe5WT1+NV0L90FOWTT0IQlF2rAxB17/Gq7OeTYVMQlD18r1XtiatmlNsRCcIZL29lowYo36+toggsCXV06Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919083; c=relaxed/simple;
	bh=ToVeGWb1ZxTCfZDwDu+MVRA47oM04N+f0qQ87sHThP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIAX6Aqtv+4kz2P3nsjxWic9UAkqf3BZNcPE9IQN7HQVKNKUcOm5C6sM/AvYA4C2vjrhDlVh5cY3VroLU8hBJ8EMYKnC68Nlb+S9qpXiALGN9mEfTYTStAKmjizp1lh31Gzr8vAtTQ1GVqr9MWVhx2m0bLrsDHXi4AOUa+1cFvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDpowf3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDpowf3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0763CC4CEC3;
	Mon, 14 Oct 2024 15:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919083;
	bh=ToVeGWb1ZxTCfZDwDu+MVRA47oM04N+f0qQ87sHThP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDpowf3QgUps+TGGmb1s6MgRXGkx+IM4K71Sx4qS0gYv9L6HTRHAmYmoJb0PL3zd9
	 kN0sAFZoM8xzSwvud5fG+YF6+GkD0vqLuhfXsrdSzd0WK3E+Bfoz0yhlILVvPeyJXS
	 oyVMNVIhc4CiuhCF9Fpj15BBUFDnxiK9XRsMhKCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 509/798] iomap: handle a post-direct I/O invalidate race in iomap_write_delalloc_release
Date: Mon, 14 Oct 2024 16:17:43 +0200
Message-ID: <20241014141237.976965673@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 98617f00101d6..1833608f39318 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -990,7 +990,15 @@ static int iomap_write_delalloc_release(struct inode *inode,
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



