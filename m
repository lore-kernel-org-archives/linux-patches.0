Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6502D1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB880C433D2;
	Wed, 28 Dec 2022 16:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244032;
	bh=rTuHuNPhpGbfiz00yJnLqN0l1eECxgJVrAOuYPMspio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wd8tFe5yRaFigf3Td12v4DJHsTI9RQZu2kp59HKFWltWNherrN1asNpEV0ns+W/hq
	 g9krc6360G2XAz9fj2Wi8rkfRMnuc8RwcmErZ+ouFL7OdOdt8oMueh04/HDgGKNbhg
	 oO3Ufa0hUpxCWKIxE/KfJv/CRSHl5u9t4Rp4PyGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0598/1146] f2fs: allow to set compression for inlined file
Date: Wed, 28 Dec 2022 15:35:37 +0100
Message-Id: <20221228144346.412442977@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 82cda1258227..f96bbfa8b399 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1915,6 +1915,10 @@ static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
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



