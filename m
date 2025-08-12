Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668932EAB97;
	Tue, 12 Aug 2025 18:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021957; cv=none; b=GLS3m88/xGRP7+nFLqgEpzy/dM3OJ3GwTzQW5HIoTHynvAKd0i3BhL6pWjdzhH5CmXlaWxzL8DnosNyFbbTRDUZifCDJofjAqJ3a7Shjdh/borDXAkN7ZrOT9i8k9lmdiiz/l+HUzOgO1U/sb0luowyHlJdbHy2fbB6PA0rMHts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021957; c=relaxed/simple;
	bh=Ng7d3PJv2YP08aMJ54wozxJfly7RX1mKzQAsURctJZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYZVxBpiwwoXvJwPPxBGYpNPdLoaVyujKLQTQB2nkiToKKid74V2AgLRJsJ8EdYsl50BNe/48bXIm1E5muvbO8BLUSFLoblL+H4UbJqqpmx1vQ7wO+XDAOK2GWT7lrdrzyYGaI/TEbSE8DRGdpS+b/hz5U7LDoLXOziH5QtEMm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwypYP9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwypYP9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8378AC4CEF0;
	Tue, 12 Aug 2025 18:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021956;
	bh=Ng7d3PJv2YP08aMJ54wozxJfly7RX1mKzQAsURctJZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BwypYP9pYaFXwtOhOMYy5zgN0ayOsVs3BuphPXH8wwXxKbQ16xAJv1zfOxHh4PnGG
	 x7LMLvllXMkvfQ+QhLcBlavyzBK102A2npubrdL1SjVlenx88ZYdV7CXVWfYNPmMiL
	 /wh6eOUnePRy4ne9i0ogaYdSal8GWvhP8+N3vaXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/369] hfs: make splice write available again
Date: Tue, 12 Aug 2025 19:25:10 +0200
Message-ID: <20250812173015.240946535@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 4c831f30475a222046ded25560c3810117a6cff6 ]

Since 5.10, splice() or sendfile() return EINVAL. This was
caused by commit 36e2c7421f02 ("fs: don't allow splice read/write
without explicit ops").

This patch initializes the splice_write field in file_operations, like
most file systems do, to restore the functionality.

Fixes: 36e2c7421f02 ("fs: don't allow splice read/write without explicit ops")
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20250529140033.2296791-2-frank.li@vivo.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index a81ce7a740b9..451115360f73 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -692,6 +692,7 @@ static const struct file_operations hfs_file_operations = {
 	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.splice_read	= filemap_splice_read,
+	.splice_write	= iter_file_splice_write,
 	.fsync		= hfs_file_fsync,
 	.open		= hfs_file_open,
 	.release	= hfs_file_release,
-- 
2.39.5



