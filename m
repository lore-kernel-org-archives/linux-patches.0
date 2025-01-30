Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768CF1E8835;
	Thu, 30 Jan 2025 14:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246621; cv=none; b=fVa6BNVVvA48i7D4WoxapCXYIEuXhY07I15mzsBqGeuUUQE4NngqzgZKt9HTAEaUqQIeM8At182wiqmwistfJubxIwGqwbxS0z2MVNj8wFGm970fM8MgCEN36TX8szwlSqjk2zVMUI4dLMbBqHI1Yx/7ri8HRkd8E/4aOVnvx80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246621; c=relaxed/simple;
	bh=HbqoS7J4BjN5iRgiXXhGMt8xoRcKXkprFifgNFBF2FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYjfKOVy0nG2DneLXXjL8YyucAdV84ND4XAx+28ncbK3Rtue3mEkuRJNDgBg0LHp9p5XtBhy2sER9/Kq4xMYJCHCbRMoBjLq+AzLgDYiVnZtcoK8R1S8PHz8Qb2g+kF0qSUWRBMSFAXvu3LR3aZ5qvhdZ/q1fQj5p5vs7F20szo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpcSUVUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpcSUVUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FC7C4CED2;
	Thu, 30 Jan 2025 14:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246621;
	bh=HbqoS7J4BjN5iRgiXXhGMt8xoRcKXkprFifgNFBF2FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KpcSUVUCAMDthV0Cha1c4Ggf1iinSAlPpXlMe7rZG6GpFbfV+4gqQVRy1m3Ub2XNP
	 wG+udp2ZI+hg2oc2bv+jhfLKJczIB0bBB7GLq/SKTiADC0Qqu47CV+sgpw97IDkOM5
	 SF4whv+PAvkNPsrB361vc4h8VsNMgexFQa0Obkes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/91] dm array: fix unreleased btree blocks on closing a faulty array cursor
Date: Thu, 30 Jan 2025 15:00:22 +0100
Message-ID: <20250130140133.808649831@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



