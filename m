Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1DF1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8C1C433D2;
	Wed, 28 Dec 2022 16:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243744;
	bh=f1yknhdNEv510RONUsHY8Ln7xVDyPd46hqurIzVSIZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgUlNoDrFaar9qFyy8Fo25WgFfnGbndZhebx1UVV/XGJIu6c6er4ICHP9tMATmOnH
	 EF2k779ON1aWtJVFEBBOHKbk2CS2tZy0M8vf9RffOvGrwAB1LfeQzPn1/wvyGkyycV
	 tiMsp/xcAngPawhIo/OC4vGGBJuAfHdotCDqtKYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0581/1073] f2fs: allow to set compression for inlined file
Date: Wed, 28 Dec 2022 15:36:09 +0100
Message-Id: <20221228144343.829594317@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit a995627e6dd81d4485d40ce64880017a080d71e6 ]

The below commit disallows to set compression on empty created file which
has a inline_data. Let's fix it.

Fixes: 7165841d578e ("f2fs: fix to check inline_data during compressed inode conversion")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index ce4905a073b3..74337edcbbb0 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1866,6 +1866,10 @@ static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
 			if (!f2fs_disable_compressed_file(inode))
 				return -EINVAL;
 		} else {
+			/* try to convert inline_data to support compression */
+			int err = f2fs_convert_inline_inode(inode);
+			if (err)
+				return err;
 			if (!f2fs_may_compress(inode))
 				return -EINVAL;
 			if (S_ISREG(inode->i_mode) && F2FS_HAS_BLOCKS(inode))
-- 
2.35.1



