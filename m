Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5783246AA62;
	Fri,  7 Aug 2026 15:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116621; cv=none; b=OgjUKLVcjIueB4WNV6KSGuue8ScpzKxdaI/zVZUymjNSwTiuaUvb0OiBscZhiIQNDKbqRWOpt5VRM0eYRJkUVD9qqww6OeCY8FwDOPOLJ68ryh54mrvcT1TVuZxydZFGv3V1JqcpDiSW0EB/JtdUapWXR9iejSgQHWMVuwgZL8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116621; c=relaxed/simple;
	bh=TXJbUIapcHgMfS1dd7kpijX6ix6cMfqr+I4wrlhZOsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctqThv4M3sCw8awzjKCy01BWAmHM9Wy65c/38xb7D2r+V9XdVJWUEO0tod6GOv2Xs3Ndk4wRClOL6F5WzzI54yitWLudN9qWf8C2IGyI3hYnddgdPkTmW61/T308WO5S9hhwtDbf5EPB4WCG/ptHQ0ZjEYrM6M1sZOxFtiecPjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CiuBqMuu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CiuBqMuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4ED1F000E9;
	Fri,  7 Aug 2026 15:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116620;
	bh=2aCzHN/unLkiXWzv7DFdJCEMixw//gNriF2bcF8kFok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CiuBqMuuYLSjIAlavu3uh6GNx9hrjcg+luq9mDcjRpXd/0WcHThGglhnCCLt+WG84
	 5/PDHby3RLFB89M0vkURAoRA8w775LJH+Vuglym+wTz7NtUJp4IfGnOVNeAQhouM+j
	 an9vgIoUbjhZ4sHPZ+2K+OGxRJdf8zsM52oUWmMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 033/438] ntfs: drop stale page-cache when shrinking a non-resident attr
Date: Fri,  7 Aug 2026 16:33:49 +0200
Message-ID: <20260807143428.715060025@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 4e646ecd44759e552b0b9ccd995f3f608daab414 ]

ntfs_non_resident_attr_shrink() shrinks attribute sizes but fails to
trim the page cache. This leaves orphaned dirty folios beyond the new
end of the attribute, leading to writeback failures (-ENOENT), data
loss, and $EA chain corruption.

Fix this by truncating the page cache to the new size immediately after
updating the sizes, preventing writeback from flushing out-of-range folios.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 0f1d0b54cfb52..22338ad541279 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -4292,6 +4292,16 @@ static int ntfs_non_resident_attr_shrink(struct ntfs_inode *ni, const s64 newsiz
 		ni->initialized_size = newsize;
 		ctx->attr->data.non_resident.initialized_size = cpu_to_le64(newsize);
 	}
+
+	/*
+	 * Drop any page-cache folios that now lie beyond the shrunk
+	 * attribute. The clusters backing them have just been freed and the
+	 * runlist truncated, so leaving stale dirty folios around makes a
+	 * later writeback map a vcn past the new allocation, which fails with
+	 * -ENOENT and loses the write.
+	 */
+	truncate_inode_pages(VFS_I(ni)->i_mapping, newsize);
+
 	/* Update data size in the index. */
 	if (ni->type == AT_DATA && ni->name == AT_UNNAMED)
 		NInoSetFileNameDirty(ni);
-- 
2.53.0



