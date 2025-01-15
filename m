Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54B5248BD1;
	Wed, 15 Jan 2025 10:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938513; cv=none; b=kPbR05EZy5v0UIsXLoQIN/Kw8dRaxdVoFriQD4rQK7DB7s8cuJnDnWLYNrx6oP6qBydrG66VnBL0AopTTp5tgyguJ9U4IPl7VIVxdrbttcVngBy+0k+Z1wS9Dxm273MgLTWpdihDTo8b5vSRaIc6YwMQ7aJaPcwYgnFPzqj/tuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938513; c=relaxed/simple;
	bh=w7/Q2rjkR/jFXHHTKfEzcjdcP8eyYZkHwWfo/UIgSH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmU7D9OZBCAEzD3eD0t/uywZA0SU7DK//DIw9uG5v6DmqyWncH/WLjUoEmaCbBtuPUOgrlHgJLvzglZht0eosaWQ/WZXuCsUF2fcdq3/RUNzt2GPD5Za3jkAnquEDk76hgb2/Hiuv33puPOGt1Wu8B2sQsNmYlxJSZgcbiCnAEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+KjjgSP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+KjjgSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5706CC4CEDF;
	Wed, 15 Jan 2025 10:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938512;
	bh=w7/Q2rjkR/jFXHHTKfEzcjdcP8eyYZkHwWfo/UIgSH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+KjjgSPsS/LfU4dOPd4cTNckOPMkdbj9RfjbE3M/4wO3ddTfctGTnuAB6c6aoleJ
	 JRNwsHOBUVLhHVMmQNohaPRww2rQxlehX+jLdv8DIBu2hx8GT4lu1mqnvGC37oNG/d
	 5aT4zCqJtzStEce+YdP0wetrB077quQdvmTM+HAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/129] dm array: fix unreleased btree blocks on closing a faulty array cursor
Date: Wed, 15 Jan 2025 11:36:21 +0100
Message-ID: <20250115103554.615389394@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

From: Ming-Hung Tsai <mtsai@redhat.com>

[ Upstream commit 626f128ee9c4133b1cfce4be2b34a1508949370e ]

The cached block pointer in dm_array_cursor might be NULL if it reaches
an unreadable array block, or the array is empty. Therefore,
dm_array_cursor_end() should call dm_btree_cursor_end() unconditionally,
to prevent leaving unreleased btree blocks.

This fix can be verified using the "array_cursor/iterate/empty" test
in dm-unit:
  dm-unit run /pdata/array_cursor/iterate/empty --kernel-dir <KERNEL_DIR>

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Fixes: fdd1315aa5f0 ("dm array: introduce cursor api")
Reviewed-by: Joe Thornber <thornber@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/persistent-data/dm-array.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index de303ba33857..788a31cae187 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -960,10 +960,10 @@ EXPORT_SYMBOL_GPL(dm_array_cursor_begin);
 
 void dm_array_cursor_end(struct dm_array_cursor *c)
 {
-	if (c->block) {
+	if (c->block)
 		unlock_ablock(c->info, c->block);
-		dm_btree_cursor_end(&c->cursor);
-	}
+
+	dm_btree_cursor_end(&c->cursor);
 }
 EXPORT_SYMBOL_GPL(dm_array_cursor_end);
 
-- 
2.39.5



