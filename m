Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6FE2E9753;
	Tue, 17 Jun 2025 15:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174940; cv=none; b=blXXtyAcKOn4qnWo8AoagRCFLyO79lQ5HI6P4qDgWIsroXCC9pPFF7QKEHfCnaQZbapfpGAu13sJWUGbDurJqbtlZqZo2oqRaOQkRx1y2QEqVbwGwnFnGwFC27mXWuxJOQPb4BB0YnQR1FPBRlsEw/Tb0DZAPyMyi7B1Smtk7GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174940; c=relaxed/simple;
	bh=ru66QfUEQZmtMrkiR7dyKAIeHuWj5CWvqnbJDwe4gh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9+6WJgotWnz0MYrxYnf0DfUM+U/U8dUsojqDK3uLeLEsI2lIj6HG2/hPUe7XvzqgvqjNVYk7r6e20e1iemF/hqnmP8zh9ND2s1BzL1zxZWmdKvQz0ywo0v14ocXq8LI/Ow6+X2CzzqCrxC0pVShc+T1YVGkSQmqLUsIGU+lvoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7DVBNAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7DVBNAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4352CC4CEE7;
	Tue, 17 Jun 2025 15:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174939;
	bh=ru66QfUEQZmtMrkiR7dyKAIeHuWj5CWvqnbJDwe4gh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7DVBNAAojWG2rI2i9FpYJWwgi9L6EXLm9Pt5SDianNtVxjK7Zb3tl9H4qNrqY4b4
	 U71dcb38RwhiQXfonSiaBeAel4Dzn5BFKGwXYD/R+I0tcA/PJ9Moj1X+EzZzRVvGcx
	 Zhgr/liy1aDbzp55RMJFf5lVX57ogbarDKd0ak6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/512] fs/ntfs3: handle hdr_first_de() return value
Date: Tue, 17 Jun 2025 17:20:44 +0200
Message-ID: <20250617152422.744477356@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



