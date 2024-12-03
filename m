Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31841F75AC;
	Tue,  3 Dec 2024 16:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242397; cv=none; b=gSkljru7N5Rr4GLsJYHpedI8VBZvdUR8suguLzcYyyfaCuMX35jHQAPIZyXYUoziOA8MP2HYJLXx7W3hLl67T31cVr2V9IpD8Omgl9R8IvPAVMNeE7wwTF8j6KrgNRmuZcN0VzZxKZaD3D4XakWpr6ZI3SKdDTHDNsuNA5+Yixo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242397; c=relaxed/simple;
	bh=L9/5evnyqkz0H/U8c2z1H7qvfhFRsDAFtKwRdzo+1Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQGcOdDfDD8+YwmvcD7rTEqCTLBCN+IaauQxZHqdA1HbSpaWzKYesvYYA49/foe23Z5aiHMcbHhQRX9P4qG84eW5zMGjMIcoDtmvV9F5fBFdYO7lyqExi+OuzDowARMF0BXSPT28l+GdeWepWLP8T/AVGR9rLMDYhePrk+Eq0xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IspGhxrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IspGhxrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DBAC4CECF;
	Tue,  3 Dec 2024 16:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242397;
	bh=L9/5evnyqkz0H/U8c2z1H7qvfhFRsDAFtKwRdzo+1Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IspGhxrEGctNvXRETosN1qQ7Z3kjWWiL25ff0T62/TRHiCPgAXQOtsTH52faW/hkX
	 OXPHguW2szWqoNeuBdfWHIBmHtpxwRq6mW4rg6Wtv4vugc2eC1Xos/W9+GOCW23yr/
	 0KXoHYKor4XmfO6JBxR9acsVkAl01HWXBkD1U7No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 692/826] io_uring: check for overflows in io_pin_pages
Date: Tue,  3 Dec 2024 15:46:59 +0100
Message-ID: <20241203144810.751260850@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 0c0a4eae26ac78379d0c1db053de168a8febc6c9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/memmap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -137,7 +137,12 @@ struct page **io_pin_pages(unsigned long
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


