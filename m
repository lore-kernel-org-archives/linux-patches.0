Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577F02E9730;
	Tue, 17 Jun 2025 15:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174398; cv=none; b=sADA8Rj7eqln31HpgWN5Ea/FUZwqm0crUc7UUWGzLyPB6d3ATypN90WIc5Anh6Eem8e9H6H1JOiSuwEQkmKlP9lLyIpnrXg9DItkQbBCbzOkHn21SX5iq7V1sIEg1NFWdr1HG97wLBC1lYhBcZXPq2qGj9ILO5/np1N83hmFrSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174398; c=relaxed/simple;
	bh=JIL11OcL48asIMJf0+JicUY7keHdJxKZg0Gr3jEhe0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQUz+H8CM+dwS3vT58pzH1uRLOWTf/q0JYS5hBaM1/4axOugpf5yhCpJkC6e8qTFsE4vHL8fe7L9gTST8XUnzCOvB69h+k92WtFx9Nb2VgAZqd7pA3gidmx52dp0U6HBNgwaYieoAvXXjHJx58Tj/uB+eHA7AuDwEWTfLI+QFwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=knagZ30p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="knagZ30p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB5DC4CEF2;
	Tue, 17 Jun 2025 15:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174398;
	bh=JIL11OcL48asIMJf0+JicUY7keHdJxKZg0Gr3jEhe0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knagZ30pqQtaTEQKQfIDN78Ef/QbY1o308AWFzuoOj8gA6yYRUtGmUCM9NesJxuRY
	 Pl1TgcOO6IEutbGn55N9vcgIH0qr5QeyzTY8s7bIviPo2xWGJv3001vQv/Nobwi8+H
	 rHj5ATjH0Cr4vnyVAd24xWkDvQvE0bcTKa+Z+ym0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/356] fs/ntfs3: handle hdr_first_de() return value
Date: Tue, 17 Jun 2025 17:22:58 +0200
Message-ID: <20250617152340.770578993@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 28aae6ea1e615..191b91ffadbb2 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -2184,6 +2184,10 @@ static int indx_get_entry_to_replace(struct ntfs_index *indx,
 
 		e = hdr_first_de(&n->index->ihdr);
 		fnd_push(fnd, n, e);
+		if (!e) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		if (!de_is_last(e)) {
 			/*
@@ -2205,6 +2209,10 @@ static int indx_get_entry_to_replace(struct ntfs_index *indx,
 
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



