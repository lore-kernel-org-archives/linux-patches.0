Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C622517AB;
	Tue, 29 Apr 2025 17:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948148; cv=none; b=jg1r6wtc5FMRHC0YJDZIMPMqx7IrUyMqawo2wDudL42LPU0Et3aYvjtrQjNTIVxYGtvJFq7XweNhQPmnHUFcVmhpyjiUUHeMPQZaqSVVfa5hX23bB8CSq8erdMPFSJ3IH9k9nZw6DJ3Kc1IeZUKw5zxUh8fxr+27/VMaGKh2lts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948148; c=relaxed/simple;
	bh=YNBDzpudBfRj2Z1aXnyU5inghbV1P202A04Z0MEFl90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KblbEa63U58lN5fyk19wxZBt6egqET3IIn+m3lVkzU55Oc3u2ykYwo4NfMOZiKLYiDFD82ehP4vwdACkAhEoX6cYWJ86JO672Id/0YYsaMRWlsDV2BHqEzCBrijIFDLBcOtzcC7maCroXnWUVRj6P4oich2Sw7ep8PSQV4Uv7nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKRg8Hgm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKRg8Hgm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D0BC4CEEE;
	Tue, 29 Apr 2025 17:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948147;
	bh=YNBDzpudBfRj2Z1aXnyU5inghbV1P202A04Z0MEFl90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKRg8HgmXtHR033BZxKvGyDYHrgCWwDb2jaiux1D0UbwuFuFXLd4ubEfZJg+S63RZ
	 Ji+GpgyGrZ4zYVXj0msxHY54Pk6GKw072paZpIY7R+Qwi4m5rLJJbk7W2jU+DWfNff
	 xHAf/yCblBR3YgQ4DeEA0AZwEgwlK35OAJlp2bAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+e37dd1dfc814b10caa55@syzkaller.appspotmail.com
Subject: [PATCH 6.12 172/280] fs/ntfs3: Fix WARNING in ntfs_extend_initialized_size
Date: Tue, 29 Apr 2025 18:41:53 +0200
Message-ID: <20250429161122.151267068@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4ca1fff826fd0..748c4be912db5 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -428,6 +428,7 @@ static int ntfs_extend(struct inode *inode, loff_t pos, size_t count,
 	}
 
 	if (extend_init && !is_compressed(ni)) {
+		WARN_ON(ni->i_valid >= pos);
 		err = ntfs_extend_initialized_size(file, ni, ni->i_valid, pos);
 		if (err)
 			goto out;
-- 
2.39.5



