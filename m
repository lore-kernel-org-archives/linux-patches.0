Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE73182D2;
	Mon,  6 Jan 2025 15:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178115; cv=none; b=Nk0DDXb8Vp1sOSjfN2CLp/h4g60FWJpuCFlDuVlGfFl0+9gBR1LGBIWpoSw/iDXHt7vUbXWvOUFX6krI7OIsfv/P0NZbDEAWK5bi378t/3Syh9N3Tigc0uuAGzTkFj0sHvnjjGjIkNmTuC6mB0T/UmebKrZmu2pIv7OEwZdPYVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178115; c=relaxed/simple;
	bh=IdLfp2XUpYKNobIQLV5vTXffrDhRTG63SSFxMhibDiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHRGzIPApe/SNSV/7M/gpTaSOATlHiBqPRorPzG7nYueZ/zKuRjaX02z4+eMOn4VCGDbrS5y1WExbdmdOaBnFPUuo8MAwKuCfJeH+3deK4erP1qb/dtscrgFZXZ4QlO8lij8joBw2ZkkUjyWmx3kfzJJ94SQkl66o3FMkxoYE1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWBCFkS/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWBCFkS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6197CC4CED2;
	Mon,  6 Jan 2025 15:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178114;
	bh=IdLfp2XUpYKNobIQLV5vTXffrDhRTG63SSFxMhibDiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWBCFkS/hHkELlBZQd+AUKHeTBcDfiQ0SzDtOGSa2FXuWM8jxBQTOgrMmKm8bbUyj
	 8vuqLsX4QmMj2uHRZDIJoGpieVGnLmyxHlXpRpqmETMdVjJwOKwlsa+EetZEbVPZUN
	 f21/d6s+cem/2bbrW6NkRooY812FzZZiJrn/g3Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f966c13b1b4fc0403b19@syzkaller.appspotmail.com,
	Yue Hu <huyue2@coolpad.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/138] erofs: fix order >= MAX_ORDER warning due to crafted negative i_size
Date: Mon,  6 Jan 2025 16:15:34 +0100
Message-ID: <20250106151133.606303879@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 1dd73601a1cba37a0ed5f89a8662c90191df5873 upstream.

As syzbot reported [1], the root cause is that i_size field is a
signed type, and negative i_size is also less than EROFS_BLKSIZ.
As a consequence, it's handled as fast symlink unexpectedly.

Let's fall back to the generic path to deal with such unusual i_size.

[1] https://lore.kernel.org/r/000000000000ac8efa05e7feaa1f@google.com

Reported-by: syzbot+f966c13b1b4fc0403b19@syzkaller.appspotmail.com
Fixes: 431339ba9042 ("staging: erofs: add inode operations")
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Link: https://lore.kernel.org/r/20220909023948.28925-1-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index 0a94a52a119f..93a4ed665d93 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -202,7 +202,7 @@ static int erofs_fill_symlink(struct inode *inode, void *data,
 
 	/* if it cannot be handled with fast symlink scheme */
 	if (vi->datalayout != EROFS_INODE_FLAT_INLINE ||
-	    inode->i_size >= PAGE_SIZE) {
+	    inode->i_size >= PAGE_SIZE || inode->i_size < 0) {
 		inode->i_op = &erofs_symlink_iops;
 		return 0;
 	}
-- 
2.39.5



