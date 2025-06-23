Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA9A347DD;
	Mon, 23 Jun 2025 13:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685996; cv=none; b=cS/Ysr1zHeYKntHpTN63TJ/FnhXn53XLvWDPEpWKzw6moKNnEreYpsUd317Gs9s1lrHkRT+KCM9BnWsvPNnxmdDa0mhx4A3BxpBkT8GPkkTcIiHxqalZqEsOTRKD5y3qArn/kz9ZtLOkWLTObrCOm3StsSb+tz7pBjbIHu68M8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685996; c=relaxed/simple;
	bh=97cBATPOu0LVc7soeKtwR8A834CDLA8UdEqkxJkbne8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mATeJLvl4+Qvreo5x56eulWk553RsqsESpd8u4r2Rs/PLyFpcR5qkNHYTuzky18ByAKb0RfcbamMtJ00LT3TzYPr60Q4tLKahs3IepoDjtMCclY6yWA5WxpqoeqMGlFWS/WnKCDgk2Fn3j9ox6aviE0XYjfufBqzQBCD8IX95Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HT/ZXpwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HT/ZXpwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60689C4CEEA;
	Mon, 23 Jun 2025 13:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685996;
	bh=97cBATPOu0LVc7soeKtwR8A834CDLA8UdEqkxJkbne8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HT/ZXpwC4Oy/oahZqIOgqRby9J3ELkwOds1krKfj1CQhpHyBiDm1tP3s67bXqTBvY
	 922ComglxIosySOnx3+NX13UtDPTUsmDTCYhfiMYa55ttyX3WzVYYzKGJv22Fx6VoX
	 4bTrnbTJmUuFJ13WIuboBlrbxMeICXtt8/1osq5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/508] fs/ntfs3: handle hdr_first_de() return value
Date: Mon, 23 Jun 2025 15:01:27 +0200
Message-ID: <20250623130646.279873321@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Vatoropin <a.vatoropin@crpt.ru>

[ Upstream commit af5cab0e5b6f8edb0be51a9f47f3f620e0b4fd70 ]

The hdr_first_de() function returns a pointer to a struct NTFS_DE. This
pointer may be NULL. To handle the NULL error effectively, it is important
to implement an error handler. This will help manage potential errors
consistently.

Additionally, error handling for the return value already exists at other
points where this function is called.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Andrey Vatoropin <a.vatoropin@crpt.ru>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 139bdaececd72..ee6de53d2ad12 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -2166,6 +2166,10 @@ static int indx_get_entry_to_replace(struct ntfs_index *indx,
 
 		e = hdr_first_de(&n->index->ihdr);
 		fnd_push(fnd, n, e);
+		if (!e) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		if (!de_is_last(e)) {
 			/*
@@ -2187,6 +2191,10 @@ static int indx_get_entry_to_replace(struct ntfs_index *indx,
 
 	n = fnd->nodes[level];
 	te = hdr_first_de(&n->index->ihdr);
+	if (!te) {
+		err = -EINVAL;
+		goto out;
+	}
 	/* Copy the candidate entry into the replacement entry buffer. */
 	re = kmalloc(le16_to_cpu(te->size) + sizeof(u64), GFP_NOFS);
 	if (!re) {
-- 
2.39.5



