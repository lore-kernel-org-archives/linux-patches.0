Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6B71D63EF;
	Tue, 27 May 2025 16:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364516; cv=none; b=MlGTJ8/f64beWwCL7A+aUpaLQ+Ud5eLmlpFTepvCZ7xuMSCbio21pUuuBv720rsa/30cMKOHtGyv8SiyiCb34F5Td+Wp5QHMPxG7/5PCZ3OUaV2JNsjo39gpbcWEdITMfSNU5tUeYM4X6RYTiCNe8mH38IVyWU3RvfdSOuys8wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364516; c=relaxed/simple;
	bh=/3zCnMzRO25fMRYYUB7fENHAkapELNXaRMwIapLCiK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjVOh9EwWDVrTZWMOunqRRQi98DxUd5OfqzGyMHLa4FA/iRvlCLRJJ96RIZ4nL9OWuQijv2DvxWSpEP8V7nXUCTRdqA2a9cMR0LywdcPTxfS6thD3mZGJeLuLrJ6AaZ/zMc5gZn/feYBO9gh4aq1GPWivvCkaQVSjCWY6NTgeiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqOpCXrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqOpCXrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D9DC4CEE9;
	Tue, 27 May 2025 16:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364516;
	bh=/3zCnMzRO25fMRYYUB7fENHAkapELNXaRMwIapLCiK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqOpCXrf5hhZ/iU0pdJm7Mx7d31yDqcEis58JLcidHjoae5oIDoy32JnRiWqt8mhc
	 l1g2xRevw3xggigFpOlHxbta20s3UiGvK5yYjLpCzMGXZSRMxVdbAYpG899oaIv6cX
	 JTU5bz8odi1Xtm7LwnHVcpXByXlU74JvI4Hwf9GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/626] fuse: Return EPERM rather than ENOSYS from link()
Date: Tue, 27 May 2025 18:19:04 +0200
Message-ID: <20250527162447.137029223@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit 8344213571b2ac8caf013cfd3b37bc3467c3a893 ]

link() is documented to return EPERM when a filesystem doesn't support
the operation, return that instead.

Link: https://github.com/libfuse/libfuse/issues/925
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index a1e86ec07c38b..ff543dc09130e 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1133,6 +1133,8 @@ static int fuse_link(struct dentry *entry, struct inode *newdir,
 	else if (err == -EINTR)
 		fuse_invalidate_attr(inode);
 
+	if (err == -ENOSYS)
+		err = -EPERM;
 	return err;
 }
 
-- 
2.39.5



