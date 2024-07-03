Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C16518EFCE;
	Wed,  3 Jul 2024 11:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004437; cv=none; b=D4J9uYOka8/LTIz6QaMZt7wnN4BMIaD3g+BftKQlaL1JqNE99bF4oCPHJzH42aWOFri9MFykul6kS0G8M2gX7D30xNYL9TGVfwrYYKwzM6X6RVD1hS+V3EoWi32Hx2Q2g/duLfgHZ2IL08B24xkPCBXur6poyafAo7eTKuGICeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004437; c=relaxed/simple;
	bh=Fd14rfEsc0+Y73utfZAJaG5fNe/elMLkOfwfMw2oBNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0mGb5WT4hUhANRTLIdd/I0XqyaBhf1t/8knrK7Fc9dp3yAh8eFZhbrF+gwrE4NuZrd4QsRSx+aIud4JmC10cCh7sUvkMlR7xNQvTuza35QY/LIbjsehIUGdN+jIEt+aoEVeLf6/QKlJcC3vHrNWthRSxenAZQcsy23b1Zbv/BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdJVoESh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdJVoESh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B83C32781;
	Wed,  3 Jul 2024 11:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004437;
	bh=Fd14rfEsc0+Y73utfZAJaG5fNe/elMLkOfwfMw2oBNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdJVoESh9RWpS3tNtfyPlKFs39eFRDcYZaVfvzDM5C+bfyOnd8NMr06aHCP7ey5ez
	 uhs0jTMc7ai3YrpAd9sZ8Jv0/TWsYL/wxyNuaidLDiVQ6s+RmmPGPbZzn3P0myTBxh
	 CLzGr9XFKbepIxsCvIWsgDxnyE4NzirZRD5G+A9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/290] nilfs2: Remove check for PageError
Date: Wed,  3 Jul 2024 12:37:02 +0200
Message-ID: <20240703102905.750492925@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 79ea65563ad8aaab309d61eeb4d5019dd6cf5fa0 ]

If read_mapping_page() encounters an error, it returns an errno, not a
page with PageError set, so this test is not needed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Stable-dep-of: 7373a51e7998 ("nilfs2: fix nilfs_empty_dir() misjudgment and long loop on I/O errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index eb7de9e2a384e..24cfe9db66e02 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -194,7 +194,7 @@ static struct page *nilfs_get_page(struct inode *dir, unsigned long n)
 	if (!IS_ERR(page)) {
 		kmap(page);
 		if (unlikely(!PageChecked(page))) {
-			if (PageError(page) || !nilfs_check_page(page))
+			if (!nilfs_check_page(page))
 				goto fail;
 		}
 	}
-- 
2.43.0



