Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D872FAC06;
	Tue, 12 Aug 2025 18:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024795; cv=none; b=FUggbhUih2BVwbtkPnXZfHExtcE2Pk7srGriu6Qb3vWrzgJR+k4c9QTTPb1b08w9roDcG0ek1Wal3qjl3PMZTuVl5defjm3o73M2/J7B1p1X0ovt9pSbLtJVopfFPGswxjdaljtCjlcu390aHXrorIXHwXchKXCzcvr8QfOuIt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024795; c=relaxed/simple;
	bh=8Nd2O0nXgmwcTBMTZ5/5ZzlYZB3phGn4K/KReX1ygDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLO9J5ad5Ro6COCv4pc4ZOSJS6il8dhkfKBOtKgWYdltdI2H72fAy4r+qjAhOnbq5sNkKpeBhZUfL2ahUdZitwIE81p2PObRi4GQi6KWdDycg/rhMuZI2GT2Yo++r9JwGnAwBoiWSeKCjCy2VR4+YbpJ0WhHRgz5Nw7Umxedyck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXsOdGYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXsOdGYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9948C4CEF0;
	Tue, 12 Aug 2025 18:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024795;
	bh=8Nd2O0nXgmwcTBMTZ5/5ZzlYZB3phGn4K/KReX1ygDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXsOdGYXV+Vpl+dmHxf/hXx+lLRRDs9iKmq/RXN2UvQPmKKpi+QIBFD/4o/nlsGtp
	 IybKvPt1tCCPakVqRNRvw/QsCrkp5vAq6t/UdiHqkHv9E8V3UFYsaGEwhVkEA5//jg
	 lUMGcZYoZXvael5V1bk+d+cXnHJgmbkYUCZS4dx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 479/627] f2fs: fix to check upper boundary for gc_no_zoned_gc_percent
Date: Tue, 12 Aug 2025 19:32:54 +0200
Message-ID: <20250812173442.739858147@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit a919ae794ad2dc6d04b3eea2f9bc86332c1630cc ]

This patch adds missing upper boundary check while setting
gc_no_zoned_gc_percent via sysfs.

Fixes: 9a481a1c16f4 ("f2fs: create gc_no_zoned_gc_percent and gc_boost_zoned_gc_percent")
Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 173ad1a72746..5da0254e2057 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -628,6 +628,13 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 		return count;
 	}
 
+	if (!strcmp(a->attr.name, "gc_no_zoned_gc_percent")) {
+		if (t > 100)
+			return -EINVAL;
+		*ui = (unsigned int)t;
+		return count;
+	}
+
 	if (!strcmp(a->attr.name, "gc_boost_zoned_gc_percent")) {
 		if (t > 100)
 			return -EINVAL;
-- 
2.39.5



