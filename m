Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FBD1D094A;
	Wed,  2 Oct 2024 13:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876689; cv=none; b=hk0AsgXvPBRLPzzNq9cWs/4tPGRB9e0Joyq36QrZ2bYhjZ3zN80vT88X/N4UXWVpDDGCmNNfGmSZYQI4oZ6cMaJwSAslxy04fDLZwz0EHUBKKl8P3ZEGZqQOaq9N9aq9i8hkKhMVNgjHgF2nclQMkQ6Ltu72KmaiwpmUDubPMGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876689; c=relaxed/simple;
	bh=4lAA3N3SkjijY1qQOCLhz2A7O2c8VHN5n2LmBZR4A3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOVdJmMgkhCx/f98UtOhuC2c7sXROrGMkyVVeug6sVNbl+Ie10Dg1pyrb91vfEylH69mmca1LN4sRmMQsNLf+nzoLuQFOX3JepYNmWt/brz/fx2EP+1QnOpakCkHVSvYDx41JTIN29dS4+c5zzJnAUI1FIAdvo7jP9RkB6KtDI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWbn8NvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWbn8NvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A95EC4CEC5;
	Wed,  2 Oct 2024 13:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876688;
	bh=4lAA3N3SkjijY1qQOCLhz2A7O2c8VHN5n2LmBZR4A3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWbn8NvUqyjfoJ2kXxA9fSn+rQOBYq/D7iywIemWs7ItWaOZMWoyQAokcBy8uXQHw
	 3gRJIY3rbkdkm5PC+OLOKsp4Y8504vjRYx9HiOCQ1db4ovABTfSld9KRS1Da3Q471X
	 1W/Qtwp5hju0W1UxCKc5zY2/CJQuDiiS44f+9Qt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangyun <yangyun50@huawei.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.11 498/695] fuse: use exclusive lock when FUSE_I_CACHE_IO_MODE is set
Date: Wed,  2 Oct 2024 14:58:16 +0200
Message-ID: <20241002125842.352137085@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yangyun <yangyun50@huawei.com>

commit 2f3d8ff457982f4055fe8f7bf19d3821ba22c376 upstream.

This may be a typo. The comment has said shared locks are
not allowed when this bit is set. If using shared lock, the
wait in `fuse_file_cached_io_open` may be forever.

Fixes: 205c1d802683 ("fuse: allow parallel dio writes with FUSE_DIRECT_IO_ALLOW_MMAP")
CC: stable@vger.kernel.org # v6.9
Signed-off-by: yangyun <yangyun50@huawei.com>
Reviewed-by: Bernd Schubert <bschubert@ddn.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1345,7 +1345,7 @@ static bool fuse_dio_wr_exclusive_lock(s
 
 	/* shared locks are not allowed with parallel page cache IO */
 	if (test_bit(FUSE_I_CACHE_IO_MODE, &fi->state))
-		return false;
+		return true;
 
 	/* Parallel dio beyond EOF is not supported, at least for now. */
 	if (fuse_io_past_eof(iocb, from))


