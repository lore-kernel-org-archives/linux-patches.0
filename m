Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE74379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301921; cv=none; b=EhgdC0wh+K8MWECXAaC0Ck8Ct5woLDaw7vLOYhbf1Kopb9ZedyQyA9cr56GYdQhE1ynB1iiTz/JRrafr2EfTVVRVpDGuQyA5N+VZ8KVCI9PMe0lsgKc5A9yNhHaUWCAtGcfbCrWGSgAdd4vtNAwb19grXhokFh2OH1LrE6VZu2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301921; c=relaxed/simple;
	bh=/eGj+kVru/CIY2gEsbfQKme3EjFMJUdXZ1Z9GRk8S3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rg4iRMw1s8V0h6XhKROcUE4WTQfe5Yw+dSmZvam+cWaaXyF8nwsYifFHlqOzsLv+iphhE2nvBjx1Q34rlOHacz0XzpiJ6Cj/IVy1dQ5WJe4JhO8oowwaVItGeXEbgjD5ddLS5Amht0mcumKesl42fDN4550pH6HUsZKrOcv62Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oFl+qFYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oFl+qFYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69125C19424;
	Sat, 28 Feb 2026 18:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301920;
	bh=/eGj+kVru/CIY2gEsbfQKme3EjFMJUdXZ1Z9GRk8S3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFl+qFYtClbq4Hs/bK/nWkjXaHNRYFwTUGwHaQtKl6yiQBVKlYx/fa4Kix3gwfIwT
	 y37zZmNdXDy5kwfa3hrDTgitSbXyZw9qzqUQAHLfu5sZlztEHV8bQ6dXzPB2yEVHo0
	 kGEgwjiu11yabmXXYFLHnpryjwoUebi1JEn2JC00XkCKO8GAPnnK3LJJfRrPjYBTZO
	 P5cIDplk/GdrzFlV5o6RcYSbf1VuJvbx9CtkGi3OM3eVowNQRz2AMYlXyFxt//DQr9
	 XkMALN/dW0EJwhUFrTLGP1cqvcMlw9NIi131Outd2ByBb5oK7G8WPcI+Z6vfxEidiA
	 iMl4X80PP1ieg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 354/385] io_uring/cancel: de-unionize file and user_data in struct io_cancel_data
Date: Sat, 28 Feb 2026 12:59:36 -0500
Message-ID: <20260228180011.1568201-354-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 22dbb0987bd1e0ec3b1e4ad20756a98f99aa4a08 ]

By having them share the same space in struct io_cancel_data, it ends up
disallowing IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_USERDATA from
working. Eg you cannot match on both a file and user_data for
cancelation purposes. This obviously isn't a common use case as nobody
has reported this, but it does result in -ENOENT potentially being
returned when trying to match on both, rather than actually doing what
the API says it would.

Fixes: 4bf94615b888 ("io_uring: allow IORING_OP_ASYNC_CANCEL with 'fd' key")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index b33995e00ba90..da13a1d820622 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -6,10 +6,8 @@
 
 struct io_cancel_data {
 	struct io_ring_ctx *ctx;
-	union {
-		u64 data;
-		struct file *file;
-	};
+	u64 data;
+	struct file *file;
 	u8 opcode;
 	u32 flags;
 	int seq;
-- 
2.51.0

