Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746A3346E5E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302633; cv=none; b=G76CQJ3RXPY42E+GmlpDUlEvUHsJuCFxfu7B64Q05FrunB+hoEgQC5VrKH47iL1f44szbdCSMxCQyyUF3Efit5h2XOmN0r3DC6JWF5Z696pQGi8gTxfSflksaLs22Y/boVGdeKSuMjii5mYHS1Y8e6cd7kFGBQtJxKCuAdCAsr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302633; c=relaxed/simple;
	bh=VW0pt+Y6YbBo0h0mncjgPS6aXKoxVpFs+S7HE5S+aUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tE8HIrC2S//8RrVqhj/n7fcYonItM0TMaKvi19LNRGNz3ABO+cWWnDEFP8pwXs/fYrulr0wWeL352r/ehIUpwO/u/QjO0q/v/iVbcv98tWA5nktkrwWGZe0tW51Y9Llhc5MK3RheJCQAFf5ruZdI/tHC4rvFoecVK1nWwfToNZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BbA9PWs0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BbA9PWs0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C59C19424;
	Sat, 28 Feb 2026 18:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302633;
	bh=VW0pt+Y6YbBo0h0mncjgPS6aXKoxVpFs+S7HE5S+aUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbA9PWs0m9kHiVZYK3ZBZWe/oM4Fr8nSnDyJibSZmiaOCOSgfXBZ0JzI9/9xIjF6H
	 9S1/NhyNGA1+NLc6q4Olz2ta83ENtEwTTWD7w+Uwo4kb8siLPD8FlJDU0StI5uFBDu
	 d/3pLbTgZFyIIJd5c9Y242JoBWArfc3Lulunq0FqU24RNxRbZ9NYD8tNADtQy1Jku5
	 rMaNBvWTW7ciYYwwmCEibV/GLf1TDIQykrVsFeqRJqgA0nrhsjdx1clKpoN3uupnV3
	 9qVWr8GodttTrl9SRs9H8E6oUl8iByi3g8GIuvWeE0Ughm9lrmjjSRoGAP1WsNsLQb
	 2T7Zx+lmWcxJQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/164] fs/ntfs3: Fix slab-out-of-bounds read in DeleteIndexEntryRoot
Date: Sat, 28 Feb 2026 13:14:52 -0500
Message-ID: <20260228181505.1600663-153-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit b2bc7c44ed1779fc9eaab9a186db0f0d01439622 ]

In the 'DeleteIndexEntryRoot' case of the 'do_action' function, the
entry size ('esize') is retrieved from the log record without adequate
bounds checking.

Specifically, the code calculates the end of the entry ('e2') using:
    e2 = Add2Ptr(e1, esize);

It then calculates the size for memmove using 'PtrOffset(e2, ...)',
which subtracts the end pointer from the buffer limit. If 'esize' is
maliciously large, 'e2' exceeds the used buffer size. This results in
a negative offset which, when cast to size_t for memmove, interprets
as a massive unsigned integer, leading to a heap buffer overflow.

This commit adds a check to ensure that the entry size ('esize') strictly
fits within the remaining used space of the index header before performing
memory operations.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 6fddedca71f32..d3d006b63b27e 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3434,6 +3434,9 @@ static int do_action(struct ntfs_log *log, struct OPEN_ATTR_ENRTY *oe,
 
 		e1 = Add2Ptr(attr, le16_to_cpu(lrh->attr_off));
 		esize = le16_to_cpu(e1->size);
+		if (PtrOffset(e1, Add2Ptr(hdr, used)) < esize)
+			goto dirty_vol;
+
 		e2 = Add2Ptr(e1, esize);
 
 		memmove(e1, e2, PtrOffset(e2, Add2Ptr(hdr, used)));
-- 
2.51.0

