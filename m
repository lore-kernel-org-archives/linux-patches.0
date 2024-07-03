Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47A619AD4D;
	Wed,  3 Jul 2024 10:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003845; cv=none; b=LgF8XGTvh3aM3Eu+Jo3r70EMpoyO2B7brHmsptB75B7/qH8eyMtJKlhhsruurTIab9N8iSJeHwJutdplehhedd9DP7zTGSU9a0jDyS7dES6RUq6LtaPksqYs8JudlSa9wKlWt8CbP9tU27riC9pinR4zPA3lS6abLew5ECtzMdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003845; c=relaxed/simple;
	bh=vPosaamE2Qim9TiTZIhvJ6shQg7HLnnK+Qv9p3EaXsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgTbnSaj2Rv6XQkTE2AAGJ+fybT0qeZssNwwi/rq/vgISfQat5Z0Jqn8B7raJLD1uetzctSKAbw75f857OTcUMeHvp4qJuB7c1pFYq4MFSoEFbl8s00tR+yId3R3F7apKgt8AvqAzyxfm/Jl4xHD//WJkx5t9vz0l93mD6G+JTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MX6Mc8OR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MX6Mc8OR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD38C2BD10;
	Wed,  3 Jul 2024 10:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003845;
	bh=vPosaamE2Qim9TiTZIhvJ6shQg7HLnnK+Qv9p3EaXsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MX6Mc8ORUpnVlUFPBWnGJ5D+zycGN89gHdckeAdr1bySVlcwu1UHqrA9EcxBEq/dd
	 eS8B9X3Hpvl1+btWONVXJSTEDAvgjMB/zTpiKx1Ke7iwsiTODM+f5bL604O8KEF5GV
	 dx8hYTQIiHNPEWY2pCbcLX1CdsbVSiuF6unYXwxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/189] nilfs2: Remove check for PageError
Date: Wed,  3 Jul 2024 12:38:21 +0200
Message-ID: <20240703102843.025397708@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



