Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AA632BF21;
	Fri,  9 Jan 2026 11:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959882; cv=none; b=fzB+mQ8ANnWPi09wC74zr5i9jHZDc2Yix8TgzvEzw13x1cOlvXOBI32rZfm9+57fQjDfPpMGfNl28w6ADuwdkja9oaEfrlwNhyKM5h9eetsHJkNAjnXssVegntFY76253eO0koVcW8JzD+z614sM6Twt9202YmING8nTYJUV68I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959882; c=relaxed/simple;
	bh=4fDJcfOu20v9cJkzfRSVcMAn2668bKWMEsojHi+cTUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdY0LglByiidZ7ukDdv7UD9RbRksfC/K6bFaKor/FR96nDhWfArQzuBJzdoQabM8vUkqcxXzSgSzlNzinTl0hQmADpgQ2tGaVYWSIC0PNf4oy/5DYlqK9qIM43mozHUjTaYUhR9rBxpTenm2q20Az68GOMnRqGcM7osC/4fJ/H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lH3n3yLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lH3n3yLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CE0C4CEF1;
	Fri,  9 Jan 2026 11:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959882;
	bh=4fDJcfOu20v9cJkzfRSVcMAn2668bKWMEsojHi+cTUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lH3n3yLMwbDHK5B/goUe007Og09Wg4ptCK5h7Z8JyV5zEk+uFQTMuQ8iURy9lYOgy
	 1ZnTVcP9a7omFkn+zJ6DbyfhrQAYG5BAKfTBbpY9YRsia4HjJyNzBblq6BxlLqrxI1
	 yGuHXdrGoBaaNe7t+OVNfRPOzsYec5/aOWTpIKYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 207/737] iomap: always run error completions in user context
Date: Fri,  9 Jan 2026 12:35:46 +0100
Message-ID: <20260109112141.786635105@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit ddb4873286e03e193c5a3bebb5fc6fa820e9ee3a ]

At least zonefs expects error completions to be able to sleep.  Because
error completions aren't performance critical, just defer them to workqueue
context unconditionally.

Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20251113170633.1453259-3-hch@lst.de
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/direct-io.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 1b0f06e7e58de..8158ab18e1ae8 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -172,7 +172,18 @@ static void iomap_dio_done(struct iomap_dio *dio)
 
 		WRITE_ONCE(dio->submit.waiter, NULL);
 		blk_wake_io_task(waiter);
-	} else if (dio->flags & IOMAP_DIO_INLINE_COMP) {
+		return;
+	}
+
+	/*
+	 * Always run error completions in user context.  These are not
+	 * performance critical and some code relies on taking sleeping locks
+	 * for error handling.
+	 */
+	if (dio->error)
+		dio->flags &= ~IOMAP_DIO_INLINE_COMP;
+
+	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
 		WRITE_ONCE(iocb->private, NULL);
 		iomap_dio_complete_work(&dio->aio.work);
 	} else if (dio->flags & IOMAP_DIO_CALLER_COMP) {
-- 
2.51.0



