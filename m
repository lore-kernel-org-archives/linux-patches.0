Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BB6251780;
	Tue, 29 Apr 2025 17:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948512; cv=none; b=OCHnx8qPjYEjL4etD+qzfEWbh14WVyIjONJD9tS+wi2irgEoqYK3/I+8bfuYauOpvxOZcWoGipvT5swTNiq8ToCVxoPT7h2nycfFvzBrgVanWbX8e6pex+4pLeBefCiSIyqq2YhkU+WstLQZhkto63BytfKhwK6id08X18kC/rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948512; c=relaxed/simple;
	bh=Uko+R7AvdiQZ6MEHV9YrMyu/ReDeecjypYc9WGXPvcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a34sEnIHN1cIbnuIJkH/f45DzPjfOlPp6d0rxl81FTbl79cHJYCX8AsUS6YVMktpqwn9ZVytsnTb0nPErT4Ue8bg4F43FdyekO6mf2ljuiMXgySZVfFGLVOqvKglnGP7Buchn3leDnDK93g9xOsyn8XbrsuM+XFQozMoRAFVzJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmPCxycP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmPCxycP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365B5C4CEE9;
	Tue, 29 Apr 2025 17:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948512;
	bh=Uko+R7AvdiQZ6MEHV9YrMyu/ReDeecjypYc9WGXPvcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmPCxycP1PaUjK0DClobSeOXYaii4HtDvlQEagPuGAOYoyAPt5yIQC0RFk2KyZE/t
	 HFVAO5c0NDfq13h94kdCB36zWxvqiyX7dkD9GOeeD8B8DTGop+aI5WW1UJshW9z61D
	 SdFaRxBoNhIbUVfvJWbb/J4QY+K8nO8/YMRJNXLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kerneljasonxing@gmail.com>,
	Mina Almasry <almasrymina@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/373] page_pool: avoid infinite loop to schedule delayed worker
Date: Tue, 29 Apr 2025 18:38:20 +0200
Message-ID: <20250429161124.085525157@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 069d6ba0e33fb..416be038e1cae 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -699,7 +699,13 @@ static void page_pool_release_retry(struct work_struct *wq)
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



