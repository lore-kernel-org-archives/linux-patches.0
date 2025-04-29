Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A1C1DF73C;
	Tue, 29 Apr 2025 17:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946642; cv=none; b=huiugPdWKjMcmAVJA8+qMTII+2t94hGD3ARdKbK1HPhm06+P++W+vB/YPDyHQJ3tq+rygA2oa/sL2+qe7h4nhvlUwY+MuuSW8B60DfUvWj5epS4gOnnC+KtI6VMb+dEWRVEeA0RD0x9j/MhEwyawWhPNA9cyHHp1mWNyzH3W+No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946642; c=relaxed/simple;
	bh=7stHEwaFjy0+RCnggpucWdCXGkmuPdxF0neoyXJEzXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mu7O2zdfLJ9x2P18h0p6yd9fkAQtpiLqxUFiV6ullx9gbw0oHIXbYa/BnXA0syiSnzbmbxI/aU/N+8qyoWEe74jt0x+0TBTHgNLlPiNswHEJTychjVdUAycOmeYaqFSEVNW4iATbPXDVDi0HL3kou+qrGmJ5SYpTIk52ppTtpo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8cIibc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8cIibc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF7EC4CEE3;
	Tue, 29 Apr 2025 17:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946641;
	bh=7stHEwaFjy0+RCnggpucWdCXGkmuPdxF0neoyXJEzXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8cIibc/I/0ZEyjzPuoCriniPRRk+/nnIqU8yPIbKpWQNOPgOMsH4fCzat0y//J0j
	 IqeQSJ5Ur69OCimzzJZunaq1gWyier0hLLAsbQQHenmGBGRi76lQwpWWw4pTyRsIXH
	 /5j97ErULo7pVPs/WNUQkFozIsBoS6pDkeyr8SP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kerneljasonxing@gmail.com>,
	Mina Almasry <almasrymina@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/286] page_pool: avoid infinite loop to schedule delayed worker
Date: Tue, 29 Apr 2025 18:38:45 +0200
Message-ID: <20250429161108.724005138@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Xing <kerneljasonxing@gmail.com>

[ Upstream commit 43130d02baa137033c25297aaae95fd0edc41654 ]

We noticed the kworker in page_pool_release_retry() was waken
up repeatedly and infinitely in production because of the
buggy driver causing the inflight less than 0 and warning
us in page_pool_inflight()[1].

Since the inflight value goes negative, it means we should
not expect the whole page_pool to get back to work normally.

This patch mitigates the adverse effect by not rescheduling
the kworker when detecting the inflight negative in
page_pool_release_retry().

[1]
[Mon Feb 10 20:36:11 2025] ------------[ cut here ]------------
[Mon Feb 10 20:36:11 2025] Negative(-51446) inflight packet-pages
...
[Mon Feb 10 20:36:11 2025] Call Trace:
[Mon Feb 10 20:36:11 2025]  page_pool_release_retry+0x23/0x70
[Mon Feb 10 20:36:11 2025]  process_one_work+0x1b1/0x370
[Mon Feb 10 20:36:11 2025]  worker_thread+0x37/0x3a0
[Mon Feb 10 20:36:11 2025]  kthread+0x11a/0x140
[Mon Feb 10 20:36:11 2025]  ? process_one_work+0x370/0x370
[Mon Feb 10 20:36:11 2025]  ? __kthread_cancel_work+0x40/0x40
[Mon Feb 10 20:36:11 2025]  ret_from_fork+0x35/0x40
[Mon Feb 10 20:36:11 2025] ---[ end trace ebffe800f33e7e34 ]---
Note: before this patch, the above calltrace would flood the
dmesg due to repeated reschedule of release_dw kworker.

Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250214064250.85987-1-kerneljasonxing@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 08fbf4049c108..a11809b3149b4 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -485,7 +485,13 @@ static void page_pool_release_retry(struct work_struct *wq)
 	int inflight;
 
 	inflight = page_pool_release(pool);
-	if (!inflight)
+	/* In rare cases, a driver bug may cause inflight to go negative.
+	 * Don't reschedule release if inflight is 0 or negative.
+	 * - If 0, the page_pool has been destroyed
+	 * - if negative, we will never recover
+	 * in both cases no reschedule is necessary.
+	 */
+	if (inflight <= 0)
 		return;
 
 	/* Periodic warning */
-- 
2.39.5



