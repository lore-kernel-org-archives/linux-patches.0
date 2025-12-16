Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693573233EE;
	Tue, 16 Dec 2025 11:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884538; cv=none; b=qlgDyva8PJGNUJtG9amNMrCLEEAGWwyHQqa7IRGyuAhuZ3O6iE6XiQVTiqzOEhJuzXQv15tiWeOq5+/9ppYZ/SX+Pwz+qx+swObzucT1onRk2zdeSWdK5VubDWHV4ygc+ff94GyhaIN9OchzR5SYgznunXnSnvcaSsqZqCzUFxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884538; c=relaxed/simple;
	bh=d2Gt3p7YIWdgckZ9HcgnERPb0GQxmjORpkj42/Z8zOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orZPnrrHsBbES1X0AMlQXrNiFTUhk40+o1QjlyxFJWlJW5RM50Fhy6LTKpvb9wkk2uS5TshjT6yz5NqoprOCEJU6dJYGuyt8FKZ6A1+7t1ULohO+Z+AHG7NecpyT90RDdbYjAIJxnOMkncJ/P2vaUEqQeWk3Tlp565Bf341IVKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUWXpZT5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUWXpZT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BD0C4CEF1;
	Tue, 16 Dec 2025 11:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884538;
	bh=d2Gt3p7YIWdgckZ9HcgnERPb0GQxmjORpkj42/Z8zOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUWXpZT5UCnwyHohmg+DFIQbFUYP/4tlmCFga/FPkHvKWFffIDDLNc/FcZTm+dLCc
	 S/YAczJAUgOiKbpcITlui+ls5D+smPB4ksGMZPVCvMDlS5EjzW43758hhQ5a59x//P
	 zOmnMEIJCITccGdw9uRWpJrXJsRuuJNQZelpkfF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 225/354] iomap: always run error completions in user context
Date: Tue, 16 Dec 2025 12:13:12 +0100
Message-ID: <20251216111329.069745156@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5209f0ec7427d..aba9d5ce819d0 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -179,7 +179,18 @@ static void iomap_dio_done(struct iomap_dio *dio)
 
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



