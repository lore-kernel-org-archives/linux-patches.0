Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9110168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222C9C433EF;
	Mon,  8 May 2023 10:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542138;
	bh=R/r9/N5dpoICBosk+yL44h4j/of3ULEGpIQVyYNnpsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdPNvh0kHcKYxg+LEX+yopCE/g2DvSFDn+0RvKXdwuJv7GLRB0Wmu9wOGXCcNDKwU
	 kUQjuwwaAVgaA3BdHTGPpvXiZRAPkRWgVVlDLskYIjWk7VbL5CCk6PcjMAAv5UWv7n
	 QBuIBxa7XnHgWl32W1FPNJyecCCgzseTdT90yX64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qilin Tan <qilin.tan@mediatek.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 338/663] f2fs: fix iostat lock protection
Date: Mon,  8 May 2023 11:42:44 +0200
Message-Id: <20230508094439.129581643@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qilin Tan <qilin.tan@mediatek.com>

[ Upstream commit 144f1cd40bf91fb3ac1d41806470756ce774f389 ]

Made iostat lock irq safe to avoid potentinal deadlock.

Deadlock scenario:
f2fs_attr_store
  -> f2fs_sbi_store
  -> _sbi_store
  -> spin_lock(sbi->iostat_lock)
    <interrupt request>
    -> scsi_end_request
    -> bio_endio
    -> f2fs_dio_read_end_io
    -> f2fs_update_iostat
    -> spin_lock_irqsave(sbi->iostat_lock)  ===> Dead lock here

Fixes: 61803e984307 ("f2fs: fix iostat related lock protection")
Fixes: a1e09b03e6f5 ("f2fs: use iomap for direct I/O")
Signed-off-by: Qilin Tan <qilin.tan@mediatek.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 088b816127ecb..2884efe5269ed 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -564,9 +564,9 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 	if (!strcmp(a->attr.name, "iostat_period_ms")) {
 		if (t < MIN_IOSTAT_PERIOD_MS || t > MAX_IOSTAT_PERIOD_MS)
 			return -EINVAL;
-		spin_lock(&sbi->iostat_lock);
+		spin_lock_irq(&sbi->iostat_lock);
 		sbi->iostat_period_ms = (unsigned int)t;
-		spin_unlock(&sbi->iostat_lock);
+		spin_unlock_irq(&sbi->iostat_lock);
 		return count;
 	}
 #endif
-- 
2.39.2



