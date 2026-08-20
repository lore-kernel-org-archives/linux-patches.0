Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454C735C1A6;
	Thu, 20 Aug 2026 15:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238967; cv=none; b=pBBuVdVrTPWmbY0c+MMFT8trdq1l83AwIZjYgqSW5Ab+Oa8Ugog+5APR7o8wHJclHh/CXdUa2LlIRbVbhWw1zfMUV3uCwku50ufn7Ni1+9UoulXqLV4LxlZVy+VZOlwVvVCw6DW0g7xozjT91/DXMzBZzXA4Mtfitbplwrb7hH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238967; c=relaxed/simple;
	bh=7ZJy136Ag3/kaLZ3datCooce1YE6YvU6t3gfcaQfHEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/rVQjr4wRPYwgJz7lIsaTYZ3sbbH9oD4YPFca59aT81H4o3QIdmXKKvMT2obkpKc2NhCRtdTcLyOFEwMFqf+I/jjix0BkILGnYYrBnXvSNTFARsTR6GEK7nKh198pcQYixmOK/u9G3ZQR++Pz4e5Kb6LK6wZQeM30UjUebSX5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUAe6NnQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUAe6NnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26201F000E9;
	Thu, 20 Aug 2026 15:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238966;
	bh=V9cwqRxJPhXiMkWfRh6NodEZ/OzNmxh8WitYoVXCHxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TUAe6NnQ9B3l+9X6zl4p/n0La3hZ0o8ZTTBj0cKhjXFXxJlnCyY/qNdNVZVs37IxE
	 ioUlxIL60QX0zQenxmUTJRBV9ClUD8DtWZcUpGZomsVBywq3FnPEXuql10kryVHnCC
	 TU2Kkmi4yeSxVGlWFJ5jIOQPEc+o8EmeqrzHsG84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Yang <3497809730@qq.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 103/217] xfs: propagate errors from xfs_rtginode_load
Date: Thu, 20 Aug 2026 16:54:31 +0200
Message-ID: <20260820145240.845529308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanghui Yang <3497809730@qq.com>

commit b7e53968cb8882c2d276429ea8550848a4940874 upstream.

xfs_rtginode_ensure() treats every xfs_rtginode_load() error other than
-ENOENT as success.  This can leave the realtime group inode unset after an
I/O, allocation, or corruption error.  Growfs then continues as though the
inode had been loaded.

Only -ENOENT means that the inode needs to be created.  Return all other
errors to the growfs caller.

Fixes: ae897e0bed0f ("xfs: support creating per-RTG files in growfs")
Cc: stable@vger.kernel.org
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_rtalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -734,7 +734,7 @@ xfs_rtginode_ensure(
 	xfs_trans_cancel(tp);
 
 	if (error != -ENOENT)
-		return 0;
+		return error;
 	return xfs_rtginode_create(rtg, type, true);
 }
 


