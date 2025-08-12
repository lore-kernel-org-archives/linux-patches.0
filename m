Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36401C1AAA;
	Tue, 12 Aug 2025 19:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025355; cv=none; b=gH/LN1UwtlvvFROr7gn6DhXw5mogvLW2e4ufiZ5R0qPBfLzflUzeVwh4W6jJMQLj6OWK2Kc56ppGB5szP2L6IdQCRcJovnlJXCHx3iduvWo0qn0YrWY7FBQmJvgQAlGq6zLQPJJNz3xm2a38ySxv6Bp7pi6wfkurqvcwIqrUSpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025355; c=relaxed/simple;
	bh=eB+s/ldd/JlL0PqYbAvi1M82ya6093v6HlFZbZfbIto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sf/K6d7jg1rXDh9MzkuzQURSrijnAEYi+5IDm6imsqUIbQ5dCBO8CMpM5+1/cdtHNYGjQtBNpx4kJucV9n0vJ35pob3lhO0b7yV9+kajHeTrLijgfF3Zu1Eju6I6OhVkuDiCMX2Y3bvMBGZz6uMSbmQO1KlCU+BSbeREnao0wIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmycmywR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmycmywR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0E0C4CEF0;
	Tue, 12 Aug 2025 19:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025355;
	bh=eB+s/ldd/JlL0PqYbAvi1M82ya6093v6HlFZbZfbIto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmycmywRCUTc5m12TXejKruyZiOZRL8XpsZtacYa7Teum1Ibcj7+5fm1GcgY4PaUq
	 5Vf8Z1tfLabsITs7CT4xsgmSB3ITomXFJE8QKa1m7jcu25lNyIdg5Hf/DH9OdeJaPD
	 yBWSLgfUwPxkepQEETKZmbSgA8kX4pTZYZtK3bio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 018/480] hfs: make splice write available again
Date: Tue, 12 Aug 2025 19:43:46 +0200
Message-ID: <20250812174358.057875506@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



