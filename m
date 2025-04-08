Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAAE26A0A5;
	Tue,  8 Apr 2025 12:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114087; cv=none; b=ReBYl0leD9ay9+ES4EFh5OLNk2KHG0tRWfQYmPLDfZYSSXQ47OLuMpNSEITMWUwWiUTzgLqUCNJtSRY2S6sGafL7x2rpJX/P5Qti09w+TOfeOKDEqqkzE/DYXIk2K4vBPOxVQH/I/+vWUHTdpa8QE6so2hCzUZPiHYKFsiCH4yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114087; c=relaxed/simple;
	bh=ZLMAew5PuoU9PKBzTgzHQnnnotRHV1eDpReQE7ObaOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjYQ7CxeCDDEPHPvmCmPDCdyj5yF/ZHiEo4iciPHy+fZqgdJM9g0dgan4opnVBH/8hB0DVrg+cse8NvmV/Bpzwbi8/FhVwBjrZvYlESK1flxvNtkscLfvRcbT51tTriN8wohobGntI7mkdUTL1qF/Ffd3rh7vWiwQnGyedQ6KQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CIF5cqit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CIF5cqit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9CDC4CEE5;
	Tue,  8 Apr 2025 12:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114086;
	bh=ZLMAew5PuoU9PKBzTgzHQnnnotRHV1eDpReQE7ObaOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIF5cqitW7cGLMNJvVOec+VMm7yDxOmZRTj4s3U0zuszdJFmX8P496mbMNAN2EI6b
	 paeWZplpHyHGhgIfFdePR+Z23LASC5RhuD0co155/e84cPe54YdieJWNi9L2pAvD/Q
	 9c3MJB3JmR7YV7edpOUwNCN9Wz2aupAMQsyuIuR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Tatham <anakin@pobox.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/154] affs: dont write overlarge OFS data block size fields
Date: Tue,  8 Apr 2025 12:51:12 +0200
Message-ID: <20250408104819.508960288@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Tatham <anakin@pobox.com>

[ Upstream commit 011ea742a25a77bac3d995f457886a67d178c6f0 ]

If a data sector on an OFS floppy contains a value > 0x1e8 (the
largest amount of data that fits in the sector after its header), then
an Amiga reading the file can return corrupt data, by taking the
overlarge size at its word and reading past the end of the buffer it
read the disk sector into!

The cause: when affs_write_end_ofs() writes data to an OFS filesystem,
the new size field for a data block was computed by adding the amount
of data currently being written (into the block) to the existing value
of the size field. This is correct if you're extending the file at the
end, but if you seek backwards in the file and overwrite _existing_
data, it can lead to the size field being larger than the maximum
legal value.

This commit changes the calculation so that it sets the size field to
the max of its previous size and the position within the block that we
just wrote up to.

Signed-off-by: Simon Tatham <anakin@pobox.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/affs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index 6dae4ca09be5f..199b92f6a9941 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -724,7 +724,8 @@ static int affs_write_end_ofs(struct file *file, struct address_space *mapping,
 		tmp = min(bsize - boff, to - from);
 		BUG_ON(boff + tmp > bsize || tmp > bsize);
 		memcpy(AFFS_DATA(bh) + boff, data + from, tmp);
-		be32_add_cpu(&AFFS_DATA_HEAD(bh)->size, tmp);
+		AFFS_DATA_HEAD(bh)->size = cpu_to_be32(
+			max(boff + tmp, be32_to_cpu(AFFS_DATA_HEAD(bh)->size)));
 		affs_fix_checksum(sb, bh);
 		mark_buffer_dirty_inode(bh, inode);
 		written += tmp;
-- 
2.39.5



