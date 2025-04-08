Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FF820897E;
	Tue,  8 Apr 2025 11:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110961; cv=none; b=cExgAqK5jaEi+2Tt/JRDHg+qdvM6yg3xeWIDNGCiSzg8yTeFh+XbS5IACPGGSV3BQVkRZ9FseamsbxuVi+DsTcOIMFvCUDFTNL+jR6sxVgj7dc+Xhye+p3su5I0uRtw7PrWjj0+1xDUqOTffv1gIPva912/nv4le0WnZOrUw44I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110961; c=relaxed/simple;
	bh=3O9rTBY7rk3sxPdYC26OkNSQuTKZbSXgRdCAyIE+Xfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zo5F5a3W0JxteswloAxEj2w3soF2uj2MnOg8jmoCJJbhD+57OScC8JTRp4xJuj+Jq8GD3IlsfBk4nyCCSk8K9Li17Gpy6R7lG2w1wQi1Les2TwljUorCzLsCZFcp4jQDG+Kc3+OUBX5Odb/IrQhGCyZiCmG46N7AO3OkpZo23oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tae/5vMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tae/5vMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469D8C4CEE5;
	Tue,  8 Apr 2025 11:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110961;
	bh=3O9rTBY7rk3sxPdYC26OkNSQuTKZbSXgRdCAyIE+Xfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tae/5vMYSIYKc0xKtFsTZMN9PQO/yATQB8C4j4M0tLnKpdCjjLRtYJuB9IzkAyI7v
	 PPJY+sGKZH99JezxTziIvskfPekvSs/R3MsagCPHme2qyR7VhEbjydIEnvKijbgre5
	 SfAUqdvWcL0GebcDoaUNbYTKDuzIovnGsWhhwSN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <maharmstone@fb.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 218/731] btrfs: dont clobber ret in btrfs_validate_super()
Date: Tue,  8 Apr 2025 12:41:55 +0200
Message-ID: <20250408104919.353189428@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <maharmstone@fb.com>

[ Upstream commit 9db9c7dd5b4e1d3205137a094805980082c37716 ]

Commit 2a9bb78cfd36 ("btrfs: validate system chunk array at
btrfs_validate_super()") introduces a call to validate_sys_chunk_array()
in btrfs_validate_super(), which clobbers the value of ret set earlier.
This has the effect of negating the validity checks done earlier, making
it so btrfs could potentially try to mount invalid filesystems.

Fixes: 2a9bb78cfd36 ("btrfs: validate system chunk array at btrfs_validate_super()")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <maharmstone@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f09db62e61a1b..70b61bc237e98 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2561,6 +2561,9 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 		ret = -EINVAL;
 	}
 
+	if (ret)
+		return ret;
+
 	ret = validate_sys_chunk_array(fs_info, sb);
 
 	/*
-- 
2.39.5



