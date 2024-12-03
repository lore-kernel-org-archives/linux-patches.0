Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B6B1E3DED;
	Tue,  3 Dec 2024 15:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239669; cv=none; b=H8wJ9wWCHhl5to9YwvkLiiGk3jfQKl9wIq6zMTEdufIsjAK4bcvNEmWE3w6Wn0ZrI1OsW90NxkYEjon4Il4cnSWnEUSPzfpkFxTVcZAos+80cFJQzafAHiHW2lC9qo2NqqTK8AudbE8IKvmhAINZkniXfylR2FZZWSTLJRCBoyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239669; c=relaxed/simple;
	bh=OreZVNfYjjGaIf+cJZCw2YvmzIUc5s8ELOHDG1EPUJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHo7m36HQl7KTe80pvXPqTNJPofklpqScAliyRTwDBZ7BmylfnmIsPkOt6Lqj+4S1+LzXEorxdAGBhDxJmbsEVKuNXci7kB1y21oLuxm/wU63Le8t9aCWx+w6Y90NouRYibCep1TkXL39Q+l4apyG9M6bLq5ZOi/R+YP6YFy9wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObP5gCEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObP5gCEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFAEC4CECF;
	Tue,  3 Dec 2024 15:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239669;
	bh=OreZVNfYjjGaIf+cJZCw2YvmzIUc5s8ELOHDG1EPUJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObP5gCEB574UnTgQ6f5am2h3zFTK15lY4XFsmda5XGyQN5DaXlMCw3h6zTgkWeE43
	 yPlkmDNfI1WtGEhWGfIjIK3aPB7l9ro14rgqhqhCwtd71Kz2OO8KHJmKnj4Pl3NS+2
	 c7F3QNjORPfHqFdRWWgfw3i/lo/M1KRERxBZjqGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.11 694/817] io_uring: check for overflows in io_pin_pages
Date: Tue,  3 Dec 2024 15:44:26 +0100
Message-ID: <20241203144023.065506618@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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


