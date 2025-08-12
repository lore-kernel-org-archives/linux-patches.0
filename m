Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF0C2F4A02;
	Tue, 12 Aug 2025 19:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026485; cv=none; b=POwW36QYbMdgO1nGUOYWZC7Ea7HBgmoxXGYsLs1GQh4udWYGa9sdAbNyu095HxFzNoV0piepwdG5SlHUQYDUKmUWF0d6DutQI6/iP07AErWl2y1Le/0t8De34FZIYCufSVgovDDMHs5+ZyHxxE28ByMc2UiohjteGLYr0uIbZ3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026485; c=relaxed/simple;
	bh=AEesJgSnNxhpH9gcBa7pMTd0J4rSpERjhwIEjFApV9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZHv682xRPnWWRQ5ba9RPwmv0p348WjAOzeKvGeY5GSTD+7/QW1a1rlSElT7YxeqTzgeM/k9w6dJpAbTY7ZF7KxdAsItk0X6AqmeU2DPJXiwwIRPa/R/Zg/QKovm9jGII7J59ku0j9VQCuQxJv7Dmsdpp83rWAHPkxxgeBrBMxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMVfRa/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMVfRa/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B16C4CEF1;
	Tue, 12 Aug 2025 19:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026485;
	bh=AEesJgSnNxhpH9gcBa7pMTd0J4rSpERjhwIEjFApV9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMVfRa/z1EoF2SGMlwVFptWK+m3Ah0X5BpbR9gxX+ikEPq/EXoyJuIAiTaJmOLQip
	 fKw0dN08pP5ySvNnjxllsd7pNpdpANxdBthLxclgTj3guzZa+wNRnvYlNKXAsFiZL5
	 dc0lZl14eXJaUhbhGjY4MnjTgym5+3DhBTdVMQdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 351/480] f2fs: fix to check upper boundary for gc_no_zoned_gc_percent
Date: Tue, 12 Aug 2025 19:49:19 +0200
Message-ID: <20250812174411.907732680@linuxfoundation.org>
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
index db5418f72ff8..05e5d8316c70 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -621,6 +621,13 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
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



