Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6F9243964;
	Tue, 29 Apr 2025 17:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949474; cv=none; b=K1CpC0ofDNU7qMx8Q/tYJ++L6widDrwjajaE4qgk/+76S2E00Zx+pWEn1+kNY4qMU7K3tFpmoqzuZeNw/C8Dn0Mf71fXOFFHz+/MZzt7XvvjI3favvqYBYWuaXNkHaXYYuSr/TqxFqgs6+1RvTqYkRLcH5ueesXS0hWHPabmLrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949474; c=relaxed/simple;
	bh=3LKYrr+eyka/VFxdzepxoLr2yoWK9NV2Ce5m1aGy/Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RA1CPVHWMV5xb2fmdtr+EuSrLWuuHPovlBR66SRxqNDDh50gp09FG3do8KYjHQQxkqzMNX2p/HMzXx3Tyfb/FqGwCpm/rDjaTXw9cZZEC4NeHvLA3aooBbfST5aeI0RcdxCF7wQ/ycUp5W6MEt5hx47HaSnEj1nNMt+zyVmimfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7em14FD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7em14FD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAEBC4CEE9;
	Tue, 29 Apr 2025 17:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949474;
	bh=3LKYrr+eyka/VFxdzepxoLr2yoWK9NV2Ce5m1aGy/Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7em14FDGagqHwOjU5GQ1lrgdA9USFRZqbPt60KOEt8C5ywydTHzkj70MyE81mW2Z
	 WqgiN2wcc4fcEicFSVMAHXeKrwf/mM16PTWUlLrObWb2nwikV/fYykCumxLorLZpuV
	 +TrAtBMLXLfbfUml/bA6X5tA+JZsiw22HWUC+tc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+e37dd1dfc814b10caa55@syzkaller.appspotmail.com
Subject: [PATCH 5.15 330/373] fs/ntfs3: Fix WARNING in ntfs_extend_initialized_size
Date: Tue, 29 Apr 2025 18:43:27 +0200
Message-ID: <20250429161136.706827552@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit ff355926445897cc9fdea3b00611e514232c213c ]

Syzbot reported a WARNING in ntfs_extend_initialized_size.
The data type of in->i_valid and to is u64 in ntfs_file_mmap().
If their values are greater than LLONG_MAX, overflow will occur because
the data types of the parameters valid and new_valid corresponding to
the function ntfs_extend_initialized_size() are loff_t.

Before calling ntfs_extend_initialized_size() in the ntfs_file_mmap(),
the "ni->i_valid < to" has been determined, so the same WARN_ON determination
is not required in ntfs_extend_initialized_size().
Just execute the ntfs_extend_initialized_size() in ntfs_extend() to make
a WARN_ON check.

Reported-and-tested-by: syzbot+e37dd1dfc814b10caa55@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e37dd1dfc814b10caa55
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 2d5d234a4533d..74cf9c51e3228 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -435,6 +435,7 @@ static int ntfs_extend(struct inode *inode, loff_t pos, size_t count,
 	}
 
 	if (extend_init && !is_compressed(ni)) {
+		WARN_ON(ni->i_valid >= pos);
 		err = ntfs_extend_initialized_size(file, ni, ni->i_valid, pos);
 		if (err)
 			goto out;
-- 
2.39.5



