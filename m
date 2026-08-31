Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38666479884;
	Mon, 31 Aug 2026 13:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184452; cv=none; b=tXaQSQX6tn5Cr6FeRV6E6R+zu7F/NsU7b9yA123fa1Q1eD6iHsDlw3Srsqeec48oMZVo8WkaUjZZ/9jw4AdPM1x8ghs1gQVszrMHlyRvmRfxNDseEZzQ3v7CbDkAEjamANuWfxgylwY5MZe2Xhr0q3xW9DLu0tVEog47QUJPOPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184452; c=relaxed/simple;
	bh=/N4XIw1a8usYrK4mMKS3pnN8+1487w4KBVI/aJ0bmtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5raEAQCN5I6BP9KlTPJ1EPbI3QC6hqdWdAuM25S6t8R/abvZS+tvTdZ0WXlbHJ2gtP74EWJ+Hw57LnXrX8i8/zEX7pShp7QeAlitsM4Ie4a6Pt1/ZEvR7V+hGf1H90wBi9mFDqubcBHR7KHAtOzHHpfKQyT8LoOLCWjhhqrfXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2Z+HKL8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2Z+HKL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932091F00A3D;
	Mon, 31 Aug 2026 13:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184451;
	bh=1fL9SV9oI1VN+eBGU3uBQuwkBqOh6p8PhGMd/7zzMWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r2Z+HKL83pO6vKo4/D2b3xhcNt/w0FPzM22/6pp5NcD7EsWgm/UHn0sUvBz2KUt9E
	 4v4dhCvfBaOQfHetA3phG+TlANtjtRxmOt2OHQvY4CvO6Ze3Q+YBkqztGy5UxUB3XM
	 Vk0ft3Q29r95cZ17KI6uY2wmL0N0gV8LCRM65MLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianzhou Zhao <xnxc22xnxc22@qq.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 13/91] exfat: fix double free in delayed_free
Date: Mon, 31 Aug 2026 15:34:01 +0200
Message-ID: <20260831133400.229110345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 1f3d9724e16d62c7d42c67d6613b8512f2887c22 ]

The double free could happen in the following path.

exfat_create_upcase_table()
        exfat_create_upcase_table() : return error
        exfat_free_upcase_table() : free ->vol_utbl
        exfat_load_default_upcase_table : return error
     exfat_kill_sb()
           delayed_free()
                  exfat_free_upcase_table() <--------- double free
This patch set ->vol_util as NULL after freeing it.

Reported-by: Jianzhou Zhao <xnxc22xnxc22@qq.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/nls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/exfat/nls.c b/fs/exfat/nls.c
index 705710f93e2dd..0e05c6b5a2864 100644
--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -804,4 +804,5 @@ int exfat_create_upcase_table(struct super_block *sb)
 void exfat_free_upcase_table(struct exfat_sb_info *sbi)
 {
 	kvfree(sbi->vol_utbl);
+	sbi->vol_utbl = NULL;
 }
-- 
2.53.0



