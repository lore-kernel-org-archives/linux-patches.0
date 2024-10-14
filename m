Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2394B1A0BE7;
	Mon, 14 Oct 2024 14:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915925; cv=none; b=jjxPu/xZw359KG799Wviv49BtpFDIXKzH+K4lK3hRfBiV7i+Z0fa7k/WNeM3rkif0WYtzWCAWsz+rH5ZujHK1nqzyPlzf60hJDaYp31tvUyzrmMjR7J9gf3DVUub2GEiYUH/5HeP0ZNh0eFjisAoeVUPKQ2T74Z+HAb4gT+4qXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915925; c=relaxed/simple;
	bh=iIuu1rMdxUQUFhvIpHWx7+RTSiVu2bjRUnGsEPzYQ44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4lKRmvh0CDeWARhqrf6JyXp+KXW0rH+K8bUzM4KHVObcMxE0R7RIhuwgSTvVCAco3RMF1uMYfag6pPb4iqD1O9YtT14N/5+YIRC2tV7hAbjLDf5O0vBTbQyaqdKl2CHWBdrQKbPvqHHqjeEvxqNX0TbHkoPu2lHZ2Ogjww2EUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0Xr1kSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0Xr1kSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A954C4CEC3;
	Mon, 14 Oct 2024 14:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915925;
	bh=iIuu1rMdxUQUFhvIpHWx7+RTSiVu2bjRUnGsEPzYQ44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0Xr1kSdSA49vXLJEoiQ/KNxMsIqmHVrhgWsr341UdvOeWl24SKHxo7u+mplMpq0K
	 KLWNt4ip+eIyff6CTGEaPqYE6IRTDM+EMz7AcBafxsOUSeUJJdMedRkJdJjMtAAe0F
	 hDUMLjm9dpT+AVRhe9rxVYOBeZiwHSdeAqEpSMpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5fca234bd7eb378ff78e@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 039/214] io_uring: check if we need to reschedule during overflow flush
Date: Mon, 14 Oct 2024 16:18:22 +0200
Message-ID: <20241014141046.516220094@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit eac2ca2d682f94f46b1973bdf5e77d85d77b8e53 ]

In terms of normal application usage, this list will always be empty.
And if an application does overflow a bit, it'll have a few entries.
However, nothing obviously prevents syzbot from running a test case
that generates a ton of overflow entries, and then flushing them can
take quite a while.

Check for needing to reschedule while flushing, and drop our locks and
do so if necessary. There's no state to maintain here as overflows
always prune from head-of-list, hence it's fine to drop and reacquire
the locks at the end of the loop.

Link: https://lore.kernel.org/io-uring/66ed061d.050a0220.29194.0053.GAE@google.com/
Reported-by: syzbot+5fca234bd7eb378ff78e@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7a166120a45c3..7057d942fb2b0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -627,6 +627,21 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
 		}
 		list_del(&ocqe->list);
 		kfree(ocqe);
+
+		/*
+		 * For silly syzbot cases that deliberately overflow by huge
+		 * amounts, check if we need to resched and drop and
+		 * reacquire the locks if so. Nothing real would ever hit this.
+		 * Ideally we'd have a non-posting unlock for this, but hard
+		 * to care for a non-real case.
+		 */
+		if (need_resched()) {
+			io_cq_unlock_post(ctx);
+			mutex_unlock(&ctx->uring_lock);
+			cond_resched();
+			mutex_lock(&ctx->uring_lock);
+			io_cq_lock(ctx);
+		}
 	}
 
 	if (list_empty(&ctx->cq_overflow_list)) {
-- 
2.43.0



