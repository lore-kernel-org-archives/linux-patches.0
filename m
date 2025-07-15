Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC8E2D8778;
	Tue, 15 Jul 2025 13:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587342; cv=none; b=pQ/m9yIt152MELmPhnpjquLqwFbqjkC3cKvLGXXxZUk8BOI3oxSNAClcUegMt7ioCmqUyXRd/ZqlZ7Ol5/EdIShbUB+lcMgECgFMSiNe4YBd9M7I1eG8t4L4HpNDWgV8WWVQlWbcmN2sPYQiQbcZ6+36VLxFVzpTSQQRhjL72xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587342; c=relaxed/simple;
	bh=ExTUCf+FVGc9XJzvZdbUo9ukFVM1vnHAR7jKWStG7PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2nbIEGlSLmYe1YfE1FFIUuowkot2UpfTHUmHuiFymrnAwZY+Jc1C4lk8wZd0hRe8A26z1jsoDwHRhoTK853TIS/CF6VYksmI4GEdyNtXNGn+QNJptWTIixbIuaalT/YcMbVZ16sftp8htiLBNecw/00QLHMw75m5JVvnU3nx/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SwMZlm8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SwMZlm8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9E0C4CEE3;
	Tue, 15 Jul 2025 13:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587342;
	bh=ExTUCf+FVGc9XJzvZdbUo9ukFVM1vnHAR7jKWStG7PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwMZlm8Ks1tNqW2LFTNSwJhS7cWpt6iTriq3IBVtcFlzQHC8C/C+wgivHZKW/Tifh
	 ju5/X0slt56rQlIZJWR0fhekvBsTlQn6iK8pHeE41arY30S1fxGKyjsw4VWpDOKH22
	 e4WK/EMFb7cYDRkrIsG9tpGtYVGeFmBc3vZkcG5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 64/88] erofs: fix to add missing tracepoint in erofs_read_folio()
Date: Tue, 15 Jul 2025 15:14:40 +0200
Message-ID: <20250715130757.138280012@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 99f7619a77a0a2e3e2bcae676d0f301769167754 ]

Commit 771c994ea51f ("erofs: convert all uncompressed cases to iomap")
converts to use iomap interface, it removed trace_erofs_readpage()
tracepoint in the meantime, let's add it back.

Fixes: 771c994ea51f ("erofs: convert all uncompressed cases to iomap")
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250708111942.3120926-1-chao@kernel.org
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/data.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 5c2e6fbb70a3e..7b648bec61fd0 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -354,6 +354,8 @@ int erofs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
  */
 static int erofs_read_folio(struct file *file, struct folio *folio)
 {
+	trace_erofs_read_folio(folio, true);
+
 	return iomap_read_folio(folio, &erofs_iomap_ops);
 }
 
-- 
2.39.5



