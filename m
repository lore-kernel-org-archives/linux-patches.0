Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149F92505CB;
	Tue, 20 May 2025 14:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750595; cv=none; b=U0FTb/4zK1U3lu6YOtZ9iKtUIewPwka1KwcESaruf8aktAVbXSFWGTdSHxwzhPNTX4drx9wIaBihd+JyeO1Mfw8jfMDqcEXFBpHk496vuSRTqLQga5UbTtOkJmxg9S/VNrLEj1jvoUU3X/S9FETf0BCrt3lHbmoNFtWpgVRVocs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750595; c=relaxed/simple;
	bh=1Kg8oiLF1/RfXjC1OqXmVJhzRf0XbQEe+JEui980py4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQdQySbBgPjVr5mxjFDnmtDW1QDDGpzLbhCgIMRBr6DUJ84T9WSDtNMWefdpozJdK89M9xb75PgglkZ/qfOWhchQknj1D+zq9Kv3ijp8quwxWx7SjWfM5OstAFJXbNsnSxtJf6L4dJ9Pi4zJKOOjznLHfIEe+uKISNrXHrvTLoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+AbXkIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+AbXkIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26046C4AF09;
	Tue, 20 May 2025 14:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750594;
	bh=1Kg8oiLF1/RfXjC1OqXmVJhzRf0XbQEe+JEui980py4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+AbXkIh2qLL4zUOgicF0+n5jISeWoBrPD+xnhG9Om+DcUXms2vunqcH5h8MReRBz
	 Uc+RLbNY7hAjaQMEUw+qBYyrUEmZzBtQ2LU4gRTw0uMoZkz8Kt9SXRwKGmTG5CzqZS
	 XRHjy0bRpWpqQJ5pEwP02rraj4hD+x0V+Ig+28dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 060/145] ublk: fix dead loop when canceling io command
Date: Tue, 20 May 2025 15:50:30 +0200
Message-ID: <20250520125812.933318416@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit dd24f87f65c957f30e605e44961d2fd53a44c780 ]

Commit:

f40139fde527 ("ublk: fix race between io_uring_cmd_complete_in_task and
		ublk_cancel_cmd")

adds a request state check in ublk_cancel_cmd(), and if the request is
started, skips canceling this uring_cmd.

However, the current uring_cmd may be in ACTIVE state, without block
request coming to the uring command. Meantime, if the cached request in
tag_set.tags[tag] has been delivered to ublk server and reycycled, then
this uring_cmd can't be canceled.

ublk requests are aborted in ublk char device release handler, which
depends on canceling all ACTIVE uring_cmd. So it causes a dead loop.

Fix this issue by not taking a stale request into account when canceling
uring_cmd in ublk_cancel_cmd().

Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Closes: https://lore.kernel.org/linux-block/mruqwpf4tqenkbtgezv5oxwq7ngyq24jzeyqy4ixzvivatbbxv@4oh2wzz4e6qn/
Fixes: f40139fde527 ("ublk: fix race between io_uring_cmd_complete_in_task and ublk_cancel_cmd")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250515162601.77346-1-ming.lei@redhat.com
[axboe: rewording of commit message]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 348c4feb7a2df..7bbfc20f116a4 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1677,7 +1677,7 @@ static void ublk_cancel_cmd(struct ublk_queue *ubq, unsigned tag,
 	 * that ublk_dispatch_req() is always called
 	 */
 	req = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], tag);
-	if (req && blk_mq_request_started(req))
+	if (req && blk_mq_request_started(req) && req->tag == tag)
 		return;
 
 	spin_lock(&ubq->cancel_lock);
-- 
2.39.5



