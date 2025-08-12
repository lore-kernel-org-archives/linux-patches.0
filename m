Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B473217F35;
	Tue, 12 Aug 2025 19:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026479; cv=none; b=WkcBZg2We/owaiLClxq+KjdcTL/MT3UGR1Qn26oi85D3ABOYM00G7SUpCWBoubBWlhqDdWCM2uoAeVLWGkE1Rfeu+qcOp2Ngi00b8tkV7fknNg2nv6cWHaN+PtD7kBMhDEp+vW8xiXKEwKGkdj0cGrq/woAlFXvhQnUw319WtjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026479; c=relaxed/simple;
	bh=S0zkH4V+pTyH1d/ZUt2nlulsdJB7LMUxyG8YqrlOFuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCze8WS17wK2i9R0m1kYNJ7uaF8uCLexeBAJTRHnQIHHDenybz53Gf9nzHfiuuunYyPjm8argcVJw+9Hxx3OmmbCgAttH/zPOaO1vTavOa2VVCdwuIlVVByAKS2wfCPLI4QxW9b/zGFdZuBIg0X2Uowr4Rq4w6q65V6gQDmx7cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Abq/gQ5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Abq/gQ5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC405C4CEF0;
	Tue, 12 Aug 2025 19:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026479;
	bh=S0zkH4V+pTyH1d/ZUt2nlulsdJB7LMUxyG8YqrlOFuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Abq/gQ5EKa6tPt2Ve004A1On64yGxWvA6UFAm7o7zTUXliQsduJ2gkt/dA+MWtCcV
	 U8NtEky2EUYDf36pLJfwdv8XKheYrUEJQlBUb9g25IzIyU0SbjQ/VKJjEcH/OmnSy6
	 LmPvifuDF1a03/hbSZmOxOhRCYbW6RxHeN97DIRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"yohan.joung" <yohan.joung@sk.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 349/480] f2fs: fix to check upper boundary for value of gc_boost_zoned_gc_percent
Date: Tue, 12 Aug 2025 19:49:17 +0200
Message-ID: <20250812174411.828153656@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index c69161366467..932df15df328 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -621,6 +621,13 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
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



