Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8CF1F540C;
	Tue, 21 Jan 2025 18:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482826; cv=none; b=R5MuTkjsIDAAvyDeZ/CV75FJbrrtbALvv5ivPZxktmSYsF81Uc6tHR8AcIP0QCEBiJW/EYG3P6AwVbMbaOXgEdtQawwHFQVcGuVXnaL4h8geGjueIKe/wwF3tiBfeDUi6d8vEAbI6oO9LqeBQ7e44NAD1sbRoixcTqamLmrFC5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482826; c=relaxed/simple;
	bh=469MClTjW5jlMESj3ilpsbtZDZpjCrN19yHoCUpVoNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjzQQw+wWNkruTLT6zAu5PaEb9AbPIMyJO+gGQnWh+yIvnUCpqKpen8FAzWyoW3JCjIHdv1BfXqk45OHVY0wjsTB6lIsrqFykLEKi2BUQe/yA8i+0qULEiqO7gldZKnSe2Qvn8rGd4ZQbteq4IihKEnmiWK8rF5/eNDMEJbPqJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAbJIZXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAbJIZXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032CAC4CEDF;
	Tue, 21 Jan 2025 18:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482826;
	bh=469MClTjW5jlMESj3ilpsbtZDZpjCrN19yHoCUpVoNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAbJIZXdSVfdJRPaA00C0Pm4XwGscuPNDESZuQVrEK/q0ewca4cSviFXAptmp0+18
	 cWrvuYLWgexvrkVRsC6pX5rGGYY9jPku5rxnoTV6Wk2qD2b13JcHo6MImBs4XFs0bJ
	 hoiKu3hVIBpXg7iMa32xUORNM0b/mpUFB9v7My2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/127] dm array: fix unreleased btree blocks on closing a faulty array cursor
Date: Tue, 21 Jan 2025 18:51:16 +0100
Message-ID: <20250121174529.846017872@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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
index 33bc4b38911a..a2d9493d3593 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -954,10 +954,10 @@ EXPORT_SYMBOL_GPL(dm_array_cursor_begin);
 
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



