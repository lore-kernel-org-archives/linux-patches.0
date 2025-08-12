Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625BF2222D2;
	Tue, 12 Aug 2025 19:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025352; cv=none; b=W+qMGk6fGeKZTdX3rIy9DuE/XS+lBlA+XFiBduPfnFC26Zkw7UBRrye6gXwd3GhpQDQhFyZLbFt/9cnIIJLeXrUdMCVz2hYkW+K3JdxhIo5fgjmRaLzS4lx8wEWC8CF3VcqpUIwwfIiTe5DqyvifFx/KiFVKxGQbJYKMPCqJRh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025352; c=relaxed/simple;
	bh=R3POt4e0jSmrZsCKJwJCZANFuL+NBwgoOyTYltj++DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXxbyOIyQNETX5iWaalQbn4m+jutGul6unPgOVsT/vO99Mxq2S+57Ol8jwk3B/XbE3O5z4Pw0RYlCao2zI1WK2UPIDQcDjMC0UIy1h0/EeS+uo+aVWm0ho5DXd4/uc5OFJgzWfrQ+vDbb+l7cNI7tD0eaHcjFOR7/sP+lY1i+6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOwmZMr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOwmZMr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BF4C4CEF0;
	Tue, 12 Aug 2025 19:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025352;
	bh=R3POt4e0jSmrZsCKJwJCZANFuL+NBwgoOyTYltj++DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOwmZMr1GNJema6/cS0nraomLWT4QXZnl7dayoUV7ofmc07GWFVkOeLUolnwW5t7a
	 FQ04lqbQun90hJgQ4nmaI3zTZXHoiNRzqbC0LLcaxrJCAB59CUk3qBdO/YBoPCH0ZO
	 eoC+cp+hJ2EXzCClzwy2YLLIlZ4bT2J8GNZW97UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 017/480] hfsplus: make splice write available again
Date: Tue, 12 Aug 2025 19:43:45 +0200
Message-ID: <20250812174358.017152032@linuxfoundation.org>
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

[ Upstream commit 2eafb669da0bf71fac0838bff13594970674e2b4 ]

Since 5.10, splice() or sendfile() return EINVAL. This was
caused by commit 36e2c7421f02 ("fs: don't allow splice read/write
without explicit ops").

This patch initializes the splice_write field in file_operations, like
most file systems do, to restore the functionality.

Fixes: 36e2c7421f02 ("fs: don't allow splice read/write without explicit ops")
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20250529140033.2296791-1-frank.li@vivo.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index f331e9574217..c85b5802ec0f 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -368,6 +368,7 @@ static const struct file_operations hfsplus_file_operations = {
 	.write_iter	= generic_file_write_iter,
 	.mmap		= generic_file_mmap,
 	.splice_read	= filemap_splice_read,
+	.splice_write	= iter_file_splice_write,
 	.fsync		= hfsplus_file_fsync,
 	.open		= hfsplus_file_open,
 	.release	= hfsplus_file_release,
-- 
2.39.5



