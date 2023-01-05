Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3862F8494
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 12:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D99C433EF;
	Thu,  5 Jan 2023 12:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923518;
	bh=2qvO8GfEQrY9oVIaOE5jezmCt+dbKJGAOyJDJPt/1w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzWov8uAWRmZ6sfq7tdc4+cW2wluvU4pwYy8du82RoOIN9e6b9ByeZLTSVZwTfu7O
	 RZh5Ierd1jOTaH/zqDteB6AdI50UU6JUBtIm3Z0aoU+Ytix/hXvo/Y5q7e/2SlAak1
	 DmC6rSonuIngiAhUmSsXGwJEmCfHnRSnlml0hza0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 046/251] fs: sysv: Fix sysv_nblocks() returns wrong value
Date: Thu,  5 Jan 2023 13:53:03 +0100
Message-Id: <20230105125336.884358801@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit e0c49bd2b4d3cd1751491eb2d940bce968ac65e9 ]

sysv_nblocks() returns 'blocks' rather than 'res', which only counting
the number of triple-indirect blocks and causing sysv_getattr() gets a
wrong result.

[AV: this is actually a sysv counterpart of minixfs fix -
0fcd426de9d0 "[PATCH] minix block usage counting fix" in
historical tree; mea culpa, should've thought to check
fs/sysv back then...]

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/sysv/itree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/sysv/itree.c b/fs/sysv/itree.c
index 08d3e630b49c..f5b0837511cf 100644
--- a/fs/sysv/itree.c
+++ b/fs/sysv/itree.c
@@ -437,7 +437,7 @@ static unsigned sysv_nblocks(struct super_block *s, loff_t size)
 		res += blocks;
 		direct = 1;
 	}
-	return blocks;
+	return res;
 }
 
 int sysv_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
-- 
2.35.1



