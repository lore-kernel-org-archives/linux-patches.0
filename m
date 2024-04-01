Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903C617552;
	Mon,  1 Apr 2024 15:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987009; cv=none; b=G0Cd/4naPNL0LdXh642ly34GscxV5pl7aBRNWvaCNYkOWlG/SPjFVqaJHdj/QgnSPONu25N8/1GvuMcCrQl8aP/uYcAT34Fgp1rBd0SB5bLl722HlN5AioLmzl3O33oo+ySiXC9D4oCBLGXHADV27gpqNUY4XMqd9U0xxGmTkxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987009; c=relaxed/simple;
	bh=fCXlgZh3MMp9nkqTdnkctRefHl0tzQaklli1FE9X0Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7RggJC9oCasFRrMLcrjzFw9OMDV0YlYu7CmePgAMhbNiymUpiUZN4E6/aLkKrb4Aq5Wv/z3bZSb11R37li8jQvJMAwOXZU4AAxm76vrxBD4bPcZ+P1Kvv9ZbYAxqm0Mkh3m8W7Z7nK+U/LYgWZU3yGKdX0vRq2sckp+MfCcUtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZ8+UcXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZ8+UcXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2B0C433F1;
	Mon,  1 Apr 2024 15:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987009;
	bh=fCXlgZh3MMp9nkqTdnkctRefHl0tzQaklli1FE9X0Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZ8+UcXqRp5xRznP8TzO5abN7RtzzuxWTFcOto27NxCfm7aS5xD8bVjbTlvecLVpe
	 G8ixctWQOD5c3HzGX2YCkbQ/NtewN8jv0QhWsBXZMhdDuMR3UqOcEe7Usfp0EbxTy0
	 Nlp9fNyr3F4PX+pBdbVmYH9OaG06kPVigrtqleT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sargun Dhillon <sargun@meta.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 155/399] io_uring/rw: return IOU_ISSUE_SKIP_COMPLETE for multishot retry
Date: Mon,  1 Apr 2024 17:42:01 +0200
Message-ID: <20240401152553.814603329@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 0a3737db8479b77f95f4bfda8e71b03c697eb56a ]

If read multishot is being invoked from the poll retry handler, then we
should return IOU_ISSUE_SKIP_COMPLETE rather than -EAGAIN. If not, then
a CQE will be posted with -EAGAIN rather than triggering the retry when
the file is flagged as readable again.

Cc: stable@vger.kernel.org
Reported-by: Sargun Dhillon <sargun@meta.com>
Fixes: fc68fcda04910 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 8756e367acd91..2b84ce8a8a677 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -948,6 +948,8 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		 */
 		if (io_kbuf_recycle(req, issue_flags))
 			rw->len = 0;
+		if (issue_flags & IO_URING_F_MULTISHOT)
+			return IOU_ISSUE_SKIP_COMPLETE;
 		return -EAGAIN;
 	}
 
-- 
2.43.0



