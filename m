Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2572E2E738F;
	Sat, 12 Sep 2026 07:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199917; cv=none; b=rTTceM702Q/mPCn8k0l8NPYVDh6eyVdbXM0c6iPiDPpfsXkuxpERd768iwUHndjv4Iv/qd35WSQOS8CgLDkaM5zXsbkjJZxRuWTtr4UmDIu+yYyj5HZnNWiEp5KilIeOowiZR71OIGnpUX1bO6jD9bwnKHAQqkTzbnf10IN2NK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199917; c=relaxed/simple;
	bh=y0jIjnG3Qoo4Od9+00zP2KcLnZmk0BQZtcxRHa7cdOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxcwR7Wp61nJ/MrGp3+/y+CKXdFw+aeZ++lh+cAR+cggzx5f1p0kMO4RBndiHhzDGmakln7SrRh4NZESUsDYc65NEpXszDiq2QwYacLunp0WSSQZDz4R4LY0FZHZQSyHFqDemWbam397EFh2j88Z2cPrSvmqGBYeL1K3VqFbj68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0eaWmAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0eaWmAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166881F000FF;
	Sat, 12 Sep 2026 07:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199916;
	bh=Ivh0PKCkonB/dnm0veFOGnOZ/PvPmaTxYGDwEzw7u44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0eaWmAerkS7z1e7rGHaWTFfjRWDke2pyTN+9QdLuc/Mvu9EQ9LYjlzu73p07+k3z
	 lzK3kdzOfcAV7P40s4M6JvFnQhMbhMnHBX7dD4qIyPYB7CFYLAn+sZyaf67Jf6oVwz
	 IqDFFJoSZLSe5J81bPjRROd1DCnLAFdfWkX/JYUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0681/1815] isofs: release zisofs block pointer buffer head
Date: Sat, 12 Sep 2026 08:40:31 +0200
Message-ID: <20260912065704.874702226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 2f7dd9b86fe4076059e6a4a2a2c5d565afd76b9e ]

zisofs_fill_pages() reads the compressed block pointer table.  The error
paths release the current buffer_head, the loop also releases the old
buffer_head when it advances. However, the success path leaves the last
buffer_head referenced. Release it before returning success.

Fixes: 59bc055211b8 ("zisofs: Implement reading of compressed files when PAGE_CACHE_SIZE > compress block size")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Link: https://patch.msgid.link/20260721091152.1450622-1-chenyichong@uniontech.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/isofs/compress.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/isofs/compress.c b/fs/isofs/compress.c
index 3fda92358e225..f9869d62b8509 100644
--- a/fs/isofs/compress.c
+++ b/fs/isofs/compress.c
@@ -293,6 +293,7 @@ static int zisofs_fill_pages(struct inode *inode, int full_page, int pcount,
 		memzero_page(*pages, poffset, PAGE_SIZE - poffset);
 		SetPageUptodate(*pages);
 	}
+	brelse(bh);
 	return 0;
 }
 
-- 
2.53.0



