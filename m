Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B43B1E7C2E;
	Wed, 15 Jan 2025 10:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937925; cv=none; b=QbCrF2Xnz9UxHNvXR5qNMGurzbZlnPy7O84FMRY4IZAO8qJqNE84yITlsoiI9ALpeQehaumx8iurvCjxobVOQ0Jqh4WL2vbeZmZjFWFXAUBnH05UDwsVSkDbj1wPdkNvSpuDBYF6w8DjxTsmMiwASVjNCd5gREm9Uc1Aku+oohs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937925; c=relaxed/simple;
	bh=G/qGnrXUV7D61DS7SCW4ujAFTGyDIctWMV/pp6Ej5Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWtW6WxUmpPpM3G8pm1FjBj6YvDs3F2Qd9jLDJVDMBWznELh5CZjoT2AJliBayoYNwqYLs/hUMRsdCr2m9488eLS+xMEh+SsfXifWMZOv9zDMAKoveQSdTECFbdTWDJyrH1RajPoxKGIg+pyjoJsNdBj3bqQIaYT5TPyJCIeRW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RntgaQqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RntgaQqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56461C4CEDF;
	Wed, 15 Jan 2025 10:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937924;
	bh=G/qGnrXUV7D61DS7SCW4ujAFTGyDIctWMV/pp6Ej5Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RntgaQqjQd2+EJcyIi1Q55acuK5hoZ6rScp1XSsZ+2Jfr/JGpZZTm6PRKSTEsI16S
	 bW8x4Q+K2ZhoLauEZEUZ9K8OSRpZDvN5iMVu1BpdnOza8GFu3fDIdvVd3r0vR/UCJr
	 Ys+G1hFtzq8VHwofASzP/7BzFUKSxG6Vt0TRaDpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/189] dm array: fix unreleased btree blocks on closing a faulty array cursor
Date: Wed, 15 Jan 2025 11:35:03 +0100
Message-ID: <20250115103606.653473635@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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
index 4866ff56125f..0850dfdffc8c 100644
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



