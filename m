Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939911FF7C5;
	Tue, 12 Aug 2025 18:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022874; cv=none; b=MYpN0EkVpUoJwlInmwt80cvNd1SikJe2VcCyeiEVhE4lOTRAmI+nehw8BAMQX+SeH461gIM/j/YBxAjn6ieTiym21HoABSJ/FYY05mPb0zeVor+m9ohV1qctZAq8+NVRCQ7AhCWsCXJKROoVwLbEoCUAI4MxbC3f4dLFF+WykZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022874; c=relaxed/simple;
	bh=8dNOxOxxq0dBU7SNqO/HMXdacy8NTZSjDSdP91LYJnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHar18+BJtPT5O2mzLaHmSmsv1glADf1M+vjQiSawDl5IUDYDb/CNVoMjtGbWZyrhzdmYuoXi594Azx6hwGY+h1/P95abHjedVv7kPV0Xb69tVn9rKWgxaA+ED1FvTod/GC2iZ0ZOfomCnvuQ46TrlT3Qg1fNmS1UZZQlcMBJdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PrZbpKk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PrZbpKk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC44C4CEF0;
	Tue, 12 Aug 2025 18:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022874;
	bh=8dNOxOxxq0dBU7SNqO/HMXdacy8NTZSjDSdP91LYJnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PrZbpKk7pW9z1QVnUAciz1G1HroJaUF5SghD2fT+d9BjIRQ1PKvWcNos+l7+gALjx
	 cqkdaZjCqQPqUtnNNmVEypRysVRXDf5l5a4tnc1HUud1QjesS8giDjCo+DJuDgcStP
	 UWE+irK6vOJG/R45ieqfLortXs3akGgD65ChEBdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"yohan.joung" <yohan.joung@sk.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 252/369] f2fs: fix to check upper boundary for value of gc_boost_zoned_gc_percent
Date: Tue, 12 Aug 2025 19:29:09 +0200
Message-ID: <20250812173024.240822515@linuxfoundation.org>
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

From: yohan.joung <yohan.joung@sk.com>

[ Upstream commit 10dcaa56ef93f2a45e4c3fec27d8e1594edad110 ]

to check the upper boundary when setting gc_boost_zoned_gc_percent

Fixes: 9a481a1c16f4 ("f2fs: create gc_no_zoned_gc_percent and gc_boost_zoned_gc_percent")
Signed-off-by: yohan.joung <yohan.joung@sk.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 7df638f901a1..b450046c24ab 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -623,6 +623,13 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 		return count;
 	}
 
+	if (!strcmp(a->attr.name, "gc_boost_zoned_gc_percent")) {
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



