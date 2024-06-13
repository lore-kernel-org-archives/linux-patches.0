Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFD6161;
	Thu, 13 Jun 2024 12:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282208; cv=none; b=XfZD3lW2IweCmtpXeWvXdt54k7cQF9CzGQ57mMywL4jSu4MmOeU1kI6PFFEhNJ1TLws3AncgAYfWs+CLpyRX16CmmoFsXBNgOP/9xV2ws+IhyQsh9I7iyd59umkjCxAXRFJB4A1D9Pm8Sp/z+jpFGbd0vyuJjt03QSTjI7GR1No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282208; c=relaxed/simple;
	bh=Zyl6Nn4cKf7YKMJrdtIJlOp7luhwQXDHJdpsy1jy1eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOrF3FihkQT7YsVHivlBCBoes54qZE+MHNg6EHq86kahHqVwHdrN560sgeHjigi1WkPmBFhpqqzo/yzdPNrhsDT8T7DKjcd4YMV8+PeQgJxQjtzZ/aNLdxaVB3FtfDE4Rb3X6bRgYs+egaDxmVuq2pKpvik4lGSN4dPzBsXLumM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpQbGRvV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpQbGRvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346FBC2BBFC;
	Thu, 13 Jun 2024 12:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282208;
	bh=Zyl6Nn4cKf7YKMJrdtIJlOp7luhwQXDHJdpsy1jy1eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpQbGRvVHhIL9WxGLQJwCz/hC6qsLrB31P3DYBUpi5Z16PcDuFZYxmliRKzVFk7CK
	 D+QE8d/UhlXlgQqfEV115ZIqEcfqeYMTpWop5mIHnILYOkjg1qe85nLOdBrtpj+iEM
	 P2ZnBRWmU2BmipvBshNJzcou4sRChuB600N39hxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 200/402] f2fs: fix to check pinfile flag in f2fs_move_file_range()
Date: Thu, 13 Jun 2024 13:32:37 +0200
Message-ID: <20240613113309.940906839@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit e07230da0500e0919a765037c5e81583b519be2c ]

ioctl(F2FS_IOC_MOVE_RANGE) can truncate or punch hole on pinned file,
fix to disallow it.

Fixes: 5fed0be8583f ("f2fs: do not allow partial truncation on pinned file")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 39002f3c3f8a7..f10156aecf425 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2790,7 +2790,8 @@ static int f2fs_move_file_range(struct file *file_in, loff_t pos_in,
 			goto out;
 	}
 
-	if (f2fs_compressed_file(src) || f2fs_compressed_file(dst)) {
+	if (f2fs_compressed_file(src) || f2fs_compressed_file(dst) ||
+		f2fs_is_pinned_file(src) || f2fs_is_pinned_file(dst)) {
 		ret = -EOPNOTSUPP;
 		goto out_unlock;
 	}
-- 
2.43.0



