Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B462C1FF7C5;
	Tue, 12 Aug 2025 18:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022877; cv=none; b=NvDjKe7lyuPZ5kje9XAB6H183+ghjRPQqtHp1qBrLIq7X+QmEUdcUhu8wwsbHPdY99GYkyeKB/L3uu9GoliW+i4KZLtilvur2bqiEL6q27bt2i2xUZtize5MfBRuJuuAVaKjrUtYRGuAU0HptzLoE5cl2hNywaiqyrMTRRNnvgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022877; c=relaxed/simple;
	bh=0kYvsHNPYeip7p5Pt554CkIvCRPN2DmKO4HF8yhTj2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYMphYq7qVohNQM6gRWGijLTV6DmeC1hWG6FGAdgCSIkboO/zqYXe8/klaCgV5+wqisTg7LleLcnuwGqYLNdKsGswH2NgMBlA/cxgzZ2znLGobFU1uJw1GgNiHUg0w5ipvPCANNOqRD69InUz8zY8wW36w9cjyoagwNfFnPWW2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LjfTlEVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LjfTlEVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365A2C4CEF0;
	Tue, 12 Aug 2025 18:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022877;
	bh=0kYvsHNPYeip7p5Pt554CkIvCRPN2DmKO4HF8yhTj2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LjfTlEVhuBTitjcT4kajp/P+1f3L0czKf84uim+gafwdwNrKL6cXss7/0Nhpn0UuO
	 mvPU0QpT/sesHK1b/xFsmJzvPZIOsuBsvCzRnQrbE62KCqwskuFG1doGTMlaDb/WIS
	 Sl49TdMfqp1I8C/xVnaETk6QEAqCdZNlcn9kgA30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 253/369] f2fs: fix to check upper boundary for gc_valid_thresh_ratio
Date: Tue, 12 Aug 2025 19:29:10 +0200
Message-ID: <20250812173024.278553264@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 7a96d1d73ce9de5041e891a623b722f900651561 ]

This patch adds missing upper boundary check while setting
gc_valid_thresh_ratio via sysfs.

Fixes: e791d00bd06c ("f2fs: add valid block ratio not to do excessive GC for one time GC")
Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index b450046c24ab..d79d8041b8b7 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -630,6 +630,13 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 		return count;
 	}
 
+	if (!strcmp(a->attr.name, "gc_valid_thresh_ratio")) {
+		if (t > 100)
+			return -EINVAL;
+		*ui = (unsigned int)t;
+		return count;
+	}
+
 #ifdef CONFIG_F2FS_IOSTAT
 	if (!strcmp(a->attr.name, "iostat_enable")) {
 		sbi->iostat_enable = !!t;
-- 
2.39.5



