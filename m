Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922F6217F35;
	Tue, 12 Aug 2025 19:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026482; cv=none; b=QrGdbnl5U2ohgY75aQ9mFiajYgaiSsvbKDP6IQDm79aKqg/9sfCxsdzKTxOvPiNxoZMwNGhl1H3aVHH758CwWpqe1HOeI3A4eoHTD7mv31J7kTBokwY97xHCsSC4kftRQQ1Tz+2917EJIUZQgwaPKHBG3WIwlNxNmxcs1UBiWu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026482; c=relaxed/simple;
	bh=xUcYxuS7XXtNmarc8Df0LOzNYkwi1iK2/YH4SfbIUGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ml4YEhBWFOoIlgptKU8zwYQfG/elP61FvCwOfDmcPPFa191qDdo3FG/HRZrNRu+YKtmC276tRzukmw4Ua8GwJrvAh9FKQ4FPnJqJxLENGQ8O/v07qH6r+fvLCnix3tdcOqxeeenAqlfjH5hIWifqduRP3zo1l5Av27wH3cw4dAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zofpWWBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zofpWWBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E41C4CEF1;
	Tue, 12 Aug 2025 19:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026482;
	bh=xUcYxuS7XXtNmarc8Df0LOzNYkwi1iK2/YH4SfbIUGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zofpWWBK8YfnYYXSpZ3RKG7XQFkZcPkpdJqMnh8Zt81gamw9/qnOBqb+iglSFDevs
	 OG412y9rDdpkkAeoR/Uc+SKYDUMNRdiBb0umsXMTfxivQp69iCcQBKAr2q3wK8GxR4
	 YY7cNUOufCfKqh3+4/LF3EMKN/AWxwuG7yuuxzMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 350/480] f2fs: fix to check upper boundary for gc_valid_thresh_ratio
Date: Tue, 12 Aug 2025 19:49:18 +0200
Message-ID: <20250812174411.867444132@linuxfoundation.org>
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
index 932df15df328..db5418f72ff8 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -628,6 +628,13 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
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



