Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD172F234C;
	Tue, 17 Jun 2025 15:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175749; cv=none; b=eFo6S0PPJr3+F5fYOcC10G3ZaUV4vncC3ZHUxkKEstxptBIt4zOM17C4LeCOp9CJnK9i6TmT5GYS5lvoPmEJxcuQUH9BECMElA2IzmS2MOKwqDzslKh4pc58lyh3ykLqBfpnucWBExojtXUiMgQFRgOViMKQcPCZ18O008l6IUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175749; c=relaxed/simple;
	bh=SklbKqFCtxWTVzJcamT7+wKzk+oFW8xEZB57ynuu5ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=td9M8VVO2GXPPYK0uGjTxbRwZZxEd8SqyZ/l/4QMhax7JhhEblli4xF2ZvaPZSSCV3UKde5e1AtRN0vItkJXzE/7gBaErvMe16tDMpf86PcDbWq5uI2gkt/fZY2Pgfh1XX4l5PfCmC8/9wpOItU6sE6SswBKR0jrns01dSkZTjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddo3DC/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddo3DC/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FE5C4CEE3;
	Tue, 17 Jun 2025 15:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175749;
	bh=SklbKqFCtxWTVzJcamT7+wKzk+oFW8xEZB57ynuu5ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddo3DC/WhUZ21G3mf6Tc8gTj7dEyxn2aaSfuntG2LRXNrSsJrtKhDH+MCBzag0iDx
	 F5cIf+oRP6tPHOhieqmCAZFnbYHxytrfwsZsjQyic7svoVlvystB6TbTnXNoUQAVFf
	 r3dvC/s2ZnTVIUnkcLeQUzp4imh8Er6WCh79c6KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 119/780] fs/ntfs3: handle hdr_first_de() return value
Date: Tue, 17 Jun 2025 17:17:07 +0200
Message-ID: <20250617152456.344878616@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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
index 78d20e4baa2c9..1bf2a6593dec6 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -2182,6 +2182,10 @@ static int indx_get_entry_to_replace(struct ntfs_index *indx,
 
 		e = hdr_first_de(&n->index->ihdr);
 		fnd_push(fnd, n, e);
+		if (!e) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		if (!de_is_last(e)) {
 			/*
@@ -2203,6 +2207,10 @@ static int indx_get_entry_to_replace(struct ntfs_index *indx,
 
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



