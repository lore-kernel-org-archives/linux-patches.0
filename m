Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BBE1E522;
	Thu, 30 Jan 2025 14:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246949; cv=none; b=ND1pSI8ybWw3ptfU2DUDjtmIdAioXOknau6+NrGCsRk7VPtpKeAyExvAYYlEzdhGz2os6o1TmoRjT482K6Afd4I3OpZ0RjRKS9HD6XiRpFfAKE0pUivCQgAvf6NK1O96y7LaGM5Xo/ilXGZ+ttpkzEr6Hi3a3nDZAf2gq3cKMM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246949; c=relaxed/simple;
	bh=q1IsPQAsihT/gpOWocAL95ps0BlEsvWDTnFDJJp3CvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuZW5SGc7I2kJF9PrZOgPjbIIK6mnd4LrGZsRV6o2wdGFAhjLGhpuQt5lTUM9oCJKUzDWJ97p87cyoC21FYCDjwP+i9k+C/jBKxnZ4YW6fT4zdfz6zrfE5ppZGsx6irAPXuG/gWo0O8OUEHF0DIIp9qgVuzY60KiZErJNj0c0lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtJKTBcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtJKTBcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968C8C4CED2;
	Thu, 30 Jan 2025 14:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246949;
	bh=q1IsPQAsihT/gpOWocAL95ps0BlEsvWDTnFDJJp3CvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtJKTBcc8NZPX/RiP3j+tULQOu3o717ArkTagUFtT58h1CkxAiYCWs30IBCmlDiu+
	 +p8nukrOrImFOfEnWZMfGmDkLaFXHZOqLpto7VML4qu0hsd3bS/yMt52imgks6rwel
	 qsPnw/Yicl4VEGiDEmpibjhmdx++sxpJLhZWiy14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/133] dm array: fix unreleased btree blocks on closing a faulty array cursor
Date: Thu, 30 Jan 2025 14:59:53 +0100
Message-ID: <20250130140142.674546483@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 849eb1b97c43..f97de343a398 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -950,10 +950,10 @@ EXPORT_SYMBOL_GPL(dm_array_cursor_begin);
 
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



