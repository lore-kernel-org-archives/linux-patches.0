Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F7A25178C;
	Mon, 23 Jun 2025 13:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685346; cv=none; b=Y8RJlA9H5w0P/IECVRUXFsLlaSGIgdX0zhg7lvuSeYYqCgrOmwLIGsmFTQKHclyO7u1i1GSaSWkARda1XB1AxklMDplfm7ff/yY2mVcsLFiR6s3VfxgdVF/6rTqkBQfJWno7GI+btQigvSVelcMqi0WQVLkkbGvQsuNiXMfHKsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685346; c=relaxed/simple;
	bh=wNWW82chupB8hztxRRHiqHojoITsR7hQNOSo/PN2tg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVkeClx9AqjW8ElL9XWioKKgx25g+hTR57kJ8nnMYT9Esg2Qqf5MQ4mWhKp+SsvLd6B+X/nZ3XGD72LBfAF3IjoM+bt0eXQHHPqOuWV5ZTh3nzu+1p/X1wE5kSbJfcSEtK59KdiwhRAUTtoSOh5U6/gqBmuPjgfN4kC9SZyvtE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sueAtRdu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sueAtRdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3E3C4CEEA;
	Mon, 23 Jun 2025 13:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685346;
	bh=wNWW82chupB8hztxRRHiqHojoITsR7hQNOSo/PN2tg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sueAtRduVpvpGN4cQ91ASBugu+5Cbx8bQ+Hh57SZYZr3dapbWUr5/zakKi7iWF+KI
	 DRASao2A1QILAUoHbr4Uc/BYeITi0+nZ2zgA/vKviBnQrNUKP9ZlnE7PWnz7p6Waux
	 UmE44sIXDXHxo8BiJl2G6EujHauvmU6dxrxlZi1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/411] fs/ntfs3: handle hdr_first_de() return value
Date: Mon, 23 Jun 2025 15:02:53 +0200
Message-ID: <20250623130633.876550909@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cc2d29261859a..0fe1b5696e855 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -2173,6 +2173,10 @@ static int indx_get_entry_to_replace(struct ntfs_index *indx,
 
 		e = hdr_first_de(&n->index->ihdr);
 		fnd_push(fnd, n, e);
+		if (!e) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		if (!de_is_last(e)) {
 			/*
@@ -2194,6 +2198,10 @@ static int indx_get_entry_to_replace(struct ntfs_index *indx,
 
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



