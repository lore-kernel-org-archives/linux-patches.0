Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001843A7189;
	Sat, 17 Oct 2026 17:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257772; cv=none; b=hotak6GhroxXyyFGtqRZTmz0a6nMa++dkeNpg4Iy0LMii3I2A2DmL0j9U+++OSSB/XB/jtlD2SRwr35I332fujkU2ACsR0mJUjEQNcAU0ldZG2t1BboDiqV4pHHQr8AZUHMLEmutxtO/WwuTflUCFaRFqJvOvV30/3Fr7x3lZXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257772; c=relaxed/simple;
	bh=NejZLF61qkUnMxKtTKREwEOBPauIk11qxNfYGyJl/5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejLaNhnlyKG5b52oRy/jqrliQxLNCvWgR9BM7xTCruZXtgO8sHD+ZD6LlZtWb5Mq7KAoqBtvtZpg9wmTlDVYZdmhDyTug6Z9Lqm9w8EB6NSJg3sqsGArRKZOjiY8S/+hbqw53ZRwZU488J4f3+VrCwnPlGFPwuVNduFkzImPQ9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nre/FvVI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nre/FvVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9181F000C4;
	Sat, 17 Oct 2026 17:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257770;
	bh=KPYV1nAfiKXZAadGFqIilfewiT26VW2iqXfxxKvbTJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nre/FvVI6QDUi+pxjBEWpuKBNKTxBu3Mef64r9tfZG9oCdgdeUlf8trwY/BAbaozG
	 ZdLlQsneUdR894su2d6TchBwru/P4ABRUyE5Od6qal9GaERKCVgVlES9240pOBpNFo
	 se812jzjCHFEWJh/7bhpuIcV+UKvKm8tVZ6Lcrhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0658/1674] io_uring: check for overflows in io_pin_pages
Date: Sat, 17 Oct 2026 17:48:50 +0200
Message-ID: <20261017160448.001683563@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 0c0a4eae26ac78379d0c1db053de168a8febc6c9 ]

WARNING: CPU: 0 PID: 5834 at io_uring/memmap.c:144 io_pin_pages+0x149/0x180 io_uring/memmap.c:144
CPU: 0 UID: 0 PID: 5834 Comm: syz-executor825 Not tainted 6.12.0-next-20241118-syzkaller #0
Call Trace:
 <TASK>
 __io_uaddr_map+0xfb/0x2d0 io_uring/memmap.c:183
 io_rings_map io_uring/io_uring.c:2611 [inline]
 io_allocate_scq_urings+0x1c0/0x650 io_uring/io_uring.c:3470
 io_uring_create+0x5b5/0xc00 io_uring/io_uring.c:3692
 io_uring_setup io_uring/io_uring.c:3781 [inline]
 ...
 </TASK>

io_pin_pages()'s uaddr parameter came directly from the user and can be
garbage. Don't just add size to it as it can overflow.

Cc: stable@vger.kernel.org
Reported-by: syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1b7520ddb168e1d537d64be47414a0629d0d8f8f.1732581026.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 712c724a7444c..910cd75753df9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2718,7 +2718,12 @@ struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
 	struct page **pages;
 	int ret;
 
-	end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (check_add_overflow(uaddr, len, &end))
+		return ERR_PTR(-EOVERFLOW);
+	if (check_add_overflow(end, PAGE_SIZE - 1, &end))
+		return ERR_PTR(-EOVERFLOW);
+
+	end = end >> PAGE_SHIFT;
 	start = uaddr >> PAGE_SHIFT;
 	nr_pages = end - start;
 	if (WARN_ON_ONCE(!nr_pages))
-- 
2.53.0



