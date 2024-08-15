Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8372044376;
	Thu, 15 Aug 2024 14:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730904; cv=none; b=lYS0FOSmoSFU5V9VfUs7ZVG26evFyMn2vbMHn9JtQFs7Su6OKpBvYE6z0K4c/vIbsDdrHsTLQAdKuQiq7dpA/8r7zGZ/D4zmeFZnkOYRklcHBvpYg8tIf/Nx98T4D/d/s/wKYJj4GmGstTHM3IjUiLwiqBD5Rh1RdHtESzxVzaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730904; c=relaxed/simple;
	bh=rnMn+4mMcjT0yZj04ErKyVzeWeyK1KXHzBbdAlLShKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/q8urh7qf8/Cm5SMU83JjXu/svAGHiVDkB+MS6uITrRHMJXJyJUQCxkmHyfERlEFBTZu7ccU0lPqQj6LrQrsCXDosgG85EpD4qxaVz39foUMkx1wq2muSDxRk8N7yXYGZ7gwlNPtN8PH+b3lYnpFQsVnGjSgd7QZ5e8kRfbIoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTpXqkq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTpXqkq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084D6C32786;
	Thu, 15 Aug 2024 14:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730904;
	bh=rnMn+4mMcjT0yZj04ErKyVzeWeyK1KXHzBbdAlLShKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTpXqkq6W0xcjNFj79HxyjIeAWSjamRRqynDyXvhwHgpoF3vZACABfFPxnapa72CB
	 ff1+8KAi1w8yhk4DNRiwERjusXC31llG2/k00KKW3/Etrng+04gK4TbAI42tFA1HyH
	 DxI7rp1uTBk8114YNGLsgwPb8rSnQeunpRePURTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+32d3767580a1ea339a81@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 30/67] squashfs: squashfs_read_data need to check if the length is 0
Date: Thu, 15 Aug 2024 15:25:44 +0200
Message-ID: <20240815131839.483798465@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit eb66b8abae98f869c224f7c852b685ae02144564 ]

When the length passed in is 0, the pagemap_scan_test_walk() caller should
bail.  This error causes at least a WARN_ON().

Link: https://lkml.kernel.org/r/20231116031352.40853-1-lizhi.xu@windriver.com
Reported-by: syzbot+32d3767580a1ea339a81@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/0000000000000526f2060a30a085@google.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/squashfs/block.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 581ce95193390..2dc730800f448 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -321,7 +321,7 @@ int squashfs_read_data(struct super_block *sb, u64 index, int length,
 		TRACE("Block @ 0x%llx, %scompressed size %d\n", index - 2,
 		      compressed ? "" : "un", length);
 	}
-	if (length < 0 || length > output->length ||
+	if (length <= 0 || length > output->length ||
 			(index + length) > msblk->bytes_used) {
 		res = -EIO;
 		goto out;
-- 
2.43.0



