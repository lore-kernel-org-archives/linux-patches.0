Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AB6242D65;
	Sat, 12 Sep 2026 12:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216437; cv=none; b=r4LqsvBDMlRVOURkBUBoPl31JqJj8ZtK/8+Mrjqk5wuntATYhExe8b588ZWhcYC+eUwwBZwliaHO60jvPlXI3Powd9YMjP767wBOACeFrFlnUQq16nUgxFAJilPhD1FUU00DccWeV/f9Ytfl453qeD+KGU4bW5QAR4PZECZjmBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216437; c=relaxed/simple;
	bh=oRM25l0Cq7ZVBIhAB8xToTsfZTvgWPjupFT1Y/yo7b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXWS5rxMtBVQScuUGuE7w5frerTLwRHJOxt9wc4NsOcFi+rJ51bB/FNTNPPFw2B02GYCsx3Aeaow1PemTvaDYoICc+FEbF6uKFHj6UUofpyBae2u1zGyTP1POcYznNUXY23UvKk0qVzBAfyIFaF/KjZMrMpYLN/HDN3W0fRe+Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UeIm3vh3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UeIm3vh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8821F000FF;
	Sat, 12 Sep 2026 12:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216436;
	bh=ZCjs+34T9C6+ltlqhEWIWRb5OAsNpPV0T7gNVsl7ue0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UeIm3vh3zqt9U9KRurvdm9AmYkz2eR7FGF2KAOn9hkYloR4Fp7wAHBYX9gZPwv2NI
	 jO2A+JGj6RVMCEw1Jr/mnOgSbBsXY+tledMK52xC4DWYQA95XItmcKld9svPlxLcNs
	 hGApx8Mw1YRJbqcsJYOGKdOnCxbdakBMO7bZWD7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0699/1376] isofs: release zisofs block pointer buffer head
Date: Sat, 12 Sep 2026 08:52:05 +0200
Message-ID: <20260912065623.124147190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 2f7dd9b86fe4076059e6a4a2a2c5d565afd76b9e ]

zisofs_fill_pages() reads the compressed block pointer table.  The error
paths release the current buffer_head, the loop also releases the old
buffer_head when it advances. However, the success path leaves the last
buffer_head referenced. Release it before returning success.

Fixes: 59bc055211b8 ("zisofs: Implement reading of compressed files when PAGE_CACHE_SIZE > compress block size")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Link: https://patch.msgid.link/20260721091152.1450622-1-chenyichong@uniontech.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/isofs/compress.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/isofs/compress.c b/fs/isofs/compress.c
index 05b9fa80ba9c2..7d701eb7af52a 100644
--- a/fs/isofs/compress.c
+++ b/fs/isofs/compress.c
@@ -293,6 +293,7 @@ static int zisofs_fill_pages(struct inode *inode, int full_page, int pcount,
 		memzero_page(*pages, poffset, PAGE_SIZE - poffset);
 		SetPageUptodate(*pages);
 	}
+	brelse(bh);
 	return 0;
 }
 
-- 
2.53.0



