Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403CA34E74D;
	Tue, 16 Dec 2025 11:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886136; cv=none; b=STnxPISHwKYW+qlU8LWrf6pTao8gS0xXFUwyGcLC7DlVtKBuO/kuE0BaPmEJxcsWpsdeqONN+OdWMySs+SkGzabABSJyUT/1Cebscffn5TjKT1OT67J4Po8AhR50sBeVGtFMSAH4Jc9tDkI9xQ6qFbGaFS7l8ySy5xAO1/qLeg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886136; c=relaxed/simple;
	bh=yCQTXJbDMT6shHYGVJd9Ak5PP9eTZBnZl8rhHnBj0Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVDTWhvLy2loiIetVOmkjTEf21gnkDekb9Jpr4Ehq8w64uNtneOTLPfZVfchcPCZipQRjaCbhcyAGMFQM7dl4/uUYSA54ymI52qvik0mNYveZX0ovucz5h/eNVEmd9A8heD048oUMIWwHzBkvwqoINDhesC3Iwl6rfUYbZoZbsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c00wTjaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c00wTjaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF609C4CEF1;
	Tue, 16 Dec 2025 11:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886136;
	bh=yCQTXJbDMT6shHYGVJd9Ak5PP9eTZBnZl8rhHnBj0Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c00wTjaKg6Dtty9tBCcWEi5bwfdyW/4wPe++W7+ri0+u0ykIxJRxtCk/KvJP27ei5
	 JkhP/E2UcrQpfcTf9KZNO29aAhy6dmQfALwZZvPhoE+Mvhu3/X6zl11Tjw+nChLKZE
	 crq+lGnNTM3JevCfHQ+ZCHthKQIXToHQM2PWIJg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 347/507] iomap: always run error completions in user context
Date: Tue, 16 Dec 2025 12:13:08 +0100
Message-ID: <20251216111358.031523432@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 46aa85af13dc5..97c40e7df7215 100644
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



