Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E817376BCD;
	Tue, 16 Dec 2025 12:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888049; cv=none; b=FKCzBI4EGgWJoxRuk7h/ZduTddnsQyD0xVtizSXmj2VLN8deMYhO86Bx0jJ48UV4XKCAcmk09kXuJBvKQc5W79EEA88BpwW0mCTJ5t2ex0cDjghRnJbVo4tM1uhCXbRejoEZBCaqEPPSnyL3rvv/ZJsMFOm31xFPwORaSp42fFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888049; c=relaxed/simple;
	bh=msD+cXn3moI6mas6WbkOEVTxMiwEYv0KjnDMqPpuycE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTVyrTJg/8BHRyqtRYekIX7h2AVFFlKp0DaNQJLJrWnlYexkDDu0WzA9+0I3jQkBVrjFsw8zbuqaipDCOGdwvmPd2J4Q/NfvYZQfKKxXQAiqNd3HUJssSat/5y8ePKjO9Qp16g5tXtKtrZ1zeZrl1t8laqjRT/gjVwoKeJq1pnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKMnINiZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKMnINiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863B3C4CEF1;
	Tue, 16 Dec 2025 12:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888049;
	bh=msD+cXn3moI6mas6WbkOEVTxMiwEYv0KjnDMqPpuycE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKMnINiZsqPb1CBYIKFKBhsXFs8IUkOGzuVPCPKNP8IAcrRFtP81vc9bbMDViJo8m
	 oWMyivwQa0VXxWYumuBhN0Q7kTLCo8J2ceTWKncv2BzjvRIqiS3oSGXR8UKSv3x5Dq
	 C84fd3PYuiuiTQHUtFQKXRDvUzSUubmovuVcyjmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 415/614] iomap: always run error completions in user context
Date: Tue, 16 Dec 2025 12:13:02 +0100
Message-ID: <20251216111416.408640907@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5d5d63efbd576..143160042552b 100644
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



