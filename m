Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0F5173334;
	Wed,  3 Jul 2024 11:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005411; cv=none; b=HBQt2QBXazscxaNSzZkQnbvgazuL/z/u7m0r2OKgeb5+uf5ZtTozvpohWHg9nUirqFdYyOa6qRuJHQOgfFRn+Av6PKix7r8jnxTK0xiciw30Of1bjBrEfXkJ3w+9OZB82Wvcb8DIlQMv1fjnYfpNYL5qdMfg0pyLOOEt0T9LsDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005411; c=relaxed/simple;
	bh=flabiqIXBRcEocleJ+kFx2Hn9U9rdkACWWhdDMzwdBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJyLG8nQ+CKXRa+qbaL5sX/N/nFVi9gZygKrBpTjGsVCOntkDMtMrwXlcnvkrxsAKg+fh5t/7HD+K7ZOuc0Uw6g1/vXJrN7/p9jxGkr0NlbMkN4bM8GxfpmZtDg1ns3v621mLd30d36ehucmhd8Of15Zq+5f1pSg055ujhXqrm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1k0wE4vN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1k0wE4vN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B927C2BD10;
	Wed,  3 Jul 2024 11:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005411;
	bh=flabiqIXBRcEocleJ+kFx2Hn9U9rdkACWWhdDMzwdBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1k0wE4vN/BZGDnwScsn7IfbvVhL2DqhrlrI9g1tilE8R0EjkmE7APGC32zCLWP/Wr
	 T9Rkr1o45m52J92x3JSyAq/wX8RTzsAkCDFXw7FpRZYE6+WFzNNYdFg6bECINXyMP3
	 jJYpruSDTxcIDqdBE2gEeTUUyTCuAIvn/sBB/pdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/356] nilfs2: Remove check for PageError
Date: Wed,  3 Jul 2024 12:36:47 +0200
Message-ID: <20240703102915.786318080@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



