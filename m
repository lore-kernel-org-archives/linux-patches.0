Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7F8359A90
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302462; cv=none; b=e/zjlzrfk02fVZf+2r66ene15KubyqRu1vxtMHmSMr8X1xVnK5y9zpPZn/mV6N4UJtlav2XR84rXqkDmU6p0M930EqDGflIQaVUrVpeLq3hgoer/znhQFJUQlPjjv9czTg66SmKdz1kYkEijbs/0QTwaHc5vxrquYby0JlMhwQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302462; c=relaxed/simple;
	bh=xqGIzXcC1pOj4e0BTZPsAb7fHh/216WDicleARCR9i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGCk50rrd2GoXBMcdkTdpaANOkK0Fdmw45cj+XXQ/aM9bjlP/+sO3+p9uhGKYkW6vHszLNH314sggonGvcEP5X5Hd6zmlWVTkgWB4/1P+u4a57PTwOcA0fJml58bwtRP30R8ys6G/XohRtquapWe9SGkIsG7UGhnyOAtUVsB5KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+dCtEML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+dCtEML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4809DC116D0;
	Sat, 28 Feb 2026 18:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302462;
	bh=xqGIzXcC1pOj4e0BTZPsAb7fHh/216WDicleARCR9i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+dCtEMLgjRiM4IaVO6zXAkOLuizOqXaeXHAKthNrTGEt7xUzw6APPLWRldv/BC/6
	 Zna80Qa7FxOsO06dISo3wEzok/zGHJbIvXNIC9wBrg97Maynxv+mbiu783VVYwArJr
	 yDJNr2j4FNuwlsDBLX6U+0jSfMaG8PfDNhvHccoEwIg1XhqPYd1HYykcfROIc7GKcS
	 YxsYN3NU09VKV3Ic/89bO0YftaGeb8avq0Ci+ONS2vL+mw1/EoKvXR10cBzudorlMl
	 cJP5aPnih8V+kz7SQHuX/Yf9kfAz2+MArAz2b8CuUfNIKxZu7xbTxkv5jujlU5dw0q
	 qMGMpP+/bp/cg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 205/232] io_uring/cancel: add IORING_ASYNC_CANCEL_USERDATA
Date: Sat, 28 Feb 2026 13:10:58 -0500
Message-ID: <20260228181127.1592657-205-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

[ Upstream commit 8165b566049b14152873011ea540eb22eae5111d ]

Add a flag to explicitly match on user_data in the request for
cancelation purposes. This is the default behavior if none of the
other match flags are set, but if we ALSO want to match on user_data,
then this flag can be set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 22dbb0987bd1 ("io_uring/cancel: de-unionize file and user_data in struct io_cancel_data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/cancel.c             | 18 ++++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a8579ec1a8683..7adc7c4e9894b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -276,11 +276,13 @@ enum io_uring_op {
  *				request 'user_data'
  * IORING_ASYNC_CANCEL_ANY	Match any request
  * IORING_ASYNC_CANCEL_FD_FIXED	'fd' passed in is a fixed descriptor
+ * IORING_ASYNC_CANCEL_USERDATA	Match on user_data, default for no other key
  */
 #define IORING_ASYNC_CANCEL_ALL	(1U << 0)
 #define IORING_ASYNC_CANCEL_FD	(1U << 1)
 #define IORING_ASYNC_CANCEL_ANY	(1U << 2)
 #define IORING_ASYNC_CANCEL_FD_FIXED	(1U << 3)
+#define IORING_ASYNC_CANCEL_USERDATA	(1U << 4)
 
 /*
  * send/sendmsg and recv/recvmsg flags (sqe->ioprio)
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index c27e10e3dd8c3..577d2f85b3e5b 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -25,24 +25,30 @@ struct io_cancel {
 };
 
 #define CANCEL_FLAGS	(IORING_ASYNC_CANCEL_ALL | IORING_ASYNC_CANCEL_FD | \
-			 IORING_ASYNC_CANCEL_ANY | IORING_ASYNC_CANCEL_FD_FIXED)
+			 IORING_ASYNC_CANCEL_ANY | IORING_ASYNC_CANCEL_FD_FIXED | \
+			 IORING_ASYNC_CANCEL_USERDATA)
 
 /*
  * Returns true if the request matches the criteria outlined by 'cd'.
  */
 bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd)
 {
+	bool match_user_data = cd->flags & IORING_ASYNC_CANCEL_USERDATA;
+
 	if (req->ctx != cd->ctx)
 		return false;
-	if (cd->flags & IORING_ASYNC_CANCEL_ANY) {
+
+	if (!(cd->flags & (IORING_ASYNC_CANCEL_FD)))
+		match_user_data = true;
+
+	if (cd->flags & IORING_ASYNC_CANCEL_ANY)
 		goto check_seq;
-	} else if (cd->flags & IORING_ASYNC_CANCEL_FD) {
+	if (cd->flags & IORING_ASYNC_CANCEL_FD) {
 		if (req->file != cd->file)
 			return false;
-	} else {
-		if (req->cqe.user_data != cd->data)
-			return false;
 	}
+	if (match_user_data && req->cqe.user_data != cd->data)
+		return false;
 	if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
 check_seq:
 		if (cd->seq == req->work.cancel_seq)
-- 
2.51.0

