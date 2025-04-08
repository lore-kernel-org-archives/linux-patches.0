Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB77266EEA;
	Tue,  8 Apr 2025 11:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112865; cv=none; b=PSpfbSC9pO4Fh+Jc1mz/r4MSy8I7ejYeiLCX3BVrLo46W2RALhRVX3NG7TfUCCtRm3Keq2r7tEEUeVMpDePxuS8+FztTopIQXII2HkjSEMDKjvlS9m4pfwVujKZSDPG5a//xPPXFLWxg6t4AHmjC03o2FFpYuhbVK8LaRw9amoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112865; c=relaxed/simple;
	bh=OT7ZH1PTuY4/3cgY/y0MTBB6EIEmjC5Lo9/jM1hPbeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5qxK7dFdZhxYVvEyZQa5qAhrmVcLv/G+6zy5XftfS0wmk3B8nWWy2UyuCC8xGdk+OijO6pSgtQbTusfwo35mzguVbHFMUnYpkfyuqxOUSihO4aIKndUs54vKCyiVkVVKuU/cfCUfWv+0vIHAEPBJgPY2uicJIYCnzSU6rJm9AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fMOSAmkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fMOSAmkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3BFC4CEE5;
	Tue,  8 Apr 2025 11:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112864;
	bh=OT7ZH1PTuY4/3cgY/y0MTBB6EIEmjC5Lo9/jM1hPbeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fMOSAmknXMtF313U38xVChepDoFdzvisADCgiBWgbZauILQe2l8HVFddoi1ALpJwF
	 wU3tgA3YcbPKh1EhpsmPQfsS/+OwtjPh8A+t0tYJhBRwh2zlE32S2mcQLzC+vzl7xN
	 lepISRrfl/X0idpqyEBn1wQeRVnIULdfBHif6YUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Tatham <anakin@pobox.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 226/279] affs: dont write overlarge OFS data block size fields
Date: Tue,  8 Apr 2025 12:50:09 +0200
Message-ID: <20250408104832.470850694@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 88d4e6263df96..2000241431d55 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -726,7 +726,8 @@ static int affs_write_end_ofs(struct file *file, struct address_space *mapping,
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



