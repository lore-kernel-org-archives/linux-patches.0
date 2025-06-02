Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A87F221FCA;
	Mon,  2 Jun 2025 14:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873108; cv=none; b=F5KvT9i7NVpag+i4LCB56ON3CVq0tV8Nc6OBNzGAbp70AF7xGZezU+H5JlGk2MYQ087KG80rKNwl+XZ987QcKDbtmUWetsDWJPxjeJCDe+f7rFjbyTbLA9j5rargDG7j9tygwHI+u9KiYYeq7NIn40sb4YitljQdfADDbhMZN6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873108; c=relaxed/simple;
	bh=OuR4ybpAeEaN/xepoRY3gLJ4zLd+axxqbqUk6lPJ4q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPjk3q9o3xIFB0Vtvq+eOzrELqom46kOWbjQMxTDfvo/t5XcKZ/yxrbD7clrXCGQGnml5itUdfUqpat2mus5N1cD/tFNVtIev1L/nibuS43n8vTMkIbdmJ+irc7bhmfYtogOWXb9hvO7vj85g5zzLvgvN2lXOXvFDf+FLzhn8d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzx0KKlD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzx0KKlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE81C4CEEB;
	Mon,  2 Jun 2025 14:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873108;
	bh=OuR4ybpAeEaN/xepoRY3gLJ4zLd+axxqbqUk6lPJ4q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzx0KKlDMit9OfC2nRibYRG9uD6JqaMZ+NtKxLsRNVHVakLr/dZb37tn+b3MzzSwj
	 NrcQxSPdaOZNn2hKWZjwio6+4QI7KS/LrOOAtUeSTuXyEBTTuM1Zo48/8cxWItsLrz
	 4vMc562T6vu/dC2JOuvG5Qk0T/QTClRqK5KBlkGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/444] fuse: Return EPERM rather than ENOSYS from link()
Date: Mon,  2 Jun 2025 15:41:43 +0200
Message-ID: <20250602134342.514458521@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e4d6cc0d2332a..82951a535d2d4 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1121,6 +1121,8 @@ static int fuse_link(struct dentry *entry, struct inode *newdir,
 	else if (err == -EINTR)
 		fuse_invalidate_attr(inode);
 
+	if (err == -ENOSYS)
+		err = -EPERM;
 	return err;
 }
 
-- 
2.39.5



